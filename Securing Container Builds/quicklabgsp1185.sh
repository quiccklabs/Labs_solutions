
echo ""
echo ""
echo "Please export the values."


# Prompt user to input three regions
read -p "Enter REGION: " REGION


export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')

gcloud services enable artifactregistry.googleapis.com

git clone https://github.com/GoogleCloudPlatform/java-docs-samples
cd java-docs-samples/container-registry/container-analysis

gcloud artifacts repositories create container-dev-java-repo \
    --repository-format=maven \
    --location=$REGION \
    --description="Java package repository for Container Dev Workshop"

gcloud artifacts repositories describe container-dev-java-repo \
    --location=$REGION

gcloud artifacts print-settings mvn \
    --repository=container-dev-java-repo \
    --location=$REGION


# add file here

rm pom.xml
wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/refs/heads/master/Securing%20Container%20Builds/pom.xml
sed -i "s/\$REGION/$REGION/g; s/\$DEVSHELL_PROJECT_ID/$DEVSHELL_PROJECT_ID/g" pom.xml


mvn deploy -DskipTests

gcloud artifacts repositories create maven-central-cache \
    --project=$PROJECT_ID \
    --repository-format=maven \
    --location=$REGION \
    --description="Remote repository for Maven Central caching" \
    --mode=remote-repository \
    --remote-repo-config-desc="Maven Central" \
    --remote-mvn-repo=MAVEN-CENTRAL

gcloud artifacts repositories describe maven-central-cache \
    --location=$REGION

gcloud artifacts print-settings mvn \
    --repository=maven-central-cache \
    --location=$REGION

mkdir .mvn 
cat > .mvn/extensions.xml << EOF
<extensions xmlns="http://maven.apache.org/EXTENSIONS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/EXTENSIONS/1.0.0 http://maven.apache.org/xsd/core-extensions-1.0.0.xsd">
  <extension>
    <groupId>com.google.cloud.artifactregistry</groupId>
    <artifactId>artifactregistry-maven-wagon</artifactId>
    <version>2.2.0</version>
  </extension>
</extensions>
EOF

rm -rf ~/.m2/repository 
mvn compile


cat > ./policy.json << EOF
[
  {
    "id": "private",
    "repository": "projects/${PROJECT_ID}/locations/$REGION/repositories/container-dev-java-repo",
    "priority": 100
  },
  {
    "id": "central",
    "repository": "projects/${PROJECT_ID}/locations/$REGION/repositories/maven-central-cache",
    "priority": 80
  }
]

EOF

gcloud artifacts repositories create virtual-maven-repo \
    --project=${PROJECT_ID} \
    --repository-format=maven \
    --mode=virtual-repository \
    --location=$REGION \
    --description="Virtual Maven Repo" \
    --upstream-policy-file=./policy.json


