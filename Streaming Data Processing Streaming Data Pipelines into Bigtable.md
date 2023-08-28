
# Streaming Data Processing: Streaming Data Pipelines into Bigtable



Open the SSH terminal and connect to the training VM

Navigation menu ( Navigation menu icon), click Compute Engine > VM instances.

 click on SSH to open a terminal window. Then click Connect.
## 

## Run these command on 1st connection

```bash
git clone https://github.com/GoogleCloudPlatform/training-data-analyst

source /training/project_env.sh

cd ~/training-data-analyst/courses/streaming/process/sandiego
./install_quickstart.sh

/training/sensor_magic.sh
```


## Open a second SSH terminal and connect to the training VM

In the upper right corner of the training-vm SSH terminal, click on the gear-shaped button (Settings icon), and select New Connection from the drop-down menu. A new terminal window will open.


## Run these command on 2nd  connection

```bash
export ZONE=
```


```bash
export REGION="${ZONE%-*}"
source /training/project_env.sh

gcloud services disable dataflow.googleapis.com --force
gcloud services enable dataflow.googleapis.com

cd ~/training-data-analyst/courses/streaming/process/sandiego

cd ~/training-data-analyst/courses/streaming/process/sandiego
./create_cbt.sh

cd ~/training-data-analyst/courses/streaming/process/sandiego
./run_oncloud.sh $DEVSHELL_PROJECT_ID $BUCKET CurrentConditions --bigtable
```



### Now just wait for 5 minutes score will update automatically
