
export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

gcloud services enable iap.googleapis.com \
        osconfig.googleapis.com \
        networkmanagement.googleapis.com

# Create the instance with the necessary metadata and tags
# gcloud compute instances create lamp-1-vm \
#     --project=$DEVSHELL_PROJECT_ID \
#     --zone=$ZONE \
#     --machine-type=e2-small \
#     --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
#     --metadata=enable-oslogin=true \
#     --maintenance-policy=MIGRATE \
#     --provisioning-model=STANDARD \
#     --tags=http-server \
#     --create-disk=auto-delete=yes,boot=yes,device-name=lamp-1-vm,image=projects/debian-cloud/global/images/debian-12-bookworm-v20240709,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced \
#     --no-shielded-secure-boot \
#     --shielded-vtpm \
#     --shielded-integrity-monitoring \
#     --labels=goog-ec-src=vm_add-gcloud \
#     --reservation-affinity=any



gcloud compute instances create lamp-1-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-osconfig=TRUE,enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append --tags=http-server --create-disk=auto-delete=yes,boot=yes,device-name=lamp-1-vm,image=projects/debian-cloud/global/images/debian-12-bookworm-v20250311,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ops-agent-policy=v2-x86-template-1-4-0,goog-ec-src=vm_add-gcloud --reservation-affinity=any && printf 'agentsRule:\n  packageState: installed\n  version: latest\ninstanceFilter:\n  inclusionLabels:\n  - labels:\n      goog-ops-agent-policy: v2-x86-template-1-4-0\n' > config.yaml && gcloud compute instances ops-agents policies create goog-ops-agent-v2-x86-template-1-4-0-$ZONE --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --file=config.yaml

sleep 30

# Create firewall rule to allow incoming HTTP traffic on port 80
gcloud compute firewall-rules create allow-http \
    --project=$DEVSHELL_PROJECT_ID \
    --direction=INGRESS \
    --priority=1000 \
    --network=default \
    --action=ALLOW \
    --rules=tcp:80 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=http-server

sleep 10

# Generate SSH keys
gcloud compute config-ssh --project "$DEVSHELL_PROJECT_ID" --quiet

# CLOUDSDK_CORE_DISABLE_PROMPTS=1 
# gcloud compute ssh lamp-1-vm   --project="$DEVSHELL_PROJECT_ID"   --zone="$ZONE"   --troubleshoot   --tunnel-through-iap   --command="sudo sed -i '/buster-backports/d' /etc/apt/sources.list && sudo apt-get update && sudo apt-get install apache2 php7.0 -y && sudo service apache2 restart"

gcloud compute ssh lamp-1-vm --project "$DEVSHELL_PROJECT_ID" --zone $ZONE --command "sudo sed -i '/buster-backports/d' /etc/apt/sources.list && sudo apt-get update && sudo apt-get install apache2 php7.0 -y && sudo service apache2 restart"


sleep 10

INSTANCE_ID="$(gcloud compute instances describe  lamp-1-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --format='value(id)')"

gcloud monitoring uptime create lamp-uptime-check \
  --resource-type="gce-instance" \
  --resource-labels=project_id=$DEVSHELL_PROJECT_ID,instance_id=$INSTANCE_ID,zone=$ZONE


cat > email-channel.json <<EOF_END
{
  "type": "email",
  "displayName": "quicklab",
  "description": "Subscribe to quicklab",
  "labels": {
    "email_address": "$USER_EMAIL"
  }
}
EOF_END


gcloud beta monitoring channels create --channel-content-from-file="email-channel.json"




# Run the gcloud command and store the output in a variable
channel_info=$(gcloud beta monitoring channels list)

# Extract the channel ID using grep and awk
channel_id=$(echo "$channel_info" | grep -oP 'name: \K[^ ]+' | head -n 1)


cat > app-engine-error-percent-policy.json <<EOF_END
{
  "displayName": "Inbound Traffic Alert",
  "userLabels": {},
  "conditions": [
    {
      "displayName": "VM Instance - Network traffic",
      "conditionThreshold": {
        "filter": "resource.type = \"gce_instance\" AND metric.type = \"agent.googleapis.com/interface/traffic\"",
        "aggregations": [
          {
            "alignmentPeriod": "300s",
            "crossSeriesReducer": "REDUCE_NONE",
            "perSeriesAligner": "ALIGN_RATE"
          }
        ],
        "comparison": "COMPARISON_GT",
        "duration": "60s",
        "trigger": {
          "count": 1
        },
        "thresholdValue": 500
      }
    }
  ],
  "alertStrategy": {},
  "combiner": "OR",
  "enabled": true,
  "notificationChannels": [
    "$channel_id"
  ],
  "severity": "SEVERITY_UNSPECIFIED"
}
EOF_END


gcloud alpha monitoring policies create --policy-from-file="app-engine-error-percent-policy.json"


INSTANCE_ID=$(gcloud compute instances describe lamp-1-vm --zone=$ZONE --format='value(id)')

gcloud monitoring uptime create lamp-uptime-check \
  --resource-type="gce-instance" \
  --resource-labels=project_id=$DEVSHELL_PROJECT_ID,instance_id=$INSTANCE_ID,zone=$ZONE

gcloud compute ssh lamp-1-vm --project "$DEVSHELL_PROJECT_ID" --zone $ZONE --command "sudo sed -i '/buster-backports/d' /etc/apt/sources.list && sudo apt-get update && sudo apt-get install apache2 php7.0 -y && sudo service apache2 restart"
