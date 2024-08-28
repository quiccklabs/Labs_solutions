


gcloud services enable datacatalog.googleapis.com

bq mk demo_dataset

bq cp bigquery-public-data:new_york_taxi_trips.tlc_yellow_trips_2018 $DEVSHELL_PROJECT_ID:demo_dataset.trips



# -------------------------------
# Create a Tag Template.
# -------------------------------
gcloud data-catalog tag-templates create demo_tag_template \
    --location=$REGION \
    --display-name="Demo Tag Template" \
    --field=id=source_of_data_asset,display-name="Source of data asset",type=string,required=TRUE \
    --field=id=number_of_rows_in_data_asset,display-name="Number of rows in data asset",type=double \
    --field=id=has_pii,display-name="Has PII",type=bool \
    --field=id=pii_type,display-name="PII type",type='enum(Email|Social Security Number|None)'



# -------------------------------
# Lookup the Data Catalog entry for the table.
# -------------------------------
ENTRY_NAME=$(gcloud data-catalog entries lookup '//bigquery.googleapis.com/projects/'$DEVSHELL_PROJECT_ID'/datasets/demo_dataset/tables/trips' --format="value(name)")


# -------------------------------
# Attach a Tag to the table.
# -------------------------------

# Create the Tag file.
cat > tag.json << EOF
  {
    "source_of_data_asset": "tlc_yellow_trips_2018",
    "pii_type": "None"
  }
EOF

gcloud data-catalog tags create --entry=${ENTRY_NAME} \
    --tag-template=demo_tag_template --tag-template-location=$REGION --tag-file=tag.json
