gcloud auth list

git clone https://github.com/GoogleCloudPlatform/training-data-analyst

cd ~/training-data-analyst/courses/developingapps/nodejs/cloudstorage/start

. prepare_environment.sh

gsutil mb gs://$DEVSHELL_PROJECT_ID-media

export GCLOUD_BUCKET=$DEVSHELL_PROJECT_ID-media

cd ~/training-data-analyst/courses/developingapps/nodejs/cloudstorage/start/server/gcp

rm cloudstorage.js

##uploading files here


npm start
