


#task 3

gsutil rm -r gs://$DEVSHELL_PROJECT_ID/**


#task 4

curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -d '{
    "description": "",
    "name": "edge-security-policy",
    "rules": [
      {
        "action": "deny(403)",
        "description": "Default rule, higher priority overrides it",
        "match": {
          "config": {
            "srcIpRanges": [
              "*"
            ]
          },
          "versionedExpr": "SRC_IPS_V1"
        },
        "preview": false,
        "priority": 2147483647
      }
    ],
    "type": "CLOUD_ARMOR_EDGE"
  }' \
  "https://www.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/securityPolicies"

sleep 30

curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -d '{
    "securityPolicy": "projects/'"$DEVSHELL_PROJECT_ID"'/global/securityPolicies/edge-security-policy"
  }' \
  "https://compute.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/backendBuckets/lb-backend-bucket/setEdgeSecurityPolicy"



