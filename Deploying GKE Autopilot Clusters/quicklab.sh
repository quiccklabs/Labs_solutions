

export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")

PROJECT_ID=`gcloud config get-value project`



export my_region=$REGION

export my_cluster=autopilot-cluster-1


gcloud container clusters create-auto $my_cluster --region $my_region

gcloud container clusters get-credentials $my_cluster --region $my_region

kubectl config view

kubectl cluster-info

kubectl config current-context

kubectl config get-contexts

kubectl config use-context gke_${DEVSHELL_PROJECT_ID}_us-central1_autopilot-cluster-1


kubectl create deployment nginx-1 --image=nginx:latest


