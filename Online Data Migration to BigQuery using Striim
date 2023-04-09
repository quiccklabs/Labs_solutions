


gcloud config set compute/zone us-central1-a
export COMPUTE_ZONE=us-central1-a

export USER_PWD=QUICKLABuser

export ROOT_PWD=QUICKLABroot

export PROJECT_ID=$(gcloud config get-value project)
CSQL_NAME=striim-sql-src
CSQL_USERNAME=striim-user



gcloud sql instances create $CSQL_NAME \
    --root-password=$ROOT_PWD \
    --zone=$COMPUTE_ZONE \
    --enable-bin-log


gcloud sql users create $CSQL_USERNAME \
    --instance $CSQL_NAME \
    --password $USER_PWD \
    --host=%


STRIIMVM_NAME=striim-1-vm
STRIIMVM_ZONE=us-central1-a


gcloud sql instances patch $CSQL_NAME --authorized-networks=$(gcloud compute instances describe $STRIIMVM_NAME --format='get(networkInterfaces[0].accessConfigs[0].natIP)' --zone=$STRIIMVM_ZONE)













