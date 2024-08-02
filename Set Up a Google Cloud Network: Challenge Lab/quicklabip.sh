export ZONE="$(gcloud compute instances list --project=$DEVSHELL_PROJECT_ID --format='value(ZONE)')"
export INT_IP=$(gcloud compute instances describe antern-postgresql-vm --zone=$ZONE \
  --format='get(networkInterfaces[0].networkIP)')
echo -e "\033[1;34mVM Internal IP:\033[0m \033[1;33m$INT_IP\033[0m"
