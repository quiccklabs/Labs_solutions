#GSP330 new

gcloud services enable container.googleapis.com \
    cloudbuild.googleapis.com \
    sourcerepo.googleapis.com

sleep 20


export PROJECT_ID=$(gcloud config get-value project)
gcloud projects add-iam-policy-binding $PROJECT_ID \
--member=serviceAccount:$(gcloud projects describe $PROJECT_ID \
--format="value(projectNumber)")@cloudbuild.gserviceaccount.com --role="roles/container.developer"

# Lab has changed and is requesting to create the repo in GH 
curl -sS https://webi.sh/gh | sh
gh auth login
gh api user -q ".login"
GITHUB_USERNAME=$(gh api user -q ".login")
git config --global user.name "${GITHUB_USERNAME}"
git config --global user.email "${USER_EMAIL}"
echo ${GITHUB_USERNAME}
echo ${USER_EMAIL}

export REPO=my-repository
export PROJECT_ID=$PROJECT_ID
export ZONE=us-west1-c # make sure to udpate the zone if needed
export REGION="${ZONE%-*}" 
export CLUSTER_NAME=hello-cluster

gcloud beta container clusters create "$CLUSTER_NAME" --zone "$ZONE" --cluster-version latest --release-channel "regular" --enable-autoscaling --min-nodes 2 --max-nodes 6 --num-nodes 3 

# Function to check if a namespace exists
namespace_exists() {
    local namespace="$1"
    kubectl get namespace "$namespace" &> /dev/null
}

# Create production namespace if it doesn't exist
if ! namespace_exists "prod"; then
    echo "Creating 'prod' namespace..."
    kubectl create namespace prod
else
    echo "'prod' namespace already exists."
fi

# Sleep for 10 seconds
sleep 10

# Create development namespace if it doesn't exist
if ! namespace_exists "dev"; then
    echo "Creating 'dev' namespace..."
    kubectl create namespace dev
else
    echo "'dev' namespace already exists."
fi

# Sleep for 10 seconds
sleep 10

export GH_REPO=sample-app

gh repo create $GH_REPO --private 
cd ~
mkdir $GH_REPO
gsutil cp -r gs://spls/gsp330/sample-app/* $GH_REPO

cd $GH_REPO

## You have to run this command as well because lab is updated 

for file in cloudbuild-dev.yaml cloudbuild.yaml; do
    sed -i "s/<your-region>/${REGION}/g" "$file"
    sed -i "s/<your-zone>/${ZONE}/g" "$file"
done

echo "# sample-app" >> README.md

git init
git config credential.helper gcloud.sh
git remote add google https://github.com/${GITHUB_USERNAME}/${GH_REPO}
git branch -m master
git add . && git commit -m "initial commit"

git checkout -b dev
git push -u origin dev


#TASK 3
export SERVICE_ACCOUNT=$(gcloud projects describe $PROJECT_ID \
--format="value(projectNumber)")-compute@developer.gserviceaccount.com
# Use GH and default SA
gcloud builds triggers create github \
    --name="sample-app-prod-deploy" \
    --service-account="$SERVICE_ACCOUNT" \
    --description="Cloud Build Trigger for production deployment" \
    --repo="sample-app" \
    --branch-pattern="^master$" \
    --build-config="cloudbuild.yaml"



gcloud builds triggers create github \
    --name="sample-app-dev-deploy" \
    --service-account="$SERVICE_ACCOUNT" \
    --description="Cloud Build Trigger for development deployment" \
    --repo="sample-app" \
    --branch-pattern="^dev$" \
    --build-config="cloudbuild-dev.yaml"





#TASK 4:-

COMMIT_ID="$(git rev-parse --short=7 HEAD)"
gcloud builds submit --tag="${REGION}-docker.pkg.dev/${PROJECT_ID}/$REPO/hello-cloudbuild:${COMMIT_ID}" .

# Capture the IMAGES value into a variable
EXPORTED_IMAGE="$(gcloud builds submit --tag="${REGION}-docker.pkg.dev/${PROJECT_ID}/$REPO/hello-cloudbuild:${COMMIT_ID}" . | grep IMAGES | awk '{print $2}')"

# Print the value of the variable
echo "EXPORTED_IMAGE: ${EXPORTED_IMAGE}"

git checkout dev

for file in cloudbuild-dev.yaml; do
    sed -i "s/<your-region>/${REGION}/g" "$file"
    sed -i "s/<your-zone>/${ZONE}/g" "$file"
    sed -i "s/<version>/v1.0/g" "$file"
done

sed -i "s#<todo>#$EXPORTED_IMAGE#g" dev/deployment.yaml


git add .
git commit -m "dev: add v1.0 to dev env" 
git push -u origin dev

sleep 10

kubectl expose deployment development-deployment -n dev --name=dev-deployment-service --type=LoadBalancer --port 8080 --target-port 8080


git checkout master

sed -i "s/<your-region>/${REGION}/g" "cloudbuild.yaml"
sed -i "s/<your-zone>/${ZONE}/g" "cloudbuild.yaml"
sed -i "s/<version>/v1.0/g" cloudbuild.yaml

sed -i "s#<todo>#$EXPORTED_IMAGE#g" prod/deployment.yaml

git add .
git commit -m "prod: add version 1"
git push

sleep 10

kubectl expose deployment production-deployment -n prod --name=prod-deployment-service --type=LoadBalancer --port 8080 --target-port 8080


#TASK 5:

git checkout dev



sed -i '28a\	http.HandleFunc("/red", redHandler)' main.go


sed -i '32a\
func redHandler(w http.ResponseWriter, r *http.Request) { \
	img := image.NewRGBA(image.Rect(0, 0, 100, 100)) \
	draw.Draw(img, img.Bounds(), &image.Uniform{color.RGBA{255, 0, 0, 255}}, image.ZP, draw.Src) \
	w.Header().Set("Content-Type", "image/png") \
	png.Encode(w, img) \
}' main.go



sed -i "s/v1.0/v2.0/g" cloudbuild-dev.yaml
sed -i "17c\        image: $REGION-docker.pkg.dev/$PROJECT_ID/my-repository/hello-cloudbuild:v2.0" dev/deployment.yaml


git add .
git commit -m "dev: add version 2"
git push -u origin dev

sleep 10


git checkout master


sed -i '28a\	http.HandleFunc("/red", redHandler)' main.go


sed -i '32a\
func redHandler(w http.ResponseWriter, r *http.Request) { \
	img := image.NewRGBA(image.Rect(0, 0, 100, 100)) \
	draw.Draw(img, img.Bounds(), &image.Uniform{color.RGBA{255, 0, 0, 255}}, image.ZP, draw.Src) \
	w.Header().Set("Content-Type", "image/png") \
	png.Encode(w, img) \
}' main.go


sed -i "s/v1.0/v2.0/g" "$file" cloudbuild.yaml

sed -i "17c\        image: $REGION-docker.pkg.dev/$PROJECT_ID/my-repository/hello-cloudbuild:v2.0" prod/deployment.yaml


git add .
git commit -m "prod: add version 2"
git push

# Undo the deployment rollout fro both prod and dev 
# OR do it manualluy in the build trigger by rebuilding the previous version in both deployments (v1.0)
kubectl -n dev rollout undo deployment/production-deployment 
kubectl -n prod rollout undo deployment/development-deployment

sleep 10
kubectl -n dev rollout status deployment/production-deployment
kubectl rollout status deployment/production-deployment -n prod

