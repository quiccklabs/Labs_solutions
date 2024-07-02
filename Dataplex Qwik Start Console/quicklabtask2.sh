
LAKE_ID="sensors"
ZONE_ID="temperature-raw-data"
ASSET_ID="measurements"


# Detach (delete) the asset
gcloud dataplex assets delete $ASSET_ID --lake=$LAKE_ID --zone=$ZONE_ID --location=$REGION --quiet

# Delete the zone
gcloud dataplex zones delete $ZONE_ID --lake=$LAKE_ID --location=$REGION --quiet

# Delete the lake
gcloud dataplex lakes delete $LAKE_ID --location=$REGION --quiet
