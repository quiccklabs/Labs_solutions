

curl -LO https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Ingesting%20New%20Datasets%20into%20BigQuery/quicklab.csv

curl -LO https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Ingesting%20New%20Datasets%20into%20BigQuery/products.csv

bq mk ecommerce

gsutil mb gs://$DEVSHELL_PROJECT_ID/

gsutil cp products.csv gs://$DEVSHELL_PROJECT_ID/

gsutil cp quicklab.csv gs://$DEVSHELL_PROJECT_ID/


bq --location=US load --source_format=CSV --autodetect --skip_leading_rows=1 ecommerce.products gs://$DEVSHELL_PROJECT_ID/products.csv

bq --location=US load --source_format=CSV --autodetect --skip_leading_rows=1 ecommerce.products gs://data-insights-course/exports/products.csv

