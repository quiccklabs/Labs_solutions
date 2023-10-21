


curl -LO https://github.com/quiccklabs/Labs_solutions/blob/master/APIs%20Explorer%20Cloud%20Storage/demo-image1-copy.png
curl -LO https://github.com/quiccklabs/Labs_solutions/blob/master/APIs%20Explorer%20Cloud%20Storage/demo-image1.png
curl -LO https://github.com/quiccklabs/Labs_solutions/blob/master/APIs%20Explorer%20Cloud%20Storage/demo-image2.png


gcloud alpha services api-keys create --display-name="quicklab"  
KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=quicklab") 
export API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)") 
echo $API_KEY

gsutil mb gs://$DEVSHELL_PROJECT_ID

gsutil mb gs://$DEVSHELL_PROJECT_ID-quicklab

gsutil cp demo-image1.png gs://$DEVSHELL_PROJECT_ID

gsutil cp demo-image2.png gs://$DEVSHELL_PROJECT_ID

gsutil cp demo-image1-copy.png gs://$DEVSHELL_PROJECT_ID-quicklab