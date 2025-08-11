

#!/bin/bash

# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)



gcloud services enable osconfig.googleapis.com



gcloud compute networks create privatenet --project=$DEVSHELL_PROJECT_ID --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional --bgp-best-path-selection-mode=legacy && gcloud compute networks subnets create privatenet-us --project=$DEVSHELL_PROJECT_ID --range=10.130.0.0/20 --stack-type=IPV4_ONLY --network=privatenet --region=$REGION


gcloud compute --project=$DEVSHELL_PROJECT_ID firewall-rules create privatenet-allow-ssh --direction=INGRESS --priority=1000 --network=privatenet --action=ALLOW --rules=tcp:22 --source-ranges=0.0.0.0/0



#TASK 2


gcloud compute instances create vm-internal --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-medium --network-interface=stack-type=IPV4_ONLY,subnet=privatenet-us,no-address --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=vm-internal,image=projects/debian-cloud/global/images/debian-11-bullseye-v20240110,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any


#TASK 3


gcloud compute instances create vm-bastion --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-micro --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=privatenet-us --metadata=enable-osconfig=TRUE,enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/compute,https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=vm-bastion,image=projects/debian-cloud/global/images/debian-12-bookworm-v20250709,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ops-agent-policy=v2-x86-template-1-4-0,goog-ec-src=vm_add-gcloud --reservation-affinity=any && printf 'agentsRule:\n  packageState: installed\n  version: latest\ninstanceFilter:\n  inclusionLabels:\n  - labels:\n      goog-ops-agent-policy: v2-x86-template-1-4-0\n' > config.yaml && gcloud compute instances ops-agents policies create goog-ops-agent-v2-x86-template-1-4-0-$ZONE --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --file=config.yaml && gcloud compute resource-policies create snapshot-schedule default-schedule-1 --project=$DEVSHELL_PROJECT_ID --region=$REGION --max-retention-days=14 --on-source-disk-delete=keep-auto-snapshots --daily-schedule --start-time=05:00 && gcloud compute disks add-resource-policies vm-bastion --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --resource-policies=projects/$DEVSHELL_PROJECT_ID/regions/$REGION/resourcePolicies/default-schedule-1


#TASK  4

gsutil mb gs://$DEVSHELL_PROJECT_ID

gsutil cp gs://cloud-training/gcpnet/private/access.png gs://$DEVSHELL_PROJECT_ID


gcloud compute networks subnets update privatenet-us --region=$REGION --enable-private-ip-google-access


#TASK 5

gcloud compute routers create nat-router --region=$REGION --network=privatenet


gcloud compute routers nats create nat-config \
    --router=nat-router \
    --router-region=$REGION \
    --nat-all-subnet-ip-ranges \
    --auto-allocate-nat-external-ips
