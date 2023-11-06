

gcloud config set run/region $REGION

gcloud services enable run.googleapis.com

sleep 10

git clone https://github.com/subfuzion/dart-flutter-fullstack-demo.git && cd dart-flutter-fullstack-demo/backend

cat > cloudbuild.yaml <<EOF_END
steps:
- name: gcr.io/cloud-builders/docker
  args: ['build', '-t', 'gcr.io/$DEVSHELL_PROJECT_ID/backend-service', '.']
- name: 'gcr.io/cloud-builders/docker'
  args: ['push', 'gcr.io/$DEVSHELL_PROJECT_ID/backend-service']
EOF_END


gcloud run deploy backend-service \
   --image gcr.io/$GOOGLE_CLOUD_PROJECT/backend-service \
   --platform managed \
   --region $REGION \
   --allow-unauthenticated \
   --max-instances=2

backend_service=$(gcloud run services list --platform managed --format='value(URL)' --filter='backend-service')

curl -X POST -H "content-type: application/json" \
   -d '{ "name": "World" }' -i -w "\n" $backend_service


gcloud run deploy backend-proxy \
   --image gcr.io/qwiklabs-resources/backend-proxy \
   --platform managed \
   --region $REGION \
   --allow-unauthenticated \
   --set-env-vars "ENDPOINT=$backend_service" \
   --max-instances=2

backend_proxy=$(gcloud run services list --platform managed --format='value(URL)' --filter='backend-proxy')

curl -X POST -H "content-type: application/json" \
   -d '{ "name": "World" }' -i -w "\n" $backend_proxy

gcloud builds submit --config cloudbuild.yaml
