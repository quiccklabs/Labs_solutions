export PROJECT_ID=$(gcloud config get-value project)
export BUCKET_NAME="$PROJECT_ID-bucket"

gsutil cp customers.csv gs://$BUCKET_NAME/customers.csv


bq load \
    --source_format=CSV \
    --autodetect \
    --replace \
    customer_details.customers \
    gs://$BUCKET_NAME/customers.csv


#TASK 2

bq query --use_legacy_sql=false \
'CREATE TABLE customer_details.male_customers AS
 SELECT CustomerID, Gender
 FROM customer_details.customers
 WHERE Gender = "Male"'


#TASK 3

bq extract \
    --destination_format=CSV \
    --compression=NONE \
    customer_details.male_customers \
    gs://$BUCKET_NAME/exported_male_customers.csv
