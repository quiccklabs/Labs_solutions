


export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")


PROJECT_ID=`gcloud config get-value project`

export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")


# echo ""
# echo ""
# echo "Please export the values."



gcloud services enable securitycenter.googleapis.com --project=$DEVSHELL_PROJECT_ID

gcloud projects get-iam-policy $PROJECT_ID > policy.yaml

# Edit the policy.yaml to include audit configs for Cloud Healthcare
cat <<EOF >> policy.yaml
auditConfigs:
- auditLogConfigs:
  - logType: ADMIN_READ
  service: cloudresourcemanager.googleapis.com
EOF

gcloud projects set-iam-policy $PROJECT_ID policy.yaml



sleep 15

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
--member=user:demouser1@gmail.com --role=roles/bigquery.admin


gcloud projects remove-iam-policy-binding $DEVSHELL_PROJECT_ID \
--member=user:demouser1@gmail.com --role=roles/bigquery.admin

export PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format="value(projectNumber)")

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USER_EMAIL \
  --role=roles/cloudresourcemanager.projectIamAdmin



gcloud compute instances create instance-1 --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/cloud-platform --create-disk=auto-delete=yes,boot=yes,device-name=instance-1,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230912,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any

gcloud dns --project=$DEVSHELL_PROJECT_ID policies create dns-test-policy --description="Please like share & subscirbe to quicklab" --networks="default" --alternative-name-servers="" --private-alternative-name-servers="" --no-enable-inbound-forwarding --enable-logging

sleep 30

gcloud compute ssh --zone "$ZONE" "instance-1" --tunnel-through-iap --project "$DEVSHELL_PROJECT_ID" --quiet --command "gcloud projects get-iam-policy \$(gcloud config get project) && curl etd-malware-trigger.goog"

## deleting the vm command

gcloud compute instances create attacker-instance \
--scopes=cloud-platform  \
--zone=$ZONE \
--machine-type=e2-medium  \
--image-family=ubuntu-2004-lts \
--image-project=ubuntu-os-cloud \
--no-address


gcloud compute networks subnets update default \
--region="${ZONE%-*}" \
--enable-private-ip-google-access

sleep 30

gcloud compute ssh --zone "$ZONE" "attacker-instance" --tunnel-through-iap --project "$DEVSHELL_PROJECT_ID" --quiet --command "curl etd-malware-trigger.goog"


gcloud beta dns --project=$DEVSHELL_PROJECT_ID policies update dns-test-policy --description="Please like share & subscribe to quicklab" --networks="default" --alternative-name-servers="" --private-alternative-name-servers="" --enable-inbound-forwarding --enable-logging --enable-dns64-all-queries


gcloud compute instances delete instance-1 --zone=$ZONE --quiet

gcloud compute ssh --zone "$ZONE" "attacker-instance" --tunnel-through-iap --project "$DEVSHELL_PROJECT_ID" --quiet --command "curl etd-malware-trigger.goog"
gcloud compute ssh --zone "$ZONE" "attacker-instance" --tunnel-through-iap --project "$DEVSHELL_PROJECT_ID" --quiet --command "curl etd-malware-trigger.goog"

