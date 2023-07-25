








gcloud compute instances create speaking-with-a-webpage --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD  --scopes=https://www.googleapis.com/auth/cloud-platform --tags=http-server,https-server --create-disk=auto-delete=yes,boot=yes,device-name=speaking-with-a-webpage,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230711,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any

sleep 20

gcloud compute ssh "speaking-with-a-webpage" --zone "$ZONE" --project "$DEVSHELL_PROJECT_ID" --quiet --command 'sudo apt update && sudo apt install git -y && sudo apt-get install -y maven openjdk-11-jdk && git clone https://github.com/googlecodelabs/speaking-with-a-webpage.git && gcloud compute firewall-rules create dev-ports --allow=tcp:8443 --source-ranges=0.0.0.0/0 && cd ~/speaking-with-a-webpage/01-hello-https && mvn clean jetty:run' 


