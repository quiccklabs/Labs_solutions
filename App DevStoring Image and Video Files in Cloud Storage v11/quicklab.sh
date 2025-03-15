gcloud auth list

git clone https://github.com/GoogleCloudPlatform/training-data-analyst

cd ~/training-data-analyst/courses/developingapps/nodejs/cloudstorage/start

. prepare_environment.sh

gsutil mb gs://$DEVSHELL_PROJECT_ID-media

export GCLOUD_BUCKET=$DEVSHELL_PROJECT_ID-media

cd ~/training-data-analyst/courses/developingapps/nodejs/cloudstorage/start/server/gcp

rm cloudstorage.js

##uploading files here

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/refs/heads/master/App%20DevStoring%20Image%20and%20Video%20Files%20in%20Cloud%20Storage%20v11/cloudstorage.js

npm start
