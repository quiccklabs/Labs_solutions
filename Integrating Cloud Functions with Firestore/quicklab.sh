


PROJECT_ID=$(gcloud config get-value project)

PROJECT_NUMBER=$(gcloud projects list \
 --filter="project_id:$PROJECT_ID" \
 --format='value(project_number)')

gcloud config set functions/region $REGION




cat > functions/index.js <<'EOF_END'
const functions = require("firebase-functions");

// The Firebase Admin SDK to access Firestore.
const admin = require("firebase-admin");
admin.initializeApp();

// Take the text parameter passed to this HTTP endpoint and insert it into
// Firestore under the path /customers/:documentId
exports.addCustomer = functions
  .region('${REGION}')
  .https.onRequest(async (req, res) => {
  const data = (req.body) || {};
  // Push the new message into Firestore using the Firebase Admin SDK.
  const writeResult = await admin.firestore().collection("customers").add(data);
  // Log and send back a message that we've successfully written the message
  functions.logger.log('Added customer data with document ID:', writeResult.id);
   // Add the code below before the final res.json statement
  const fs = require('fs/promises');
 try {
   const secret = await fs.readFile('/etc/secrets/api_cred/latest', { encoding: 'utf8' });
   // use the secret. For lab testing purposes, we log the secret.
   functions.logger.log('secret: ', secret);
 } catch (err) {
   functions.logger.log(err);
 } 
res.json({result: `Customer data with ID: ${writeResult.id} added.`});
  
});


exports.addCustomerName = functions
  .region('us-west1')
  .firestore.document('/customers/{documentId}')
  .onCreate((snap, context) => {
  // Get the current value of some of the fields stored in Firestore.
  const fName = snap.data().firstName;
  const lName = snap.data().lastName;
  // Concatenate the first and last names.
  const personName = `${fName} ${lName}`;

  // Access the parameter `{documentId}` with `context.params` and log the person name.
  functions.logger.log('Added person name', context.params.documentId, personName);

   // Set a 'personName' field in Firestore document and return a Promise.
   return snap.ref.set({personName}, {merge: true});
 });
EOF_END

sed -i "10c\  .region('$REGION')" functions/index.js

sed -i "32c\  .region('$REGION')" functions/index.js




PROJECT_NUMBER=$(gcloud projects list --filter="project_id:$PROJECT_ID" --format='value(project_number)')

SERVICE_ACCOUNT=service-$PROJECT_NUMBER@gcf-admin-robot.iam.gserviceaccount.com

gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SERVICE_ACCOUNT --role roles/artifactregistry.reader

gcloud services disable cloudfunctions.googleapis.com

gcloud services enable cloudfunctions.googleapis.com

sleep 20

gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SERVICE_ACCOUNT --role roles/artifactregistry.reader

sleep 20


firebase deploy --only functions

FUNCTION_URI=$(gcloud functions describe addCustomer --format='value(httpsTrigger.url)'); echo $FUNCTION_URI

curl -X POST -H 'Content-Type: application/json' $FUNCTION_URI -d '{"firstName":"Lucas", "lastName":"Sherman", "Phone":"555-555-5555"}'


firebase deploy --only functions:addCustomerName


curl -X POST -H 'Content-Type: application/json' $FUNCTION_URI -d '{"firstName":"Walter", "lastName":"Ross", "Phone":"999-999-9999"}'

gcloud services enable secretmanager.googleapis.com

echo -n "secret_api_key" | gcloud secrets create api-cred --replication-policy="automatic" --data-file=-

gcloud secrets add-iam-policy-binding api-cred --member=serviceAccount:$PROJECT_ID@appspot.gserviceaccount.com --project=$PROJECT_ID --role='roles/secretmanager.secretAccessor'


cd functions

gcloud functions deploy addCustomer \
  --runtime nodejs16 \
  --set-secrets '/etc/secrets/api_cred/latest=api-cred:latest' \
  --trigger-http \
  --quiet



FUNCTION_URI=$(gcloud functions describe addCustomer --format='value(httpsTrigger.url)'); echo $FUNCTION_URI

curl -X POST -H 'Content-Type: application/json' $FUNCTION_URI -d '{"firstName":"Lucas", "lastName":"Sherman", "Phone":"555-555-5555"}'

curl -X POST -H 'Content-Type: application/json' $FUNCTION_URI -d '{"firstName":"Secret", "lastName":"Test", "Phone":"000-999-1234"}'

gcloud functions logs read addCustomer \
  --region $REGION --limit=100 --format "value(log)"