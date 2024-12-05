export PROJECT=$(gcloud projects list --format="value(PROJECT_ID)")

gsutil iam get gs://$PROJECT-urgent

gsutil iam ch -d allUsers gs://$PROJECT-urgent
gsutil iam ch -d allAuthenticatedUsers gs://$PROJECT-urgent

gsutil iam get gs://$PROJECT-urgent
