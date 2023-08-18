

gcloud services enable cloudscheduler.googleapis.com

gcloud pubsub topics create $DEVSHELL_PROJECT_ID-cron-topic

gcloud pubsub subscriptions create $DEVSHELL_PROJECT_ID-cron-sub --topic=$DEVSHELL_PROJECT_ID-cron-topic

gcloud scheduler jobs create pubsub $DEVSHELL_PROJECT_ID-cron-scheduler-job \
    --schedule="* * * * *" \
    --topic=$DEVSHELL_PROJECT_ID-cron-topic \
    --message-body="$MESSAGE_BODY" \
    --time-zone="America/New_York" \
    --description="Cron job for qwiklabs" \
    --location=$REGION

gcloud pubsub subscriptions pull $DEVSHELL_PROJECT_ID-cron-sub --limit 5
