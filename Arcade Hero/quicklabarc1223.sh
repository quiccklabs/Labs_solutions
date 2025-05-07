echo ""
echo ""



read -p "Export REGION :- " REGION

mkdir ~/hello-http && cd $_
touch index.js && touch package.json

cat > index.js <<EOF_END
const functions = require('@google-cloud/functions-framework');

functions.http('helloWorld', (req, res) => {
  res.status(200).send('HTTP with Node.js in GCF 2nd gen!');
});
EOF_END


cat > package.json <<EOF_END
{
  "name": "nodejs-functions-gen2-codelab",
  "version": "0.0.1",
  "main": "index.js",
  "dependencies": {
    "@google-cloud/functions-framework": "^2.0.0"
  }
}
EOF_END



gcloud functions deploy cf-nodejs \
  --gen2 \
  --runtime=nodejs20 \
  --region=$REGION \
  --trigger-http \
  --allow-unauthenticated \
  --entry-point=helloWorld \
  --min-instances=5



echo "n" | gcloud functions deploy cf-pubsub \
  --gen2 \
  --region=$REGION \
  --runtime=nodejs20 \
  --trigger-topic=cf-pubsub \
  --min-instances=5 \
  --entry-point=helloWorld \
  --source=. \
  --allow-unauthenticated
