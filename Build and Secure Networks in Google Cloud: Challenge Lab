Build and Secure Networks in Google Cloud: Challenge Lab


export IAP_NETWORK_TAG=

export INTERNAL_NETWORK_TAG=

export HTTP_NETWORK_TAG=

export ZONE=


gcloud compute firewall-rules delete open-access
 

gcloud compute firewall-rules create ssh-ingress --allow=tcp:22 --source-ranges 35.235.240.0/20 --target-tags $IAP_NETWORK_TAG --network acme-vpc
 
gcloud compute instances add-tags bastion --tags=$IAP_NETWORK_TAG --zone=$ZONE
 

gcloud compute firewall-rules create http-ingress --allow=tcp:80 --source-ranges 0.0.0.0/0 --target-tags $HTTP_NETWORK_TAG --network acme-vpc
 
gcloud compute instances add-tags juice-shop --tags=$HTTP_NETWORK_TAG --zone=$ZONE
 

gcloud compute firewall-rules create internal-ssh-ingress --allow=tcp:22 --source-ranges 192.168.10.0/24 --target-tags $INTERNAL_NETWORK_TAG --network acme-vpc
 
gcloud compute instances add-tags juice-shop --tags=$INTERNAL_NETWORK_TAG --zone=$ZONE
 


Task 6 : SSH to bastion host via IAP and juice-shop via bastion
In Compute Engine -> VM Instances page, click the SSH button for the bastion host. Then SSH to juice-shop by
 
gcloud compute ssh juice-shop --internal-ip






