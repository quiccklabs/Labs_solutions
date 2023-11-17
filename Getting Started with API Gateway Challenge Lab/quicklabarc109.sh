




gcloud auth list

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

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=serviceAccount:service-$PROJECT_NUMBER@gcf-admin-robot.iam.gserviceaccount.com \
  --role=roles/artifactregistry.reader


gcloud functions deploy GCFunction \
  --runtime=nodejs20 \
  --trigger-http \
  --gen2 \
  --allow-unauthenticated \
  --entry-point=helloWorld \
  --region=$REGION \
  --max-instances 5 \
  --source=./



gcloud services enable apigateway.googleapis.com

sleep 10

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









