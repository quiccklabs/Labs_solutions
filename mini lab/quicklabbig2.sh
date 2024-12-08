echo ""
echo ""

read -p "Enter REGION: " REGION


export PROJECT_ID=$(gcloud projects list --format="value(PROJECT_ID)")


bq mk --connection \
    --connection_type='CLOUD_SPANNER' \
    --properties='{"database":"projects/'$PROJECT_ID'/instances/ecommerce-instance/databases/ecommerce"}' \
    --location=$REGION \
    my_connection_id


bq query --use_legacy_sql=false \
"
SELECT * FROM EXTERNAL_QUERY('$PROJECT_ID.$REGION.my_connection_id', 'SELECT * FROM orders;');
"

bq query --use_legacy_sql=false \
"
CREATE VIEW ecommerce.order_history AS SELECT * FROM EXTERNAL_QUERY('$PROJECT_ID.$REGION.my_connection_id', 'SELECT * FROM orders;');
"
