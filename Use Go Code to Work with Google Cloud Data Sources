TASK 3:-

export PROJECT_ID=$(gcloud info --format="value(config.project)")

git clone https://github.com/GoogleCloudPlatform/DIY-Tools.git

gcloud firestore import gs://$PROJECT_ID-firestore/prd-back

cd ~/DIY-Tools/gcp-data-drive/cmd/webserver

go build -mod=readonly -v -o gcp-data-drive

./gcp-data-drive



TASK 5:-

In the Cloud Shell toolbar, click the + icon next to the first Cloud Shell tab to open a second Cloud Shell tab.

export PROJECT_ID=$(gcloud info --format="value(config.project)")

export PREVIEW_URL=[REPLACE_WITH_WEB_PREVIEW_URL]

echo $PREVIEW_URL/fs/$PROJECT_ID/symbols/product/symbol




Task 6 :- 

In the Cloud Shell toolbar, click the + icon next to the first Cloud Shell tab to open a second Cloud Shell tab.


export PROJECT_ID=$(gcloud info --format="value(config.project)")

cd ~/DIY-Tools/gcp-data-drive/cmd/webserver

gcloud app deploy app.yaml --project $PROJECT_ID -q

export TARGET_URL=https://$(gcloud app describe --format="value(defaultHostname)")

curl $TARGET_URL/fs/$PROJECT_ID/symbols/product/symbol

curl $TARGET_URL/fs/$PROJECT_ID/symbols/product/symbol/008888166900

curl $TARGET_URL/bq/$PROJECT_ID/publicviews/ca_zip_codes












