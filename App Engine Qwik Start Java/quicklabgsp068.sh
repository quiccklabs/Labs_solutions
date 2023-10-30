
gcloud services enable appengine.googleapis.com

sleep 10

git clone https://github.com/GoogleCloudPlatform/java-docs-samples.git

cd java-docs-samples/appengine-java8/helloworld

mvn clean
mvn package

# Start mvn appengine:run in the background with a timeout of 120 seconds
timeout 30 mvn appengine:run &

# Continue with the other commands after a 30-second pause
sleep 30

gcloud app create --region=$REGION

sed -i "s/myProjectId/$DEVSHELL_PROJECT_ID/g" pom.xml

mvn package appengine:deploy

gcloud app browse
