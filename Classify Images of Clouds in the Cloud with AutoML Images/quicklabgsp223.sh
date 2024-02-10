


gsutil mb -p $GOOGLE_CLOUD_PROJECT \
    -c standard    \
    -l us \
    gs://$GOOGLE_CLOUD_PROJECT-vcm/

export BUCKET=$GOOGLE_CLOUD_PROJECT-vcm

gsutil -m cp -r gs://spls/gsp223/images/* gs://${BUCKET}

gsutil cp gs://spls/gsp223/data.csv .

sed -i -e "s/placeholder/${BUCKET}/g" ./data.csv

gsutil cp ./data.csv gs://${BUCKET}



