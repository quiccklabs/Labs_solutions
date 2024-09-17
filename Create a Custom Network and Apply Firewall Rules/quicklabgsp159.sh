
echo ""
echo ""
echo "Please enter the regions for the custom network subnets."

# Prompt user to input three regions
read -p "Enter REGION_1: " REGION_1
read -p "Enter REGION_2: " REGION_2
read -p "Enter REGION_3: " REGION_3

# Create a custom network
gcloud compute networks create taw-custom-network --subnet-mode custom

# Create subnets in the specified regions with the correct IP ranges
gcloud compute networks subnets create subnet-$REGION_1 \
   --network taw-custom-network \
   --region $REGION_1 \
   --range 10.0.0.0/16

gcloud compute networks subnets create subnet-$REGION_2 \
   --network taw-custom-network \
   --region $REGION_2 \
   --range 10.1.0.0/16

gcloud compute networks subnets create subnet-$REGION_3 \
   --network taw-custom-network \
   --region $REGION_3 \
   --range 10.2.0.0/16

# List the created subnets in the custom network
gcloud compute networks subnets list \
   --network taw-custom-network

# Create firewall rules for HTTP, ICMP, internal traffic, SSH, and RDP
gcloud compute firewall-rules create nw101-allow-http \
   --allow tcp:80 --network taw-custom-network --source-ranges 0.0.0.0/0 \
   --target-tags http

gcloud compute firewall-rules create nw101-allow-icmp \
   --allow icmp --network taw-custom-network --target-tags rules

gcloud compute firewall-rules create nw101-allow-internal \
   --allow tcp:0-65535,udp:0-65535,icmp --network taw-custom-network \
   --source-ranges "10.0.0.0/16","10.2.0.0/16","10.1.0.0/16"

gcloud compute firewall-rules create nw101-allow-ssh \
   --allow tcp:22 --network taw-custom-network --target-tags ssh

gcloud compute firewall-rules create nw101-allow-rdp \
   --allow tcp:3389 --network taw-custom-network
