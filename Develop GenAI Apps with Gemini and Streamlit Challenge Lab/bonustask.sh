
cd generative-ai/gemini/sample-apps/gemini-streamlit-cloudrun
pip install google-cloud-aiplatform

streamlit run chef.py \
  --browser.serverAddress=localhost \
  --server.enableCORS=false \
  --server.enableXsrfProtection=false \
  --server.port 8080
