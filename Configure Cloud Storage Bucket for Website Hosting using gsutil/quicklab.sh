  
PROJECT_ID=$(gcloud config get-value project)




gsutil web set -m index.html -e error.html gs://$PROJECT_ID-bucket

gsutil iam ch allUsers:objectViewer gs://$PROJECT_ID-bucket



gsutil uniformbucketlevelaccess set off gs://$PROJECT_ID-bucket


gsutil web set -m index.html -e error.html gs://$PROJECT_ID-bucket


gsutil cp gs://$PROJECT_ID-bucket/index.html .
gsutil cp gs://$PROJECT_ID-bucket/error.html .


gsutil cp index.html gs://$PROJECT_ID-bucket/index.html
gsutil cp error.html gs://$PROJECT_ID-bucket/error.html


gsutil acl ch -u AllUsers:R gs://$PROJECT_ID-bucket/index.html
gsutil acl ch -u AllUsers:R gs://$PROJECT_ID-bucket/error.html





