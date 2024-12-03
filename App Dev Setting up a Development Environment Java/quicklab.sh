



echo ""
echo ""
echo "Please export the values."


# Prompt user to input three regions
read -p "Enter ZONE: " ZONE



gcloud compute instances create dev-instance --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/cloud-platform --tags=http-server --create-disk=auto-delete=yes,boot=yes,device-name=dev-instance,image=projects/debian-cloud/global/images/debian-12-bookworm-v20241112,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any

sleep 20

gcloud compute firewall-rules create allow-http \
    --network=default \
    --direction=INGRESS \
    --action=ALLOW \
    --rules=tcp:80 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=http-server

cat > prepare_disk.sh <<'EOF_END'

sudo apt-get update
sudo apt-get install -yq openjdk-17-jdk
sudo sed -i 's/^\(keystore\.type\s*=\s*\).*$/\1jks/' /etc/java-17-openjdk/security/java.security; sudo rm /etc/ssl/certs/java/cacerts; sudo /usr/sbin/update-ca-certificates -f
sudo apt-get install git -y
sudo apt-get install -yq maven
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080
export GCLOUD_PROJECT="$(curl -H Metadata-Flavor:Google http://metadata/computeMetadata/v1/project/project-id)"
java -version
git clone --depth=1 https://github.com/GoogleCloudPlatform/training-data-analyst
ln -s ~/training-data-analyst/courses/developingapps/v1.3/java/devenv ~/devenv
cd ~/devenv
mvn clean install
mvn spring-boot:run

EOF_END



gcloud compute scp prepare_disk.sh dev-instance:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh dev-instance --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/prepare_disk.sh"