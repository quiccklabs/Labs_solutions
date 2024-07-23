



PROJECT_ID=$(gcloud config get-value project)
REGION=${ZONE%-*}
echo "PROJECT_ID=${PROJECT_ID}"
echo "REGION=${REGION}"

USER=$(gcloud config get-value account 2> /dev/null)
echo "USER=${USER}"

gcloud services enable cloudaicompanion.googleapis.com --project ${PROJECT_ID}

gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/cloudaicompanion.user
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/serviceusage.serviceUsageViewer

gcloud services enable container.googleapis.com --project ${PROJECT_ID}

gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/container.admin

gcloud container clusters create test \
    --project=$PROJECT_ID \
    --zone=$ZONE \
    --num-nodes=3 \
    --machine-type=e2-standard-4

git clone --depth=1 https://github.com/GoogleCloudPlatform/microservices-demo

cd ~/microservices-demo
kubectl apply -f ./release/kubernetes-manifests.yaml

kubectl get deployments

sleep 30

echo "http://$(kubectl get service frontend-external -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')"

gcloud builds worker-pools create pool-test \
  --project=$PROJECT_ID \
  --region=$REGION \
  --no-public-egress

gcloud artifacts repositories create my-repo \
  --repository-format=docker \
  --location=$REGION \
  --description="My private Docker repository"