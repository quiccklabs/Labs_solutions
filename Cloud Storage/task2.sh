

# 2nd Project ID

export REGION="${ZONE%-*}"

gsutil mb -p $DEVSHELL_PROJECT_ID -c STANDARD -l $REGION -b on gs://$DEVSHELL_PROJECT_ID-2

gsutil uniformbucketlevelaccess set off gs://$DEVSHELL_PROJECT_ID-2

echo "subscribe to quicklab" > test.txt

gsutil cp test.txt gs://$DEVSHELL_PROJECT_ID-2




# Create the service account
gcloud iam service-accounts create cross-project-storage --display-name "Cross-Project Storage Account"

# Grant Storage Object Viewer role to the service account
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member="serviceAccount:cross-project-storage@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" --role="roles/storage.objectViewer"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member="serviceAccount:cross-project-storage@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" --role="roles/storage.objectAdmin"

# Generate and download the JSON key file
gcloud iam service-accounts keys create credentials.json --iam-account=cross-project-storage@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com

# Create VM instance
gcloud compute instances create crossproject \
  --project=$DEVSHELL_PROJECT_ID \
  --zone=$ZONE \
  --machine-type=e2-medium \
  --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
  --metadata=enable-oslogin=true \
  --maintenance-policy=MIGRATE \
  --provisioning-model=STANDARD \
  --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
  --create-disk="auto-delete=yes,boot=yes,device-name=crossproject,image=projects/debian-cloud/global/images/debian-11-bullseye-v20240110,mode=rw,size=10,type=pd-balanced" \
  --no-shielded-secure-boot \
  --shielded-vtpm \
  --shielded-integrity-monitoring \
  --labels=goog-ec-src=vm_add-gcloud \
  --reservation-affinity=any



# Change storage roles
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
    --member serviceAccount:cross-project-storage@YOUR_PROJECT_ID.iam.gserviceaccount.com \
    --role roles/storage.objectAdmin


