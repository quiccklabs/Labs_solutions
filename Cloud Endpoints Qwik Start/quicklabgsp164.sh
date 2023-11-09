


gsutil cp gs://spls/gsp164/endpoints-quickstart.zip .
unzip endpoints-quickstart.zip

cd endpoints-quickstart

cd scripts

./deploy_api.sh

./deploy_app.sh

./query_api.sh

./query_api.sh JFK

./deploy_api.sh ../openapi_with_ratelimit.yaml

./deploy_app.sh

gcloud alpha services api-keys create --display-name="testnamee"  
KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=testnamee") 
export API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)") 


./query_api_with_key.sh $API_KEY

# Function to generate traffic
generate_traffic() {
  ./generate_traffic_with_key.sh "$API_KEY"
}

# Function to send authenticated request
send_authenticated_request() {
  ./query_api_with_key.sh "$API_KEY"
}

# Generate traffic for 5-10 seconds
generate_traffic &

# Sleep for 10 seconds (adjust as needed)
sleep 10

# Send an authenticated request
send_authenticated_request


