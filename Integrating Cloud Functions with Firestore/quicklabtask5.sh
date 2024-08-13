
#TASK 5



gcloud services enable secretmanager.googleapis.com

echo -n "secret_api_key" | gcloud secrets create api-cred --replication-policy="automatic" --data-file=-

gcloud secrets add-iam-policy-binding api-cred --member=serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com --project=$PROJECT_ID --role='roles/secretmanager.secretAccessor'





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
 
const Firestore = require('@google-cloud/firestore');
const firestore = new Firestore({
  projectId: process.env.GOOGLE_CLOUD_PROJECT,
});

functions.cloudEvent('updateCustomer', async cloudEvent => {
  console.log('Loading protos...');
  const root = await protobuf.load('data.proto');
  const DocumentEventData = root.lookupType(
   'google.events.cloud.firestore.v1.DocumentEventData'
  );

  console.log('Decoding data...');
  const firestoreReceived = DocumentEventData.decode(cloudEvent.data);

  const resource = firestoreReceived.value.name;
  const affectedDoc = firestore.doc(resource.split('/documents/')[1]);

  // Fullname already exists, so don't update again to avoid infinite loop.
  if (firestoreReceived.value.fields.hasOwnProperty('fullname')) {
    console.log('Fullname is already present in document.');
     // BEGIN access a secret
 const fs = require('fs/promises');
 try {
   const secret = await fs.readFile('/etc/secrets/api_cred/latest', { encoding: 'utf8' });
   // use the secret. For lab testing purposes, we log the secret.
   console.log('secret: ', secret);
 } catch (err) {
   console.log(err);
 }
 // End access a secret
    return;
  }

  if (firestoreReceived.value.fields.hasOwnProperty('lastname')) {
    const lname = firestoreReceived.value.fields.lastname.stringValue;
    const fname = firestoreReceived.value.fields.firstname.stringValue;
    const fullname = `${fname} ${lname}`
    console.log(`Adding fullname --> ${fullname}`);
    await affectedDoc.update({
     fullname: fullname
    });
  }
});
EOF_END


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
    --trigger-event-filters-path-pattern=document='customers/{name}' \
    --set-secrets '/etc/secrets/api_cred/latest=api-cred:latest'
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
