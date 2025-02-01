
echo ""
echo ""

read -p "ENTER LANGUAGE:- " LANGUAGE
read -p "ENTER LOCAL:- " LOCAL
read -p "ENTER BIGQUERY_ROLE:- " BIGQUERY_ROLE
read -p "ENTER CLOUD_STORAGE_ROLE:- " CLOUD_STORAGE_ROLE


gcloud iam service-accounts create sample-sa

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=serviceAccount:sample-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role=$BIGQUERY_ROLE

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=serviceAccount:sample-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role=$CLOUD_STORAGE_ROLE

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=serviceAccount:sample-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role=roles/serviceusage.serviceUsageConsumer

sleep 120

gcloud iam service-accounts keys create sample-sa-key.json --iam-account sample-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com

export GOOGLE_APPLICATION_CREDENTIALS=${PWD}/sample-sa-key.json

wget https://raw.githubusercontent.com/guys-in-the-cloud/cloud-skill-boosts/main/Challenge-labs/Integrate%20with%20Machine%20Learning%20APIs%3A%20Challenge%20Lab/analyze-images-v2.py

sed -i "s/'en'/'${LOCAL}'/g" analyze-images-v2.py

python3 analyze-images-v2.py

python3 analyze-images-v2.py $DEVSHELL_PROJECT_ID $DEVSHELL_PROJECT_ID

bq query --use_legacy_sql=false "SELECT locale,COUNT(locale) as lcount FROM image_classification_dataset.image_text_detail GROUP BY locale ORDER BY lcount DESC"


gcloud iam service-accounts create sample-sa

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=serviceAccount:sample-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role=$BIGQUERY_ROLE

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=serviceAccount:sample-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role=$CLOUD_STORAGE_ROLE

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=serviceAccount:sample-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role=roles/serviceusage.serviceUsageConsumer

sleep 120

gcloud iam service-accounts keys create sample-sa-key.json --iam-account sample-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com

export GOOGLE_APPLICATION_CREDENTIALS=${PWD}/sample-sa-key.json

wget https://raw.githubusercontent.com/guys-in-the-cloud/cloud-skill-boosts/main/Challenge-labs/Integrate%20with%20Machine%20Learning%20APIs%3A%20Challenge%20Lab/analyze-images-v2.py

sed -i "s/'en'/'${LOCAL}'/g" analyze-images-v2.py

python3 analyze-images-v2.py

python3 analyze-images-v2.py $DEVSHELL_PROJECT_ID $DEVSHELL_PROJECT_ID

bq query --use_legacy_sql=false "SELECT locale,COUNT(locale) as lcount FROM image_classification_dataset.image_text_detail GROUP BY locale ORDER BY lcount DESC"
