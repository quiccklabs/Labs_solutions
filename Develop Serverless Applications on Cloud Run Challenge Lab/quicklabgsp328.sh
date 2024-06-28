



gcloud auth list
gcloud config list project

gcloud config set project \
$(gcloud projects list --format='value(PROJECT_ID)' \
--filter='qwiklabs-gcp')

gcloud config set run/region $REGION
gcloud config set run/platform managed

git clone https://github.com/rosera/pet-theory.git && cd pet-theory/lab07
export PROJECT_ID=$(gcloud info --format='value(config.project)')


# Task 1:-

cd ~/pet-theory/lab07/unit-api-billing

gcloud builds submit --tag gcr.io/${PROJECT_ID}/billing-staging-api:0.1
gcloud run deploy $TASK_1_SERVICES_NAME --image gcr.io/${PROJECT_ID}/billing-staging-api:0.1 --quiet

gcloud run services list


# Task 2:-

cd ~/pet-theory/lab07/staging-frontend-billing

gcloud builds submit --tag gcr.io/${PROJECT_ID}/frontend-staging:0.1
gcloud run deploy $TASK_2_SERVICES_NAME --image gcr.io/${PROJECT_ID}/frontend-staging:0.1 --quiet

gcloud run services list


# Task 3:-

cd ~/pet-theory/lab07/staging-api-billing

gcloud builds submit --tag gcr.io/${PROJECT_ID}/billing-staging-api:0.2
gcloud run deploy $TASK_3_SERVICES_NAME --image gcr.io/${PROJECT_ID}/billing-staging-api:0.2 --quiet

gcloud run services list

BILLING_URL=$(gcloud run services describe $TASK_3_SERVICES_NAME \
  --platform managed \
  --region $REGION \
  --format "value(status.url)")

curl -X get -H "Authorization: Bearer $(gcloud auth print-identity-token)" $BILLING_URL


# Task 4:-

gcloud iam service-accounts create $TASK_4_SERVICES_NAME --display-name "Billing Service Cloud Run"


# Task 5:-

cd ~/pet-theory/lab07/prod-api-billing

gcloud builds submit --tag gcr.io/${PROJECT_ID}/billing-prod-api:0.1
gcloud run deploy $TASK_5_SERVICES_NAME --image gcr.io/${PROJECT_ID}/billing-prod-api:0.1 --quiet

gcloud run services list

PROD_BILLING_SERVICE=$TASK_3_SERVICES_NAME

PROD_BILLING_URL=$(gcloud run services \
  describe $PROD_BILLING_SERVICE \
  --platform managed \
  --region $REGION \
  --format "value(status.url)")

curl -X get -H "Authorization: Bearer \
 $(gcloud auth print-identity-token)" \
 $PROD_BILLING_URL


# Task 6:-

gcloud iam service-accounts create $TASK_6_SERVICES_NAME --display-name "Billing Service Cloud Run Invoker"


# Task 7:-

cd ~/pet-theory/lab07/prod-frontend-billing

gcloud builds submit --tag gcr.io/${PROJECT_ID}/frontend-prod:0.1
gcloud run deploy $TASK_7_SERVICES_NAME --image gcr.io/${PROJECT_ID}/frontend-prod:0.1 --quiet

gcloud run services list


