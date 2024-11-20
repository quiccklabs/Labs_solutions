


echo ""
echo ""
echo "Please export the values."


# Prompt user to input three regions
read -p "Enter ZONE_1: " ZONE_1
read -p "Enter ZONE_2: " ZONE_2
read -p "Enter ZONE_3: " ZONE_3
read -p "Enter ZONE_4: " ZONE_4

export REGION="${ZONE_1%-*}"


gcloud compute networks create mynetwork --subnet-mode=auto

gcloud compute networks create privatenet \
--subnet-mode=custom

gcloud compute networks subnets create privatesubnet \
--network=privatenet --region=$REGION \
--range=10.0.0.0/24 --enable-private-ip-google-access


gcloud compute instances create default-vm-1 \
--machine-type e2-micro \
--zone=$ZONE_1 --network=default

gcloud compute instances create mynet-vm-1 \
--machine-type e2-micro \
--zone=$ZONE_1 --network=mynetwork

gcloud compute instances create mynet-vm-2 \
--machine-type e2-micro \
--zone=$ZONE_2 --network=mynetwork

gcloud compute instances create privatenet-bastion \
--machine-type e2-micro \
--zone=$ZONE_3  --subnet=privatesubnet --can-ip-forward


gcloud compute instances create privatenet-vm-1 \
--machine-type e2-micro \
--zone=$ZONE_4  --subnet=privatesubnet


#TASK 4

ip=$(curl -s https://api.ipify.org)
echo "My External IP address is: $ip"


gcloud compute firewall-rules create \
mynetwork-ingress-allow-ssh-from-cs \
--network mynetwork --action ALLOW --direction INGRESS \
--rules tcp:22 --source-ranges $ip --target-tags=lab-ssh


gcloud compute instances add-tags mynet-vm-2 \
    --zone $ZONE_2 \
    --tags lab-ssh
gcloud compute instances add-tags mynet-vm-1 \
    --zone $ZONE_1 \
    --tags lab-ssh

gcloud compute firewall-rules create \
mynetwork-ingress-allow-icmp-internal --network \
mynetwork --action ALLOW --direction INGRESS --rules icmp \
--source-ranges 10.128.0.0/9


#TASK 5

gcloud compute firewall-rules create \
mynetwork-ingress-deny-icmp-all --network \
mynetwork --action DENY --direction INGRESS --rules icmp \
--priority 500


gcloud compute firewall-rules update \
mynetwork-ingress-deny-icmp-all \
--priority 2000


gcloud compute firewall-rules list \
--filter="network:mynetwork"

gcloud compute firewall-rules create \
mynetwork-egress-deny-icmp-all --network \
mynetwork --action DENY --direction EGRESS --rules icmp \
--priority 10000

gcloud compute firewall-rules list \
--filter="network:mynetwork"
