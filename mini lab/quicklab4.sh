export PROJECT=$(gcloud projects list --format="value(PROJECT_ID)")

gsutil setmeta -h "Content-Type:text/html" gs://$PROJECT-bucket/index.html
