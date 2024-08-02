gcloud services enable datamigration.googleapis.com
gcloud services enable servicenetworking.googleapis.com

export ZONE="$(gcloud compute instances list --project=$DEVSHELL_PROJECT_ID --format='value(ZONE)')"
export PROJECT_ID=$DEVSHELL_PROJECT_ID
gcloud compute ssh --zone "$ZONE" "antern-postgresql-vm" --project "$DEVSHELL_PROJECT_ID" --quiet
