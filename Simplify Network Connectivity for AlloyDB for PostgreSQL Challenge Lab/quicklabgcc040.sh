read -p "ENTER CLUSTER_ID: " CLUSTER_ID
read -p "ENTER PASSWORD: " PASSWORD
read -p "ENTER INSTANCE_ID: " INSTANCE_ID


export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")

PROJECT_ID=`gcloud config get-value project`

gcloud config set compute/region $REGION

gcloud compute addresses create psa-range \
    --global \
    --purpose=VPC_PEERING \
    --addresses=10.8.12.0 \
    --prefix-length=24 \
    --network=cloud-vpc


gcloud services vpc-peerings connect \
    --service=servicenetworking.googleapis.com \
    --network=cloud-vpc \
    --ranges=psa-range


gcloud compute networks peerings update servicenetworking-googleapis-com \
    --network=cloud-vpc \
    --export-custom-routes \
    --import-custom-routes



#task 2



gcloud alloydb clusters create $CLUSTER_ID \
    --region=$REGION \
    --network=cloud-vpc \
    --password=$PASSWORD \
    --allocated-ip-range-name=psa-range


gcloud alloydb instances create $INSTANCE_ID \
    --region=$REGION \
    --cluster=$CLUSTER_ID \
    --instance-type=PRIMARY \
    --cpu-count=2


#TASK 4


gcloud beta compute vpn-gateways create cloud-vpc-vpn-gw1 --network cloud-vpc --region "$REGION"

gcloud beta compute vpn-gateways create on-prem-vpn-gw1 --network  on-prem-vpc --region "$REGION"

gcloud beta compute vpn-gateways describe cloud-vpc-vpn-gw1 --region "$REGION"

gcloud beta compute vpn-gateways describe  on-prem-vpn-gw1 --region "$REGION"

gcloud compute routers create cloud-vpc-router1 \
    --region "$REGION" \
    --network cloud-vpc \
    --asn 65001

gcloud compute routers create  on-prem-vpc-router1 \
    --region "$REGION" \
    --network  on-prem-vpc \
    --asn 65002


gcloud beta compute vpn-tunnels create cloud-vpc-tunnel0 \
    --peer-gcp-gateway on-prem-vpn-gw1 \
    --region "$REGION" \
    --ike-version 2 \
    --shared-secret [SHARED_SECRET] \
    --router cloud-vpc-router1 \
    --vpn-gateway cloud-vpc-vpn-gw1 \
    --interface 0


gcloud beta compute vpn-tunnels create cloud-vpc-tunnel1 \
    --peer-gcp-gateway  on-prem-vpn-gw1 \
    --region "$REGION" \
    --ike-version 2 \
    --shared-secret [SHARED_SECRET] \
    --router cloud-vpc-router1 \
    --vpn-gateway cloud-vpc-vpn-gw1 \
    --interface 1


gcloud beta compute vpn-tunnels create  on-prem-vpc-tunnel0 \
    --peer-gcp-gateway cloud-vpc-vpn-gw1 \
    --region "$REGION" \
    --ike-version 2 \
    --shared-secret [SHARED_SECRET] \
    --router  on-prem-vpc-router1 \
    --vpn-gateway  on-prem-vpn-gw1 \
    --interface 0


gcloud beta compute vpn-tunnels create  on-prem-vpc-tunnel1 \
    --peer-gcp-gateway cloud-vpc-vpn-gw1 \
    --region "$REGION" \
    --ike-version 2 \
    --shared-secret [SHARED_SECRET] \
    --router  on-prem-vpc-router1 \
    --vpn-gateway  on-prem-vpn-gw1 \
    --interface 1


gcloud compute routers add-interface cloud-vpc-router1 \
    --interface-name if-tunnel0-to-on-prem-vpc \
    --ip-address 169.254.0.1 \
    --mask-length 30 \
    --vpn-tunnel cloud-vpc-tunnel0 \
    --region "$REGION"


gcloud compute routers add-bgp-peer cloud-vpc-router1 \
    --peer-name bgp-on-prem-tunnel0 \
    --interface if-tunnel0-to-on-prem-vpc \
    --peer-ip-address 169.254.0.2 \
    --peer-asn 65002 \
    --region "$REGION"


gcloud compute routers add-interface cloud-vpc-router1 \
    --interface-name if-tunnel1-to-on-prem-vpc \
    --ip-address 169.254.1.1 \
    --mask-length 30 \
    --vpn-tunnel cloud-vpc-tunnel1 \
    --region "$REGION"


gcloud compute routers add-bgp-peer cloud-vpc-router1 \
    --peer-name bgp-on-prem-vpc-tunnel1 \
    --interface if-tunnel1-to-on-prem-vpc \
    --peer-ip-address 169.254.1.2 \
    --peer-asn 65002 \
    --region "$REGION"

gcloud compute routers add-interface  on-prem-vpc-router1 \
    --interface-name if-tunnel0-to-cloud-vpc \
    --ip-address 169.254.0.2 \
    --mask-length 30 \
    --vpn-tunnel  on-prem-vpc-tunnel0 \
    --region "$REGION"

gcloud compute routers add-bgp-peer  on-prem-vpc-router1 \
    --peer-name bgp-cloud-vpc-tunnel0 \
    --interface if-tunnel0-to-cloud-vpc \
    --peer-ip-address 169.254.0.1 \
    --peer-asn 65001 \
    --region "$REGION"

gcloud compute routers add-interface   on-prem-vpc-router1 \
    --interface-name if-tunnel1-to-cloud-vpc \
    --ip-address 169.254.1.2 \
    --mask-length 30 \
    --vpn-tunnel  on-prem-vpc-tunnel1 \
    --region "$REGION"


gcloud compute routers add-bgp-peer   on-prem-vpc-router1 \
    --peer-name bgp-cloud-vpc-tunnel1 \
    --interface if-tunnel1-to-cloud-vpc \
    --peer-ip-address 169.254.1.1 \
    --peer-asn 65001 \
    --region "$REGION"



gcloud compute firewall-rules create vpc-demo-allow-subnets-from-on-prem \
    --network cloud-vpc \
    --allow tcp,udp,icmp \
    --source-ranges 192.168.1.0/24


gcloud compute firewall-rules create on-prem-allow-subnets-from-vpc-demo \
    --network on-prem-vpc \
    --allow tcp,udp,icmp \
    --source-ranges 10.1.1.0/24,10.2.1.0/24




gcloud compute networks update cloud-vpc --bgp-routing-mode GLOBAL



#### task 5

gcloud compute routes create alloydb-custom-route \
    --network=on-prem-vpc \
    --destination-range=10.8.12.0/24 \
    --next-hop-vpn-tunnel=on-prem-vpc-tunnel0 \
    --priority=1000

gcloud compute routes create alloydb-return-route \
    --network=cloud-vpc \
    --destination-range=10.1.1.0/24 \
    --next-hop-vpn-tunnel=cloud-vpc-tunnel0 \
    --priority=1000


gcloud alloydb instances describe $INSTANCE_ID --region=$REGION --cluster=$CLUSTER_ID
