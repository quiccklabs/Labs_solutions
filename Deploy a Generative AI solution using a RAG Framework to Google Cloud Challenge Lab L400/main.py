import os
import yaml
import logging
import google.cloud.logging
from flask import Flask, render_template, request

import firebase_admin
from firebase_admin import firestore

import vertexai
from vertexai.generative_models import GenerativeModel
from vertexai.language_models import TextEmbeddingInput, TextEmbeddingModel
from google.cloud import aiplatform

# Configure Cloud Logging
logging_client = google.cloud.logging.Client()
logging_client.setup_logging()
logging.basicConfig(level=logging.INFO)

# Instantiating the Firebase client
firebase_app = firebase_admin.initialize_app()
db = firestore.client()

# Instantiate an embedding model here
embedding_model = None

# Instantiate a Generative AI model here
gen_model = None

# Instantiate the index endpoint here
index_endpoint = None


# Helper function that reads from the config file.
def get_config_value(config, section, key, default=None):
    """
    Retrieve a configuration value from a section with an optional default value.
    """
    try:
        return config[section][key]
    except:
        return default


# Open the config file (config.yaml)
with open("config.yaml") as f:
    config = yaml.safe_load(f)

# Read application variables from the config fle
TITLE = get_config_value(config, "app", "title", "Ask Google")
SUBTITLE = get_config_value(config, "app", "subtitle", "Your friendly Bot")
CONTEXT = get_config_value(
    config, "gemini", "context", "You are a bot who can answer all sorts of questions"
)
BOTNAME = get_config_value(config, "gemini", "botname", "Google")

app = Flask(__name__)


# The Home page route
@app.route("/", methods=["POST", "GET"])
def main():

    # The user clicked on a link to the Home page
    # They haven't yet submitted the form
    if request.method == "GET":
        question = ""
        answer = "Hi, I'm FreshBot. What are your food safety questions?"

    # The user asked a question and submitted the form
    # The request.method would equal 'POST'
    else:
        question = request.form["input"]
        # Do not delete this logging statement.
        logging.info(
            question,
            extra={"labels": {"service": "cymbal-service", "component": "question"}},
        )

        # Get the data to answer the question that
        # most likely matches the question based on the embeddings
        data = search_vector_database(question)

        # Ask Gemini to answer the question using the data
        # from the database
        answer = ask_gemini(question, data)

    # Do not delete this logging statement.
    logging.info(
        answer, extra={"labels": {"service": "cymbal-service", "component": "answer"}}
    )
    print("Answer: " + answer)

    # Display the home page with the required variables set
    model = {
        "title": TITLE,
        "subtitle": SUBTITLE,
        "botname": BOTNAME,
        "message": answer,
        "input": question,
    }

    return render_template("index.html", model=model)


def search_vector_database(question):

  model = TextEmbeddingModel.from_pretrained("text-embedding-004")
  embeddings = model.get_embeddings([question])
  for embedding in embeddings:
    vector = embedding.values
  return vector
    
PROJECT_ID = os.getenv("project_id")
LOCATION = os.getenv("lab_region")


# Initialization
from google.cloud import aiplatform
aiplatform.init(project=PROJECT_ID, location=LOCATION)

from vertexai.language_models import TextEmbeddingInput

QUESTION = "What is the minimum safe cooking temperature for chicken?"
question_with_task_type  = TextEmbeddingInput(
    text=QUESTION,
    task_type="RETRIEVAL_QUERY"
)

my_index_endpoint = aiplatform.MatchingEngineIndexEndpoint(

# YOu need to supply the full name of your endopoint
# Get this from the Google Cloud console.
index_endpoint_name="2534484253186457600"
    )

QUESTION_EMBEDDING = search_vector_database(question_with_task_type)

# run query
response = my_index_endpoint.find_neighbors(
    deployed_index_id = "assessment_index_deployed",
    queries = [QUESTION_EMBEDDING],
    num_neighbors = 5
)


for idx, neighbor in enumerate(response[0]):
    print(f"{neighbor.distance:.2f} {neighbor.id}")

DOCUMENT_URL = "fpc-manual.pdf"

from langchain_community.document_loaders import PyPDFLoader

pdf = PyPDFLoader(DOCUMENT_URL)
pages = pdf.load_and_split()
pages = [page.page_content for page in pages]

ids = [i for i in range(len(pages))]

from google.cloud import firestore
db = firestore.Client()

collection_name = "pdf_pages"

documents = []
for idx, neighbor in enumerate(response[0]):
  id = str(neighbor.id)
  document = db.collection(collection_name).document(id).get()
  documents.append(document.to_dict()["page"])

pages = "\n\n".join(documents)

print(len(pages))

import vertexai
from vertexai.preview.generative_models import GenerativeModel, Part


def ask_gemini(question, data):
  """
  This function builds a prompt with the user question and data,
  then sends it to Gemini to get the answer.

  Args:
      question: The user's question as a string.
      data: The retrieved data from Firestore as a dictionary.

  Returns:
      The generated answer from Gemini as a string.
  """

  model = GenerativeModel("gemini-1.5-flash-001")
  prompt = f"""
  context: Answer the question using the following data.

  Data: {pages}

  question: {question}
  answer:
  """

  response = model.generate_content(
      prompt,
      generation_config={
          "max_output_tokens": 8192,
          "temperature": 0.5,
          "top_p": 0.5,
          "top_k": 10,
      },
      stream=False
  )
  return response.text

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
