export PROJECT_ID=

gcloud compute firewall-rules create fw-allow-lb-access --direction=INGRESS --priority=1000 --network=my-internal-app --action=ALLOW --rules=all --source-ranges=10.10.0.0/16 --target-tags=backend-service


gcloud compute  firewall-rules create fw-allow-health-checks --direction=INGRESS --priority=1000 --network=my-internal-app --action=ALLOW --rules=tcp:80 --source-ranges=35.191.0.0/16,130.211.0.0/22 --target-tags=backend-service


gcloud compute routers create nat-config \
    --network my-internal-app \
    --region us-central1


gcloud compute routers nats create nat-router-us-central1 \
    --router-region us-central1 \
    --router nat-config \
    --nat-all-subnet-ip-ranges \
    --auto-allocate-nat-external-ips



gcloud compute instances create utility-vm  --zone=us-central1-f --machine-type=n1-standard-1 --network-interface=private-network-ip=10.10.20.50,subnet=subnet-a,no-address --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --create-disk=auto-delete=yes,boot=yes,device-name=utility-vm,image=projects/debian-cloud/global/images/debian-10-buster-v20230206,mode=rw,size=10,type=projects/$PROJECT_ID/zones/us-central1-f/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any










