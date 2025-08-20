



# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)



export Your_Project_Id=$PROJECT_ID

gcloud compute networks create xall-vpc--vpc-01 \
    --description="Please like share & subscribe to quicklab" \
    \
    --project=$Your_Project_Id \
    \
    --subnet-mode=custom \
    --bgp-routing-mode=global \
    --mtu=1460


gcloud compute networks subnets create xgl-subnet--cerps-bau-nonprd--be1-01 \
    --description="Please like share & subscribe to quicklab" \
    \
    --project=$Your_Project_Id \
    --network=xall-vpc--vpc-01 \
    --region=us-central1 \
    \
    --range=10.1.1.0/24 \
    --enable-private-ip-google-access \
    --enable-flow-logs


gcloud compute firewall-rules create xall-vpc--vpc-01--xall-fw--user--a--linux--v01 \
    --description="Please like share & subscribe to quicklab" \
    \
    --project=$Your_Project_Id \
    --network=xall-vpc--vpc-01 \
    \
    --priority=1000 \
    --direction=ingress \
    --action=allow \
    --target-tags=xall-vpc--vpc-01--xall-fw--user--a--linux--v01 \
    --source-ranges=0.0.0.0/0 \
    --rules=tcp:22,icmp


gcloud compute firewall-rules create xall-vpc--vpc-01--xall-fw--user--a--windows--v01 \
    --description="I think you guy still subscribe the channel aren't you ?" \
    \
    --project=$Your_Project_Id \
    --network=xall-vpc--vpc-01 \
    \
    --priority=1000 \
    --direction=ingress \
    --action=allow \
    --target-tags=xall-vpc--vpc-01--xall-fw--user--a--windows--v01 \
    --source-ranges=0.0.0.0/0 \
    --rules=tcp:3389,icmp


gcloud compute firewall-rules create xall-vpc--vpc-01--xall-fw--user--a--sapgui--v01 \
    --description="Please comment down if the video is helpfull" \
    \
    --project=$Your_Project_Id \
    --network=xall-vpc--vpc-01 \
    \
    --priority=1000 \
    --direction=ingress \
    --action=allow \
    --target-tags=xall-vpc--vpc-01--xall-fw--user--a--sapgui--v01 \
    --source-ranges=0.0.0.0/0 \
    --rules=tcp:3200-3299,tcp:3600-3699




gcloud compute firewall-rules create xall-vpc--vpc-01--xall-fw--user--a--sap-fiori--v01 \
    --description="IF someone copy this command please give a credit at least guys " \
    \
    --project=$Your_Project_Id \
    --network=xall-vpc--vpc-01 \
    \
    --priority=1000 \
    --direction=ingress \
    --action=allow \
    --target-tags=xall-vpc--vpc-01--xall-fw--user--a--sap-fiori--v01 \
    --source-ranges=0.0.0.0/0 \
    --rules=tcp:80,tcp:8000-8099,tcp:443,tcp:4300-44300




gcloud compute firewall-rules create xall-vpc--vpc-01--xgl-fw--cerps-bau-dev--a-env--v01 \
    --description="IF someone copy this command please give a credit at least guys " \
    \
    --project=$Your_Project_Id \
    --network=xall-vpc--vpc-01 \
    \
    --priority=1000 \
    --direction=ingress \
    --action=allow \
    --target-tags=xall-vpc--vpc-01--xgl-fw--cerps-bau-dev--a-env--v01 \
    --source-tags=xall-vpc--vpc-01--xgl-fw--cerps-bau-dev--a-env--v01 \
    --rules=tcp:3200-3299,tcp:3300-3399,tcp:4800-4899,tcp:80,tcp:8000-8099,tcp:443,tcp:44300-44399,tcp:3600-3699,tcp:8100-8199,tcp:44400-44499,tcp:50000-59999,tcp:30000-39999,tcp:4300-4399,tcp:40000-49999,tcp:1128-1129,tcp:5050,tcp:8000-8499,tcp:515,icmp



gcloud compute firewall-rules create xall-vpc--vpc-01--xgl-fw--cerps-bau-dev--a-ds4--v01 \
    --description="IF someone copy this command please give a credit at least guys" \
    \
    --project=$Your_Project_Id \
    --network=xall-vpc--vpc-01 \
    \
    --priority=1000 \
    --direction=ingress \
    --action=allow \
    --target-tags=xall-vpc--vpc-01--xgl-fw--cerps-bau-dev--a-ds4--v01 \
    --source-tags=xall-vpc--vpc-01--xgl-fw--cerps-bau-dev--a-ds4--v01 \
    --rules=tcp,udp,icmp



gcloud compute addresses create xgl-ip-address--cerps-bau-dev--dh1--d-cerpshana1 \
    --description="Help me to reach 5K guys" \
    \
    --project=$Your_Project_Id \
    --region=us-central1 \
    --subnet=xgl-subnet--cerps-bau-nonprd--be1-01 \
    \
    --addresses=10.1.1.100




gcloud compute addresses create xgl-ip-address--cerps-bau-dev--ds4--d-cerpss4db \
    --description="Help me to reach 5K guys" \
    \
    --project=$Your_Project_Id \
    --region=us-central1 \
    --subnet=xgl-subnet--cerps-bau-nonprd--be1-01 \
    \
    --addresses=10.1.1.101



gcloud compute addresses create xgl-ip-address--cerps-bau-dev--ds4--d-cerpss4scs \
    --description="Help me to reach 5K guys" \
    \
    --project=$Your_Project_Id \
    --region=us-central1 \
    --subnet=xgl-subnet--cerps-bau-nonprd--be1-01 \
    \
    --addresses=10.1.1.102




gcloud compute addresses create xgl-ip-address--cerps-bau-dev--ds4--d-cerpss4app1 \
    --description="Help me to reach 5K guys" \
    \
    --project=$Your_Project_Id \
    --region=us-central1 \
    --subnet=xgl-subnet--cerps-bau-nonprd--be1-01 \
    \
    --addresses=10.1.1.103




gcloud compute routers create xall-vpc--vpc-01--xall-router--shared-nat--de1-01 \
    --description="Help me to reach 5K guys" \
    \
    --project=$Your_Project_Id \
    --region=us-central1 \
    --network=xall-vpc--vpc-01




gcloud compute routers nats create xall-vpc--vpc-01--xall-nat-gw--shared-nat--de1-01 \
    \
    --project=$Your_Project_Id \
    --region=us-central1 \
    --router=xall-vpc--vpc-01--xall-router--shared-nat--de1-01 \
    \
    --auto-allocate-nat-external-ips \
    --nat-all-subnet-ip-ranges \
    --enable-logging












