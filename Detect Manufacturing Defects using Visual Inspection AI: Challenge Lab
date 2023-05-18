TASK 1:-

export container_name=


export VISERVING_CPU_DOCKER_WITH_MODEL=${container_name}
export HTTP_PORT=8602
export LOCAL_METRIC_PORT=8603

docker pull ${VISERVING_CPU_DOCKER_WITH_MODEL}



docker run -v /secrets:/secrets --rm -d --name "container_name" \
--network="host" \
-p ${HTTP_PORT}:8602 \
-p ${LOCAL_METRIC_PORT}:8603 \
-t ${VISERVING_CPU_DOCKER_WITH_MODEL} \
--use_default_credentials=false \
--service_account_credentials_json=/secrets/assembly-usage-reporter.json



TASK 2:-

gsutil cp gs://cloud-training/gsp895/prediction_script.py .

export PROJECT_ID=$(gcloud config get-value core/project)
gsutil mb gs://${PROJECT_ID}
gsutil -m cp gs://cloud-training/gsp897/cosmetic-test-data/*.png \
gs://${PROJECT_ID}/cosmetic-test-data/
gsutil cp gs://${PROJECT_ID}/cosmetic-test-data/IMG_07703.png .



TASK 3:- 

python3 ./prediction_script.py --input_image_file=./IMG_07703.png  --port=8602 --output_result_file=


TASK 4:-

export PROJECT_ID=$(gcloud config get-value core/project)
gsutil cp gs://${PROJECT_ID}/cosmetic-test-data/IMG_0769.png .

python3 ./prediction_script.py --input_image_file=./IMG_0769.png  --port=8602 --output_result_file=




