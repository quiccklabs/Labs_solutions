
gcloud compute firewall-rules create app-allow-http \
--network my-internal-app \
--target-tags lb-backend \
--source-ranges 0.0.0.0/0 \
--allow tcp:80


gcloud compute --project=$DEVSHELL_PROJECT_ID firewall-rules create app-allow-health-check --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp --source-ranges=130.211.0.0/22,35.191.0.0/16 --target-tags=lb-backend


gcloud compute instance-templates create instance-template-1 \
--machine-type n1-standard-1 \
--network my-internal-app \
--subnet subnet-a \
--tags lb-backend \
--metadata startup-script-url=gs://cloud-training/gcpnet/ilb/startup.sh \
--region=us-central1


gcloud compute instance-templates create instance-template-2 \
--machine-type n1-standard-1 \
--network my-internal-app \
--subnet subnet-b \
--tags lb-backend \
--metadata startup-script-url=gs://cloud-training/gcpnet/ilb/startup.sh \
--region=us-central1


gcloud beta compute instance-groups managed create instance-group-1 --project=$DEVSHELL_PROJECT_ID --base-instance-name=instance-group-1 --size=1 --template=instance-template-1 --zone=us-central1-a --list-managed-instances-results=PAGELESS --no-force-update-on-repair && gcloud beta compute instance-groups managed set-autoscaling instance-group-1 --project=$DEVSHELL_PROJECT_ID --zone=us-central1-a --cool-down-period=45 --max-num-replicas=5 --min-num-replicas=1 --mode=on --target-cpu-utilization=0.8

gcloud beta compute instance-groups managed create instance-group-2 --project=$DEVSHELL_PROJECT_ID --base-instance-name=instance-group-2 --size=1 --template=instance-template-2 --zone=us-central1-b --list-managed-instances-results=PAGELESS --no-force-update-on-repair && gcloud beta compute instance-groups managed set-autoscaling instance-group-2 --project=$DEVSHELL_PROJECT_ID --zone=us-central1-b --cool-down-period=45 --max-num-replicas=5 --min-num-replicas=1 --mode=on --target-cpu-utilization=0.8


gcloud compute instances create utility-vm \
--zone us-central1-f \
--machine-type f1-micro \
--network my-internal-app \
--subnet subnet-a \
--private-network-ip 10.10.20.50






