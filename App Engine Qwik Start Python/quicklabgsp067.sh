gcloud auth list
gcloud services enable appengine.googleapis.com

git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git

cd python-docs-samples/appengine/standard_python3/hello_world

sudo apt install python3 -y
sudo apt install python3.11-venv -y
python3 -m venv create myvenv
source myvenv/bin/activate


sed -i '32c\    return "Hello, Cruel World!"' main.py

sleep 30

gcloud app create --region=$REGION

gcloud app deploy --quiet
