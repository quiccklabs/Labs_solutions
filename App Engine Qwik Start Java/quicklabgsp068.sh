
gcloud services enable appengine.googleapis.com

sleep 10

git clone https://github.com/GoogleCloudPlatform/java-docs-samples.git

cd java-docs-samples/appengine-java8/helloworld

mvn clean
mvn package

timeout 30 mvn appengine:run &

sleep 30

gcloud app create --region=$REGION

sed -i "s/myProjectId/$DEVSHELL_PROJECT_ID/g" pom.xml

mvn package appengine:deploy

gcloud app browse
