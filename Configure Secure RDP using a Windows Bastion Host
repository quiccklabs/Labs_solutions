

gcloud compute networks create securenetwork --project=$DEVSHELL_PROJECT_ID --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional && gcloud compute networks subnets create secure-subnet --project=$DEVSHELL_PROJECT_ID --range=10.0.0.0/24 --stack-type=IPV4_ONLY --network=securenetwork --region=us-central1


gcloud compute --project=$DEVSHELL_PROJECT_ID firewall-rules create secuer-firewall --direction=INGRESS --priority=1000 --network=securenetwork --action=ALLOW --rules=tcp:3389 --source-ranges=0.0.0.0/0 --target-tags=rdp


gcloud compute instances create vm-securehost --project=$DEVSHELL_PROJECT_ID --zone=us-central1-a --machine-type=n1-standard-2 --network-interface=stack-type=IPV4_ONLY,subnet=secure-subnet,no-address --network-interface=stack-type=IPV4_ONLY,subnet=default,no-address --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --tags=rdp --create-disk=auto-delete=yes,boot=yes,device-name=vm-securehost,image=projects/windows-cloud/global/images/windows-server-2016-dc-v20230510,mode=rw,size=150,type=projects/$DEVSHELL_PROJECT_ID/zones/us-central1-a/diskTypes/pd-standard --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any



gcloud compute instances create vm-bastionhost --project=$DEVSHELL_PROJECT_ID --zone=us-central1-a --machine-type=n1-standard-2 --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=secure-subnet --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --tags=rdp --create-disk=auto-delete=yes,boot=yes,device-name=vm-securehost,image=projects/windows-cloud/global/images/windows-server-2016-dc-v20230510,mode=rw,size=150,type=projects/$DEVSHELL_PROJECT_ID/zones/us-central1-a/diskTypes/pd-standard --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any


gcloud compute reset-windows-password vm-securehost --user app_admin --zone us-central1-a




