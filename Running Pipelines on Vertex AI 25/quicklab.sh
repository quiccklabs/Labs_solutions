

export PROJECT_NUMBER="$(gcloud projects describe $DEVSHELL_PROJECT_ID --format='get(projectNumber)')"


gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
  --role=roles/storage.admin

sleep 70

gcloud storage buckets create gs://$DEVSHELL_PROJECT_ID
touch emptyfile1
touch emptyfile2
gcloud storage cp emptyfile1 gs://$DEVSHELL_PROJECT_ID/pipeline-output/emptyfile1
gcloud storage cp emptyfile2 gs://$DEVSHELL_PROJECT_ID/pipeline-input/emptyfile2


wget https://storage.googleapis.com/cloud-training/dataengineering/lab_assets/ai_pipelines/basic_pipeline.json

sed -i 's/PROJECT_ID/$DEVSHELL_PROJECT_ID/g' basic_pipeline.json

tail -20 basic_pipeline.json

gcloud storage cp basic_pipeline.json gs://$DEVSHELL_PROJECT_ID/pipeline-input/basic_pipeline.json
