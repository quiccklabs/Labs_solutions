


gcloud services enable texttospeech.googleapis.com --project=$DEVSHELL_PROJECT_ID

sudo apt-get install -y virtualenv

python3 -m venv venv

source venv/bin/activate


gcloud iam service-accounts create tts-qwiklab

export PROJECT_ID=$(gcloud config get-value project)

gcloud iam service-accounts keys create tts-qwiklab.json --iam-account tts-qwiklab@$PROJECT_ID.iam.gserviceaccount.com

export GOOGLE_APPLICATION_CREDENTIALS=tts-qwiklab.json



