

gsutil mb gs://$DEVSHELL_PROJECT_ID


curl -O https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Introduction%20to%20SQL%20for%20BigQuery%20and%20Cloud%20SQL/start_station_name.csv
curl -O https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Introduction%20to%20SQL%20for%20BigQuery%20and%20Cloud%20SQL/end_station_name.csv

gsutil cp start_station_name.csv gs://$DEVSHELL_PROJECT_ID/
gsutil cp end_station_name.csv gs://$DEVSHELL_PROJECT_ID/



gcloud sql instances create my-demo \
    --database-version=MYSQL_5_7 \
    --region=$REGION \
    --tier=db-f1-micro \
    --root-password=quicklab

gcloud sql databases create bike --instance=my-demo


