
export TOPIC_NAME=

export SUBSCRIPTION_NAME=

export JOB_NAME=

export MESSAGE_BODY=""

export REGION=

gcloud pubsub topics create $TOPIC_NAME

gcloud pubsub subscriptions create $SUBSCRIPTION_NAME --topic=$TOPIC_NAME

gcloud services enable cloudscheduler.googleapis.com

gcloud scheduler jobs create pubsub $JOB_NAME --schedule="* * * * *" --topic=$TOPIC_NAME --message-body="$MESSAGE_BODY" --time-zone="Etc/UTC" --description="subscribe to quicklab" --project=$DEVSHELL_PROJECT_ID --location=$REGION


