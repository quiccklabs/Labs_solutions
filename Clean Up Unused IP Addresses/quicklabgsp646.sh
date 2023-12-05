



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

gcloud functions deploy unused_ip_function --trigger-http --runtime=nodejs12 --region=$REGION --quiet

export FUNCTION_URL=$(gcloud functions describe unused_ip_function --region=$REGION --format=json | jq -r '.httpsTrigger.url')

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

gcloud scheduler jobs run unused-ip-job \
--location=$REGION
gcloud compute addresses list --filter="region:($REGION)"
 
WORKDIR=$(pwd)
cd $WORKDIR/gcf-automated-resource-cleanup/unused-ip
PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2>/dev/null)
REGION="${ZONE%-*}"
USED_IP=used-ip-address
UNUSED_IP=unused-ip-address
gcloud compute addresses create $UNUSED_IP --project=$PROJECT_ID --region=$REGION







