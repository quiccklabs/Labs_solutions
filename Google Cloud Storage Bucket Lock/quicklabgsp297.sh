
export BUCKET="$(gcloud config get-value project)"		

gsutil mb "gs://$BUCKET"

gsutil retention set 10s "gs://$BUCKET"

gsutil retention get "gs://$BUCKET"

gsutil cp gs://cloud-samples-data/storage/bucket-lock/dummy_transactions "gs://$BUCKET/"

gsutil ls -L "gs://$BUCKET/dummy_transactions"

gsutil mv gs://$BUCKET/dummy_transactions gs://$BUCKET/example_transactions

gsutil retention lock "gs://$BUCKET/"

gsutil cp gs://cloud-samples-data/storage/bucket-lock/example_transactions "gs://$BUCKET/"

gsutil retention temp set "gs://$BUCKET/example_transactions"

gsutil retention temp release "gs://$BUCKET/example_transactions"

gsutil retention event-default set "gs://$BUCKET/"

gsutil cp gs://cloud-samples-data/storage/bucket-lock/dummy_loan "gs://$BUCKET/"

gsutil mv gs://$BUCKET/dummy_loan gs://$BUCKET/example_loan

gsutil cp gs://cloud-samples-data/storage/bucket-lock/example_loan "gs://$BUCKET/"

gsutil retention event release "gs://$BUCKET/example_loan"

gsutil retention temp set "gs://$BUCKET/dummy_transactions"

gsutil rm "gs://$BUCKET/dummy_transactions"

gsutil retention temp release "gs://$BUCKET/dummy_transactions"

gsutil retention event-default set "gs://$BUCKET/"

gsutil cp gs://cloud-samples-data/storage/bucket-lock/dummy_loan "gs://$BUCKET/"

gsutil ls -L "gs://$BUCKET/dummy_loan"

gsutil retention event release "gs://$BUCKET/dummy_loan"

gsutil ls -L "gs://$BUCKET/dummy_loan"








