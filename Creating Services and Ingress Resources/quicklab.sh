

source <(kubectl completion bash)

gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE

git clone https://github.com/GoogleCloudPlatform/training-data-analyst

ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s

cd ~/ak8s/GKE_Services/

kubectl apply -f dns-demo.yaml

kubectl get pods

kubectl exec -it dns-demo-1 -- /bin/bash -c "apt-get update && apt-get install -y iputils-ping && apt-get install -y curl"

sleep 20

kubectl create -f hello-v1.yaml
kubectl get deployments
kubectl apply -f ./hello-svc.yaml
kubectl get service hello-svc
kubectl apply -f ./hello-nodeport-svc.yaml
kubectl get service hello-svc

gcloud compute addresses create regional-loadbalancer --project=$DEVSHELL_PROJECT_ID --region="${ZONE%-*}"

gcloud compute addresses create global-ingress --project=$DEVSHELL_PROJECT_ID --global

kubectl create -f hello-v2.yaml

kubectl get deployments

export STATIC_LB=$(gcloud compute addresses describe regional-loadbalancer --region "${ZONE%-*}" --format json | jq -r '.address')

sed -i "s/10\.10\.10\.10/$STATIC_LB/g" hello-lb-svc.yaml

cat hello-lb-svc.yaml

kubectl apply -f ./hello-lb-svc.yaml

kubectl apply -f hello-ingress.yaml

EXTERNAL_IP1=$(gcloud compute addresses describe regional-loadbalancer --project=$DEVSHELL_PROJECT_ID --region="${ZONE%-*}" --format 'value(address)')

EXTERNAL_IP2=$(gcloud compute addresses describe global-ingress --project=$DEVSHELL_PROJECT_ID --global --format 'value(address)')