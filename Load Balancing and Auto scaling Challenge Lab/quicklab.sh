
echo ""
echo ""

read -p "ENTER REGION_2: " REGION_2
read -p "ENTER ZONE_3: " ZONE_3

export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")

PROJECT_ID=`gcloud config get-value project`


cat > startup-script.sh <<EOF_END
#!/bin/bash
sudo apt-get update
sudo apt-get install -y apache2

EOF_END


gcloud compute instance-templates create primecalc \
--metadata-from-file startup-script=startup-script.sh \
--no-address --tags http-health-check --machine-type=e2-medium

# gcloud compute instance-templates create your-instance-template \
#   --startup-script=./startup-script.sh \
#   --tags=http-health-check \
#   --image-family=debian-10 \
#   --image-project=debian-cloud


gcloud compute health-checks create tcp http-health-check \
  --port=80 \
  --check-interval=5s \
  --timeout=5s \
  --unhealthy-threshold=3 \
  --healthy-threshold=2



#task 2


# gcloud beta compute instance-groups managed create $REGION-mig --project=$PROJECT_ID --base-instance-name=$REGION-mig --template=projects/$PROJECT_ID/global/instanceTemplates/primecalc --size=1 --zones=$REGION-b,$REGION-c,$REGION-d,$REGION-a --target-distribution-shape=EVEN --instance-redistribution-type=proactive --default-action-on-vm-failure=repair --health-check=projects/$PROJECT_ID/global/healthChecks/http-health-check --initial-delay=60 --no-force-update-on-repair --standby-policy-mode=manual --list-managed-instances-results=pageless && gcloud beta compute instance-groups managed set-autoscaling $REGION-mig --project=$PROJECT_ID --region=$REGION --mode=on --min-num-replicas=1 --max-num-replicas=2 --target-cpu-utilization=0.8 --cpu-utilization-predictive-method=none --cool-down-period=60



AVAILABLE_ZONES=$(gcloud compute zones list --filter="region:($REGION)" --format="value(name)")

# If you want to include all the available zones, just pass them as a comma-separated list
ZONE_LIST=$(echo $AVAILABLE_ZONES | tr '\n' ',' | sed 's/,$//')

# Now, run your instance-groups create command with the dynamic ZONE_LIST
# Format the ZONE_LIST variable into a comma-separated list
ZONE_LIST_COMMA=$(echo $ZONE_LIST | tr ' ' ',')

# Run the gcloud command with the formatted ZONE_LIST
gcloud beta compute instance-groups managed create $REGION-mig \
  --project=$PROJECT_ID \
  --base-instance-name=$REGION-mig \
  --template=projects/$PROJECT_ID/global/instanceTemplates/primecalc \
  --size=1 \
  --zones=$ZONE_LIST_COMMA \
  --target-distribution-shape=EVEN \
  --instance-redistribution-type=proactive \
  --default-action-on-vm-failure=repair \
  --health-check=projects/$PROJECT_ID/global/healthChecks/http-health-check \
  --initial-delay=60 \
  --no-force-update-on-repair \
  --standby-policy-mode=manual \
  --list-managed-instances-results=pageless

# Now set the autoscaling
gcloud beta compute instance-groups managed set-autoscaling $REGION-mig \
  --project=$PROJECT_ID \
  --region=$REGION \
  --mode=on \
  --min-num-replicas=1 \
  --max-num-replicas=2 \
  --target-cpu-utilization=0.8 \
  --cpu-utilization-predictive-method=none \
  --cool-down-period=60


# gcloud beta compute instance-groups managed create $REGION_2-mig --project=$PROJECT_ID --base-instance-name=$REGION_2-mig --template=projects/$PROJECT_ID/global/instanceTemplates/primecalc --size=1 --zones=$REGION_2-b,$REGION_2-c,$REGION_2-d,$REGION-a --target-distribution-shape=EVEN --instance-redistribution-type=proactive --default-action-on-vm-failure=repair --health-check=projects/$PROJECT_ID/global/healthChecks/http-health-check --initial-delay=60 --no-force-update-on-repair --standby-policy-mode=manual --list-managed-instances-results=pageless && gcloud beta compute instance-groups managed set-autoscaling $REGION_2-mig --project=$PROJECT_ID --region=$REGION_2 --mode=on --min-num-replicas=1 --max-num-replicas=2 --target-cpu-utilization=0.8 --cpu-utilization-predictive-method=none --cool-down-period=60



AVAILABLE_ZONES_2=$(gcloud compute zones list --filter="region:($REGION_2)" --format="value(name)")

# Ensure that the available zones are in the correct format (with spaces between zones)
ZONE_LIST_COMMA_2=$(echo $AVAILABLE_ZONES_2 | tr ' ' ',')

# Remove any trailing comma if present
ZONE_LIST_COMMA_2=$(echo $ZONE_LIST_COMMA_2 | sed 's/,$//')

# Output the formatted list
echo $ZONE_LIST_COMMA_2

# Run the gcloud command with the dynamically fetched zones
gcloud beta compute instance-groups managed create $REGION_2-mig \
  --project=$PROJECT_ID \
  --base-instance-name=$REGION_2-mig \
  --template=projects/$PROJECT_ID/global/instanceTemplates/primecalc \
  --size=1 \
  --zones=$ZONE_LIST_COMMA_2 \
  --target-distribution-shape=EVEN \
  --instance-redistribution-type=proactive \
  --default-action-on-vm-failure=repair \
  --health-check=projects/$PROJECT_ID/global/healthChecks/http-health-check \
  --initial-delay=60 \
  --no-force-update-on-repair \
  --standby-policy-mode=manual \
  --list-managed-instances-results=pageless

# Set autoscaling
gcloud beta compute instance-groups managed set-autoscaling $REGION_2-mig \
  --project=$PROJECT_ID \
  --region=$REGION_2 \
  --mode=on \
  --min-num-replicas=1 \
  --max-num-replicas=2 \
  --target-cpu-utilization=0.8 \
  --cpu-utilization-predictive-method=none \
  --cool-down-period=60


#task 3

gcloud compute firewall-rules create lb-firewall-rule --network default --allow=tcp:80 \
--source-ranges 35.191.0.0/16 --target-tags http-health-check



#Task 4




# Set variables
token=$(gcloud auth application-default print-access-token)
project_id=$(gcloud config get-value project)

# 1. Create Security Policy
curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d '{
    "description": "Default security policy for: backend1",
    "name": "default-security-policy-for-backend-service-backend1",
    "rules": [
      {
        "action": "allow",
        "match": {"config": {"srcIpRanges": ["*"]}, "versionedExpr": "SRC_IPS_V1"},
        "priority": 2147483647
      },
      {
        "action": "throttle",
        "description": "Default rate limiting rule",
        "match": {"config": {"srcIpRanges": ["*"]}, "versionedExpr": "SRC_IPS_V1"},
        "priority": 2147483646,
        "rateLimitOptions": {
          "conformAction": "allow",
          "enforceOnKey": "IP",
          "exceedAction": "deny(403)",
          "rateLimitThreshold": {"count": 500, "intervalSec": 60}
        }
      }
    ]
  }' \
  "https://compute.googleapis.com/compute/v1/projects/$project_id/global/securityPolicies"

sleep 30

# 2. Create Backend Service
curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d '{
    "backends": [
      {"balancingMode": "RATE", "capacityScaler": 1, "group": "projects/'"$project_id"'/regions/'"$REGION"'/instanceGroups/'"$REGION"'-mig", "maxRatePerInstance": 50},
      {"balancingMode": "RATE", "capacityScaler": 1, "group": "projects/'"$project_id"'/regions/'"$REGION_2"'/instanceGroups/'"$REGION_2"'-mig", "maxRatePerInstance": 50}
    ],
    "cdnPolicy": {"cacheKeyPolicy": {"includeHost": true, "includeProtocol": true, "includeQueryString": true}, "cacheMode": "CACHE_ALL_STATIC", "clientTtl": 3600, "defaultTtl": 3600, "maxTtl": 86400, "negativeCaching": false, "serveWhileStale": 0},
    "compressionMode": "DISABLED",
    "connectionDraining": {"drainingTimeoutSec": 300},
    "enableCDN": true,
    "healthChecks": ["projects/'"$project_id"'/global/healthChecks/http-health-check"],
    "loadBalancingScheme": "EXTERNAL_MANAGED",
    "localityLbPolicy": "ROUND_ROBIN",
    "name": "backend1",
    "portName": "http",
    "protocol": "HTTP",
    "securityPolicy": "projects/'"$project_id"'/global/securityPolicies/default-security-policy-for-backend-service-backend1",
    "sessionAffinity": "NONE",
    "timeoutSec": 30
  }' \
  "https://compute.googleapis.com/compute/beta/projects/$project_id/global/backendServices"

# Continue similarly with other commands...


sleep 40 

# 3. Set Security Policy to Backend Service
curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d '{
    "securityPolicy": "projects/'"$project_id"'/global/securityPolicies/default-security-policy-for-backend-service-backend1"
  }' \
  "https://compute.googleapis.com/compute/v1/projects/$project_id/global/backendServices/backend1/setSecurityPolicy"


sleep 20

# 4. Create URL Map
curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d '{
    "defaultService": "projects/'"$project_id"'/global/backendServices/backend1",
    "name": "quicklab"
  }' \
  "https://compute.googleapis.com/compute/v1/projects/$project_id/global/urlMaps"

sleep 30

# Create Target HTTP Proxy (IPv4)
curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d '{
    "name": "quicklab-target-proxy",
    "urlMap": "projects/'"$project_id"'/global/urlMaps/quicklab"
  }' \
  "https://compute.googleapis.com/compute/v1/projects/$project_id/global/targetHttpProxies"

sleep 20

# Create Target HTTP Proxy (IPv6)
curl -X POST -H "Content-Type: application/json" \
  -H "Authorization: Bearer $token" \
  -d '{
    "name": "quicklab-target-proxy-2",
    "urlMap": "projects/'"$project_id"'/global/urlMaps/quicklab"
  }' \
  "https://compute.googleapis.com/compute/v1/projects/$project_id/global/targetHttpProxies"


LB_IP_ADDRESS=$(gcloud compute forwarding-rules describe quicklab --global --format="value(IPAddress)")




gcloud compute instances create stress-test-vm \
--machine-type=e2-standard-2 --zone $ZONE_3
