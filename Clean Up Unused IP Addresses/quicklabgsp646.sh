

gcloud services enable run.googleapis.com

gcloud services disable cloudfunctions.googleapis.com

gcloud services enable cloudfunctions.googleapis.com




PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2>/dev/null)
REGION="${ZONE%-*}"
USED_IP=used-ip-address
UNUSED_IP=unused-ip-address

gcloud services enable cloudscheduler.googleapis.com
sleep 20
git clone https://github.com/GoogleCloudPlatform/gcf-automated-resource-cleanup.git && cd gcf-automated-resource-cleanup/

WORKDIR=$(pwd)
cd $WORKDIR/unused-ip

gcloud compute addresses create $USED_IP --project=$PROJECT_ID --region=$REGION
gcloud compute addresses create $UNUSED_IP --project=$PROJECT_ID --region=$REGION

gcloud compute addresses list --filter="region:($REGION)"
export USED_IP_ADDRESS=$(gcloud compute addresses describe $USED_IP --region=$REGION --format=json | jq -r '.address')

gcloud compute instances create static-ip-instance \
--zone=$ZONE \
--machine-type=e2-medium \
--subnet=default \
--address=$USED_IP_ADDRESS
sleep 20

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
--member="serviceAccount:$DEVSHELL_PROJECT_ID@appspot.gserviceaccount.com" \
--role="roles/artifactregistry.reader"



PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format='value(projectNumber)')

# Your existing deployment command
deploy_function() {
gcloud functions deploy unused_ip_function --gen2 --trigger-http --runtime=nodejs20 --region=$REGION --quiet
}

# Variables
SERVICE_NAME="unused_ip_function"

# Loop until the Cloud Function is deployed
while true; do
  # Run the deployment command
  deploy_function

  # Check if Cloud Function is deployed
  if gcloud functions describe $SERVICE_NAME --region $REGION &> /dev/null; then
    echo "Cloud Function is deployed. Exiting the loop."
    break
  else
    echo "Waiting for Cloud Function to be deployed..."
    echo "Meantime Subscribe to Quicklab[https://www.youtube.com/@quick_lab]."
    sleep 10
  fi
done


export FUNCTION_URL=$(gcloud functions describe unused_ip_function --region=$REGION --format="value(url)")

if [ "$REGION" == "us-central1" ]; then
  gcloud app create --region us-central
else
  gcloud app create --region "$REGION"
fi

gcloud scheduler jobs create http unused-ip-job \
--schedule="* 2 * * *" \
--uri=$FUNCTION_URL \
--location=$REGION \
--oidc-service-account-email=$DEVSHELL_PROJECT_ID@appspot.gserviceaccount.com

sleep 60

gcloud scheduler jobs run unused-ip-job \
--location=$REGION


gcloud compute addresses list --filter="region:($REGION)"

sleep 30

PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2>/dev/null)
REGION="${ZONE%-*}"
USED_IP=used-ip-address
UNUSED_IP=unused-ip-address
gcloud compute addresses create $UNUSED_IP --project=$PROJECT_ID --region=$REGION





