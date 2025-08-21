




# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)



gcloud config set compute/zone $ZONE

gcloud container clusters create io --zone $ZONE

gcloud storage cp -r gs://spls/gsp021/* .

cd orchestrate-with-kubernetes/kubernetes

kubectl create deployment nginx --image=nginx:1.27.0

kubectl get pods

kubectl expose deployment nginx --port 80 --type LoadBalancer

kubectl get services

cd ~/orchestrate-with-kubernetes/kubernetes

kubectl create -f pods/fortune-app.yaml


kubectl create secret generic tls-certs --from-file tls/  
kubectl create configmap nginx-proxy-conf --from-file nginx/proxy.conf  
kubectl create -f pods/secure-fortune.yaml

kubectl create -f services/fortune-app.yaml

gcloud compute firewall-rules create allow-fortune-nodeport --allow tcp:31000

kubectl get pods -l "app=fortune-app"

kubectl get pods -l "app=fortune-app,secure=enabled"

kubectl label pods secure-fortune 'secure=enabled'
kubectl get pods secure-fortune --show-labels


kubectl create -f deployments/auth.yaml

kubectl create -f services/auth.yaml

kubectl create -f deployments/fortune-service.yaml
kubectl create -f services/fortune-service.yaml


kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf  
kubectl create -f deployments/frontend.yaml  
kubectl create -f services/frontend.yaml

kubectl get services frontend
