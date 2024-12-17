



export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")

export REGION=${ZONE%-*}

gcloud compute addresses create eth-mainnet-rpc-ip --project=$DEVSHELL_PROJECT_ID --region=$REGION

gcloud compute --project=$DEVSHELL_PROJECT_ID firewall-rules create eth-rpc-node-fw --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:30303,tcp:9000,tcp:8545,udp:30303,udp:9000 --source-ranges=0.0.0.0/0 --target-tags=eth-rpc-node

NAT_IP=$(gcloud compute addresses describe eth-mainnet-rpc-ip --region=$REGION --format='get(address)')


## IAM code


gcloud iam service-accounts create eth-rpc-node-sa \
    --description="Service account for Ethereum RPC node" \
    --display-name="eth-rpc-node-sa"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member="serviceAccount:eth-rpc-node-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/compute.osLogin"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member="serviceAccount:eth-rpc-node-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/servicemanagement.serviceController"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member="serviceAccount:eth-rpc-node-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/logging.logWriter"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member="serviceAccount:eth-rpc-node-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/monitoring.metricWriter"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member="serviceAccount:eth-rpc-node-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/cloudtrace.agent"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member="serviceAccount:eth-rpc-node-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/compute.networkUser"


## snapshot

gcloud compute resource-policies create snapshot-schedule eth-mainnet-rpc-node-disk-snapshot --project=$DEVSHELL_PROJECT_ID --region=$REGION --max-retention-days=7 --on-source-disk-delete=keep-auto-snapshots --daily-schedule --start-time=18:00 --storage-location=$REGION

# 2 changes need to do machine type and scope

gcloud compute instances create eth-mainnet-rpc-node --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-medium --network-interface=address=$NAT_IP,network-tier=PREMIUM,nic-type=GVNIC,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=eth-rpc-node-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append --tags=eth-rpc-node --create-disk=auto-delete=yes,boot=yes,device-name=eth-mainnet-rpc-node,disk-resource-policy=projects/$DEVSHELL_PROJECT_ID/regions/$REGION/resourcePolicies/eth-mainnet-rpc-node-disk-snapshot,image=projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20241115,mode=rw,size=50,type=pd-ssd --create-disk=device-name=eth-mainnet-rpc-node-disk,disk-resource-policy=projects/$DEVSHELL_PROJECT_ID/regions/$REGION/resourcePolicies/eth-mainnet-rpc-node-disk-snapshot,mode=rw,name=eth-mainnet-rpc-node-disk,size=200,type=pd-ssd --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any





# code to addd 


# sudo -i -u ethereum bash <<EOF

# # Start the bash command line (already the default shell)
# bash

# # Change to the ethereum user's home directory
# cd ~

# # Confirm the current directory
# echo "You are now in the home directory of the 'ethereum' user:"
# pwd

# EOF





sleep 30

cat > prepare_disk.sh <<'EOF_END'
sudo dd if=/dev/zero of=/swapfile bs=1MiB count=25KiB
sudo chmod 0600 /swapfile
sudo mkswap /swapfile
echo "/swapfile swap swap defaults 0 0" | sudo tee -a /etc/fstab
sudo swapon -a
free -g
sudo lsblk
echo "y" | sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
sudo mkdir -p /mnt/disks/chaindata-disk
sudo mount -o discard,defaults /dev/sdb /mnt/disks/chaindata-disk
sudo chmod a+w /mnt/disks/chaindata-disk
sudo blkid /dev/sdb
export DISK_UUID=$(findmnt -n -o UUID /dev/sdb)
echo "UUID=$DISK_UUID /mnt/disks/chaindata-disk ext4 discard,defaults,nofail 0 2" | sudo tee -a /etc/fstab
df -h

sudo useradd -m ethereum
sudo usermod -aG sudo ethereum
sudo usermod -aG google-sudoers ethereum

EOF_END

cat > prepare_disk_2.sh <<'EOF_END'

#!/bin/bash

# Run commands as the ethereum user
sudo -u ethereum bash <<'EOF'

# Ensure we're in the home directory
cd ~

# Update and install required packages
sudo apt update -y
sudo apt-get update -y
sudo apt install -y dstat jq

# Install Google Cloud Ops Agent
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install
rm add-google-cloud-ops-agent-repo.sh

# Prepare directories
mkdir -p /mnt/disks/chaindata-disk/ethereum/geth/chaindata
mkdir -p /mnt/disks/chaindata-disk/ethereum/geth/logs
mkdir -p /mnt/disks/chaindata-disk/ethereum/lighthouse/chaindata
mkdir -p /mnt/disks/chaindata-disk/ethereum/lighthouse/logs

# Install Ethereum and Lighthouse
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get -y install ethereum

# Check Geth version
geth version

# Fetch the latest Lighthouse release information
RELEASE_URL="https://api.github.com/repos/sigp/lighthouse/releases/latest"
LATEST_VERSION=$(curl -s $RELEASE_URL | jq -r '.tag_name')

# Download and extract Lighthouse
DOWNLOAD_URL=$(curl -s $RELEASE_URL | jq -r '.assets[] | select(.name | endswith("x86_64-unknown-linux-gnu.tar.gz")) | .browser_download_url')
curl -L "$DOWNLOAD_URL" -o "lighthouse-${LATEST_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
tar -xvf "lighthouse-${LATEST_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
sudo mv lighthouse /usr/bin
rm "lighthouse-${LATEST_VERSION}-x86_64-unknown-linux-gnu.tar.gz"

# Set up JWT secret
cd ~
mkdir -p ~/.secret
openssl rand -hex 32 > ~/.secret/jwtsecret
chmod 440 ~/.secret/jwtsecret

EOF
EOF_END

gcloud compute scp prepare_disk.sh eth-mainnet-rpc-node:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh eth-mainnet-rpc-node --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/prepare_disk.sh"

gcloud compute scp prepare_disk_2.sh eth-mainnet-rpc-node:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh eth-mainnet-rpc-node --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/prepare_disk_2.sh"




cat > prepare_disk_3.sh <<'EOF_END'
#!/bin/bash

sudo -u ethereum bash <<'EOFF'

mkdir -p ~/.secret
openssl rand -hex 32 > ~/.secret/jwtsecret
chmod 440 ~/.secret/jwtsecret

# Ensure we're in the home directory


export CHAIN=eth
export NETWORK=mainnet
export EXT_IP_ADDRESS_NAME=$CHAIN-$NETWORK-rpc-ip
export EXT_IP_ADDRESS=$(gcloud compute addresses list --filter=$EXT_IP_ADDRESS_NAME --format="value(address_range())")

nohup geth --datadir "/mnt/disks/chaindata-disk/ethereum/geth/chaindata" \
--http.corsdomain "*" \
--http \
--http.addr 0.0.0.0 \
--http.port 8545 \
--http.corsdomain "*" \
--http.api admin,debug,web3,eth,txpool,net \
--http.vhosts "*" \
--gcmode full \
--cache 2048 \
--mainnet \
--metrics \
--metrics.addr 127.0.0.1 \
--syncmode snap \
--authrpc.vhosts="localhost" \
--authrpc.port 8551 \
--authrpc.jwtsecret=/home/ethereum/.secret/jwtsecret \
--txpool.accountslots 32 \
--txpool.globalslots 8192 \
--txpool.accountqueue 128 \
--txpool.globalqueue 2048 \
--nat extip:$EXT_IP_ADDRESS \
&> "/mnt/disks/chaindata-disk/ethereum/geth/logs/geth.log" &

sudo chmod 666 /etc/google-cloud-ops-agent/config.yaml

sudo cat << EOF >> /etc/google-cloud-ops-agent/config.yaml
logging:
  receivers:
    syslog:
      type: files
      include_paths:
      - /var/log/messages
      - /var/log/syslog

    ethGethLog:
      type: files
      include_paths: ["/mnt/disks/chaindata-disk/ethereum/geth/logs/geth.log"]
      record_log_file_path: true

    ethLighthouseLog:
      type: files
      include_paths: ["/mnt/disks/chaindata-disk/ethereum/lighthouse/logs/lighthouse.log"]
      record_log_file_path: true

    journalLog:
      type: systemd_journald

  service:
    pipelines:
      logging_pipeline:
        receivers:
        - syslog
        - journalLog
        - ethGethLog
        - ethLighthouseLog
EOF

sudo systemctl stop google-cloud-ops-agent
sudo systemctl start google-cloud-ops-agent

sudo journalctl -xe | grep "google_cloud_ops_agent_engine"

sudo cat << EOF >> /etc/google-cloud-ops-agent/config.yaml
metrics:
  receivers:
    prometheus:
        type: prometheus
        config:
          scrape_configs:
            - job_name: 'geth_exporter'
              scrape_interval: 10s
              metrics_path: /debug/metrics/prometheus
              static_configs:
                - targets: ['localhost:6060']
            - job_name: 'lighthouse_exporter'
              scrape_interval: 10s
              metrics_path: /metrics
              static_configs:
                - targets: ['localhost:5054']

  service:
    pipelines:
      prometheus_pipeline:
        receivers:
        - prometheus
EOF

sudo systemctl stop google-cloud-ops-agent
sudo systemctl start google-cloud-ops-agent

sudo journalctl -xe | grep "google_cloud_ops_agent_engine"

EOFF
EOF_END

gcloud compute scp prepare_disk_3.sh eth-mainnet-rpc-node:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh eth-mainnet-rpc-node --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/prepare_disk_3.sh"







cat > email-channel.json <<EOF_END
{
  "type": "email",
  "displayName": "quicklab",
  "description": "Please subscrbibe to quicklab",
  "labels": {
    "email_address": "$USER_EMAIL"
  }
}
EOF_END

gcloud beta monitoring channels create --channel-content-from-file="email-channel.json"

# Get the channel ID
email_channel_info=$(gcloud beta monitoring channels list)
email_channel_id=$(echo "$email_channel_info" | grep -oP 'name: \K[^ ]+' | head -n 1)

cat > quicklabb.json <<EOF_END
{
  "displayName": "VM - Disk space alert - 90% utilization",
  "documentation": {
    "content": "Check the disk space of the VM",
    "mimeType": "text/markdown"
  },
  "userLabels": {},
  "conditions": [
    {
      "displayName": "VM Instance - Disk utilization",
      "conditionThreshold": {
        "filter": "resource.type = \"gce_instance\" AND metric.type = \"agent.googleapis.com/disk/percent_used\" AND (metric.labels.device = \"/dev/sdb\" AND metric.labels.state = \"used\")",
        "aggregations": [
          {
            "alignmentPeriod": "300s",
            "crossSeriesReducer": "REDUCE_NONE",
            "perSeriesAligner": "ALIGN_MEAN"
          }
        ],
        "comparison": "COMPARISON_GT",
        "duration": "0s",
        "trigger": {
          "count": 1
        },
        "thresholdValue": 90
      }
    }
  ],
  "alertStrategy": {
    "autoClose": "172800s",
    "notificationPrompts": [
      "OPENED",
      "CLOSED"
    ]
  },
  "combiner": "OR",
  "enabled": true,
  "notificationChannels": [
    "$email_channel_id"
  ],
  "severity": "SEVERITY_UNSPECIFIED"
}
EOF_END

gcloud alpha monitoring policies create --policy-from-file="quicklabb.json"

export INSTANCE_ID=$(gcloud compute instances list --filter=eth-mainnet-rpc-node --zones $ZONE --format="value(id)")

curl -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Content-Type: application/json" \
  "https://monitoring.googleapis.com/v3/projects/$DEVSHELL_PROJECT_ID/uptimeCheckConfigs" \
  -d "$(cat <<EOF
{
  "displayName": "eth-mainnet-rpc-node-uptime-check",
  "monitoredResource": {
    "type": "gce_instance",
    "labels": {
      "instance_id": "$INSTANCE_ID",
      "project_id": "$DEVSHELL_PROJECT_ID",
      "zone": "$ZONE"
    }
  },
  "httpCheck": {
    "path": "/",
    "port": 8545,
    "requestMethod": "GET",
    "acceptedResponseStatusCodes": [
      {
        "statusClass": "STATUS_CLASS_2XX"
      }
    ]
  },
  "period": "60s",
  "timeout": "10s",
  "checkerType": "STATIC_IP_CHECKERS"
}
EOF
)"


