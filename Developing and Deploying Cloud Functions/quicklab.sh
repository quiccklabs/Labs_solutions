


PROJECT_ID=$(gcloud config get-value project)

gcloud services enable \
  artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  storage.googleapis.com \
  pubsub.googleapis.com

sleep 60

mkdir ~/quicklab && cd $_

cat > index.js <<'EOF_END'
const functions = require('@google-cloud/functions-framework');

functions.http('convertTemp', (req, res) => {
 var dirn = req.query.convert;
 var ctemp = (req.query.temp - 32) * 5/9;
 var target_unit = 'Celsius';

 if (req.query.temp === undefined) {
    res.status(400);
    res.send('Temperature value not supplied in request.');
 }
 if (dirn === undefined)
   dirn = process.env.TEMP_CONVERT_TO;
 if (dirn === 'ctof') {
   ctemp = (req.query.temp * 9/5) + 32;
   target_unit = 'Fahrenheit';
 }

 res.send(`Temperature in ${target_unit} is: ${ctemp.toFixed(2)}.`);
});
EOF_END

cat > package.json <<'EOF_END'
{
  "dependencies": {
    "@google-cloud/functions-framework": "^3.0.0"
  }
}
EOF_END

# Function to check if the function exists
function function_exists() {
  gcloud functions describe temperature-converter --region $REGION --format="value(state)" > /dev/null 2>&1
}

# Function to check if the function is active
function check_function_active() {
  gcloud functions describe temperature-converter --region $REGION --format="value(state)" | grep "ACTIVE" > /dev/null
}

# Function to check if the function failed
function check_function_failed() {
  gcloud functions describe temperature-converter --region $REGION --format="value(state)" | grep "FAILED" > /dev/null
}

# Function to deploy the function
function deploy_function() {
  gcloud functions deploy temperature-converter \
    --gen2 \
    --runtime nodejs20 \
    --entry-point convertTemp \
    --source . \
    --region $REGION \
    --trigger-http \
    --timeout 600s \
    --max-instances 1 \
    --no-allow-unauthenticated \
    --quiet || { echo "Function deployment failed. Exiting."; exit 1; }
}

# Function to delete the function
function delete_function() {
  gcloud functions delete temperature-converter --region $REGION --quiet || { echo "Function deletion failed. Exiting."; exit 1; }
}

# Check if the function exists and is active
if ! function_exists; then
  echo "Function does not exist. Creating..."
  deploy_function
  # Wait for the function to become active or fail
  while ! check_function_active && ! check_function_failed; do
    echo "Function not yet active or failed. Rechecking in 10 seconds..."
    sleep 10
  done
  if check_function_failed; then
    echo "Function deployment failed. Retrying..."
    delete_function
    deploy_function
  fi
elif ! check_function_active; then
  echo "Function not in ACTIVE status. Deleting and recreating..."
  delete_function
  deploy_function
  # Wait for the function to become active or fail
  while ! check_function_active && ! check_function_failed; do
    echo "Function not yet active or failed. Rechecking in 10 seconds..."
    sleep 10
  done
  if check_function_failed; then
    echo "Function deployment failed. Exiting."
    exit 1
  fi
else
  echo "Function is already running and active. Continuing..."
fi

# Function is now active, proceed with next command
echo "Function is active. Proceeding with next command."



sleep 10

FUNCTION_URI=$(gcloud functions describe temperature-converter --gen2 --region $REGION --format "value(serviceConfig.uri)"); echo $FUNCTION_URI

curl -H "Authorization: bearer $(gcloud auth print-identity-token)" "${FUNCTION_URI}?temp=70"

curl -H "Authorization: bearer $(gcloud auth print-identity-token)" "${FUNCTION_URI}?temp=21.11&convert=ctof"


PROJECT_NUMBER=$(gcloud projects list \
    --filter="project_id:$PROJECT_ID" \
    --format='value(project_number)')



#TASK 3


SERVICE_ACCOUNT=$(gsutil kms serviceaccount -p $PROJECT_NUMBER)

gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SERVICE_ACCOUNT --role roles/pubsub.publisher

gsutil cp gs://cloud-training/CBL491/data/average-temps.csv .

mkdir ~/temp-data-checker && cd $_

touch index.js && touch package.json


cat > index.js <<'EOF_END'
const functions = require('@google-cloud/functions-framework');

// Register a CloudEvent callback with the Functions Framework that will
// be triggered by Cloud Storage events.
functions.cloudEvent('checkTempData', cloudEvent => {
  console.log(`Event ID: ${cloudEvent.id}`);
  console.log(`Event Type: ${cloudEvent.type}`);

  const file = cloudEvent.data;
  console.log(`Bucket: ${file.bucket}`);
  console.log(`File: ${file.name}`);
  console.log(`Created: ${file.timeCreated}`);
});
EOF_END



cat > package.json <<'EOF_END'
{
    "name": "temperature-data-checker",
    "version": "0.0.1",
    "main": "index.js",
    "dependencies": {
      "@google-cloud/functions-framework": "^2.1.0"
    }
  }
EOF_END

BUCKET="gs://gcf-temperature-data-$PROJECT_ID"


gsutil mb -l $REGION $BUCKET

# Function to check if the function exists
function function_exists() {
  gcloud functions describe temperature-data-checker --region $REGION > /dev/null 2>&1
}

# Function to deploy the function
function deploy_function() {
  gcloud functions deploy temperature-data-checker \
    --gen2 \
    --runtime nodejs16 \
    --entry-point checkTempData \
    --source . \
    --region $REGION \
    --trigger-bucket $BUCKET \
    --trigger-location $REGION \
    --max-instances 1 \
    --quiet
}

# Loop until the function exists
while ! function_exists; do
  echo "Function not found. Deploying..."
  echo "Meantime Subscribe to Quicklab [https://www.youtube.com/@quick_lab].."

  deploy_function
  sleep 10  # You can adjust the sleep duration as needed
done

# Continue with the next code after the function is created
echo "Function created. Continuing with the next code."
# Add your next code here

sleep 10

cd ~
gsutil cp gs://cloud-training/CBL491/data/average-temps.csv .
gsutil cp ~/average-temps.csv $BUCKET/average-temps.csv

 gcloud functions logs read temperature-data-checker \
 --region $REGION --gen2 --limit=100 --format "value(log)"


 #TASK 4

 mkdir ~/temp-data-converter && cd $_

cat > index.js <<'EOF_END'
const functions = require('@google-cloud/functions-framework');

functions.http('convertTemp', (req, res) => {
 var dirn = req.query.convert;
 var ctemp = (req.query.temp - 32) * 5/9;
 var target_unit = 'Celsius';

 if (req.query.temp === undefined) {
    res.status(400);
    res.send('Temperature value not supplied in request.');
 }
 if (dirn === undefined)
   dirn = process.env.TEMP_CONVERT_TO;
 if (dirn === 'ctof') {
   ctemp = (req.query.temp * 9/5) + 32;
   target_unit = 'Fahrenheit';
 }

 res.send(`Temperature in ${target_unit} is: ${ctemp.toFixed(2)}.`);
});
EOF_END
 
 
cat > package.json <<'EOF_END'
 {
    "name": "temperature-converter",
    "version": "0.0.1",
    "main": "index.js",
    "scripts": {
      "unit-test": "mocha tests/unit*test.js --timeout=6000 --exit",
      "test": "npm -- run unit-test"
    },
    "devDependencies": {
      "mocha": "^9.0.0",
      "sinon": "^14.0.0"
    },
    "dependencies": {
      "@google-cloud/functions-framework": "^2.1.0"
    }
  }

EOF_END
 

mkdir tests && touch tests/unit.http.test.js


cat > tests/unit.http.test.js <<'EOF_END'
const {getFunction} = require('@google-cloud/functions-framework/testing');

describe('functions_convert_temperature_http', () => {
  // Sinon is a testing framework that is used to create mocks for Node.js applications written in Express.
  // Express is Node.js web application framework used to implement HTTP functions.
  const sinon = require('sinon');
  const assert = require('assert');
  require('../');

  const getMocks = () => {
    const req = {body: {}, query: {}};

    return {
      req: req,
      res: {
        send: sinon.stub().returnsThis(),
        status: sinon.stub().returnsThis()
      },
    };
  };

  let envOrig;
  before(() => {
    envOrig = JSON.stringify(process.env);
  });

  after(() => {
    process.env = JSON.parse(envOrig);
  });

  it('convertTemp: should convert a Fahrenheit temp value by default', () => {
    const mocks = getMocks();
    mocks.req.query = {temp: 70};

    const convertTemp = getFunction('convertTemp');
    convertTemp(mocks.req, mocks.res);
    assert.strictEqual(mocks.res.send.calledOnceWith('Temperature in Celsius is: 21.11.'), true);
  });

  it('convertTemp: should convert a Celsius temp value', () => {
    const mocks = getMocks();
    mocks.req.query = {temp: 21.11, convert: 'ctof'};

    const convertTemp = getFunction('convertTemp');
    convertTemp(mocks.req, mocks.res);
    assert.strictEqual(mocks.res.send.calledOnceWith('Temperature in Fahrenheit is: 70.00.'), true);
  });

  it('convertTemp: should convert a Celsius temp value by default', () => {
    process.env.TEMP_CONVERT_TO = 'ctof';
    const mocks = getMocks();
    mocks.req.query = {temp: 21.11};

    const convertTemp = getFunction('convertTemp');
    convertTemp(mocks.req, mocks.res);
    assert.strictEqual(mocks.res.send.calledOnceWith('Temperature in Fahrenheit is: 70.00.'), true);
  });

  it('convertTemp: should return an error message', () => {
    const mocks = getMocks();

    const convertTemp = getFunction('convertTemp');
    convertTemp(mocks.req, mocks.res);

    assert.strictEqual(mocks.res.status.calledOnce, true);
    assert.strictEqual(mocks.res.status.firstCall.args[0], 400);
  });
});
EOF_END


cat > package.json <<'EOF_END'
{
  "name": "temperature-converter",
  "version": "0.0.1",
  "main": "index.js",
  "scripts": {
    "unit-test": "mocha tests/unit*test.js --timeout=6000 --exit",
    "test": "npm -- run unit-test"
  },
  "devDependencies": {
    "mocha": "^9.0.0",
    "sinon": "^14.0.0"
  },
  "dependencies": {
    "@google-cloud/functions-framework": "^2.1.0"
  }
}
EOF_END



npm install

npm test


gcloud run deploy temperature-converter \
--image=$REGION-docker.pkg.dev/$PROJECT_ID/gcf-artifacts/temperature--converter:version_1 \
--set-env-vars=TEMP_CONVERT_TO=ctof \
--region=$REGION \
--project=$PROJECT_ID \
 && gcloud run services update-traffic temperature-converter --to-latest --region=$REGION
