
gcloud services disable  dataflow.googleapis.com

gcloud services enable  dataflow.googleapis.com

sleep 30


git clone https://github.com/GoogleCloudPlatform/training-data-analyst

gsutil mb gs://$DEVSHELL_PROJECT_ID

export BUCKET=$DEVSHELL_PROJECT_ID

cd ~/training-data-analyst/courses/data_analysis/lab2/javahelp
./run_oncloud3.sh $DEVSHELL_PROJECT_ID $BUCKET JavaProjectsThatNeedHelp

