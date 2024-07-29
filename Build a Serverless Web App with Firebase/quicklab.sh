
git clone https://github.com/rosera/pet-theory.git

cd pet-theory/lab02/

npm i && npm audit fix --force

gcloud firestore databases create --location=$REGION

echo "https://console.cloud.google.com/firebase?referrer=search&project=$DEVSHELL_PROJECT_ID"
