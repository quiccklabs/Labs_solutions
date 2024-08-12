



export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
gcloud config set compute/region $REGION

gcloud services enable \
  cloudresourcemanager.googleapis.com \
  container.googleapis.com \
  artifactregistry.googleapis.com \
  containerregistry.googleapis.com \
  containerscanning.googleapis.com

gcloud services enable artifactregistry.googleapis.com \
cloudbuild.googleapis.com \
run.googleapis.com

mkdir app && cd app

gsutil cp gs://cloud-training/CBL515/sample-apps/sample-node-app.zip . && unzip sample-node-app

cd sample-node-app

npm install

timeout 10  npm start

gcloud artifacts repositories create my-repo --repository-format=docker \
  --location=$REGION \
  --description="Docker repository for Container Dev Workshop subscribe to quicklab"

gcloud auth configure-docker $REGION-docker.pkg.dev

REPO=${REGION}-docker.pkg.dev/${PROJECT_ID}/my-repo

cat > cloudbuild.yaml <<EOF
steps:
- name: 'gcr.io/cloud-builders/docker'
  args: [ 'build', '-t', '${REPO}/sample-node-app-image', '.' ]
images:
- '${REPO}/sample-node-app-image'
EOF

gcloud builds submit --region=$REGION --config=cloudbuild.yaml

gcloud run deploy sample-node-app --image ${REPO}/sample-node-app-image --region $REGION --allow-unauthenticated


URL=$(gcloud run services list --format='value(URL)')


curl $URL/service/products | jq

sleep 30

curl $URL/service/products | jq