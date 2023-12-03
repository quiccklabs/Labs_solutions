


bq mk ecommerce

gsutil mb gs://$DEVSHELL_PROJECT_ID/

gsutil cp products.csv gs://$DEVSHELL_PROJECT_ID/

gsutil cp quicklab.csv gs://$DEVSHELL_PROJECT_ID/


bq --location=US load --source_format=CSV --autodetect --skip_leading_rows=1 ecommerce.products gs://$DEVSHELL_PROJECT_ID/products.csv

bq --location=US load --source_format=CSV --autodetect --skip_leading_rows=1 ecommerce.products gs://data-insights-course/exports/products.csv

