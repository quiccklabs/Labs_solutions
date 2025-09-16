#!/bin/bash

# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)


gcloud config set compute/zone $ZONE

gcloud storage cp -r gs://spls/gsp053/kubernetes .
cd kubernetes

gcloud container clusters create bootcamp \
  --machine-type e2-small \
  --num-nodes 3 \
  --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw"


#TASK 2

kubectl create -f deployments/fortune-app-blue.yaml
kubectl create -f services/fortune-app.yaml

kubectl scale deployment fortune-app-blue --replicas=5
kubectl get pods | grep fortune-app-blue | wc -l

kubectl scale deployment fortune-app-blue --replicas=3
kubectl get pods | grep fortune-app-blue | wc -l


#TASK 3 (ask before continuing)
# Simple colored prompt
echo -ne "\e[1;33m? \e[1;36mDo you want to continue with Task 3? \e[0m[\e[1;32mY\e[0m/\e[1;31mN\e[0m]: "
read -r CONFIRM
if [[ "$CONFIRM" != "Y" && "$CONFIRM" != "y" ]]; then
  echo -e "\e[1;31m❌ Task 3 aborted by user.\e[0m"
  exit 0
fi
echo -e "\e[1;32m✅ Continuing with Task 3...\e[0m"



kubectl set image deployment/fortune-app-blue fortune-app=$REGION-docker.pkg.dev/qwiklabs-resources/spl-lab-apps/fortune-service:2.0.0
kubectl set env deployment/fortune-app-blue APP_VERSION=2.0.0

# kubectl rollout history deployment/fortune-app-blue
# kubectl rollout pause deployment/fortune-app-blue
# kubectl rollout status deployment/fortune-app-blue
# kubectl rollout resume deployment/fortune-app-blue
# kubectl rollout status deployment/fortune-app-blue
# kubectl rollout undo deployment/fortune-app-blue

kubectl create -f deployments/fortune-app-canary.yaml


#TASK 5
kubectl apply -f services/fortune-app-blue-service.yaml
kubectl create -f deployments/fortune-app-green.yaml
kubectl apply -f services/fortune-app-green-service.yaml
kubectl apply -f services/fortune-app-blue-service.yaml
