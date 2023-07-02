PART 0:-  Assigning Values 

export ZONE=

export PROJECTID=$(gcloud config get-value project)

gcloud auth login


PART 1:-  Run all this commands on lab-vm instance 


gcloud iam service-accounts create devops --display-name devops

gcloud config configurations activate default

gcloud iam service-accounts list  --filter "displayName=devops"

SA=$(gcloud iam service-accounts list --format="value(email)" --filter "displayName=devops")

gcloud projects add-iam-policy-binding $PROJECTID --member serviceAccount:$SA --role=roles/iam.serviceAccountUser

gcloud projects add-iam-policy-binding $PROJECTID --member serviceAccount:$SA --role=roles/compute.instanceAdmin

gcloud compute instances create vm-2 \
--service-account=$SA \
--zone=$ZONE

cat > role-definition.yaml <<EOF
title: Custom Role
description: Custom role with cloudsql.instances.connect and cloudsql.instances.get permissions
includedPermissions:
- cloudsql.instances.connect
- cloudsql.instances.get
EOF


gcloud iam roles create customRole --project=$PROJECTID --file=role-definition.yaml

gcloud iam service-accounts create bigquery-qwiklab --display-name bigquery-qwiklab

SSA=$(gcloud iam service-accounts list --format="value(email)" --filter "displayName=bigquery-qwiklab")

gcloud projects add-iam-policy-binding $PROJECTID --member=serviceAccount:$SSA --role=roles/bigquery.dataViewer

gcloud projects add-iam-policy-binding $PROJECTID --member=serviceAccount:$SSA --role=roles/bigquery.user


gcloud compute instances create bigquery-instance --service-account=$SSA --scopes=https://www.googleapis.com/auth/bigquery --zone=$ZONE




---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PART 2:- Run all command on bigquery-instance




export PROJECT_ID=$(gcloud config get-value project)

sudo apt-get update

sudo apt-get install -y git python3-pip

pip3 install --upgrade pip

pip3 install google-cloud-bigquery

pip3 install pyarrow

pip3 install pandas

pip3 install db-dtypes


echo "
from google.auth import compute_engine
from google.cloud import bigquery
credentials = compute_engine.Credentials(
    service_account_email='bigquery-qwiklab@$PROJECT_ID.iam.gserviceaccount.com')
query = '''
SELECT name, SUM(number) as total_people
FROM "bigquery-public-data.usa_names.usa_1910_2013"
WHERE state = 'TX'
GROUP BY name, state
ORDER BY total_people DESC
LIMIT 20
'''
client = bigquery.Client(
    project='$PROJECT_ID',
    credentials=credentials)
print(client.query(query).to_dataframe())
" > query.py


pip3 install --upgrade pip

pip3 install google-cloud-bigquery

pip3 install pyarrow

pip3 install pandas

pip3 install db-dtypes

python3 query.py






-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
