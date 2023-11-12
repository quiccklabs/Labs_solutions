





gcloud compute instances create quicklab --project=$DEVSHELL_PROJECT_ID --zone=$ZONE_1 --machine-type=e2-standard-2 --network-interface=network-tier=PREMIUM,private-network-ip=10.0.0.3,stack-type=IPV4_ONLY,subnet=msad-1-sub0 --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=msad-1-tcp-3389,http-server,https-server --create-disk=auto-delete=yes,boot=yes,device-name=quicklab,image=projects/windows-cloud/global/images/windows-server-2019-dc-v20231011,mode=rw,size=50,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE_1/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any

sleep 10  

gcloud compute reset-windows-password quicklab --zone $ZONE_1 --user admin --quiet
 
sleep 10  

gcloud compute reset-windows-password msad-1-ad-1 --zone $ZONE_2 --user admin --quiet
