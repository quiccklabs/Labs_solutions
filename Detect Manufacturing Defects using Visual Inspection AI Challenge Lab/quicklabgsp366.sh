
read -p "Enter CONTAINER_NAME:- " CONTAINER_NAME
read -p "Enter TASK_3_FILE_NAME:- " TASK_3_FILE_NAME
read -p "Enter TASK_4_FILE_NAME:- " TASK_4_FILE_NAME

ZONE="$(gcloud compute instances list --project=$DEVSHELL_PROJECT_ID --format='value(ZONE)' | head -n 1)"

# cat > env_vars.sh <<'EOF'
# export CONTAINER_NAME=$CONTAINER_NAME
# export TASK_3_FILE_NAME=$TASK_3_FILE_NAME
# export TASK_4_FILE_NAME=$TASK_4_FILE_NAME
# EOF


echo "export CONTAINER_NAME=$CONTAINER_NAME" > env_vars.sh
echo "export TASK_3_FILE_NAME=$TASK_3_FILE_NAME" >> env_vars.sh
echo "export TASK_4_FILE_NAME=$TASK_4_FILE_NAME" >> env_vars.sh


source env_vars.sh

cat > prepare_disk.sh <<'EOF_END'
# Source the environment variables
source /tmp/env_vars.sh

export mobile_inspection=gcr.io/ql-shared-resources-test/defect_solution@sha256:776fd8c65304ac017f5b9a986a1b8189695b7abbff6aa0e4ef693c46c7122f4c

export VISERVING_CPU_DOCKER_WITH_MODEL=${mobile_inspection}
export HTTP_PORT=8602
export LOCAL_METRIC_PORT=8603

docker pull ${VISERVING_CPU_DOCKER_WITH_MODEL}

docker run -v /secrets:/secrets --rm -d --name "$CONTAINER_NAME" \
--network="host" \
-p ${HTTP_PORT}:8602 \
-p ${LOCAL_METRIC_PORT}:8603 \
-t ${VISERVING_CPU_DOCKER_WITH_MODEL} \
--use_default_credentials=false \
--service_account_credentials_json=/secrets/assembly-usage-reporter.json

# Task 2
gsutil cp gs://cloud-training/gsp895/prediction_script.py .

export PROJECT_ID=$(gcloud config get-value core/project)
gsutil mb gs://${PROJECT_ID}
gsutil -m cp gs://cloud-training/gsp897/cosmetic-test-data/*.png \
gs://${PROJECT_ID}/cosmetic-test-data/
gsutil cp gs://${PROJECT_ID}/cosmetic-test-data/IMG_07703.png .

# Task 3
sudo apt install python3 -y
sudo apt install python3-pip -y
sudo apt install python3.11-venv -y 
python3 -m venv create myvenv
source myvenv/bin/activate
pip install absl-py  
pip install numpy 
pip install requests

python3 ./prediction_script.py --input_image_file=./IMG_07703.png  --port=8602 --output_result_file=${TASK_3_FILE_NAME}

# Task 4
export PROJECT_ID=$(gcloud config get-value core/project)
gsutil cp gs://${PROJECT_ID}/cosmetic-test-data/IMG_0769.png .

python3 ./prediction_script.py --input_image_file=./IMG_0769.png  --port=8602 --output_result_file=${TASK_4_FILE_NAME}
EOF_END


# Copy the environment variables script to the VM
gcloud compute scp env_vars.sh lab-vm:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

# Copy the prepare_disk.sh script to the VM
gcloud compute scp prepare_disk.sh lab-vm:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

# SSH into the VM and execute the script
gcloud compute ssh lab-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/prepare_disk.sh"
