

# Set the bucket name and location
BUCKET_NAME=$DEVSHELL_PROJECT_ID
LOCATION=$REGION

# Create the bucket
gcloud storage buckets create gs://$BUCKET_NAME --location=$LOCATION 

# Download the image to Cloud Shell
wget --output-document google.png https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png

# Upload the image to the bucket
gsutil cp google.png gs://$BUCKET_NAME


# Make all objects in the bucket publicly accessible
gsutil iam ch allUsers:objectViewer gs://$BUCKET_NAME

gsutil acl ch -u AllUsers:R gs://$DEVSHELL_PROJECT_ID/google.png


gcloud services enable compute.googleapis.com


curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -d '{
    "bucketName": "'"$DEVSHELL_PROJECT_ID"'",
    "cdnPolicy": {
      "cacheMode": "CACHE_ALL_STATIC",
      "clientTtl": 3600,
      "defaultTtl": 3600,
      "maxTtl": 86400,
      "negativeCaching": false,
      "serveWhileStale": 0
    },
    "compressionMode": "DISABLED",
    "description": "",
    "enableCdn": true,
    "name": "lb-backend-bucket"
  }' \
  "https://www.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/backendBuckets"

sleep 30

curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -d '{
    "defaultService": "projects/'"$DEVSHELL_PROJECT_ID"'/global/backendBuckets/lb-backend-bucket",
    "name": "edge-cache-lb"
  }' \
  "https://www.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/urlMaps"

sleep 30

curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -d '{
    "name": "edge-cache-lb-target-proxy",
    "urlMap": "projects/'"$DEVSHELL_PROJECT_ID"'/global/urlMaps/edge-cache-lb"
  }' \
  "https://www.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/targetHttpProxies"

sleep 30

curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -d '{
    "IPProtocol": "TCP",
    "ipVersion": "IPV4",
    "loadBalancingScheme": "EXTERNAL_MANAGED",
    "name": "edge-cache-lb-forwarding-rule",
    "networkTier": "PREMIUM",
    "portRange": "80",
    "target": "projects/'"$DEVSHELL_PROJECT_ID"'/global/targetHttpProxies/edge-cache-lb-target-proxy"
  }' \
  "https://www.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/forwardingRules"

