
gcloud spanner instances create banking-instance \
--config=regional-us-central1  \
--description="quicklab_1" \
--nodes=1

gcloud spanner databases create banking-db --instance=banking-instance

gcloud spanner instances create banking-instance-2 \
--config=regional-us-central1  \
--description="quicklab_2" \
--nodes=2

gcloud spanner databases create banking-db-2 --instance=banking-instance-2
