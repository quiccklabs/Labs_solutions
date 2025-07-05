

# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)


gcloud services enable artifactregistry.googleapis.com

gcloud config set project $PROJECT_ID

gcloud config set compute/region $REGION

gcloud artifacts repositories create my-python-repo \
    --repository-format=python \
    --location=$REGION \
    --description="Python package repository"


pip install keyrings.google-artifactregistry-auth

pip config set global.extra-index-url https://$REGION-python.pkg.dev/$PROJECT_ID/my-python-repo/simple

mkdir my-package
cd my-package


cat > setup.py <<EOF_END
from setuptools import setup, find_packages

setup(
    name='my_package',
    version='0.1.0',
    author='cls',
    author_email='$USER_EMAIL',
    packages=find_packages(exclude=['tests']),
    install_requires=[
        # List your dependencies here
    ],
    description='A sample Python package',
)
EOF_END

cat > my_module.py <<EOF_END
def hello_world():
    return 'Hello, world!'
EOF_END

pip install twine

python setup.py sdist bdist_wheel

python3 -m twine upload --repository-url https://$REGION-python.pkg.dev/$PROJECT_ID/my-python-repo/ dist/*
