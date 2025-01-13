

gcloud auth list

gcloud services enable run.googleapis.com

git clone https://github.com/GoogleCloudPlatform/generative-ai.git

cd generative-ai/gemini/sample-apps/gemini-streamlit-cloudrun

gsutil cp gs://spls/gsp517/chef.py .

rm -rf Dockerfile chef.py

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Develop%20GenAI%20Apps%20with%20Gemini%20and%20Streamlit%20Challenge%20Lab/Dockerfile.txt

wget https://raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Develop%20GenAI%20Apps%20with%20Gemini%20and%20Streamlit%20Challenge%20Lab/chef.py

mv Dockerfile.txt Dockerfile

gcloud storage cp chef.py gs://$DEVSHELL_PROJECT_ID-generative-ai/

export PROJECT="$DEVSHELL_PROJECT_ID"


python3 -m venv gemini-streamlit
source gemini-streamlit/bin/activate
python3 -m  pip install -r requirements.txt


streamlit run chef.py \
  --browser.serverAddress=localhost \
  --server.enableCORS=false \
  --server.enableXsrfProtection=false \
  --server.port 8080
