gcloud compute networks create $VPC_NAME --project=$DEVSHELL_PROJECT_ID --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional && gcloud compute networks subnets create $SUBNET1 --project=$DEVSHELL_PROJECT_ID --range=10.10.10.0/24 --stack-type=IPV4_ONLY --network=$VPC_NAME --region=$REGION1 && gcloud compute networks subnets create $SUBNET2 --project=$DEVSHELL_PROJECT_ID --range=10.10.20.0/24 --stack-type=IPV4_ONLY --network=$VPC_NAME --region=$REGION2

gcloud compute --project=$DEVSHELL_PROJECT_ID firewall-rules create $RULE_NAME1 --direction=INGRESS --priority=65535 --network=$VPC_NAME --action=ALLOW --rules=tcp:22 --source-ranges=0.0.0.0/0

gcloud compute --project=$DEVSHELL_PROJECT_ID firewall-rules create $RULE_NAME2 --direction=INGRESS --priority=65535 --network=$VPC_NAME --action=ALLOW --rules=tcp:3389 --source-ranges=0.0.0.0/0

gcloud compute --project=$DEVSHELL_PROJECT_ID firewall-rules create $RULE_NAME3 --direction=INGRESS --priority=65535 --network=$VPC_NAME --action=ALLOW --rules=icmp --source-ranges=0.0.0.0/0
