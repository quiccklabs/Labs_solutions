echo ""
echo ""

# STEP 1: Set region
read -p "Export REGION :- " REGION


# Step 1.2: Set variables
REPO_NAME="container-registry"
FORMAT="DOCKER"
POLICY_NAME="Grandfather"
KEEP_COUNT=3

# Step 2: Create the Artifact Registry repository
gcloud artifacts repositories create $REPO_NAME \
  --repository-format=$FORMAT \
  --location=$REGION \
  --description="Docker repo for container images"

# Step 3: Create cleanup policy named 'Grandfather' to keep only the latest 3 versions
# gcloud artifacts policies create $POLICY_NAME \
#   --repository=$REPO_NAME \
#   --location=$REGION \
#   --package-type=$FORMAT \
#   --keep-count=$KEEP_COUNT \
#   --action=DELETE
