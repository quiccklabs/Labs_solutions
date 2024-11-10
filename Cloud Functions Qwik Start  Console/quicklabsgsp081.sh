echo ""
echo ""
echo "Please export the values."


# Prompt user to input three regions
read -p "Enter REGION: " REGION


gcloud services enable run.googleapis.com

sleep 10

mkdir quicklab && cd quicklab

cat > index.js <<EOF_END
/**
 * Responds to any HTTP request.
 *
 * @param {!express:Request} req HTTP request context.
 * @param {!express:Response} res HTTP response context.
 */
exports.GCFunction = (req, res) => {
    let message = req.query.message || req.body.message || 'Subscribe to quicklab';
    res.status(200).send(message);
  };
  
EOF_END


cat > package.json <<EOF_END
{
    "name": "sample-http",
    "version": "0.0.1"
  }
  
EOF_END


gsutil mb -p $DEVSHELL_PROJECT_ID gs://$DEVSHELL_PROJECT_ID

sleep 30

export PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format="json(projectNumber)" --quiet | jq -r '.projectNumber')

# Set the service account email
SERVICE_ACCOUNT="service-$PROJECT_NUMBER@gcf-admin-robot.iam.gserviceaccount.com"

# Get the current IAM policy
IAM_POLICY=$(gcloud projects get-iam-policy $DEVSHELL_PROJECT_ID --format=json)

# Check if the binding exists
if [[ "$IAM_POLICY" == *"$SERVICE_ACCOUNT"* && "$IAM_POLICY" == *"roles/artifactregistry.reader"* ]]; then
  echo "IAM binding exists for service account: $SERVICE_ACCOUNT with role roles/artifactregistry.reader"
else
  echo "IAM binding does not exist for service account: $SERVICE_ACCOUNT with role roles/artifactregistry.reader"
  
  # Create the IAM binding
  gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member=serviceAccount:$SERVICE_ACCOUNT \
    --role=roles/artifactregistry.reader

  echo "IAM binding created for service account: $SERVICE_ACCOUNT with role roles/artifactregistry.reader"
fi


gcloud functions deploy GCFunction \
  --region=$REGION \
  --gen2 \
  --trigger-http \
  --runtime=nodejs20 \
  --allow-unauthenticated \
  --max-instances=5


DATA=$(printf 'Subscribe to quicklab' | base64) && gcloud functions call GCFunction --region=$REGION --data '{"data":"'$DATA'"}'


sleep 50

sleep 30

export PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format="json(projectNumber)" --quiet | jq -r '.projectNumber')

# Set the service account email
SERVICE_ACCOUNT="service-$PROJECT_NUMBER@gcf-admin-robot.iam.gserviceaccount.com"

# Get the current IAM policy
IAM_POLICY=$(gcloud projects get-iam-policy $DEVSHELL_PROJECT_ID --format=json)

# Check if the binding exists
if [[ "$IAM_POLICY" == *"$SERVICE_ACCOUNT"* && "$IAM_POLICY" == *"roles/artifactregistry.reader"* ]]; then
  echo "IAM binding exists for service account: $SERVICE_ACCOUNT with role roles/artifactregistry.reader"
else
  echo "IAM binding does not exist for service account: $SERVICE_ACCOUNT with role roles/artifactregistry.reader"
  
  # Create the IAM binding
  gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member=serviceAccount:$SERVICE_ACCOUNT \
    --role=roles/artifactregistry.reader

  echo "IAM binding created for service account: $SERVICE_ACCOUNT with role roles/artifactregistry.reader"
fi


gcloud functions deploy GCFunction \
  --region=$REGION \
  --gen2 \
  --trigger-http \
  --runtime=nodejs20 \
  --allow-unauthenticated \
  --max-instances=5


DATA=$(printf 'Subscribe to quicklab' | base64) && gcloud functions call GCFunction --region=$REGION --data '{"data":"'$DATA'"}'

