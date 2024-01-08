
gcloud auth list

gcloud services enable cloudfunctions.googleapis.com

sleep 20

git clone --depth=1 https://github.com/GoogleCloudPlatform/training-data-analyst

ln -s ~/training-data-analyst/courses/developingapps/v1.3/nodejs/cloudfunctions ~/cloudfunctions

cd ~/cloudfunctions/start

. prepare_environment.sh


cd function

rm index.js

wget https://raw.githubusercontent.com/quiccklabs/Identify-Application-Vulnerabilities-with-Security-Command-Center/main/index.js

zip cf.zip *.js*

gcloud storage cp cf.zip gs://$GCLOUD_BUCKET/

