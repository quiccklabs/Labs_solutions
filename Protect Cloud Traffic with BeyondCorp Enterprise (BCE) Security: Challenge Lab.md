

## Protect Cloud Traffic with BeyondCorp Enterprise (BCE) Security: Challenge Lab



```
export REGION=
```
```
gcloud auth list
git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git
cd python-docs-samples/appengine/standard_python3/hello_world/
gcloud app create --project=$(gcloud config get-value project) --region=$REGION
gcloud app deploy --quiet
export AUTH_DOMAIN=$(gcloud config get-value project).uc.r.appspot.com
echo $AUTH_DOMAIN
```

