echo ""
echo ""
echo "Please export the values."


# Prompt user to input three regions
read -p "Enter ZONE: " ZONE


export REGION="${ZONE%-*}"


gcloud compute instances create quickstart-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-small --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server,https-server --create-disk=auto-delete=yes,boot=yes,device-name=quickstart-vm,image=projects/debian-cloud/global/images/debian-12-bookworm-v20240617,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any

gcloud compute firewall-rules create allow-http --allow tcp:80 --source-ranges 0.0.0.0/0 --target-tags http-server


sleep 20

cat > prepare_disk.sh <<'EOF_END'
sudo apt-get update
sudo apt-get install apache2 php7.0 -y
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install
# Configures Ops Agent to collect telemetry from the app and restart Ops Agent.
set -e
# Create a back up of the existing file so existing configurations are not lost.
sudo cp /etc/google-cloud-ops-agent/config.yaml /etc/google-cloud-ops-agent/config.yaml.bak
# Configure the Ops Agent.
sudo tee /etc/google-cloud-ops-agent/config.yaml > /dev/null << EOF
metrics:
  receivers:
    apache:
      type: apache
  service:
    pipelines:
      apache:
        receivers:
          - apache
logging:
  receivers:
    apache_access:
      type: apache_access
    apache_error:
      type: apache_error
  service:
    pipelines:
      apache:
        receivers:
          - apache_access
          - apache_error
EOF
sudo service google-cloud-ops-agent restart
sleep 60
EOF_END

gcloud compute scp prepare_disk.sh quickstart-vm:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh quickstart-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/prepare_disk.sh"


cat > prepare_disk.sh <<'EOF_END'
sudo apt-get update
sudo apt-get install apache2 php7.0 -y
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install
# Configures Ops Agent to collect telemetry from the app and restart Ops Agent.
set -e
# Create a back up of the existing file so existing configurations are not lost.
sudo cp /etc/google-cloud-ops-agent/config.yaml /etc/google-cloud-ops-agent/config.yaml.bak
# Configure the Ops Agent.
sudo tee /etc/google-cloud-ops-agent/config.yaml > /dev/null << EOF
metrics:
  receivers:
    apache:
      type: apache
  service:
    pipelines:
      apache:
        receivers:
          - apache
logging:
  receivers:
    apache_access:
      type: apache_access
    apache_error:
      type: apache_error
  service:
    pipelines:
      apache:
        receivers:
          - apache_access
          - apache_error
EOF
sudo service google-cloud-ops-agent restart
sleep 60
EOF_END

gcloud compute scp prepare_disk.sh quickstart-vm:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh quickstart-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/prepare_disk.sh"


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
  "displayName": "Apache traffic above threshold",
  "userLabels": {},
  "conditions": [
    {
      "displayName": "VM Instance - workload/apache.traffic",
      "conditionThreshold": {
        "filter": "resource.type = \"gce_instance\" AND metric.type = \"workload.googleapis.com/apache.traffic\"",
        "aggregations": [
          {
            "alignmentPeriod": "60s",
            "crossSeriesReducer": "REDUCE_NONE",
            "perSeriesAligner": "ALIGN_RATE"
          }
        ],
        "comparison": "COMPARISON_GT",
        "duration": "0s",
        "trigger": {
          "count": 1
        },
        "thresholdValue": 4000
      }
    }
  ],
  "alertStrategy": {
    "autoClose": "1800s"
  },
  "combiner": "OR",
  "enabled": true,
  "notificationChannels": [
    "$channel_id"
  ],
  "severity": "SEVERITY_UNSPECIFIED"
}
EOF_END


gcloud alpha monitoring policies create --policy-from-file="app-engine-error-percent-policy.json"


EXTERNAL_IP=$(gcloud compute instances describe quickstart-vm --zone=$ZONE --format='get(networkInterfaces[0].accessConfigs[0].natIP)')
echo -e "\033[1;34mhttp://$EXTERNAL_IP\033[0m"
