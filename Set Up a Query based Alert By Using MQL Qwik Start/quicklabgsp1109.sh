


gcloud compute instances create quicklab --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=instance-1,image=projects/debian-cloud/global/images/debian-11-bullseye-v20231115,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any



gcloud services enable monitoring.googleapis.com


cat > pubsub-channel.json <<EOF_END
    {
      "type": "email",
      "displayName": "Alert on-call",
      "description": "subscribe to quicklab",
      "labels": {
        "email_address": "$USER_EMAIL" 
      },
    }
EOF_END


gcloud beta monitoring channels create --channel-content-from-file="pubsub-channel.json"

# Run the gcloud command and store the output in a variable
channel_info=$(gcloud beta monitoring channels list)

# Extract the channel ID using grep and awk
channel_id=$(echo "$channel_info" | grep -oP 'name: \K[^ ]+' | head -n 1)

cat > app-engine-error-percent-policy.json <<EOF_END
{
  "displayName": "quicklab",
  "documentation": {
    "content": " Your CPU usage has exceeded 2 seconds.",
    "mimeType": "text/markdown"
  },
  "userLabels": {},
  "conditions": [
    {
      "displayName": "MQL Quickstart condition",
      "conditionMonitoringQueryLanguage": {
        "duration": "0s",
        "trigger": {
          "count": 1
        },
        "query": "fetch gce_instance::compute.googleapis.com/instance/cpu/usage_time\n| window 1m\n| condition val() > 2 's'"
      }
    }
  ],
  "alertStrategy": {
    "autoClose": "604800s"
  },
  "combiner": "OR",
  "enabled": true,
  "notificationChannels": [
    $channel_id
  ]
}
EOF_END

gcloud alpha monitoring policies create --policy-from-file="app-engine-error-percent-policy.json"
