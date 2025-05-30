

export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")


PROJECT_ID=`gcloud config get-value project`

export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")


gcloud services enable spanner.googleapis.com
gcloud services enable artifactregistry.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable run.googleapis.com


git clone https://github.com/GoogleCloudPlatform/training-data-analyst

cd training-data-analyst/courses/cloud-spanner/omegatrade/

cd backend/app/models

cd ../../../frontend/src/app/components

cd ../../../../backend

cat > .env <<EOF_END
PROJECTID = $DEVSHELL_PROJECT_ID
INSTANCE = omegatrade-instance
DATABASE = omegatrade-db
JWT_KEY = w54p3Y?4dj%8Xqa2jjVC84narhe5Pk
EXPIRE_IN = 30d
EOF_END

nvm install 22.6

npm install npm -g
npm install --loglevel=error

docker build -t gcr.io/$DEVSHELL_PROJECT_ID/omega-trade/backend:v1 -f dockerfile.prod .

gcloud auth configure-docker

docker push gcr.io/$DEVSHELL_PROJECT_ID/omega-trade/backend:v1

gcloud run deploy omegatrade-backend --platform managed --region $REGION --image gcr.io/$DEVSHELL_PROJECT_ID/omega-trade/backend:v1 --memory 512Mi --allow-unauthenticated

unset SPANNER_EMULATOR_HOST
node seed-data.js

cd training-data-analyst/courses/cloud-spanner/omegatrade/backend
nvm install 22.6
npm install npm -g
npm install --loglevel=error

npm install dotenv
node seed-data.js
