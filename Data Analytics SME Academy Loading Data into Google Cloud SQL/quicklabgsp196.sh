
git clone \
   https://github.com/GoogleCloudPlatform/data-science-on-gcp/

cd data-science-on-gcp/03_sqlstudio

export PROJECT_ID=$(gcloud info --format='value(config.project)')
export BUCKET=${PROJECT_ID}-ml

gsutil cp create_table.sql \
    gs://$BUCKET/create_table.sql

gcloud sql instances create flights \
    --database-version=POSTGRES_13 --cpu=2 --memory=8GiB \
    --region=$REGION --root-password=Passw0rd


export ADDRESS=$(curl -s http://ipecho.net/plain)/32

gcloud sql instances patch flights --authorized-networks $ADDRESS --quiet

gcloud sql databases create bts --instance=flights
