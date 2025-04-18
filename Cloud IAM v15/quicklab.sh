
echo ""
echo ""

read -p "ENTER USERNAME 2:- " USERNAME_2


gsutil mb -l us -b on gs://$DEVSHELL_PROJECT_ID


echo "subscribe to quicklab " > sample.txt


gsutil cp sample.txt gs://$DEVSHELL_PROJECT_ID


gcloud projects remove-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USERNAME_2 \
  --role=roles/viewer



gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USERNAME_2 \
  --role=roles/storage.objectViewer



gcloud iam service-accounts create read-bucket-objects \
  --description="Read access to GCS objects" \
  --display-name="Read Bucket Objects"


gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member="serviceAccount:read-bucket-objects@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/storage.objectViewer"



gcloud iam service-accounts list --filter="read-bucket-objects"


gcloud iam service-accounts add-iam-policy-binding read-bucket-objects@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
  --member="user:$USER_EMAIL@altostrat.com" \
  --role="roles/iam.serviceAccountUser"


gcloud iam service-accounts add-iam-policy-binding read-bucket-objects@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
  --member="user:USERNAME_2@altostrat.com" \
  --role="roles/iam.serviceAccountUser"


gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member="domain:altostrat.com" \
  --role="roles/compute.instanceAdmin.v1"


gcloud iam service-accounts add-iam-policy-binding read-bucket-objects@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
  --member="domain:altostrat.com" \
  --role="roles/iam.serviceAccountUser"




gcloud iam service-accounts list --filter="read-bucket-objects"


gcloud iam service-accounts add-iam-policy-binding read-bucket-objects@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
  --member="user:$USER_EMAIL@altostrat.com" \
  --role="roles/iam.serviceAccountUser"


gcloud iam service-accounts add-iam-policy-binding read-bucket-objects@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
  --member="user:USERNAME_2@altostrat.com" \
  --role="roles/iam.serviceAccountUser"


gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member="domain:altostrat.com" \
  --role="roles/compute.instanceAdmin.v1"


gcloud iam service-accounts add-iam-policy-binding read-bucket-objects@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
  --member="domain:altostrat.com" \
  --role="roles/iam.serviceAccountUser"


gcloud compute instances create demoiam \
  --zone=us-central1-c \
  --machine-type=e2-micro \
  --service-account=read-bucket-objects@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
  --scopes=https://www.googleapis.com/auth/cloud-platform



gcloud iam service-accounts add-iam-policy-binding read-bucket-objects@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
  --member="user:$USER_EMAIL@altostrat.com" \
  --role="roles/iam.serviceAccountUser"


gcloud iam service-accounts add-iam-policy-binding read-bucket-objects@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
  --member="user:USERNAME_2@altostrat.com" \
  --role="roles/iam.serviceAccountUser"


gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member="domain:altostrat.com" \
  --role="roles/compute.instanceAdmin.v1"


gcloud iam service-accounts add-iam-policy-binding read-bucket-objects@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
  --member="domain:altostrat.com" \
  --role="roles/iam.serviceAccountUser"



gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member="serviceAccount:read-bucket-objects@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/storage.objectViewer"


gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member="serviceAccount:read-bucket-objects@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/storage.objectViewer"
