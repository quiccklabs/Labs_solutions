#!/bin/bash

# assumes compute api is enabled

# create service accounts
gcloud iam service-accounts create linux-servers --display-name linux-servers
gcloud iam service-accounts create windows-servers --display-name windows-servers

# assign roles
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=serviceAccount:linux-servers@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role='roles/logging.logWriter'
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=serviceAccount:linux-servers@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role='roles/monitoring.metricWriter'
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=serviceAccount:windows-servers@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role='roles/logging.logWriter'
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=serviceAccount:windows-servers@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role='roles/monitoring.metricWriter'

# create vms
gcloud compute instances create linux-server-$DEVSHELL_PROJECT_ID --service-account linux-servers@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --zone us-west1-b --metadata-from-file startup-script=linux_startup.sh
gcloud compute instances create windows-server-$DEVSHELL_PROJECT_ID --service-account windows-servers@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --image-project windows-cloud --image windows-server-2016-dc-core-v20210511 --zone us-west1-b --machine-type=e2-micro --metadata-from-file windows-startup-script-ps1=windows_startup.ps1
gcloud compute instances add-tags linux-server-$DEVSHELL_PROJECT_ID --zone us-west1-b --tags http-server --machine-type=e2-micro

# open firewall for linux server
gcloud compute firewall-rules create http-server --allow tcp:80 --target-tags http-server

# set up gke
nohup ./gke.sh &

# set up pub-sub
nohup ./pubsub.sh &

sleep 3
echo "done!"
