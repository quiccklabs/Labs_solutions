


export INSTANCE_ID="bus-instance"
export CLUSTER_ID="bus-cluster"
export TABLE_ID="bus-data"
export CLUSTER_NODES=3


export NUM_WORKERS=5


export REGION="${ZONE%-*}"

gcloud services disable dataflow.googleapis.com
gcloud services enable bigtable.googleapis.com bigtableadmin.googleapis.com dataflow.googleapis.com


gcloud bigtable instances create $INSTANCE_ID \
    --display-name=$INSTANCE_ID \
    --cluster-config=id=$CLUSTER_ID,zone=$ZONE,nodes=$CLUSTER_NODES


echo project = $GOOGLE_CLOUD_PROJECT > ~/.cbtrc
echo instance = $INSTANCE_ID >> ~/.cbtrc

cbt createtable $TABLE_ID
cbt createfamily $TABLE_ID cf



sleep 80

gcloud beta dataflow jobs run import-bus-data-$(date +%s) \
--gcs-location gs://dataflow-templates/latest/GCS_SequenceFile_to_Cloud_Bigtable \
--num-workers=$NUM_WORKERS --max-workers=$NUM_WORKERS --region=$REGION \
--parameters bigtableProject=$GOOGLE_CLOUD_PROJECT,bigtableInstanceId=$INSTANCE_ID,bigtableTableId=$TABLE_ID,sourcePattern=gs://cloud-bigtable-public-datasets/bus-data/*



git clone https://github.com/googlecodelabs/cbt-intro-java.git
cd cbt-intro-java


sudo update-java-alternatives -s java-1.11.0-openjdk-amd64 && export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/


mvn package exec:java -Dbigtable.projectID=$GOOGLE_CLOUD_PROJECT \
-Dbigtable.instanceID=$INSTANCE_ID -Dbigtable.table=$TABLE_ID \
-Dquery=lookupVehicleInGivenHour


mvn package exec:java -Dbigtable.projectID=$GOOGLE_CLOUD_PROJECT \
-Dbigtable.instanceID=$INSTANCE_ID -Dbigtable.table=$TABLE_ID \
-Dquery=scanBusLineInGivenHour


mvn package exec:java -Dbigtable.projectID=$GOOGLE_CLOUD_PROJECT \
-Dbigtable.instanceID=$INSTANCE_ID -Dbigtable.table=$TABLE_ID \
-Dquery=scanEntireBusLine


mvn package exec:java -Dbigtable.projectID=$GOOGLE_CLOUD_PROJECT \
-Dbigtable.instanceID=$INSTANCE_ID -Dbigtable.table=$TABLE_ID \
-Dquery=filterBusesGoingEast


mvn package exec:java -Dbigtable.projectID=$GOOGLE_CLOUD_PROJECT \
-Dbigtable.instanceID=$INSTANCE_ID -Dbigtable.table=$TABLE_ID \
-Dquery=filterBusesGoingWest


mvn package exec:java -Dbigtable.projectID=$GOOGLE_CLOUD_PROJECT \
-Dbigtable.instanceID=$INSTANCE_ID -Dbigtable.table=$TABLE_ID \
-Dquery=scanManhattanBusesInGivenHour


