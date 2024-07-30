gcloud auth list
gcloud services enable appengine.googleapis.com

git clone https://github.com/GoogleCloudPlatform/php-docs-samples.git

cd php-docs-samples/appengine/standard/helloworld

sleep 30

gcloud app create --region=$REGION

gcloud app deploy --quiet
