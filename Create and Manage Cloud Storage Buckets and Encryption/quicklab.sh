REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")


export PROJECT_ID=$(gcloud config get-value project)
echo $PROJECT_ID

export BUCKET_NAME=storecore-${PROJECT_ID##*-}
echo $BUCKET_NAME

export BUCKET_NAME=storecore-${PROJECT_ID##*-}-$(date +%s)

gcloud storage buckets create gs://$BUCKET_NAME \
    --location=$REGION

gcloud storage buckets update gs://$BUCKET_NAME \
    --no-uniform-bucket-level-access

export BUCKET_NAME_1=$BUCKET_NAME

curl \
https://hadoop.apache.org/docs/current/\
hadoop-project-dist/hadoop-common/\
ClusterSetup.html > setup.html

cp setup.html setup2.html
cp setup.html setup3.html

gcloud storage cp setup.html gs://$BUCKET_NAME_1/

gcloud storage objects get-iam-policy gs://$BUCKET_NAME_1/setup.html > acl.txt
cat acl.txt

gcloud storage objects update gs://$BUCKET_NAME_1/setup.html --predefined-acl=private
gcloud storage objects get-iam-policy gs://$BUCKET_NAME_1/setup.html > acl2.txt
cat acl2.txt

gcloud storage objects add-iam-policy-binding gs://$BUCKET_NAME_1/setup.html \
    --member="allUsers" \
    --role="roles/storage.legacyObjectReader"
gcloud storage objects get-iam-policy gs://$BUCKET_NAME_1/setup.html > acl3.txt
cat acl3.txt


rm setup.html

gcloud storage cp gs://$BUCKET_NAME_1/setup.html setup.html


export CSEK_KEY=$(python3 -c "import os,base64; print(base64.b64encode(os.urandom(32)).decode())")

echo $CSEK_KEY

gsutil config -n

sed -i "s|^#* *encryption_key=.*|encryption_key=$CSEK_KEY|" ~/.boto

grep encryption_key ~/.boto

gsutil kms encryption -d gs://$BUCKET_NAME_1
gsutil cp setup2.html gs://$BUCKET_NAME_1/
gsutil cp setup3.html gs://$BUCKET_NAME_1/


#TASK 4

rm setup*
gsutil cp gs://$BUCKET_NAME_1/setup* ./
cat setup.html
cat setup2.html
cat setup3.html

cp ~/.boto ~/.boto.bak

KEY=$(grep '^encryption_key=' ~/.boto | cut -d= -f2)

sed -i "s/^encryption_key=/# encryption_key=/" ~/.boto

if grep -q '^# *decryption_key1=' ~/.boto; then
    sed -i "s|^# *decryption_key1=.*|decryption_key1=$KEY|" ~/.boto
elif grep -q '^decryption_key1=' ~/.boto; then
    sed -i "s|^decryption_key1=.*|decryption_key1=$KEY|" ~/.boto
else
    echo "decryption_key1=$KEY" >> ~/.boto
fi

grep -E 'encryption_key|decryption_key1' ~/.boto



export NEW_CSEK_KEY=$(python3 -c "import os,base64; print(base64.b64encode(os.urandom(32)).decode())")
echo $NEW_CSEK_KEY
sed -i "s|^# *encryption_key=.*|encryption_key=$NEW_CSEK_KEY|" ~/.boto
sed -i "s|^encryption_key=.*|encryption_key=$NEW_CSEK_KEY|" ~/.boto
grep -E 'encryption_key|decryption_key1' ~/.boto


gsutil rewrite -k gs://$BUCKET_NAME_1/setup2.html

sed -i 's/^decryption_key1=/# decryption_key1=/' ~/.boto
grep -E 'encryption_key|decryption_key1' ~/.boto

gsutil cp gs://$BUCKET_NAME_1/setup2.html recover2.html
gsutil cp gs://$BUCKET_NAME_1/setup3.html recover3.html

gcloud storage buckets describe gs://$BUCKET_NAME_1 --format="json(lifecycle)"


cat > life.json <<EOF_END
{
  "rule":
  [
    {
      "action": {"type": "Delete"},
      "condition": {"age": 31}
    }
  ]
}
EOF_END

gcloud storage buckets update gs://$BUCKET_NAME_1 --lifecycle-file=life.json

gcloud storage buckets describe gs://$BUCKET_NAME_1 --format="json(lifecycle_config)"

#TASK 6

gcloud storage buckets describe gs://$BUCKET_NAME_1 --format="json(versioning)"

gcloud storage buckets update gs://$BUCKET_NAME_1 --versioning

gcloud storage buckets describe gs://$BUCKET_NAME_1 --format="json(versioning_enabled)"
