



gsutil mb -l us -b on gs://$DEVSHELL_PROJECT_ID


echo "subscribe to quicklab " > sample.txt


gsutil cp sample.txt gs://$DEVSHELL_PROJECT_ID


gcloud projects remove-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USERNAME_2 \
  --role=roles/viewer



gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USERNAME_2 \
  --role=roles/storage.objectViewer
