

export PROJECT_ID=$DEVSHELL_PROJECT_ID
export BUCKET=$PROJECT_ID


gsutil mb -p $PROJECT_ID \
    -c standard    \
    -l us-central1 \
    gs://${BUCKET}


gsutil -m cp -r gs://car_damage_lab_images/* gs://${BUCKET}

gsutil cp gs://car_damage_lab_metadata/data.csv .

sed -i -e "s/car_damage_lab_images/${BUCKET}/g" ./data.csv

gsutil cp ./data.csv gs://${BUCKET}

sleep 20


wget https://raw.githubusercontent.com/quiccklabs/Identify-Application-Vulnerabilities-with-Security-Command-Center/main/payload.json


export AUTOML_PROXY=$(gcloud run services describe automl-proxy --region=us-central1 --format="value(status.url)")
INPUT_DATA_FILE=payload.json

curl -X POST -H "Content-Type: application/json" $AUTOML_PROXY/v1 -d "@${INPUT_DATA_FILE}"