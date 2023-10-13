
export BMSPROJ=$PROJECT_ID_1

export BASTIONPROJ=$PROJECT_ID_2

gcloud config set project $BASTIONPROJ

gcloud compute networks peerings create bms-peer-bastion --network bms-bastion-net --peer-network bms-db-net --peer-project $BMSPROJ

gcloud config set project $BMSPROJ

gcloud compute networks peerings create bms-peer-db --network  bms-db-net --peer-network bms-bastion-net --peer-project $BASTIONPROJ


