

sed -i "s/FROM python:3.8/FROM python:3.9/g" Dockerfile
echo "google-cloud-aiplatform" >> requirements.txt

pip install --no-cache-dir -r requirements.txt


export AR_REPO='chef-repo'
export SERVICE_NAME='chef-streamlit-app'
export PROJECT="$DEVSHELL_PROJECT_ID"

# Rebuild the container with updated dependencies
gcloud builds submit --tag "$REGION-docker.pkg.dev/$PROJECT/$AR_REPO/$SERVICE_NAME"

# Deploy the updated container
gcloud run deploy "$SERVICE_NAME" \
  --port=8080 \
  --image="$REGION-docker.pkg.dev/$PROJECT/$AR_REPO/$SERVICE_NAME" \
  --allow-unauthenticated \
  --region=$REGION \
  --platform=managed  \
  --project=$DEVSHELL_PROJECT_ID \
  --set-env-vars=GCP_PROJECT=$PROJECT,GCP_REGION=$REGION
