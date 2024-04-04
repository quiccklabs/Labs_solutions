#!/bin/bash

# Define color variables
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)

BG_BLACK=$(tput setab 0)
BG_RED=$(tput setab 1)
BG_GREEN=$(tput setab 2)
BG_YELLOW=$(tput setab 3)
BG_BLUE=$(tput setab 4)
BG_MAGENTA=$(tput setab 5)
BG_CYAN=$(tput setab 6)
BG_WHITE=$(tput setab 7)

BOLD=$(tput bold)
RESET=$(tput sgr0)

# Function to run form 1 code
run_form_1() {
    gcloud services enable cloudscheduler.googleapis.com

    gcloud pubsub topics create cloud-pubsub-topic

    gcloud pubsub subscriptions create 'cloud-pubsub-subscription' --topic=cloud-pubsub-topic

    gcloud scheduler jobs create pubsub cron-scheduler-job \
            --schedule="* * * * *" --topic=cron-job-pubsub-topic \
            --message-body="Hello World!" --location=$REGION

    gcloud pubsub subscriptions pull cron-job-pubsub-subscription --limit 5
}

# Function to run form 2 code
run_form_2() {
    gcloud beta pubsub schemas create city-temp-schema \
        --type=avro \
        --definition='{
            "type": "record",
            "name": "Avro",
            "fields": [
                {
                    "name": "city",
                    "type": "string"
                },
                {
                    "name": "temperature",
                    "type": "double"
                },
                {
                    "name": "pressure",
                    "type": "int"
                },
                {
                    "name": "time_position",
                    "type": "string"
                }
            ]
        }'

    gcloud pubsub topics create temp-topic \
        --message-encoding=JSON \
        --message-storage-policy-allowed-regions=$REGION \
        --schema=projects/$DEVSHELL_PROJECT_ID/schemas/temperature-schema
    
    git clone https://github.com/GoogleCloudPlatform/nodejs-docs-samples.git

    cd nodejs-docs-samples/functions/v2/helloPubSub/

    gcloud functions deploy gcf-pubsub \
    --runtime=nodejs20 \
    --region=$REGION \
    --source=. \
    --entry-point=helloPubSub \
    --trigger-topic=gcf-topic
}

# Function to run form 3 code
run_form_3() {
    gcloud pubsub snapshots create pubsub-snapshot --subscription=gcloud-pubsub-subscription

    gcloud pubsub lite-reservations create pubsub-lite-reservation \
        --location=$REGION \
        --throughput-capacity=2

    gcloud services enable cloudscheduler.googleapis.com

    gcloud pubsub lite-topics create cloud-pubsub-topic-lite \
        --location=$REGION \
        --partitions=1 \
        --per-partition-bytes=30GiB \
        --throughput-reservation=demo-reservation

    gcloud pubsub lite-subscriptions create cloud-pubsub-subscription-lite \
            --location=$REGION --topic=cloud-pubsub-topic-lite
}

# Main script block
echo "${BLUE}${BOLD}"

# Get the form number from user input
read -p "Enter the Form number (1, 2, or 3): " form_number

# Execute the appropriate function based on the selected form number
case $form_number in
    1) run_form_1 ;;
    2) run_form_2 ;;
    3) run_form_3 ;;
    *) echo "Invalid form number. Please enter 1, 2, or 3." ;;
esac
