
BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`

BG_BLACK=`tput setab 0`
BG_RED=`tput setab 1`
BG_GREEN=`tput setab 2`
BG_YELLOW=`tput setab 3`
BG_BLUE=`tput setab 4`
BG_MAGENTA=`tput setab 5`
BG_CYAN=`tput setab 6`
BG_WHITE=`tput setab 7`

BOLD=`tput bold`
RESET=`tput sgr0`
#----------------------------------------------------start--------------------------------------------------#

echo "${YELLOW}${BOLD}

Starting Execution 


${RESET}"
#gcloud auth list
#gcloud config list project
export PROJECT_ID=$(gcloud info --format='value(config.project)')
#export BUCKET_NAME=$(gcloud info --format='value(config.project)')
#export EMAIL=$(gcloud config get-value core/account)
#gcloud config set compute/region $region
#gcloud config set compute/zone $region-a
#export ZONE=$region-a



#USER_EMAIL=$(gcloud auth list --limit=1 2>/dev/null | grep '@' | awk '{print $2}')
#----------------------------------------------------code--------------------------------------------------# 


gcloud services enable cloudscheduler.googleapis.com

sleep 15

echo "${GREEN}${BOLD}

Task 1 Completed

${RESET}"


git clone https://github.com/GoogleCloudPlatform/gcf-automated-resource-cleanup.git && cd gcf-automated-resource-cleanup/

cd $WORKDIR/unused-ip

export USED_IP=used-ip-address
export UNUSED_IP=unused-ip-address

gcloud compute addresses create $USED_IP --project=$PROJECT_ID --region=$region
gcloud compute addresses create $UNUSED_IP --project=$PROJECT_ID --region=$region

gcloud compute addresses list --filter="region:($region)"

echo "${GREEN}${BOLD}

Task 2 Completed

${RESET}"


export USED_IP_ADDRESS=$(gcloud compute addresses describe $USED_IP --region=$region --format=json | jq -r '.address')


gcloud compute instances create static-ip-instance \
--zone=$region-a \
--machine-type=n1-standard-1 \
--subnet=default \
--address=$USED_IP_ADDRESS

echo "${GREEN}${BOLD}

Task 3 Completed

${RESET}"


gcloud compute addresses list --filter="region:($region)"

cat $WORKDIR/unused-ip/function.js | grep "const compute" -A 31

gcloud functions deploy unused_ip_function --trigger-http --runtime=nodejs12 --region=$region --quiet

echo "${GREEN}${BOLD}

Task 5 Completed

${RESET}"


export FUNCTION_URL=$(gcloud functions describe unused_ip_function --format=json | jq -r '.httpsTrigger.url')

gcloud app create --region us-central

gcloud scheduler jobs create http unused-ip-job \
--schedule="* 2 * * *" \
--uri=$FUNCTION_URL \
--location=$region

gcloud scheduler jobs run unused-ip-job \
--location=$region

gcloud compute addresses list --filter="region:($region)"



echo "${GREEN}${BOLD}

Task 6 Completed

Lab Completed !!!

${RESET}"

