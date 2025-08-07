



# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)


echo ""
echo ""

read -p "Enter Region 2 : " REGION_2

read -p "Enter Zone 2 : " ZONE_2


# TASK1:-

project_id=$PROJECT_ID

gcloud services enable osconfig.googleapis.com

gcloud compute networks create vpc-transit --project=$project_id --subnet-mode=custom --mtu=1460 --bgp-routing-mode=global

# TASK 2:- 

gcloud compute networks create vpc-a --project=$project_id --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional

gcloud compute networks create vpc-b --project=$project_id --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional

gcloud compute networks subnets create vpc-a-sub1-use4 --project=$project_id --range=10.20.10.0/24 --stack-type=IPV4_ONLY --network=vpc-a --region=$REGION

gcloud compute networks subnets create vpc-b-sub1-usw2 --project=$project_id --range=10.20.10.0/24 --stack-type=IPV4_ONLY --network=vpc-b --region=$REGION_2



# TASK 3:-

# Step 1: Create cloud routers


gcloud compute routers create cr-vpc-transit-use4-1 \
    --region $REGION \
    --network vpc-transit \
    --asn 65000

gcloud compute routers create cr-vpc-transit-usw2-1 \
    --region $REGION_2 \
    --network vpc-transit \
    --asn 65000


gcloud compute routers create cr-vpc-a-use4-1 \
    --region $REGION \
    --network vpc-a \
    --asn 65001


gcloud compute routers create cr-vpc-b-usw2-1 \
    --region $REGION_2 \
    --network vpc-b \
    --asn 65002



# Step 2: Create HA VPN gateways


gcloud compute vpn-gateways create vpc-transit-gw1-use4 \
   --network=vpc-transit \
   --region=$REGION 


gcloud compute vpn-gateways create vpc-transit-gw1-usw2 \
   --network=vpc-transit \
   --region=$REGION_2 


gcloud compute vpn-gateways create vpc-a-gw1-use4 \
   --network=vpc-a \
   --region=$REGION 

gcloud compute vpn-gateways create vpc-b-gw1-usw2 \
   --network=vpc-b \
   --region=$REGION_2 



# TASK 4:-

gcloud services enable networkconnectivity.googleapis.com 

gcloud alpha network-connectivity hubs create transit-hub \
   --description=Transit_hub

gcloud alpha network-connectivity spokes create bo1 \
    --hub=transit-hub \
    --description=branch_office1 \
    --vpn-tunnel=transit-to-vpc-a-tu1,transit-to-vpc-a-tu2 \
    --region=$REGION


gcloud alpha network-connectivity spokes create bo2 \
    --hub=transit-hub \
    --description=branch_office2 \
    --vpn-tunnel=transit-to-vpc-b-tu1,transit-to-vpc-b-tu2 \
    --region=$REGION_2


# TASK 5:- 


gcloud compute --project=$project_id firewall-rules create fw-a --direction=INGRESS --priority=1000 --network=vpc-a --action=ALLOW --rules=tcp:22,icmp --source-ranges=0.0.0.0/0


gcloud compute --project=$project_id firewall-rules create fw-b --direction=INGRESS --priority=1000 --network=vpc-b --action=ALLOW --rules=tcp:22,icmp --source-ranges=0.0.0.0/0



gcloud compute instances create vpc-a-vm-1 --project=$project_id --zone=$ZONE --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=vpc-a-sub1-use4 --metadata=enable-osconfig=TRUE,enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --create-disk=auto-delete=yes,boot=yes,device-name=vpc-a-vm-1,image=projects/debian-cloud/global/images/debian-11-bullseye-v20250728,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ops-agent-policy=v2-x86-template-1-4-0,goog-ec-src=vm_add-gcloud --reservation-affinity=any && printf 'agentsRule:\n  packageState: installed\n  version: latest\ninstanceFilter:\n  inclusionLabels:\n  - labels:\n      goog-ops-agent-policy: v2-x86-template-1-4-0\n' > config.yaml && gcloud compute instances ops-agents policies create goog-ops-agent-v2-x86-template-1-4-0-$ZONE --project=$project_id --zone=$ZONE --file=config.yaml && gcloud compute resource-policies create snapshot-schedule default-schedule-1 --project=$project_id --region=$REGION --max-retention-days=14 --on-source-disk-delete=keep-auto-snapshots --daily-schedule --start-time=12:00 && gcloud compute disks add-resource-policies vpc-a-vm-1 --project=$project_id --zone=$ZONE --resource-policies=projects/$project_id/regions/$REGION/resourcePolicies/default-schedule-1



gcloud compute instances create vpc-b-vm-1 --project=$project_id --zone=$ZONE_2 --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=vpc-b-sub1-usw2 --metadata=enable-osconfig=TRUE,enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --create-disk=auto-delete=yes,boot=yes,device-name=vpc-b-vm-1,image=projects/debian-cloud/global/images/debian-11-bullseye-v20250728,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ops-agent-policy=v2-x86-template-1-4-0,goog-ec-src=vm_add-gcloud --reservation-affinity=any && printf 'agentsRule:\n  packageState: installed\n  version: latest\ninstanceFilter:\n  inclusionLabels:\n  - labels:\n      goog-ops-agent-policy: v2-x86-template-1-4-0\n' > config.yaml && gcloud compute instances ops-agents policies create goog-ops-agent-v2-x86-template-1-4-0-$ZONE_2 --project=$project_id --zone=$ZONE_2 --file=config.yaml && gcloud compute resource-policies create snapshot-schedule default-schedule-1 --project=$project_id --region=$REGION_2 --max-retention-days=14 --on-source-disk-delete=keep-auto-snapshots --daily-schedule --start-time=07:00 && gcloud compute disks add-resource-policies vpc-b-vm-1 --project=$project_id --zone=$ZONE_2 --resource-policies=projects/$project_id/regions/$REGION_2/resourcePolicies/default-schedule-1






