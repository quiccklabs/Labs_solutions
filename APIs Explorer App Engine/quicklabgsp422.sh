
echo ""
echo ""

read -p "Enter REGION: " REGION

gcloud auth list

git clone https://github.com/GoogleCloudPlatform/python-docs-samples

cd ~/python-docs-samples/appengine/standard_python3/hello_world

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud app create --project $PROJECT_ID --region=$REGION

echo "Y" | gcloud app deploy app.yaml --project $PROJECT_ID

echo "Y" | gcloud app deploy -v v1