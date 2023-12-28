

gcloud services enable bigtable.googleapis.com bigtableadmin.googleapis.com

sleep 10

gcloud bigtable instances create quickstart-instance \
    --display-name="Quickstart instance" \
    --cluster-storage-type=SSD \
    --cluster-config=id=quickstart-instance-c1,zone=$ZONE,nodes=1


echo project = `gcloud config get-value project` > ~/.cbtrc

echo instance = quickstart-instance >> ~/.cbtrc


cbt createtable my-table

cbt ls

cbt createfamily my-table cf1

cbt ls my-table

cbt set my-table r1 cf1:c1=test-value

cbt read my-table

cbt deletetable my-table


