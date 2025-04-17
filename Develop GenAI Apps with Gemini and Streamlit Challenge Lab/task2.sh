cd generative-ai/gemini/sample-apps/gemini-streamlit-cloudrun

gcloud services enable run.googleapis.com


sed -i "s/FROM python:3.8/FROM python:3.9/g" Dockerfile
echo "google-cloud-aiplatform" >> requirements.txt

pip install --no-cache-dir -r requirements.txt


AR_REPO='chef-repo'
SERVICE_NAME='chef-streamlit-app' 
export PROJECT="$DEVSHELL_PROJECT_ID"
gcloud artifacts repositories create "$AR_REPO" --location="$REGION" --repository-format=Docker
gcloud builds submit --tag "$REGION-docker.pkg.dev/$DEVSHELL_PROJECT_ID/$AR_REPO/$SERVICE_NAME"

gcloud builds submit --tag "$REGION-docker.pkg.dev/$PROJECT/$AR_REPO/$SERVICE_NAME"


gcloud run deploy "$SERVICE_NAME" \
  --port=8080 \
  --image="$REGION-docker.pkg.dev/$PROJECT/$AR_REPO/$SERVICE_NAME" \
  --allow-unauthenticated \
  --region=$REGION \
  --platform=managed  \
  --project=$DEVSHELL_PROJECT_ID \
  --set-env-vars=GCP_PROJECT=$DEVSHELL_PROJECT_ID,GCP_REGION=$REGION


