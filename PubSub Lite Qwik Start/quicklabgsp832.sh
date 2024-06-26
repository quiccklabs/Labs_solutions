
gcloud services enable pubsublite.googleapis.com

sleep 30

pip3 install --upgrade google-cloud-pubsublite



gcloud pubsub lite-topics create my-lite-topic \
          --zone=$REGION-a --partitions=1 \
          --per-partition-bytes=30GiB --message-retention-period=2w

gcloud pubsub lite-subscriptions create my-lite-subscription \
  --project=$DEVSHELL_PROJECT_ID \
  --zone=$REGION-a \
  --topic=my-lite-topic \
  --delivery-requirement=deliver-after-stored
