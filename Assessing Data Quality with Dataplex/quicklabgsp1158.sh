




gcloud services enable dataproc.googleapis.com

gcloud dataplex lakes create ecommerce-lake --location=$REGION --display-name="Ecommerce Lake"


gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USER_EMAIL \
  --role=roles/dataplex.admin


gcloud dataplex zones create customer-contact-raw-zone \
  --display-name="Customer Contact Raw Zone" \
  --type=RAW \
  --location=$REGION \
  --resource-location-type=SINGLE_REGION \
  --lake=ecommerce-lake


gcloud dataplex assets create contact-info \
--location=$REGION \
--lake=ecommerce-lake \
--zone=customer-contact-raw-zone \
--display-name="Contact Info" \
--resource-type=BIGQUERY_DATASET \
--resource-name=projects/$DEVSHELL_PROJECT_ID/datasets/customers \
--discovery-enabled 



#task 3

cat > dq-customer-raw-data.yaml <<EOF_END
metadata_registry_defaults:
  dataplex:
    projects: $DEVSHELL_PROJECT_ID
    locations: $REGION
    lakes: ecommerce-lake
    zones: customer-contact-raw-zone
row_filters:
  NONE:
    filter_sql_expr: |-
      True
  INTERNATIONAL_ITEMS:
    filter_sql_expr: |-
      REGEXP_CONTAINS(item_id, 'INTNL')
rule_dimensions:
  - consistency
  - correctness
  - duplication
  - completeness
  - conformance
  - integrity
  - timeliness
  - accuracy
rules:
  NOT_NULL:
    rule_type: NOT_NULL
    dimension: completeness
  VALID_EMAIL:
    rule_type: REGEX
    dimension: conformance
    params:
      pattern: |-
        ^[^@]+[@]{1}[^@]+$
rule_bindings:
  VALID_CUSTOMER:
    entity_uri: bigquery://projects/$DEVSHELL_PROJECT_ID/datasets/customers/tables/contact_info
    column_id: id
    row_filter_id: NONE
    rule_ids:
      - NOT_NULL
  VALID_EMAIL_ID:
    entity_uri: bigquery://projects/$DEVSHELL_PROJECT_ID/datasets/customers/tables/contact_info
    column_id: email
    row_filter_id: NONE
    rule_ids:
      - VALID_EMAIL
EOF_END


gsutil cp dq-customer-raw-data.yaml gs://$DEVSHELL_PROJECT_ID-bucket

