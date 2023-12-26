

PROJECT_ID=$(gcloud config get-value project)
echo "PROJECT_ID=${PROJECT_ID}"
echo "REGION=${REGION}"

USER=$(gcloud config get-value account 2> /dev/null)
echo "USER=${USER}"

gcloud services enable cloudaicompanion.googleapis.com --project ${PROJECT_ID}

gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/cloudaicompanion.user
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/serviceusage.serviceUsageViewer

gcloud container clusters create test --region=$REGION --num-nodes=1

git clone https://github.com/GoogleCloudPlatform/microservices-demo && cd microservices-demo

kubectl apply -f ./release/kubernetes-manifests.yaml

kubectl get service frontend-external | awk '{print $4}'


gcloud container clusters update test  --region "$REGION" --enable-master-authorized-networks