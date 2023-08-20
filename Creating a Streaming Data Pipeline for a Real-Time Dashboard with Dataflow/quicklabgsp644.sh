




gcloud services enable run.googleapis.com --project=$DEVSHELL_PROJECT_ID

gcloud services disable pubsub.googleapis.com --project=$DEVSHELL_PROJECT_ID --force

gcloud services enable cloudbuild.googleapis.com --project=$DEVSHELL_PROJECT_ID --quiet

gcloud services enable pubsub.googleapis.com --project=$DEVSHELL_PROJECT_ID --quiet


git clone https://github.com/rosera/pet-theory.git

cd pet-theory/lab03

cat > package.json <<EOF_END
{
  "name": "lab03",
  "version": "1.0.0",
  "description": "This is lab03 of the Pet Theory labs",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "Patrick - IT",
  "license": "MIT"
}
EOF_END


npm install express
npm install body-parser
npm install child_process
npm install @google-cloud/storage


gcloud builds submit \
  --tag gcr.io/$DEVSHELL_PROJECT_ID/pdf-converter


gcloud run deploy pdf-converter \
  --image gcr.io/$DEVSHELL_PROJECT_ID/pdf-converter \
  --platform managed \
  --region $REGION \
  --no-allow-unauthenticated \
  --max-instances=1


SERVICE_URL=$(gcloud beta run services describe pdf-converter --platform managed --region $REGION --format="value(status.url)")

echo $SERVICE_URL


gsutil mb gs://$DEVSHELL_PROJECT_ID-upload

gsutil mb gs://$DEVSHELL_PROJECT_ID-processed

gsutil notification create -t new-doc -f json -e OBJECT_FINALIZE gs://$DEVSHELL_PROJECT_ID-upload

gcloud iam service-accounts create pubsub-cloud-run-invoker --display-name "PubSub Cloud Run Invoker"

gcloud beta run services add-iam-policy-binding pdf-converter --member=serviceAccount:pubsub-cloud-run-invoker@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role=roles/run.invoker --platform managed --region $REGION

export PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format="value(projectNumber)")

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-pubsub.iam.gserviceaccount.com --role=roles/iam.serviceAccountTokenCreator

gcloud beta pubsub subscriptions create pdf-conv-sub --topic new-doc --push-endpoint=$SERVICE_URL --push-auth-service-account=pubsub-cloud-run-invoker@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com

gsutil -m cp gs://spls/gsp644/* gs://$DEVSHELL_PROJECT_ID-upload

gsutil -m rm gs://$DEVSHELL_PROJECT_ID-upload/*

cat > Dockerfile <<EOF_END
FROM node:16
RUN apt-get update -y \
    && apt-get install -y libreoffice \
    && apt-get clean
WORKDIR /usr/src/app
COPY package.json package*.json ./
RUN npm install --only=production
COPY . .
EXPOSE 8080
CMD [ "npm", "start" ]
EOF_END

curl -LO raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Creating%20a%20Streaming%20Data%20Pipeline%20for%20a%20Real-Time%20Dashboard%20with%20Dataflow/index.js


gcloud builds submit \
  --tag gcr.io/$DEVSHELL_PROJECT_ID/pdf-converter


  gcloud run deploy pdf-converter \
  --image gcr.io/$DEVSHELL_PROJECT_ID/pdf-converter \
  --platform managed \
  --region $REGION \
  --memory=2Gi \
  --no-allow-unauthenticated \
  --max-instances=1 \
  --set-env-vars PDF_BUCKET=$DEVSHELL_PROJECT_ID-processed



