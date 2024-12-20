


echo ""
echo ""

read -p "ENTER REGION: " REGION

gcloud auth list

gcloud services enable monitoring.googleapis.com

git clone https://github.com/haggman/HelloLoggingNodeJS.git

cd HelloLoggingNodeJS


sed -i "s/nodejs22/nodejs20/g" app.yaml

gcloud app create --region=$REGION --quiet

gcloud app deploy --quiet


ACCESS_TOKEN=$(gcloud auth print-access-token)
PROJECT_ID=$(gcloud config get-value project)

# Step 1: Create the default service
curl -X POST \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type: application/json" \
  -d '{
    "displayName": "default",
    "appEngine": {
     "moduleId": "default"
  }
}' \
  https://monitoring.googleapis.com/v3/projects/$PROJECT_ID/services



# SERVICE_ID=$(curl -X GET \
#   -H "Authorization: Bearer $(gcloud auth print-access-token)" \
#   https://monitoring.googleapis.com/v3/projects/$PROJECT_ID/services \
#   | jq -r '.services[] | select(.displayName=="default") | .name')


SERVICE_ID=$(curl -X GET \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  https://monitoring.googleapis.com/v3/projects/$PROJECT_ID/services \
  | jq -r '.services[] | select(.name | contains("gae")) | .name')


# curl -X POST \
#   -H "Authorization: Bearer $(gcloud auth print-access-token)" \
#   -H "Content-Type: application/json" \
#   -d '{
#     "displayName": "99.5% - Availability - Rolling 7 days",
#     "goal": 0.995,
#     "rollingPeriod": "604800s",
#     "serviceLevelIndicator": {
#       "basicSli": {
#         "availability": {}
#       }
#     }
#   }' \
#   https://monitoring.googleapis.com/v3/$SERVICE_ID/serviceLevelObjectives



RESPONSE=$(curl -X POST \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type: application/json" \
  -d '{
    "displayName": "99.5% - Availability - Rolling 7 days",
    "goal": 0.995,
    "rollingPeriod": "604800s",
    "serviceLevelIndicator": {
      "basicSli": {
        "availability": {}
      }
    }
  }' \
  https://monitoring.googleapis.com/v3/$SERVICE_ID/serviceLevelObjectives)


NAME=$(echo $RESPONSE | jq -r '.name')  


cat > email-channel.json <<EOF_END
{
  "type": "email",
  "displayName": "quicklab",
  "description": "Subscribe to quicklab",
  "labels": {
    "email_address": "$USER_EMAIL"
  }
}
EOF_END


gcloud beta monitoring channels create --channel-content-from-file="email-channel.json"





# Run the gcloud command and store the output in a variable
channel_info=$(gcloud beta monitoring channels list)

# Extract the channel ID using grep and awk
channel_id=$(echo "$channel_info" | grep -oP 'name: \K[^ ]+' | head -n 1)


cat > app-engine-error-percent-policy.json <<EOF_END
{
  "displayName": "Really short window test",
  "userLabels": {},
  "conditions": [
    {
      "displayName": "Really short window test",
      "conditionThreshold": {
        "filter": "select_slo_burn_rate(\"$NAME\", \"600s\")",
        "aggregations": [
          {
            "alignmentPeriod": "300s",
            "crossSeriesReducer": "REDUCE_NONE"
          }
        ],
        "comparison": "COMPARISON_GT",
        "duration": "0s",
        "trigger": {
          "count": 1
        },
        "thresholdValue": 1.5
      }
    }
  ],
  "alertStrategy": {
    "notificationPrompts": [
      "OPENED",
      "CLOSED"
    ]
  },
  "combiner": "OR",
  "enabled": true,
  "notificationChannels": [
    $channel_id
  ],
  "severity": "SEVERITY_UNSPECIFIED"
}

EOF_END



gcloud alpha monitoring policies create --policy-from-file="app-engine-error-percent-policy.json"


gcloud app deploy --quiet
