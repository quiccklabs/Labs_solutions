
echo ""
echo ""

echo "Please export the value"


read -p "Enter ZONE:- " ZONE

gcloud config set compute/zone $ZONE

gsutil cp gs://spls/gsp051/continuous-deployment-on-kubernetes.zip .

unzip continuous-deployment-on-kubernetes.zip

cd continuous-deployment-on-kubernetes

gcloud container clusters create jenkins-cd \
--num-nodes 2 \
--machine-type e2-standard-2 \
--scopes "https://www.googleapis.com/auth/source.read_write,cloud-platform"

gcloud container clusters list

gcloud container clusters get-credentials jenkins-cd

kubectl cluster-info

helm repo add jenkins https://charts.jenkins.io

helm repo update

helm install cd jenkins/jenkins -f jenkins/values.yaml --wait

kubectl get pods

kubectl create clusterrolebinding jenkins-deploy --clusterrole=cluster-admin --serviceaccount=default:cd-jenkins

export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/component=jenkins-master" -l "app.kubernetes.io/instance=cd" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:8080 >> /dev/null &

kubectl get svc

cd sample-app

kubectl create ns production

kubectl apply -f k8s/production -n production

kubectl apply -f k8s/canary -n production

kubectl apply -f k8s/services -n production

kubectl scale deployment gceme-frontend-production -n production --replicas 4

kubectl get pods -n production -l app=gceme -l role=frontend

kubectl get pods -n production -l app=gceme -l role=backend

kubectl get service gceme-frontend -n production

export FRONTEND_SERVICE_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" --namespace=production services gceme-frontend)

gcloud source repos create default

