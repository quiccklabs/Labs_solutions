

export PROJECT_ID=YOUR_PROJECT_ID

gcloud compute --project=$PROJECT_ID firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server

gcloud compute --project=$PROJECT_ID firewall-rules create default-allow-health-check --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=130.211.0.0/22,35.191.0.0/16 --target-tags=http-server

gcloud compute instance-templates create us-east1-template --project=$PROJECT_ID --machine-type=n1-standard-1 --network-interface=network-tier=PREMIUM,subnet=default --metadata=startup-script-url=gs://cloud-training/gcpnet/httplb/startup.sh$'\n',enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --region=us-east1 --tags=http-server --create-disk=auto-delete=yes,boot=yes,device-name=us-east1-template,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230306,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

gcloud compute instance-templates create europe-west1-template --project=$PROJECT_ID --machine-type=n1-standard-1 --network-interface=network-tier=PREMIUM,subnet=default --metadata=startup-script-url=gs://cloud-training/gcpnet/httplb/startup.sh$'\n',enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --region=europe-west1 --tags=http-server --create-disk=auto-delete=yes,boot=yes,device-name=europe-west1-template,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230306,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

gcloud beta compute instance-groups managed create us-east1-mig --project=$PROJECT_ID --base-instance-name=us-east1-mig --size=1 --template=us-east1-template --zones=us-east1-b,us-east1-c,us-east1-d --target-distribution-shape=EVEN --instance-redistribution-type=PROACTIVE --list-managed-instances-results=PAGELESS --no-force-update-on-repair

gcloud beta compute instance-groups managed set-autoscaling us-east1-mig --project=$PROJECT_ID --region=us-east1 --cool-down-period=45 --max-num-replicas=5 --min-num-replicas=1 --mode=on --target-cpu-utilization=0.8

gcloud beta compute instance-groups managed create europe-west1-mig --project=$PROJECT_ID --base-instance-name=europe-west1-mig --size=1 --template=europe-west1-template --zones=europe-west1-b,europe-west1-d,europe-west1-c --target-distribution-shape=EVEN --instance-redistribution-type=PROACTIVE --list-managed-instances-results=PAGELESS --no-force-update-on-repair

gcloud beta compute instance-groups managed set-autoscaling europe-west1-mig --project=$PROJECT_ID --region=europe-west1 --cool-down-period=45 --max-num-replicas=5 --min-num-replicas=1 --mode=on --target-cpu-utilization=0.8

gcloud compute instances create siege-vm --project=$PROJECT_ID --zone=us-west1-c --machine-type=n1-standard-1 --network-interface=network-tier=PREMIUM,subnet=default --metadata=startup-script-url=sudo\ apt-get\ -y\ install\ siege,enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --create-disk=auto-delete=yes,boot=yes,device-name=siege-vm,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230306,mode=rw,size=10,type=projects/$PROJECT_ID/zones/us-central1-a/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=ec-src=vm_add-gcloud --reservation-affinity=any




