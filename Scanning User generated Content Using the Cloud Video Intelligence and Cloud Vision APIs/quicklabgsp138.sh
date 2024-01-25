




BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`

BG_BLACK=`tput setab 0`
BG_RED=`tput setab 1`
BG_GREEN=`tput setab 2`
BG_YELLOW=`tput setab 3`
BG_BLUE=`tput setab 4`
BG_MAGENTA=`tput setab 5`
BG_CYAN=`tput setab 6`
BG_WHITE=`tput setab 7`

BOLD=`tput bold`
RESET=`tput sgr0`
#----------------------------------------------------start--------------------------------------------------#

echo "${YELLOW}${BOLD}

Starting Execution 


${RESET}"
#gcloud auth list




#USER_EMAIL=$(gcloud auth list --limit=1 2>/dev/null | grep '@' | awk '{print $2}')
#----------------------------------------------------code--------------------------------------------------# 





export PROJECT_ID=$(gcloud info --format='value(config.project)')
export IV_BUCKET_NAME=${PROJECT_ID}-upload
export FILTERED_BUCKET_NAME=${PROJECT_ID}-filtered
export FLAGGED_BUCKET_NAME=${PROJECT_ID}-flagged
export STAGING_BUCKET_NAME=${PROJECT_ID}-staging

gsutil mb gs://${IV_BUCKET_NAME}

gsutil mb gs://${FILTERED_BUCKET_NAME}

gsutil mb gs://${FLAGGED_BUCKET_NAME}

gsutil mb gs://${STAGING_BUCKET_NAME}

gsutil ls


echo "${GREEN}${BOLD}

Task 2 Completed

${RESET}"

#TASK 3

export UPLOAD_NOTIFICATION_TOPIC=upload_notification
gcloud pubsub topics create ${UPLOAD_NOTIFICATION_TOPIC}


gcloud pubsub topics create visionapiservice

gcloud pubsub topics create videointelligenceservice

gcloud pubsub topics create bqinsert

gcloud pubsub topics list


echo "${GREEN}${BOLD}

Task 3 Completed

${RESET}"

#TASK 4

gsutil notification create -t upload_notification -f json -e OBJECT_FINALIZE gs://${IV_BUCKET_NAME}

gsutil notification list gs://${IV_BUCKET_NAME}


echo "${GREEN}${BOLD}

Task 4 Completed

${RESET}"

#TASK 5

gsutil -m cp -r gs://spls/gsp138/cloud-functions-intelligentcontent-nodejs .

cd cloud-functions-intelligentcontent-nodejs

export DATASET_ID=intelligentcontentfilter
export TABLE_NAME=filtered_content

bq --project_id ${PROJECT_ID} mk ${DATASET_ID}

bq --project_id ${PROJECT_ID} mk --schema intelligent_content_bq_schema.json -t ${DATASET_ID}.${TABLE_NAME}

bq --project_id ${PROJECT_ID} show ${DATASET_ID}.${TABLE_NAME}


sed -i "s/\[PROJECT-ID\]/$PROJECT_ID/g" config.json

sed -i "s/\[FLAGGED_BUCKET_NAME\]/$FLAGGED_BUCKET_NAME/g" config.json

sed -i "s/\[FILTERED_BUCKET_NAME\]/$FILTERED_BUCKET_NAME/g" config.json

sed -i "s/\[DATASET_ID\]/$DATASET_ID/g" config.json


sed -i "s/\[TABLE_NAME\]/$TABLE_NAME/g" config.json


echo "${GREEN}${BOLD}

Task 5 Completed

${RESET}"

#TASK 6

gcloud functions deploy GCStoPubsub --runtime nodejs10 --stage-bucket gs://${STAGING_BUCKET_NAME} --trigger-topic ${UPLOAD_NOTIFICATION_TOPIC} --entry-point GCStoPubsub --region $REGION --quiet

gcloud functions deploy visionAPI --runtime nodejs10 --stage-bucket gs://${STAGING_BUCKET_NAME} --trigger-topic visionapiservice --entry-point visionAPI --region $REGION

gcloud functions deploy videoIntelligenceAPI --runtime nodejs10 --stage-bucket gs://${STAGING_BUCKET_NAME} --trigger-topic videointelligenceservice --entry-point videoIntelligenceAPI --timeout 540 --region $REGION --quiet


gcloud functions deploy insertIntoBigQuery --runtime nodejs10 --stage-bucket gs://${STAGING_BUCKET_NAME} --trigger-topic bqinsert --entry-point insertIntoBigQuery --region $REGION --quiet


echo "${GREEN}${BOLD}

Task 6 Completed

${RESET}"

#TASK 7

curl -LO https://github.com/quiccklabs/Labs_solutions/raw/master/APIs%20Explorer%20Cloud%20Storage/demo-image1.png

gsutil cp demo-image1.png gs://$IV_BUCKET_NAME

while [[ $(gcloud beta functions logs read --filter "finished with status" "GCStoPubsub" --limit 100 --region $REGION) != *"finished with status"* ]]; do echo "Waiting for logs for GCStoPubsub..."; sleep 10; done
gcloud beta functions logs read --filter "finished with status" "insertIntoBigQuery" --limit 100 --region $REGION


echo "
#standardSql

SELECT insertTimestamp,
  contentUrl,
  flattenedSafeSearch.flaggedType,
  flattenedSafeSearch.likelihood
FROM \`$PROJECT_ID.$DATASET_ID.$TABLE_NAME\`
CROSS JOIN UNNEST(safeSearch) AS flattenedSafeSearch
ORDER BY insertTimestamp DESC,
  contentUrl,
  flattenedSafeSearch.flaggedType
LIMIT 1000
" > sql.txt

sleep 40

bq --project_id ${PROJECT_ID} query < sql.txt

echo "${GREEN}${BOLD}

Task 7 Completed

Lab Completed !!!

${RESET}"

