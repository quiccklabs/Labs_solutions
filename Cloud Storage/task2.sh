

# 2nd Project ID

export REGION="${ZONE%-*}"

gsutil mb -p $DEVSHELL_PROJECT_ID -c STANDARD -l $REGION -b on gs://$DEVSHELL_PROJECT_ID-2

gsutil uniformbucketlevelaccess set off gs://$DEVSHELL_PROJECT_ID-2

echo "subscribe to quicklab" > test.txt

gsutil cp test.txt gs://$DEVSHELL_PROJECT_ID-2




# Create the service account
gcloud iam service-accounts create cross-project-storage --display-name "Cross-Project Storage Account"

# Grant Storage Object Viewer role to the service account
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member="serviceAccount:cross-project-storage@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" --role="roles/storage.objectViewer"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member="serviceAccount:cross-project-storage@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" --role="roles/storage.objectAdmin"

# Generate and download the JSON key file
gcloud iam service-accounts keys create credentials.json --iam-account=cross-project-storage@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com

# Create VM instance
gcloud compute instances create crossproject \
    --zone $ZONE \
    --machine-type e2-medium \
    --image-family debian-11 \
    --image-project debian-cloud \
    --boot-disk-size 10GB \
    --boot-disk-type pd-balanced \

# ssh to vm
gcloud compute ssh crossproject

sleep 10

export BUCKET_NAME_2=test-2023011502
export FILE_NAME=ttcp.csv
echo $BUCKET_NAME_2/$FILE_NAME

# Authorize the VM and access file
$ ls -l
total 4
-rw-r--r-- 1 student-01-2f50fc858c40 google-sudoers 2381 Jan 15 10:26 credentials.json

# change policy
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
    --member serviceAccount:cross-project-storage@YOUR_PROJECT_ID.iam.gserviceaccount.com \
    --role roles/storage.objectAdmin

# Upload file again
gsutil cp credentials.json gs://$BUCKET_NAME_2/
