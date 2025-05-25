
#!/bin/bash

# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)


git clone https://github.com/googlecodelabs/orchestrate-with-kubernetes.git

cd orchestrate-with-kubernetes/kubernetes

ls

gcloud config set compute/zone $ZONE

gcloud container clusters create bootcamp --num-nodes 5 --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw"

kubectl create deployment nginx --image=nginx:1.10.0

kubectl expose deployment nginx --port 80 --type LoadBalancer

kubectl scale deployment nginx --replicas 3

kubectl create -f pods/monolith.yaml


##

cat pods/healthy-monolith.yaml

kubectl create -f pods/healthy-monolith.yaml

kubectl create secret generic tls-certs --from-file tls/

kubectl create configmap nginx-proxy-conf --from-file nginx/proxy.conf

kubectl create -f pods/secure-monolith.yaml

kubectl create -f services/monolith.yaml

gcloud compute firewall-rules create allow-monolith-nodeport --allow=tcp:31000

kubectl get pods -l "app=monolith"

kubectl get pods -l "app=monolith,secure=enabled"

kubectl label pods secure-monolith 'secure=enabled'
