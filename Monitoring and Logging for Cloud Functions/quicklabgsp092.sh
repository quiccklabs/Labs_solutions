

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


cat > index.js <<EOF
/**
 * Responds to any HTTP request.
 *
 * @param {!express:Request} req HTTP request context.
 * @param {!express:Response} res HTTP response context.
 */
exports.helloWorld = (req, res) => {
    let message = req.query.message || req.body.message || 'Hello World!';
    res.status(200).send(message);
  };
  
EOF


cat > package.json <<EOF
{
    "name": "sample-http",
    "version": "0.0.1"
  }
  
EOF


# Your existing deployment command
deploy_function() {
    gcloud functions deploy helloWorld \
    --trigger-http \
    --runtime nodejs20 \
    --allow-unauthenticated \
    --region $REGION \
    --max-instances 5 \
    --no-gen2 \
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


curl -LO 'https://github.com/tsenart/vegeta/releases/download/v6.3.0/vegeta-v6.3.0-linux-386.tar.gz'

tar xvzf vegeta-v6.3.0-linux-386.tar.gz



gcloud logging metrics create CloudFunctionLatency-Logs \
    --project=$DEVSHELL_PROJECT_ID \
    --description="subscribe to quicklab" \
    --log-filter='resource.type="cloud_function" AND resource.labels.function_name="helloWorld" AND log_name="projects/$DEVSHELL_PROJECT_ID/logs/cloudaudit.googleapis.com%2Factivity" AND resource.labels.region="$REGION"'
