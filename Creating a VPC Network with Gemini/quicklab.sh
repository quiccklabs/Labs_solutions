


PROJECT_ID=$(gcloud config get-value project)

echo "PROJECT_ID=${PROJECT_ID}"
echo "REGION=${REGION}"


USER=$(gcloud config get-value account 2> /dev/null)
echo "USER=${USER}"

gcloud services enable cloudaicompanion.googleapis.com --project ${PROJECT_ID}

gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/cloudaicompanion.user
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/serviceusage.serviceUsageViewer



gcloud compute networks create privatenet --project=$PROJECT_ID --subnet-mode=custom --mtu=1460 --enable-ula-internal-ipv6 --bgp-routing-mode=regional && gcloud compute networks subnets create privatenet-subnet-us --project=$PROJECT_ID --range=10.130.0.0/20 --stack-type=IPV4_IPV6 --ipv6-access-type=INTERNAL --network=privatenet --region=$REGION && gcloud compute firewall-rules create privatenet-allow-custom --project=$PROJECT_ID --network=projects/$PROJECT_ID/global/networks/privatenet --description=Allows\ connection\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ custom\ protocols. --direction=INGRESS --priority=65534 --source-ranges=10.130.0.0/20 --action=ALLOW --rules=all && gcloud compute firewall-rules create privatenet-allow-icmp --project=$PROJECT_ID --network=projects/$PROJECT_ID/global/networks/privatenet --description=Allows\ ICMP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network. --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=icmp && gcloud compute firewall-rules create privatenet-allow-rdp --project=$PROJECT_ID --network=projects/$PROJECT_ID/global/networks/privatenet --description=Allows\ RDP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ port\ 3389. --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=tcp:3389 && gcloud compute firewall-rules create privatenet-allow-ssh --project=$PROJECT_ID --network=projects/$PROJECT_ID/global/networks/privatenet --description=Allows\ TCP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ port\ 22. --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=tcp:22 && gcloud compute firewall-rules create privatenet-allow-ipv6-icmp --project=$PROJECT_ID --network=projects/$PROJECT_ID/global/networks/privatenet --description=Allows\ ICMP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network. --direction=INGRESS --priority=65534 --source-ranges=::/0 --action=ALLOW --rules=58 && gcloud compute firewall-rules create privatenet-allow-ipv6-rdp --project=$PROJECT_ID --network=projects/$PROJECT_ID/global/networks/privatenet --description=Allows\ RDP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ port\ 3389. --direction=INGRESS --priority=65534 --source-ranges=::/0 --action=ALLOW --rules=tcp:3389 && gcloud compute firewall-rules create privatenet-allow-ipv6-ssh --project=$PROJECT_ID --network=projects/$PROJECT_ID/global/networks/privatenet --description=Allows\ TCP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ port\ 22. --direction=INGRESS --priority=65534 --source-ranges=::/0 --action=ALLOW --rules=tcp:22