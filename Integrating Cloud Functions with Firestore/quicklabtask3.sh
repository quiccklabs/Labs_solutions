



PROJECT_ID=$(gcloud config get-value project)


PROJECT_NUMBER=$(gcloud projects list \
 --filter="project_id:$PROJECT_ID" \
 --format='value(project_number)')

 gcloud config set functions/region $REGION

gcloud services enable \
  artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  storage.googleapis.com \
  pubsub.googleapis.com



#Need to do manually


gcloud storage cp -R gs://cloud-training/CBL493/firestore_functions .

cd firestore_functions


cat > index.js <<'EOF_END'
 /**
  * Cloud Event Function triggered by a change to a Firestore document.
  */
 const functions = require('@google-cloud/functions-framework');
 const protobuf = require('protobufjs');

 functions.cloudEvent('newCustomer', async cloudEvent => {
   console.log(`Function triggered by event on: ${cloudEvent.source}`);
   console.log(`Event type: ${cloudEvent.type}`);

   console.log('Loading protos...');
   const root = await protobuf.load('data.proto');
   const DocumentEventData = root.lookupType('google.events.cloud.firestore.v1.DocumentEventData');

   console.log('Decoding data...');
   const firestoreReceived = DocumentEventData.decode(cloudEvent.data);

   console.log('\nNew document:');
   console.log(JSON.stringify(firestoreReceived.value, null, 2));
 });
EOF_END


cat > package.json <<'EOF_END'
{
    "name": "firestore_functions",
    "version": "0.0.1",
    "main": "index.js",
    "dependencies": {
      "@google-cloud/functions-framework": "^3.1.3",
      "protobufjs": "^7.2.2",
      "@google-cloud/firestore": "^6.0.0"
    }
   }
EOF_END


SERVICE_ACCOUNT=service-$PROJECT_NUMBER@gcf-admin-robot.iam.gserviceaccount.com

gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SERVICE_ACCOUNT --role roles/artifactregistry.reader

gcloud services disable cloudfunctions.googleapis.com

gcloud services enable cloudfunctions.googleapis.com

gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SERVICE_ACCOUNT --role roles/artifactregistry.reader





# Your existing deployment command
deploy_function() {
gcloud functions deploy newCustomer \
--gen2 \
--runtime=nodejs20 \
--region=$REGION \
--trigger-location=$REGION \
--source=. \
--entry-point=newCustomer \
--trigger-event-filters=type=google.cloud.firestore.document.v1.created \
--trigger-event-filters=database='(default)' \
--trigger-event-filters-path-pattern=document='customers/{name}'
}

# Variables
SERVICE_NAME="newCustomer"

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


