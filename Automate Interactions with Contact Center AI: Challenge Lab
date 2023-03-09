
	****************Automate Interactions with Contact Center AI: Challenge Lab******************************
              

-------------------------------------step 1-----------------------------
Task 1: Create a Cloud Storage Bucket


gsutil mb -l Region_name gs://[project id]/

-------------------------------------step 2——————————————


Task 2: Create a Cloud Function


Go to the “saf-longrun-job-func” directory

cd dataflow-contact-center-speech-analysis/saf-longrun-job-func
gcloud functions deploy safLongRunJobFunc --runtime nodejs12 --trigger-resource [project id] --region Region_name --trigger-event google.storage.object.finalize




 -------------------------------------step 3——————————————


Task 3: Create a BigQuery Dataset and Table
# To create the dataset
bq mk dataset_name



 -------------------------------------step4-----------------------------


Task 4: Create Cloud Pub/Sub Topic
gcloud pubsub topics create [Topic_Name]


 -------------------------------------step 5——————————————


Task 5: Create a Cloud Storage Bucket for Staging Contents
gsutil mb -l [Region_name] gs://[BUCKET_NAME]/
Create a folder “DFaudio” in the bucket

Need to do it manually

 -------------------------------------step 6——————————————


Task 6: Deploy a Cloud Dataflow Pipeline
Go to the saf-longrun-job-dataflow directory


python -m virtualenv env -p python3
source env/bin/activate
pip install apache-beam[gcp]
pip install dateparser


Now, execute the command given below:
python saflongrunjobdataflow.py \
--project=[PROJECT_ID] \
--region=Region_name \
--input_topic=projects/[PROJECT_ID]/topics/[Topic_Name] \
--runner=DataflowRunner \
--temp_location=gs://[BUCKET_NAME]/[FOLDER] \
--output_bigquery=[PROJECT_ID]:dataset_name.transcripts \
--requirements_file=requirements.txt



 -------------------------------------step 7——————————————


Task 7: Upload Sample Audio Files for Processing
gsutil -h x-goog-meta-callid:1234567 -h x-goog-meta-stereo:false -h x-goog-meta-pubsubtopicname:[TOPIC_NAME] -h x-goog-meta-year:2019 -h x-goog-meta-month:11 -h x-goog-meta-day:06 -h x-goog-meta-starttime:1116 cp gs://qwiklabs-bucket-gsp311/speech_commercial_mono.flac gs://[BUCKKET_NAME]


gsutil -h x-goog-meta-callid:1234567 -h x-goog-meta-stereo:true -h x-goog-meta-pubsubtopicname:[TOPIC_NAME] -h x-goog-meta-year:2019 -h x-goog-meta-month:11 -h x-goog-meta-day:06 -h x-goog-meta-starttime:1116 cp gs://qwiklabs-bucket-gsp311/speech_commercial_stereo.wav gs://[BUCKET_NAME]


After performing Task 7: Upload Sample Audio Files for Processing, we have to wait....until we see output in bigquery > dataset > table.





Task 8: Run a Data Loss Prevention Job



select * from (SELECT entities.name,entities.type, COUNT(entities.name) AS count FROM dataset_name.transcripts, UNNEST(entities) entities GROUP BY entities.name, entities.type ORDER BY count ASC ) Where count > 5





—-----------------------------—-----------------END—----------------------------—-----------------------------
