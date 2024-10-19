
echo ""
echo ""
echo "Please export the values."


# Prompt user to input three regions
read -p "Enter IAP_NETWORK_TAG: " IAP_NETWORK_TAG
read -p "Enter INTERNAL_NETWORK_TAG: " INTERNAL_NETWORK_TAG
read -p "Enter HTTP_NETWORK_TAG: " HTTP_NETWORK_TAG
read -p "Enter ZONE: " ZONE


gcloud compute firewall-rules delete open-access --quiet

gcloud compute firewall-rules create ssh-ingress --allow=tcp:22 --source-ranges 35.235.240.0/20 --target-tags $IAP_NETWORK_TAG --network acme-vpc
 
gcloud compute instances add-tags bastion --tags=$IAP_NETWORK_TAG --zone=$ZONE
 

gcloud compute firewall-rules create http-ingress --allow=tcp:80 --source-ranges 0.0.0.0/0 --target-tags $HTTP_NETWORK_TAG --network acme-vpc
 
gcloud compute instances add-tags juice-shop --tags=$HTTP_NETWORK_TAG --zone=$ZONE
 

gcloud compute firewall-rules create internal-ssh-ingress --allow=tcp:22 --source-ranges 192.168.10.0/24 --target-tags $INTERNAL_NETWORK_TAG --network acme-vpc
 
gcloud compute instances add-tags juice-shop --tags=$INTERNAL_NETWORK_TAG --zone=$ZONE

gcloud compute instances start bastion --zone=$ZONE

sleep 30

echo "export ZONE=$ZONE" > env_vars.sh

source env_vars.sh

cat > prepare_disk.sh <<'EOF_END'
# Source the environment variables
source /tmp/env_vars.sh

gcloud compute ssh juice-shop --zone=$ZONE --internal-ip --quiet

EOF_END


# Copy the environment variables script to the VM
gcloud compute scp env_vars.sh bastion:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

# Copy the prepare_disk.sh script to the VM
gcloud compute scp prepare_disk.sh bastion:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

# SSH into the VM and execute the script
gcloud compute ssh bastion --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/prepare_disk.sh"
