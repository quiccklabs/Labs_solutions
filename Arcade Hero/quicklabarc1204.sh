gcloud pubsub topics create sports_topic

gcloud pubsub topics create app_topic

gcloud pubsub subscriptions create app_subscription --topic=app_topic
