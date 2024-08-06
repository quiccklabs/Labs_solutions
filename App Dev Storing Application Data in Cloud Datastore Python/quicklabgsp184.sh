
gcloud auth list

virtualenv -p python3 vrenv

source vrenv/bin/activate

git clone https://github.com/GoogleCloudPlatform/training-data-analyst

cd ~/training-data-analyst/courses/developingapps/python/datastore/start

export GCLOUD_PROJECT=$DEVSHELL_PROJECT_ID

pip install -r requirements.txt

gcloud app create --region "$REGION"

cd quiz/gcp


cat > datastore.py <<EOF_END
# TODO: Import the os module

import os

# END TODO

# TODO: Get the GCLOUD_PROJECT environment variable

project_id = os.getenv('GCLOUD_PROJECT')

# END TODO

from flask import current_app

# TODO: Import the datastore module from the google.cloud package

from google.cloud import datastore

# END TODO

# TODO: Create a Cloud Datastore client object
# The datastore client object requires the Project ID.
# Pass through the Project ID you looked up from the
# environment variable earlier

datastore_client = datastore.Client(project_id)

# END TODO

"""
Create and persist and entity for each question
The Datastore key is the equivalent of a primary key in a relational database.
There are two main ways of writing a key:
1. Specify the kind, and let Datastore generate a unique numeric id
2. Specify the kind and a unique string id
"""
def save_question(question):
# TODO: Create a key for a Datastore entity
# whose kind is Question

    key = datastore_client.key('Question')

# END TODO

# TODO: Create a Datastore entity object using the key

    q_entity = datastore.Entity(key=key)

# END TODO

# TODO: Iterate over the form values supplied to the function

    for q_prop, q_val in question.items():

# END TODO

# TODO: Assign each key and value to the Datastore entity

        q_entity[q_prop] = q_val

# END TODO

# TODO: Save the entity

    datastore_client.put(q_entity)

# END TODO
EOF_END

cd ~/training-data-analyst/courses/developingapps/python/datastore/start


python run_server.py
