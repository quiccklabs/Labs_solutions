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
    gcloud services enable run.googleapis.com
    gcloud services enable eventarc.googleapis.com
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

    mkdir quicklab && cd $_

    cat >index.js <<'EOF_END'
    const functions = require('@google-cloud/functions-framework');

    functions.http('helloHttp', (req, res) => {
    res.send(`Hello ${req.query.name || req.body.name || 'World'}!`);
    });

EOF_END

cat >package.json <<'EOF_END'
    {
    "dependencies": {
        "@google-cloud/functions-framework": "^3.0.0"
    }
    }
EOF_END

    deploy_function() {
       yes n | gcloud functions deploy gcf-pubsub \
            --trigger-topic=gcf-topic \
            --runtime=nodejs22 \
            --gen2 \
            --entry-point=helloHttp \
            --source=. \
            --region=$REGION
    }

    deploy_success=false

    while [ "$deploy_success" = false ]; do
        if deploy_function; then
            echo "Function deployed successfully..."
            deploy_success=true
        else
            echo "Waiting for Cloud Function to be deployed..."
            echo "In the meantime, subscribe to Quicklab at https://www.youtube.com/@quick_lab."
            sleep 20
        fi
    done

}


# Function to run form 3 code
run_form_3() {

    gcloud pubsub subscriptions create pubsub-subscription-message --topic gcloud-pubsub-topic

    gcloud pubsub topics publish gcloud-pubsub-topic --message="Hello World"

    sleep 10

    gcloud pubsub subscriptions pull pubsub-subscription-message --limit 5

    gcloud pubsub snapshots create pubsub-snapshot --subscription=gcloud-pubsub-subscription
}


echo "${YELLOW}${BOLD}"

read -p "Enter the REGION: " REGION

echo "${RESET}${BOLD}"

# Main script block
echo "${BLUE}${BOLD}"

# Get the form number from user input
read -p "Enter the Form number (1, 2, or 3): " form_number

echo "${RESET}${BOLD}"


# Execute the appropriate function based on the selected form number
case $form_number in
1) run_form_1 ;;
2) run_form_2 ;;
3) run_form_3 ;;
*) echo "Invalid form number. Please enter 1, 2, or 3." ;;
esac
