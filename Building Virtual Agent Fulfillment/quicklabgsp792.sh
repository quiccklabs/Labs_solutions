
export PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format='value(projectNumber)')
export PROJECT_ID=$(gcloud info --format='value(config.project)')


gcloud services enable dialogflow.googleapis.com
gcloud services disable cloudfunctions.googleapis.com
gcloud services enable cloudfunctions.googleapis.com
gcloud services enable firestore.googleapis.com


gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:service-$PROJECT_NUMBER@gcf-admin-robot.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.reader"


gcloud firestore databases create --location=nam5


# Print Firestore in yellow
echo -e "\033[1;33mFirestore\033[0m"

# Print the URL in blue and bold
echo -e "\033[1;34m(https://console.cloud.google.com/firestore/databases/-default-/data/panel)\033[0m"
