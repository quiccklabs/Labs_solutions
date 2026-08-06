# Vertex AI: Qwik Start
# GSP917 [https://youtu.be/p0CHKpjDqiI?si=GGTZThPb9-FeiG82](https://youtu.be/p0CHKpjDqiI?si=GGTZThPb9-FeiG82)
```bash
gcloud auth list
gcloud config list project
gcloud services enable \
    compute.googleapis.com \
    iam.googleapis.com \
    iamcredentials.googleapis.com \
    monitoring.googleapis.com \
    logging.googleapis.com \
    notebooks.googleapis.com \
    aiplatform.googleapis.com \
    bigquery.googleapis.com \
    artifactregistry.googleapis.com \
    cloudbuild.googleapis.com \
    container.googleapis.com

SERVICE_ACCOUNT_ID=vertex-custom-training-sa

gcloud iam service-accounts create $SERVICE_ACCOUNT_ID  \
    --description="A custom service account for Vertex custom training with Tensorboard" \
    --display-name="Vertex AI Custom Training"

PROJECT_ID=$(gcloud config get-value core/project)
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$SERVICE_ACCOUNT_ID@$PROJECT_ID.iam.gserviceaccount.com \
    --role="roles/storage.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$SERVICE_ACCOUNT_ID@$PROJECT_ID.iam.gserviceaccount.com \
    --role="roles/bigquery.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$SERVICE_ACCOUNT_ID@$PROJECT_ID.iam.gserviceaccount.com \
    --role="roles/aiplatform.user"
```
