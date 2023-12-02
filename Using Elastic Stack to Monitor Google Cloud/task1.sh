BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`

BG_BLACK=`tput setab 0`
BG_RED=`tput setab 1`
BG_GREEN=`tput setab 2`
BG_YELLOW=`tput setab 3`
BG_BLUE=`tput setab 4`
BG_MAGENTA=`tput setab 5`
BG_CYAN=`tput setab 6`
BG_WHITE=`tput setab 7`

BOLD=`tput bold`
RESET=`tput sgr0`
#----------------------------------------------------start--------------------------------------------------#

echo "${YELLOW}${BOLD}

Starting Execution 


${RESET}"
#gcloud auth list
#gcloud config list project
export PROJECT_ID=$(gcloud info --format='value(config.project)')
#export BUCKET_NAME=$(gcloud info --format='value(config.project)')
#export EMAIL=$(gcloud config get-value core/account)
#gcloud config set compute/region $region
#gcloud config set compute/zone $region-a
#export ZONE=$region-a



#USER_EMAIL=$(gcloud auth list --limit=1 2>/dev/null | grep '@' | awk '{print $2}')
#----------------------------------------------------code--------------------------------------------------# 




gcloud auth list

export YOUR_DEPLOYMENT_CLOUD_ID="bc6907a39edc42f5bc0d34fe43b202c9:dXMtY2VudHJhbDEuZ2NwLmNsb3VkLmVzLmlvOjQ0MyQ0YTA0ZjAzZjQwYmU0YWM2ODgzMTE0YWFiNmZjYjU4NyQzMjc5MmU3YzZiYWY0ZDQzOWJhZjg3MGNkMGNkZmQ1Mw=="
export YOUR_SUPER_SECRET_PASS="9kEHdq6gDohF3fPrcZ2MlXd2"



curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.14.0-linux-x86_64.tar.gz
tar xzvf metricbeat-7.14.0-linux-x86_64.tar.gz
cd metricbeat-7.14.0-linux-x86_64/

./metricbeat setup -e -E "cloud.id=$YOUR_DEPLOYMENT_CLOUD_ID" -E "cloud.auth=elastic:$YOUR_SUPER_SECRET_PASS"


./metricbeat keystore create
echo -n "$YOUR_DEPLOYMENT_CLOUD_ID" | ./metricbeat keystore add CLOUD_ID --stdin


### ID & API KEY 

echo -n "EqTJK4wBXRVBFHVvp24n:AOgZ8VzBSSmEpF01ESJAkg" | ./metricbeat keystore add ES_API_KEY --stdin

./metricbeat keystore list



echo "cloud.id: \${CLOUD_ID}" >> metricbeat.yml
echo "output.elasticsearch:" >> metricbeat.yml
echo "  api_key: \${ES_API_KEY}" >> metricbeat.yml


./metricbeat test output


gcloud iam service-accounts keys create credentials.json --iam-account=gcp-monitor@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com

./metricbeat modules enable gcp


cat > modules.d/gcp.yml <<EOF_END
- module: gcp
  metricsets:
    - compute
  region: $REGION
  project_id: "$DEVSHELL_PROJECT_ID"
  credentials_file_path: "/home/$USER/metricbeat-7.14.0-linux-x86_64/credentials.json"
  exclude_labels: false
  period: 1m
EOF_END

./metricbeat test modules gcp

./metricbeat -e

