

gcloud compute firewall-rules create app-allow-http \
    --direction=INGRESS \
    --priority=1000 \
    --network=my-internal-app \
    --action=ALLOW \
    --rules=tcp:80 \
    --source-ranges=10.10.0.0/16 \
    --target-tags=lb-backend

gcloud compute firewall-rules create app-allow-health-check \
    --direction=INGRESS \
    --priority=1000 \
    --network=my-internal-app \
    --action=ALLOW \
    --rules=tcp:80 \
    --source-ranges=130.211.0.0/22,35.191.0.0/16 \
    --target-tags=lb-backend

gcloud compute instance-templates create instance-template-1 \
--machine-type e2-micro \
--network my-internal-app \
--subnet subnet-a \
--tags lb-backend \
--metadata startup-script-url=gs://cloud-training/gcpnet/ilb/startup.sh \
--region=$REGION


gcloud compute instance-templates create instance-template-2 \
--machine-type e2-micro \
--network my-internal-app \
--subnet subnet-b \
--tags lb-backend \
--metadata startup-script-url=gs://cloud-training/gcpnet/ilb/startup.sh \
--region=$REGION


gcloud beta compute instance-groups managed create instance-group-1 --project=$DEVSHELL_PROJECT_ID --base-instance-name=instance-group-1 --size=1 --template=instance-template-1 --zone=$ZONE_1 --list-managed-instances-results=PAGELESS --no-force-update-on-repair && gcloud beta compute instance-groups managed set-autoscaling instance-group-1 --project=$DEVSHELL_PROJECT_ID --zone=$ZONE_1 --cool-down-period=45 --max-num-replicas=5 --min-num-replicas=1 --mode=on --target-cpu-utilization=0.8

gcloud beta compute instance-groups managed create instance-group-2 --project=$DEVSHELL_PROJECT_ID --base-instance-name=instance-group-2 --size=1 --template=instance-template-2 --zone=$ZONE_2 --list-managed-instances-results=PAGELESS --no-force-update-on-repair && gcloud beta compute instance-groups managed set-autoscaling instance-group-2 --project=$DEVSHELL_PROJECT_ID --zone=$ZONE_2 --cool-down-period=45 --max-num-replicas=5 --min-num-replicas=1 --mode=on --target-cpu-utilization=0.8


gcloud compute instances create utility-vm \
--zone $ZONE_1 \
--machine-type e2-micro \
--network my-internal-app \
--subnet subnet-a \
--private-network-ip 10.10.20.50







TOKEN=$(gcloud auth application-default print-access-token)

curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "checkIntervalSec": 5,
    "description": "",
    "healthyThreshold": 2,
    "name": "my-ilb-health-check",
    "region": "projects/'"$DEVSHELL_PROJECT_ID"'/regions/'"$REGION"'",
    "tcpHealthCheck": {
      "port": 80,
      "proxyHeader": "NONE"
    },
    "timeoutSec": 5,
    "type": "TCP",
    "unhealthyThreshold": 2
  }' \
  "https://compute.googleapis.com/compute/beta/projects/$DEVSHELL_PROJECT_ID/regions/$REGION/healthChecks"


sleep 30 

curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "backends": [
      {
        "balancingMode": "CONNECTION",
        "failover": false,
        "group": "projects/'"$DEVSHELL_PROJECT_ID"'/zones/'"$ZONE_1"'/instanceGroups/instance-group-1"
      },
      {
        "balancingMode": "CONNECTION",
        "failover": false,
        "group": "projects/'"$DEVSHELL_PROJECT_ID"'/zones/'"$ZONE_2"'/instanceGroups/instance-group-2"
      }
    ],
    "connectionDraining": {
      "drainingTimeoutSec": 300
    },
    "description": "",
    "failoverPolicy": {},
    "healthChecks": [
      "projects/'"$DEVSHELL_PROJECT_ID"'/regions/'"$REGION"'/healthChecks/my-ilb-health-check"
    ],
    "loadBalancingScheme": "INTERNAL",
    "logConfig": {
      "enable": false
    },
    "name": "my-ilb",
    "network": "projects/'"$DEVSHELL_PROJECT_ID"'/global/networks/my-internal-app",
    "protocol": "TCP",
    "region": "projects/'"$DEVSHELL_PROJECT_ID"'/regions/'"$REGION"'",
    "sessionAffinity": "NONE"
  }' \
  "https://compute.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/regions/$REGION/backendServices"



 sleep 20 
 

 curl -X POST -H "Content-Type: application/json" \
 -H "Authorization: Bearer $TOKEN" \
 -d '{
   "IPAddress": "10.10.30.5",
   "IPProtocol": "TCP",
   "allowGlobalAccess": false,
   "backendService": "projects/'"$DEVSHELL_PROJECT_ID"'/regions/'"$REGION"'/backendServices/my-ilb",
   "description": "",
   "ipVersion": "IPV4",
   "loadBalancingScheme": "INTERNAL",
   "name": "my-ilb-forwarding-rule",
   "networkTier": "PREMIUM",
   "ports": [
     "80"
   ],
   "region": "projects/'"$DEVSHELL_PROJECT_ID"'/regions/'"$REGION"'",
   "subnetwork": "projects/'"$DEVSHELL_PROJECT_ID"'/regions/'"$REGION"'/subnetworks/subnet-b"
 }' \
 "https://compute.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/regions/$REGION/forwardingRules"







