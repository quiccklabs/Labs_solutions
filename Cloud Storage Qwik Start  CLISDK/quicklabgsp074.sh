



gcloud config set compute/region $REGION


gsutil mb gs://$DEVSHELL_PROJECT_ID

curl https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Ada_Lovelace_portrait.jpg/800px-Ada_Lovelace_portrait.jpg --output ada.jpg

gsutil cp ada.jpg gs://$DEVSHELL_PROJECT_ID

gsutil cp -r gs://$DEVSHELL_PROJECT_ID/ada.jpg .

gsutil cp gs://$DEVSHELL_PROJECT_ID/ada.jpg gs://$DEVSHELL_PROJECT_ID/image-folder/

gsutil acl ch -u AllUsers:R gs://$DEVSHELL_PROJECT_ID/ada.jpg