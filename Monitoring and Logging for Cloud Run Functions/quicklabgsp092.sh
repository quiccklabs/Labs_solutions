


export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")


gcloud services enable \
  artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  pubsub.googleapis.com

sleep 60

mkdir ~/hello-http && cd $_
touch index.js && touch package.json


cat > index.js <<'EOF'
const functions = require('@google-cloud/functions-framework');

functions.http('helloWorld', (req, res) => {
  res.status(200).send('HTTP with Node.js in GCF 2nd gen!');
});
EOF


cat > package.json <<'EOF'
{
  "dependencies": {
    "@google-cloud/functions-framework": "^3.0.0"
  }
}

EOF




# Your existing deployment command
deploy_function() {
    gcloud functions deploy helloWorld \
    --gen2 \
    --trigger-http \
    --runtime nodejs22 \
    --allow-unauthenticated \
    --region $REGION \
    --max-instances 5 \
    --quiet
}

# Variables
SERVICE_NAME="helloWorld"

# Loop until the Cloud Function is deployed
while true; do
  # Run the deployment command
  deploy_function

  # Check if Cloud Function is deployed
  if gcloud functions describe $SERVICE_NAME --region $REGION &> /dev/null; then
    echo "Cloud Function is deployed. Exiting the loop."
    break
  else
    echo "Waiting for Cloud Function to be deployed..."
    echo "Meantime Subscribe to Quicklab[https://www.youtube.com/@quick_lab]."
    sleep 10
  fi
done


sleep 20  

gcloud run deploy helloworld \
--image=$REGION-docker.pkg.dev/$DEVSHELL_PROJECT_ID/gcf-artifacts/${DEVSHELL_PROJECT_ID//-/_}__${REGION//-/_}__hello_world:version_1 \
--set-env-vars=LOG_EXECUTION_ID=true \
--execution-environment=gen2 \
--cpu=1 \
--memory=512Mi \
--region=$REGION \
--project=$DEVSHELL_PROJECT_ID \
&& gcloud run services update-traffic helloworld --to-latest



#task 2

curl -LO 'https://github.com/tsenart/vegeta/releases/download/v6.3.0/vegeta-v6.3.0-linux-386.tar.gz'

tar xvzf vegeta-v6.3.0-linux-386.tar.gz


gcloud logging metrics create CloudFunctionLatency-Logs \
    --project=$DEVSHELL_PROJECT_ID \
    --description="subscribe to quicklab" \
    --log-filter='resource.type="cloud_run_revision" AND resource.labels.function_name="helloWorld"'



