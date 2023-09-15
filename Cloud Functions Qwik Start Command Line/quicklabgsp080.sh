


gcloud config set compute/region $REGION

mkdir gcf_hello_world

cd gcf_hello_world

cat > index.js <<EOF_END
/**
* Background Cloud Function to be triggered by Pub/Sub.
* This function is exported by index.js, and executed when
* the trigger topic receives a message.
*
* @param {object} data The event payload.
* @param {object} context The event metadata.
*/
exports.helloWorld = (data, context) => {
const pubSubMessage = data;
const name = pubSubMessage.data
    ? Buffer.from(pubSubMessage.data, 'base64').toString() : "Hello World";
console.log(`My Cloud Function: ${name}`);
};
EOF_END


gsutil mb -p $DEVSHELL_PROJECT_ID gs://$DEVSHELL_PROJECT_ID


gcloud functions deploy helloWorld \
  --stage-bucket gs://$DEVSHELL_PROJECT_ID \
  --trigger-topic hello_world \
  --runtime nodejs20