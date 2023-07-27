



gcloud services enable cloudprofiler.googleapis.com

mkdir gcp-logging

cd gcp-logging

git clone https://GitHub.com/GoogleCloudPlatform/training-data-analyst.git

cd training-data-analyst/courses/design-process/deploying-apps-to-gcp



cat > main.py <<EOF
from flask import Flask, render_template, request
import googlecloudprofiler

app = Flask(__name__)


@app.route("/")
def main():
    model = {"title": "SUBSCRIBE TO QUICKLAB."}
    return render_template('index.html', model=model)

try:
    googlecloudprofiler.start(verbose=3)
except (ValueError, NotImplementedError) as exc:
    print(exc)


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080, debug=True, threaded=True)

EOF



cat > requirements.txt <<EOF
Flask==2.0.3
itsdangerous==2.0.1
Jinja2==3.0.3
google-cloud-profiler==3.0.6
protobuf==3.20.1

EOF



docker build -t test-python .




cat > app.yaml <<EOF
runtime: python37
EOF


gcloud app create --region=$REGION

gcloud app deploy --version=one --quiet


gcloud compute instances create my-instance --zone=europe-west1-b



