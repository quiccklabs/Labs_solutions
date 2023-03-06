TASK 1:- 

git clone https://github.com/GoogleCloudPlatform/ci-cd-for-data-processing-workflow.git

cd ~/ci-cd-for-data-processing-workflow/env-setup
source set_env.sh

TASK:- 2-4 

gcloud composer environments create data-pipeline-composer \
    --location us-central1 \
    --image-version composer-1.20.7-airflow-1.10.15

cd ~/ci-cd-for-data-processing-workflow/env-setup
chmod +x set_composer_variables.sh
./set_composer_variables.sh


export COMPOSER_DAG_BUCKET=$(gcloud composer environments describe $COMPOSER_ENV_NAME \
    --location $COMPOSER_REGION \
    --format="get(config.dagGcsPrefix)")

export COMPOSER_SERVICE_ACCOUNT=$(gcloud composer environments describe $COMPOSER_ENV_NAME \
    --location $COMPOSER_REGION \
    --format="get(config.nodeConfig.serviceAccount)")

cd ~/ci-cd-for-data-processing-workflow/env-setup
chmod +x create_buckets.sh
./create_buckets.sh

gcloud source repos create $SOURCE_CODE_REPO
cp -r ~/ci-cd-for-data-processing-workflow/source-code ~/$SOURCE_CODE_REPO
cd ~/$SOURCE_CODE_REPO
git config --global credential.'https://source.developers.google.com'.helper gcloud.sh
git config --global user.email $(gcloud config list --format 'value(core.account)')
git config --global user.name $(gcloud config list --format 'value(core.account)')
git init
git remote add google \
    https://source.developers.google.com/p/$GCP_PROJECT_ID/r/$SOURCE_CODE_REPO
git add .
git commit -m 'initial commit'
git push google master


gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
    --member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
    --role=roles/composer.admin

gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
    --member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
    --role=roles/composer.worker

TASK 5:- 

cd ~/ci-cd-for-data-processing-workflow/source-code/build-pipeline
gcloud builds submit --config=build_deploy_test.yaml --substitutions=\
REPO_NAME=$SOURCE_CODE_REPO,\
_DATAFLOW_JAR_BUCKET=$DATAFLOW_JAR_BUCKET_TEST,\
_COMPOSER_INPUT_BUCKET=$INPUT_BUCKET_TEST,\
_COMPOSER_REF_BUCKET=$REF_BUCKET_TEST,\
_COMPOSER_DAG_BUCKET=$COMPOSER_DAG_BUCKET,\
_COMPOSER_ENV_NAME=$COMPOSER_ENV_NAME,\
_COMPOSER_REGION=$COMPOSER_REGION,\
_COMPOSER_DAG_NAME_TEST=$COMPOSER_DAG_NAME_TEST


gsutil ls gs://$DATAFLOW_JAR_BUCKET_TEST/dataflow_deployment*.jar

gcloud composer environments describe $COMPOSER_ENV_NAME \
    --location $COMPOSER_REGION \
    --format="get(config.airflowUri)"


TASK :- Create the production pipeline


export DATAFLOW_JAR_FILE_LATEST=$(gcloud composer environments run $COMPOSER_ENV_NAME \
    --location $COMPOSER_REGION variables -- \
    --get dataflow_jar_file_test 2>&1 | grep -i '.jar')

cd ~/ci-cd-for-data-processing-workflow/source-code/build-pipeline
gcloud builds submit --config=deploy_prod.yaml --substitutions=\
REPO_NAME=$SOURCE_CODE_REPO,\
_DATAFLOW_JAR_BUCKET_TEST=$DATAFLOW_JAR_BUCKET_TEST,\
_DATAFLOW_JAR_FILE_LATEST=$DATAFLOW_JAR_FILE_LATEST,\
_DATAFLOW_JAR_BUCKET_PROD=$DATAFLOW_JAR_BUCKET_PROD,\
_COMPOSER_INPUT_BUCKET=$INPUT_BUCKET_PROD,\
_COMPOSER_ENV_NAME=$COMPOSER_ENV_NAME,\
_COMPOSER_REGION=$COMPOSER_REGION,\
_COMPOSER_DAG_BUCKET=$COMPOSER_DAG_BUCKET,\
_COMPOSER_DAG_NAME_PROD=$COMPOSER_DAG_NAME_PROD


TASK 6:- 

echo "_DATAFLOW_JAR_BUCKET : ${DATAFLOW_JAR_BUCKET_TEST}
_COMPOSER_INPUT_BUCKET : ${INPUT_BUCKET_TEST}
_COMPOSER_REF_BUCKET : ${REF_BUCKET_TEST}
_COMPOSER_DAG_BUCKET : ${COMPOSER_DAG_BUCKET}
_COMPOSER_ENV_NAME : ${COMPOSER_ENV_NAME}
_COMPOSER_REGION : ${COMPOSER_REGION}
_COMPOSER_DAG_NAME_TEST : ${COMPOSER_DAG_NAME_TEST}"

TASK :- Create a Trigger in cloud console

TASK :- Test the trigger (last task going to take 5-6 minutes so do now worry)

echo "testword" >>  ~/$SOURCE_CODE_REPO/workflow-dag/support-files/input.txt

echo "testword: 1" >>  ~/$SOURCE_CODE_REPO/workflow-dag/support-files/ref.txt

cd ~/$SOURCE_CODE_REPO
git add .
git commit -m 'change in test files'
git push google master




















