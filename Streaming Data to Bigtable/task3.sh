echo "Listing all Dataflow jobs:"
gcloud dataflow jobs list


export JOB_ID=$(gcloud dataflow jobs list | grep JOB_ID: | awk '{print $2}')

gcloud dataflow jobs cancel $JOB_ID

cbt deletetable current_conditions

echo -e "\e[1m\e[34mhttps://console.cloud.google.com/dataflow/jobs?referrer=search&project=$DEVSHELL_PROJECT_ID\e[0m"
