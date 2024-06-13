
cat > prepare_disk_1.sh <<'EOF_END'
source /training/project_env.sh
cd ~/training-data-analyst/courses/streaming/process/sandiego
./run_oncloud.sh $DEVSHELL_PROJECT_ID $BUCKET CurrentConditions --bigtable
EOF_END

ZONE="$(gcloud compute instances list --project=$DEVSHELL_PROJECT_ID --format='value(ZONE)' | head -n 1)"


gcloud compute scp prepare_disk_1.sh training-vm:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh training-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/prepare_disk_1.sh"


echo "Listing all Dataflow jobs:"
gcloud dataflow jobs list


export JOB_ID=$(gcloud dataflow jobs list | grep JOB_ID: | awk '{print $2}')

gcloud dataflow jobs cancel $JOB_ID

cbt deletetable current_conditions

echo -e "\e[1m\e[34mhttps://console.cloud.google.com/dataflow/jobs?referrer=search&project=$DEVSHELL_PROJECT_ID\e[0m"