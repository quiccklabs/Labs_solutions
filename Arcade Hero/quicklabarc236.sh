PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER=$(gcloud projects list --filter="project_id:$PROJECT_ID" --format='value(project_number)')

git clone https://github.com/GoogleCloudPlatform/golang-samples.git
cd golang-samples/functions/functionsv2/hellostorage/


deploy_function() {
gcloud functions deploy "$SERVICE_NAME" \
  --runtime=go121 \
  --region="$REGION" \
  --source=. \
  --entry-point=HelloStorage \
  --trigger-bucket="$DEVSHELL_PROJECT_ID-bucket"

}

# Variables
SERVICE_NAME="cf-demo"

# Loop until the Cloud Function is deployed
while true; do
  # Run the deployment command
  deploy_function

  # Check if Cloud Function is deployed
  if gcloud functions describe "$SERVICE_NAME" --region "$REGION" &> /dev/null; then
    echo "Cloud Function is deployed. Exiting the loop."
    break
  else
    echo "Waiting for Cloud Function to be deployed..."
    echo "In the meantime, subscribe to Quicklab at https://www.youtube.com/@quick_lab."
    sleep 10
  fi
done

