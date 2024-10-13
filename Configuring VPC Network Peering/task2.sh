#TASK 2

ZONE=$(gcloud compute instances list --format="value(ZONE)" | tail -n 2 | head -n 1)


gcloud compute networks peerings create peering-1-2 \
  --network=mynetwork \
  --peer-network=privatenet \
  --auto-create-routes


gcloud compute networks peerings create peering-2-1 \
  --network=privatenet \
  --peer-network=mynetwork \
  --auto-create-routes
