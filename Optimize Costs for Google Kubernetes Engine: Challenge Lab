
Task 1: 

ZONE=us-central1-b

gcloud container clusters create Cluster_Name --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-standard-2 --num-nodes=2

kubectl create namespace dev

kubectl create namespace prod

git clone https://github.com/GoogleCloudPlatform/microservices-demo.git &&
cd microservices-demo && kubectl apply -f ./release/kubernetes-manifests.yaml --namespace dev



Task 2: 

gcloud container node-pools create Pool_Name --cluster=Cluster_Name --machine-type=custom-2-3584 --num-nodes=2 --zone=$ZONE

for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o=name); do  kubectl cordon "$node"; done

for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o=name); do kubectl drain --force --ignore-daemonsets --delete-local-data --grace-period=10 "$node"; done

kubectl get pods -o=wide --namespace=dev

gcloud container node-pools delete default-pool --cluster Cluster_Name --zone $ZONE


Task 3: 

kubectl create poddisruptionbudget onlineboutique-frontend-pdb --selector app=frontend --min-available 1 --namespace dev

KUBE_EDITOR="nano" kubectl edit deployment/frontend --namespace dev

Find image under spec 
replace image: gcr.io/qwiklabs-resources/onlineboutique-frontend:v2.1
and in imagePullPolicy: Always

Press ctrl+x then Y then enter


Task 4:-

kubectl autoscale deployment frontend --cpu-percent=50 --min=1 --max=13 --namespace dev

kubectl get hpa --namespace dev
ZONE=us-central1-b

gcloud beta container clusters update Cluster_Name --enable-autoscaling --min-nodes 1 --max-nodes 6 --zone=$ZONE


