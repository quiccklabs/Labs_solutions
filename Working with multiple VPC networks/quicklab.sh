

export ZONE_1="$(gcloud compute instances list --project=$DEVSHELL_PROJECT_ID --format='value(ZONE)' | head -n 1)"

export ZONE_2="$(gcloud compute instances list --project=$DEVSHELL_PROJECT_ID --format='value(ZONE)' | tail -n 1)"


export REGION_1="${ZONE_1%-*}"

export REGION_2="${ZONE_2%-*}"


gcloud compute networks update mynetwork --switch-to-custom-subnet-mode --project=$DEVSHELL_PROJECT_ID --quiet

sleep 20


gcloud compute networks create managementnet --subnet-mode=custom

gcloud compute networks subnets create managementsubnet-us --network=managementnet --region=$REGION_1 --range=10.240.0.0/20

gcloud compute networks subnets create managementsubnet-eu --network=managementnet --region=$REGION_2 --range=172.20.0.0/20

gcloud compute networks list


gcloud compute networks create privatenet --subnet-mode=custom

gcloud compute networks subnets create privatesubnet-us --network=privatenet --region=$REGION_1 --range=172.16.0.0/24

gcloud compute networks subnets create privatesubnet-eu --network=privatenet --region=$REGION_2 --range=172.20.0.0/20

gcloud compute networks list




gcloud compute firewall-rules create managementnet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=managementnet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0

gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=privatenet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0


gcloud compute firewall-rules list --sort-by=NETWORK





gcloud compute instances create managementnet-us-vm --zone=$ZONE_1 --machine-type=e2-micro --subnet=managementsubnet-us --image-family=debian-11 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=managementnet-us-vm

gcloud compute instances create privatenet-us-vm --zone=$ZONE_1 --machine-type=e2-micro --subnet=privatesubnet-us --image-family=debian-11 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=privatenet-us-vm


sleep 30

gcloud compute instances create vm-appliance --project=$DEVSHELL_PROJECT_ID --zone=$ZONE_1 --machine-type=e2-standard-4 --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=privatesubnet-us --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=managementsubnet-us --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=mynetwork --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=vm-appliance,image=projects/debian-cloud/global/images/debian-12-bookworm-v20240910,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any