

export REGION="${ZONE%-*}"


gcloud compute networks create vpc-net --project=$DEVSHELL_PROJECT_ID --description=subscribe\ to\ quicklab --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional && gcloud compute networks subnets create vpc-subnet --project=$DEVSHELL_PROJECT_ID --range=10.1.3.0/24 --stack-type=IPV4_ONLY --network=vpc-net --region=$REGION --enable-flow-logs --logging-aggregation-interval=interval-5-sec --logging-flow-sampling=0.5 --logging-metadata=include-all


gcloud compute --project=$DEVSHELL_PROJECT_ID firewall-rules create allow-http-ssh --direction=INGRESS --priority=1000 --network=vpc-net --action=ALLOW --rules=tcp:80,tcp:22 --source-ranges=0.0.0.0/0 --target-tags=http-server




gcloud compute instances create web-server --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-micro --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=vpc-subnet --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server --create-disk=auto-delete=yes,boot=yes,device-name=web-server,image=projects/debian-cloud/global/images/debian-12-bookworm-v20240515,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --no-shielded-vtpm --no-shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any


sleep 160

gcloud compute ssh --zone "$ZONE" "web-server" --project "$DEVSHELL_PROJECT_ID" --quiet --command 'sudo apt-get update && sudo apt-get install apache2 -y && echo "<!doctype html><html><body><h1>Hello World!</h1></body></html>" | sudo tee /var/www/html/index.html'

bq mk bq_vpcflows

export MY_SERVER=$(gcloud compute instances describe web-server --zone "$ZONE" --format='get(networkInterfaces[0].accessConfigs[0].natIP)')



echo -e "\033[1;34mhttps://console.cloud.google.com/net-security/firewall-manager/firewall-policies/details/allow-http-ssh?project=\033[0m\033[1;34m$DEVSHELL_PROJECT_ID\033[0m"

echo -e "\033[1m\033[34mhttps://console.cloud.google.com/logs/query?_ga=2.159612541.1373851212.1717364279-1768117806.1717363789&_gac=1.212068896.1717364364.EAIaIQobChMIx4iR4fC9hgMV4A6DAx1fJjJvEAAYAiAAEgKTZvD_BwE\033[0m"


export MY_SERVER=$(gcloud compute instances describe web-server --zone "$ZONE" --format='get(networkInterfaces[0].accessConfigs[0].natIP)')
export MY_SERVER=$(gcloud compute instances describe web-server --zone "$ZONE" --format='get(networkInterfaces[0].accessConfigs[0].natIP)')


