gsutil cp gs://cloud-training/gsp925/*.ipynb .
python -m pip install --upgrade google-cloud-core google-cloud-documentai google-cloud-storage prettytable --user
gsutil cp gs://cloud-training/gsp925/health-intake-form.pdf form.pdf

export PROJECT_ID="$(gcloud config get-value core/project)"
export BUCKET="${PROJECT_ID}"_doc_ai_async
gsutil mb gs://${BUCKET}
gsutil -m cp gs://cloud-training/gsp925/async/*.* gs://${BUCKET}/input
