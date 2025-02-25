export PROJECT_ID=$(gcloud config get-value project)
export BUCKET_NAME="$PROJECT_ID-bucket"

bq load \
    --source_format=CSV \
    --autodetect \
    --replace \
    products.products_information \
    gs://$BUCKET_NAME/products.csv

  
bq query --use_legacy_sql=false "
CREATE SEARCH INDEX IF NOT EXISTS 
  \`$PROJECT_ID.products.products_information_search_index\`
ON \`$PROJECT_ID.products.products_information\` (ALL COLUMNS);
"


bq query --use_legacy_sql=false \
"SELECT * FROM products.products_information \
WHERE SEARCH(STRUCT(), '22 oz Water Bottle') = TRUE;"
