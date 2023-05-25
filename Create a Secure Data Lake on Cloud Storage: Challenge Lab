

export REGION=

export USER2=

gcloud services enable dataplex.googleapis.com

gsutil mb -l $REGION gs://"$DEVSHELL_PROJECT_ID-bucket"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=user:$USER2 --role=roles/serviceusage.serviceUsageAdmin
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=user:$USER2 --role=roles/dataplex.admin


