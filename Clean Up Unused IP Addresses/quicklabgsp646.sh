


gcloud services enable cloudscheduler.googleapis.com

sleep 15

git clone https://github.com/GoogleCloudPlatform/gcf-automated-resource-cleanup.git && cd gcf-automated-resource-cleanup/

export PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2>/dev/null)
export region=$REGION
WORKDIR=$(pwd)

cd $WORKDIR/unused-ip

export USED_IP=used-ip-address
export UNUSED_IP=unused-ip-address

gcloud compute addresses create $USED_IP --project=$PROJECT_ID --region=$REGION
gcloud compute addresses create $UNUSED_IP --project=$PROJECT_ID --region=$REGION


gcloud compute addresses list --filter="region:($REGION)"

export USED_IP_ADDRESS=$(gcloud compute addresses describe $USED_IP --region=$REGION --format=json | jq -r '.address')

gcloud compute instances create static-ip-instance \
--zone=$REGION-a \
--machine-type=n1-standard-1 \
--subnet=default \
--address=$USED_IP_ADDRESS

gcloud compute addresses list --filter="region:($REGION)"

cat $WORKDIR/unused-ip/function.js | grep "const compute" -A 31

gcloud functions deploy unused_ip_function --trigger-http --runtime=nodejs12 --region=$REGION --quiet

export FUNCTION_URL=$(gcloud functions describe unused_ip_function --format=json | jq -r '.httpsTrigger.url')

gcloud app create --region us-central

gcloud scheduler jobs create http unused-ip-job \
--schedule="* 2 * * *" \
--uri=$FUNCTION_URL \
--location=$REGION


gcloud scheduler jobs run unused-ip-job \
--location=$REGION


gcloud compute addresses list --filter="region:($REGION)"
