echo ""
echo ""
echo "Please export the values."


# Prompt user to input three regions
read -p "Enter BUCKET_NAME: " BUCKET_NAME


bq mk work_day

bq mk --table work_day.employee \
    employee_id:INTEGER,device_id:STRING,username:STRING,department:STRING,office:STRING

bq load --source_format=CSV --skip_leading_rows=1 work_day.employee gs://$BUCKET_NAME/employees.csv employee_id:INTEGER,device_id:STRING,username:STRING,department:STRING,office:STRING

