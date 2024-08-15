from flask import Flask, render_template, request
import os
import yaml
import vertexai
from vertexai.language_models import TextGenerationModel

app = Flask(__name__)

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
with open('config.yaml') as f:
    config = yaml.safe_load(f)

# Read application variables from the config fle
TITLE = get_config_value(config, 'app', 'title', 'Ask Google')
SUBTITLE = get_config_value(config, 'app', 'subtitle', 'Your friendly Bot')
CONTEXT = get_config_value(config, 'palm', 'context',
                           'You are a bot who can answer all sorts of questions')
BOTNAME = get_config_value(config, 'palm', 'botname', 'Google')
TEMPERATURE = get_config_value(config, 'palm', 'temperature', 0.8)
MAX_OUTPUT_TOKENS = get_config_value(config, 'palm', 'max_output_tokens', 256)
TOP_P = get_config_value(config, 'palm', 'top_p', 0.8)
TOP_K = get_config_value(config, 'palm', 'top_k', 40)


# The Home page route
@app.route("/", methods=['POST', 'GET'])
def main():

    # The user clicked on a link to the Home page
    # They haven't yet submitted the form
    if request.method == 'GET':
        question = ""
        answer = "Hi, I'm FreshBot. How may I be of assistance to you?"

    # The user asked a question and submitted the form
    # The request.method would equal 'POST'
    else:
        question = request.form['input']

        # Get the data to answer the question that
        # most likely matches the question based on the embeddings
        data = search_vector_database(question)

        # Ask Gemini to answer the question using the data
        # from the database
        answer = ask_gemini(question, data)

    # Display the home page with the required variables set
    model = {"title": TITLE, "subtitle": SUBTITLE,
             "botname": BOTNAME, "message": answer, "input": question}
    return render_template('index.html', model=model)


from vertexai.language_models import TextEmbeddingModel

def search_vector_database(question) -> list:
  """Text embedding with a Large Language Model and prints the vector."""

  model = TextEmbeddingModel.from_pretrained("textembedding-gecko@002")
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
index_endpoint_name="projects/qwiklabs-gcp-00-05caff4e8963/locations/us-central1/indexEndpoints/545933911469850624"
    )

QUESTION_EMBEDDING = search_vector_database(question_with_task_type)

# run query
response = my_index_endpoint.find_neighbors(
    deployed_index_id = "assessment_index_deployed",
    queries = [QUESTION_EMBEDDING],
    num_neighbors = 5
)

# show the results
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

  model = GenerativeModel("gemini-pro")
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
