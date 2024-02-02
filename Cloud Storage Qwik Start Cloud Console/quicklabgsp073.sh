



gcloud config set compute/region $REGION


gsutil mb gs://$DEVSHELL_PROJECT_ID

curl https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Ada_Lovelace_portrait.jpg/800px-Ada_Lovelace_portrait.jpg --output ada.jpg

mv ada.jpg kitten.png

gsutil cp kitten.png gs://$DEVSHELL_PROJECT_ID

gsutil cp -r gs://$DEVSHELL_PROJECT_ID/kitten.png .

gsutil cp gs://$DEVSHELL_PROJECT_ID/kitten.png gs://$DEVSHELL_PROJECT_ID/image-folder/


gsutil iam ch allUsers:objectViewer gs://$DEVSHELL_PROJECT_ID
