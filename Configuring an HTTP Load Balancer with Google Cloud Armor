gcloud compute --project=$DEVSHELL_PROJECT_ID firewall-rules create fw-allow-health-checks --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=130.211.0.0/22,35.191.0.0/16 --target-tags=allow-health-checks


gcloud compute instance-templates create us-central1-template --project=$DEVSHELL_PROJECT_ID --machine-type=e2-medium --network-interface=subnet=default,no-address --metadata=startup-script-url=gs://cloud-training/gcpnet/httplb/startup.sh$'\n',enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --region=us-central1 --tags=allow-health-checks --create-disk=auto-delete=yes,boot=yes,device-name=us-central1-template,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230509,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any


gcloud compute instance-templates create europe-west1-template --project=$DEVSHELL_PROJECT_ID --machine-type=e2-medium --network-interface=subnet=default,no-address --metadata=startup-script-url=gs://cloud-training/gcpnet/httplb/startup.sh$'\n',enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --region=europe-west1 --tags=allow-health-checks --create-disk=auto-delete=yes,boot=yes,device-name=europe-west1-template,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230509,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any



gcloud beta compute instance-groups managed create us-central1-mig --project=$DEVSHELL_PROJECT_ID --base-instance-name=us-central1-mig --size=1 --template=us-central1-template --zones=us-central1-c,us-central1-f,us-central1-b --target-distribution-shape=EVEN --instance-redistribution-type=PROACTIVE --list-managed-instances-results=PAGELESS --no-force-update-on-repair && gcloud beta compute instance-groups managed set-autoscaling us-central1-mig --project=$DEVSHELL_PROJECT_ID --region=us-central1 --cool-down-period=45 --max-num-replicas=5 --min-num-replicas=1 --mode=on --target-cpu-utilization=0.8


gcloud beta compute instance-groups managed create europe-west1-mig --project=$DEVSHELL_PROJECT_ID --base-instance-name=europe-west1-mig --size=1 --template=europe-west1-template --zones=europe-west1-b,europe-west1-d,europe-west1-c --target-distribution-shape=EVEN --instance-redistribution-type=PROACTIVE --list-managed-instances-results=PAGELESS --no-force-update-on-repair && gcloud beta compute instance-groups managed set-autoscaling europe-west1-mig --project=$DEVSHELL_PROJECT_ID --region=europe-west1 --cool-down-period=45 --max-num-replicas=5 --min-num-replicas=1 --mode=on --target-cpu-utilization=0.8


gcloud compute instances create siege-vm --project=$DEVSHELL_PROJECT_ID --zone=us-west1-c --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --create-disk=auto-delete=yes,boot=yes,device-name=siege-vm,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230509,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/us-central1-a/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any








