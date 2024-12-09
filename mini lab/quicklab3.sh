
echo ""
echo ""

read -p "Enter REGION: " REGION

export PROJECT_ID=$(gcloud projects list --format="value(PROJECT_ID)")
export BUCKET_NAME=$PROJECT_ID-new
export BUCKET=$PROJECT_ID-bucket


gcloud storage buckets create gs://$BUCKET_NAME --location=$REGION

gcloud storage cp --recursive gs://$BUCKET/* gs://$BUCKET_NAME

gcloud storage buckets update gs://$BUCKET_NAME --no-uniform-bucket-level-access

gcloud storage buckets add-iam-policy-binding gs://$BUCKET_NAME --member=allUsers --role=roles/storage.admin
gcloud storage buckets add-iam-policy-binding gs://$BUCKET_NAME --member=allUsers --role=roles/storage.objectViewer


gcloud storage buckets update gs://$BUCKET_NAME --web-main-page-suffix=index.html --web-error-page=error.html

gcloud compute addresses create example-ip --network-tier=PREMIUM --ip-version=IPV4 --global



gcloud compute backend-buckets create website-backend-bucket-1 \
    --gcs-bucket-name=$BUCKET_NAME \
    --enable-cdn

gcloud compute url-maps create website-url-map \
    --default-backend-bucket=website-backend-bucket-1

gcloud compute target-http-proxies create website-http-proxy \
    --url-map=website-url-map

gcloud compute addresses create website-ip --global

ID=$(gcloud compute addresses describe website-ip --global --format="get(address)")

gcloud compute forwarding-rules create website-forwarding-rule \
    --global \
    --target-http-proxy=website-http-proxy \
    --ports=80 \
    --load-balancing-scheme=EXTERNAL \
    --address=example-ip \
    --network-tier=PREMIUM


sleep 30

curl http://$ID


MAX_ATTEMPTS=10
DELAY=20  # in seconds

echo "Checking response from $ID..."

# Loop to check response
for ((i=1; i<=MAX_ATTEMPTS; i++)); do
  echo "Attempt $i of $MAX_ATTEMPTS..."
  
  # Use curl to send a request and check the response
  RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://$ID)
  
  # Check if the response is successful (HTTP 200)
  if [ "$RESPONSE" -eq 200 ]; then
    echo "Success! Received HTTP 200 from $ID."
    exit 0
  else
    echo "Attempt $i failed with response: $RESPONSE. Retrying in $DELAY seconds..."
    sleep $DELAY
  fi
done


