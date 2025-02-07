
echo ""
echo ""

read -p "ENTER VPC_NAME :- " VPC_NAME
echo ""

read -p "ENTER SUBNET_A :- " SUBNET_A
echo ""

read -p "ENTER SUBNET_B :- " SUBNET_B
echo ""

read -p "ENTER FIREWALL_1 :- " FIREWALL_1
echo ""

read -p "ENTER FIREWALL_2 :- " FIREWALL_2
echo ""

read -p "ENTER FIREWALL_3:- " FIREWALL_3
echo ""

read -p "ENTER ZONE_1:- " ZONE_1
echo ""

read -p "ENTER ZONE_2:- " ZONE_2
echo ""





export REGION_1=${ZONE_1%-*}
export REGION_2=${ZONE_2%-*}
export VM_1=us-test-01
export VM_2=us-test-02

gcloud compute networks create $VPC_NAME \
    --project=$DEVSHELL_PROJECT_ID \
    --subnet-mode=custom \
    --mtu=1460 \
    --bgp-routing-mode=regional

gcloud compute networks subnets create $SUBNET_A \
    --project=$DEVSHELL_PROJECT_ID \
    --region=$REGION_1 \
    --network=$VPC_NAME \
    --range=10.10.10.0/24 \
    --stack-type=IPV4_ONLY

gcloud compute networks subnets create $SUBNET_B \
    --project=$DEVSHELL_PROJECT_ID \
    --region=$REGION_2 \
    --network=$VPC_NAME \
    --range=10.10.20.0/24 \
    --stack-type=IPV4_ONLY

gcloud compute firewall-rules create $FIREWALL_1 \
    --project=$DEVSHELL_PROJECT_ID \
    --network=$VPC_NAME \
    --direction=INGRESS \
    --priority=1000 \
    --action=ALLOW \
    --rules=tcp:22 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=all

gcloud compute firewall-rules create $FIREWALL_2 \
    --project=$DEVSHELL_PROJECT_ID \
    --network=$VPC_NAME \
    --direction=INGRESS \
    --priority=65535 \
    --action=ALLOW \
    --rules=tcp:3389 \
    --source-ranges=0.0.0.0/24 \
    --target-tags=all

gcloud compute firewall-rules create $FIREWALL_3 \
    --project=$DEVSHELL_PROJECT_ID \
    --network=$VPC_NAME \
    --direction=INGRESS \
    --priority=1000 \
    --action=ALLOW \
    --rules=icmp \
    --source-ranges=0.0.0.0/24 \
    --target-tags=all

gcloud compute instances create $VM_1 \
    --project=$DEVSHELL_PROJECT_ID \
    --zone=$ZONE_1 \
    --subnet=$SUBNET_A \
    --tags=allow-icmp

gcloud compute instances create $VM_2 \
    --project=$DEVSHELL_PROJECT_ID \
    --zone=$ZONE_2 \
    --subnet=$SUBNET_B \
    --tags=allow-icmp

sleep 20

export EXTERNAL_IP_2=$(gcloud compute instances describe $VM_2 \
    --zone=$ZONE_2 \
    --format='get(networkInterfaces[0].accessConfigs[0].natIP)')


gcloud compute ssh $VM_1 --zone=$ZONE_1 --project=$DEVSHELL_PROJECT_ID --quiet --command="ping -c 3 $EXTERNAL_IP_2 && ping -c 3 $VM_2.$ZONE_2"


