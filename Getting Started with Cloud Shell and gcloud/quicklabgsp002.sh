


echo ""
echo ""

read -p "ENTER ZONE:- " ZONE

gcloud compute instances create gcelab2 --machine-type e2-medium --zone $ZONE

gcloud compute instances add-tags gcelab2 --zone $ZONE --tags http-server,https-server

gcloud compute firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server
