
echo ""
echo ""

read -p "Enter ZONE: " ZONE




gcloud compute instances create access-test --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=access-test,image=projects/debian-cloud/global/images/debian-12-bookworm-v20241210,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any


export EXT_IP=$(gcloud compute instances describe access-test \
    --zone=$ZONE \
    --format="get(networkInterfaces[0].accessConfigs[0].natIP)")

ACCESS_TOKEN=$(gcloud auth print-access-token)
DEVSHELL_PROJECT_ID=$(gcloud config get-value project)

sleep 30

# Create the security policy
curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  https://compute.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/securityPolicies \
  -d "{
    \"adaptiveProtectionConfig\": {
      \"layer7DdosDefenseConfig\": {
        \"enable\": false
      }
    },
    \"description\": \"\",
    \"name\": \"blocklist-access-test\",
    \"rules\": [
      {
        \"action\": \"deny(404)\",
        \"description\": \"\",
        \"match\": {
          \"config\": {
            \"srcIpRanges\": [
              \"$EXT_IP\"
            ]
          },
          \"versionedExpr\": \"SRC_IPS_V1\"
        },
        \"preview\": false,
        \"priority\": 1000
      },
      {
        \"action\": \"allow\",
        \"description\": \"Default rule, higher priority overrides it\",
        \"match\": {
          \"config\": {
            \"srcIpRanges\": [
              \"*\"
            ]
          },
          \"versionedExpr\": \"SRC_IPS_V1\"
        },
        \"preview\": false,
        \"priority\": 2147483647
      }
    ],
    \"type\": \"CLOUD_ARMOR\"
  }"


sleep 30


curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  https://compute.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/backendServices/web-backend/setSecurityPolicy \
  -d "{
    \"securityPolicy\": \"projects/$DEVSHELL_PROJECT_ID/global/securityPolicies/blocklist-access-test\"
  }"
