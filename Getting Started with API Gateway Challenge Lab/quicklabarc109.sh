



gcloud auth list

gcloud services enable apigateway.googleapis.com

sleep 10

mkdir quicklab
cd quicklab



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

sleep 40

export PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format="json(projectNumber)" --quiet | jq -r '.projectNumber')

# Set the service account email
SERVICE_ACCOUNT="service-$PROJECT_NUMBER@gcf-admin-robot.iam.gserviceaccount.com"

# Get the current IAM policy
IAM_POLICY=$(gcloud projects get-iam-policy $DEVSHELL_PROJECT_ID --format=json)

# Check if the binding exists
if [[ "$IAM_POLICY" == *"$SERVICE_ACCOUNT"* && "$IAM_POLICY" == *"roles/artifactregistry.reader"* ]]; then
  echo "IAM binding exists for service account: $SERVICE_ACCOUNT with role roles/artifactregistry.reader"
else
  echo "IAM binding does not exist for service account: $SERVICE_ACCOUNT with role roles/artifactregistry.reader"
  
  # Create the IAM binding
  gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member=serviceAccount:$SERVICE_ACCOUNT \
    --role=roles/artifactregistry.reader

  echo "IAM binding created for service account: $SERVICE_ACCOUNT with role roles/artifactregistry.reader"
fi



gcloud functions deploy GCFunction \
  --runtime=nodejs20 \
  --trigger-http \
  --gen2 \
  --allow-unauthenticated \
  --entry-point=helloWorld \
  --region=$REGION \
  --max-instances 5 \
  --source=./





gcloud pubsub topics create demo-topic

cat > index.js <<EOF
/**
 * Responds to any HTTP request.
 *
 * @param {!express:Request} req HTTP request context.
 * @param {!express:Response} res HTTP response context.
 */
const {PubSub} = require('@google-cloud/pubsub');
const pubsub = new PubSub();
const topic = pubsub.topic('demo-topic');
exports.helloWorld = (req, res) => {
  
  // Send a message to the topic
  topic.publishMessage({data: Buffer.from('Hello from Cloud Functions!')});
  res.status(200).send("Message sent to Topic demo-topic!");
};
EOF



cat > package.json <<EOF
{
  "name": "sample-http",
  "version": "0.0.1",
  "dependencies": {
    "@google-cloud/pubsub": "^3.4.1"
  }
}
EOF


gcloud functions deploy GCFunction \
  --runtime=nodejs20 \
  --trigger-http \
  --gen2 \
  --allow-unauthenticated \
  --entry-point=helloWorld \
  --region=$REGION \
  --max-instances 5 \
  --source=./




cat > openapispec.yaml <<EOF
swagger: '2.0'
info:
  title: GCFunction API
  description: Sample API on API Gateway with a Google Cloud Functions backend
  version: 1.0.0
schemes:
  - https
produces:
  - application/json
paths:
  /GCFunction:
    get:
      summary: gcfunction
      operationId: gcfunction
      x-google-backend:
        address: https://$REGION-$DEVSHELL_PROJECT_ID.cloudfunctions.net/GCFunction
      responses:
       '200':
          description: A successful response
          schema:
            type: string

EOF


PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format="value(projectNumber)")


export API_ID="gcfunction-api-$(cat /dev/urandom | tr -dc 'a-z' | fold -w ${1:-8} | head -n 1)"


gcloud api-gateway apis create $API_ID --project=$DEVSHELL_PROJECT_ID

gcloud api-gateway api-configs create gcfunction-api \
  --api=$API_ID --openapi-spec=openapispec.yaml \
  --project=$DEVSHELL_PROJECT_ID --backend-auth-service-account=$PROJECT_NUMBER-compute@developer.gserviceaccount.com


  gcloud api-gateway gateways create gcfunction-api \
  --api=$API_ID --api-config=gcfunction-api \
  --location=$REGION --project=$DEVSHELL_PROJECT_ID




# Set the service account email
SERVICE_ACCOUNT="service-$PROJECT_NUMBER@gcf-admin-robot.iam.gserviceaccount.com"

# Get the current IAM policy
IAM_POLICY=$(gcloud projects get-iam-policy $DEVSHELL_PROJECT_ID --format=json)

# Check if the binding exists
if [[ "$IAM_POLICY" == *"$SERVICE_ACCOUNT"* && "$IAM_POLICY" == *"roles/artifactregistry.reader"* ]]; then
  echo "IAM binding exists for service account: $SERVICE_ACCOUNT with role roles/artifactregistry.reader"
else
  echo "IAM binding does not exist for service account: $SERVICE_ACCOUNT with role roles/artifactregistry.reader"
  
  # Create the IAM binding
  gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member=serviceAccount:$SERVICE_ACCOUNT \
    --role=roles/artifactregistry.reader

  echo "IAM binding created for service account: $SERVICE_ACCOUNT with role roles/artifactregistry.reader"
fi


gcloud functions deploy GCFunction \
  --runtime=nodejs20 \
  --trigger-http \
  --gen2 \
  --allow-unauthenticated \
  --entry-point=helloWorld \
  --region=$REGION \
  --max-instances 5 \
  --source=./




