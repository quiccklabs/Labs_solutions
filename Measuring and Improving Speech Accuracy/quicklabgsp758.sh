



gcloud services enable notebooks.googleapis.com

gcloud services enable aiplatform.googleapis.com



gsutil mb gs://$DEVSHELL_PROJECT_ID

cat > startup-script.sh <<EOF_END
#!/bin/bash

# Copy notebooks
gsutil cp gs://spls/gsp758/notebook/measuring-accuracy.ipynb .
gsutil cp gs://spls/gsp758/notebook/speech_adaptation.ipynb .
gsutil cp gs://spls/gsp758/notebook/simple_wer_v2.py .

# Run the notebooks
jupyter nbconvert --to notebook --execute measuring-accuracy.ipynb
jupyter nbconvert --to notebook --execute speech_adaptation.ipynb

EOF_END


export REGION="${ZONE%-*}"
export NOTEBOOK_NAME="quicklab-jupyter"
export MACHINE_TYPE="e2-standard-2"
export STARTUP_SCRIPT_URL="gs://$DEVSHELL_PROJECT_ID/startup-script.sh"

gcloud compute images list --project=deeplearning-platform-release --no-standard-images --filter="name~'tf2-ent-2-1'"


gcloud notebooks instances create $NOTEBOOK_NAME \
  --location=$ZONE \
  --vm-image-project=deeplearning-platform-release \
  --vm-image-family=tf-2-11-cu113-notebooks \
  --machine-type=$MACHINE_TYPE \
  --metadata=startup-script-url=gs://$DEVSHELL_PROJECT_ID/startup-script.sh


echo -e "\e[1m\e[33mClick here: https://console.cloud.google.com/vertex-ai/workbench/user-managed?project=$DEVSHELL_PROJECT_ID\e[0m"


