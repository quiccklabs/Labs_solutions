

gcloud app create --project=$DEVSHELL_PROJECT_ID

git clone https://github.com/GoogleCloudPlatform/python-docs-samples

cd python-docs-samples/appengine/standard_python3/hello_world

cat > Dockerfile <<EOF_END
FROM python:3.8
WORKDIR /app
COPY . .
RUN pip install gunicorn
RUN pip install -r requirements.txt
ENV PORT=8080
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 main:app
EOF_END

docker build -t test-python .

gcloud app deploy --quiet