

PROJECT_ID=$(gcloud config get-value project)
OLD_BUCKET=${PROJECT_ID}-bucket
NEW_BUCKET=${PROJECT_ID}-new

gsutil mb gs://$NEW_BUCKET
gsutil web set -m index.html -e error.html gs://$NEW_BUCKET
gsutil iam ch allUsers:roles/storage.admin gs://$NEW_BUCKET
gsutil -m rsync -r gs://$OLD_BUCKET gs://$NEW_BUCKET

gcloud compute backend-buckets create backend-new \
  --gcs-bucket-name=$NEW_BUCKET \
  --enable-cdn

gcloud compute url-maps create website-map \
  --default-backend-bucket=backend-new

gcloud compute target-http-proxies create website-proxy \
  --url-map=website-map

gcloud compute forwarding-rules create website-rule \
  --global \
  --target-http-proxy=website-proxy \
  --ports=80
