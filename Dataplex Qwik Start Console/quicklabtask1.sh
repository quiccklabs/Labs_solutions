

export PROJECT_ID=$(gcloud config get-value project)
# Set display name and location
LAKE_DISPLAY_NAME="sensors"


# Create the lake
gcloud dataplex lakes create $LAKE_DISPLAY_NAME --location=$REGION


# Set display name, lake ID, location, zone ID, and zone type
LAKE_ID="sensors"
ZONE_ID="temperature-raw-data"
ZONE_DISPLAY_NAME="temperature raw data"

ZONE_TYPE="RAW"
RESOURCE_LOCATION_TYPE="SINGLE_REGION"

# Create the zone
gcloud dataplex zones create $ZONE_ID \
    --display-name="$ZONE_DISPLAY_NAME" \
    --lake=$LAKE_ID \
    --location=$REGION \
    --type=$ZONE_TYPE \
    --resource-location-type=$RESOURCE_LOCATION_TYPE


# Set the required variables for the asset
LAKE_ID="sensors"
ZONE_ID="temperature-raw-data"
ASSET_ID="measurements"
ASSET_DISPLAY_NAME="measurements"



gsutil mb -p $PROJECT_ID -l $REGION gs://$PROJECT_ID


gcloud dataplex assets create $ASSET_ID \
    --display-name="$ASSET_DISPLAY_NAME" \
    --lake=$LAKE_ID \
    --zone=$ZONE_ID \
    --location=$REGION \
    --resource-type="STORAGE_BUCKET" \
    --resource-name="projects/$PROJECT_ID/buckets/$PROJECT_ID" \
    --discovery-enabled




# Variables
