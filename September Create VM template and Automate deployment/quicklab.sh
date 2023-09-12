







  


gcloud compute instances create vm1 --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server,https-server --create-disk=auto-delete=yes,boot=yes,device-name=vm1,image=projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20230908,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-standard --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any


gcloud compute instances stop vm1 --zone=$ZONE

sleep 10

gcloud compute images create vm-image --project=$DEVSHELL_PROJECT_ID --source-disk=vm1 --source-disk-zone=$ZONE --storage-location=us

gcloud compute instance-templates create vm1-template --project=$DEVSHELL_PROJECT_ID --machine-type=e2-medium --network-interface=network=default,network-tier=PREMIUM --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server,https-server --create-disk=auto-delete=yes,boot=yes,device-name=vm1-template,image=projects/$DEVSHELL_PROJECT_ID/global/images/vm-image,mode=rw,size=10,type=pd-standard --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

gcloud compute instances create --zone $ZONE --source-instance-template vm1-template vm2 vm3 vm4 vm5 vm6 vm7 vm8