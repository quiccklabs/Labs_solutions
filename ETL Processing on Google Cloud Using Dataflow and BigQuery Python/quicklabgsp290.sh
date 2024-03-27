



gcloud services disable dataflow.googleapis.com

gcloud services enable dataflow.googleapis.com

gsutil -m cp -R gs://spls/gsp290/dataflow-python-examples .

export PROJECT=$DEVSHELL_PROJECT_ID

gcloud config set project $PROJECT

gsutil mb -c regional -l $REGION  gs://$PROJECT


gsutil cp gs://spls/gsp290/data_files/usa_names.csv gs://$PROJECT/data_files/
gsutil cp gs://spls/gsp290/data_files/head_usa_names.csv gs://$PROJECT/data_files/

bq mk lake


cat > quicklab_commands.sh <<'EOF_END'

pip install apache-beam[gcp]==2.24.0

cd /dataflow

python dataflow_python_examples/data_ingestion.py \
  --project=$PROJECT --region=$REGION \
  --runner=DataflowRunner \
  --machine_type=e2-small \
  --staging_location=gs://$PROJECT/test \
  --temp_location gs://$PROJECT/test \
  --input gs://$PROJECT/data_files/head_usa_names.csv \
  --save_main_session

python dataflow_python_examples/data_transformation.py \
  --project=$PROJECT \
  --region=$REGION \
  --runner=DataflowRunner \
  --machine_type=e2-small \
  --staging_location=gs://$PROJECT/test \
  --temp_location gs://$PROJECT/test \
  --input gs://$PROJECT/data_files/head_usa_names.csv \
  --save_main_session

sed -i "s/values = \[x.decode('utf8') for x in csv_row\]/values = \[x for x in csv_row\]/" ./dataflow_python_examples/data_enrichment.py

python dataflow_python_examples/data_enrichment.py \
  --project=$PROJECT \
  --region=$REGION \
  --runner=DataflowRunner \
  --machine_type=e2-small \
  --staging_location=gs://$PROJECT/test \
  --temp_location gs://$PROJECT/test \
  --input gs://$PROJECT/data_files/head_usa_names.csv \
  --save_main_session

python dataflow_python_examples/data_lake_to_mart.py \
  --worker_disk_type="compute.googleapis.com/projects//zones//diskTypes/pd-ssd" \
  --max_num_workers=4 \
  --project=$PROJECT \
  --runner=DataflowRunner \
  --machine_type=e2-small \
  --staging_location=gs://$PROJECT/test \
  --temp_location gs://$PROJECT/test \
  --save_main_session \
  --region=$REGION
EOF_END


chmod +x run_commands.sh

mv quicklab_commands.sh dataflow-python-examples/


docker run -it -e PROJECT=$PROJECT -v $(pwd)/dataflow-python-examples:/dataflow python:3.8 /bin/bash /dataflow/quicklab_commands.sh


