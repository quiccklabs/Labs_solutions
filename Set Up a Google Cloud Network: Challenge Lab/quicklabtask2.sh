gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USER1 \
  --role=roles/cloudsql.instanceUser

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USER2 \
  --role=roles/cloudsql.admin


gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USER2 \
  --role=roles/compute.networkAdmin

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USER2 \
  --role=roles/compute.securityAdmin

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USER2 \
  --role=roles/logging.admin


# Remove Viewer role
gcloud projects remove-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USER3 \
  --role=roles/viewer

# Add Editor role
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USER3 \
  --role=roles/editor

gcloud projects remove-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USER3 \
  --role=roles/editor

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USER3 \
  --role=roles/viewer
