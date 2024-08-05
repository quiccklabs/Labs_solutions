gcloud config set compute/region $REGION
export PROJECT_ID=$(gcloud config get-value project)


mkdir quicklab && cd quicklab

cat > index.js <<EOF_END
const functions = require('@google-cloud/functions-framework');

functions.http('helloHttp', (req, res) => {
  res.send(`Hello ${req.query.name || req.body.name || 'World'}!`);
});

EOF_END

cat > package.json <<EOF_END
{
  "dependencies": {
    "@google-cloud/functions-framework": "^3.0.0"
  }
}

EOF_END

gcloud functions deploy cf-demo \
  --gen2 \
  --runtime nodejs20 \
  --entry-point helloHttp \    
  --source . \
  --region $REGION \
  --trigger-http \
  --allow-unauthenticated \
  --quiet

