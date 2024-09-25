


ID="$(gcloud projects list --format='value(PROJECT_ID)')"


cat > SendChatwithoutStream.py <<EOF
import vertexai
from vertexai.generative_models import GenerativeModel, ChatSession

import logging
from google.cloud import logging as gcp_logging

# ------  Below cloud logging code is for Qwiklab's internal use, do not edit/remove it. --------
# Initialize GCP logging
gcp_logging_client = gcp_logging.Client()
gcp_logging_client.setup_logging()

project_id = "$ID"
location = "$REGION"

vertexai.init(project=project_id, location=location)
model = GenerativeModel("gemini-1.0-pro")
chat = model.start_chat()

def get_chat_response(chat: ChatSession, prompt: str) -> str:
    logging.info(f'Sending prompt: {prompt}')
    response = chat.send_message(prompt)
    logging.info(f'Received response: {response.text}')
    return response.text

prompt = "Hello."
print(get_chat_response(chat, prompt))

prompt = "What are all the colors in a rainbow?"
print(get_chat_response(chat, prompt))

prompt = "Why does it appear when it rains?"
print(get_chat_response(chat, prompt))

EOF

/usr/bin/python3 /home/student/SendChatwithoutStream.py

cat > SendChatwithStream.py <<EOF
import vertexai
from vertexai.generative_models import GenerativeModel, ChatSession

import logging
from google.cloud import logging as gcp_logging

# ------  Below cloud logging code is for Qwiklab's internal use, do not edit/remove it. --------
# Initialize GCP logging
gcp_logging_client = gcp_logging.Client()
gcp_logging_client.setup_logging()

project_id = "$ID"
location = "$REGION"

vertexai.init(project=project_id, location=location)
model = GenerativeModel("gemini-1.0-pro")
chat = model.start_chat()

def get_chat_response(chat: ChatSession, prompt: str) -> str:
    text_response = []
    logging.info(f'Sending prompt: {prompt}')
    responses = chat.send_message(prompt, stream=True)
    for chunk in responses:
        text_response.append(chunk.text)
    return "".join(text_response)
    logging.info(f'Received response: {response.text}')

prompt = "Hello."
print(get_chat_response(chat, prompt))

prompt = "What are all the colors in a rainbow?"
print(get_chat_response(chat, prompt))

prompt = "Why does it appear when it rains?"
print(get_chat_response(chat, prompt))

EOF


/usr/bin/python3 /home/student/SendChatwithStream.py
