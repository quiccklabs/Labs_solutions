

gcloud auth list

gcloud services enable cloudfunctions.googleapis.com

sleep 20

git clone --depth=1 https://github.com/GoogleCloudPlatform/training-data-analyst

ln -s ~/training-data-analyst/courses/developingapps/v1.3/nodejs/cloudfunctions ~/cloudfunctions

cd ~/cloudfunctions/start

. prepare_environment.sh


mkdir quicklab && cd quicklab



cat > index.js <<EOF_END
/**
 * Responds to any HTTP request.
 *
 * @param {!express:Request} req HTTP request context.
 * @param {!express:Response} res HTTP response context.
 */
exports.helloWorld = (req, res) => {
    let message = req.query.message || req.body.message || 'Hello World!';
    res.status(200).send(message);
  };
  
EOF_END

cat > package.json <<EOF_END
{
    "name": "sample-http",
    "version": "0.0.1"
  }
  
EOF_END



  gcloud functions deploy process-feedback \
    --runtime nodejs20 \
    --entry-point helloWorld \
    --source . \
    --trigger-topic feedback \
    --max-instances 1 \
    --no-allow-unauthenticated \
    --quiet 

cd ..

cd function

rm index.js

wget https://raw.githubusercontent.com/quiccklabs/Identify-Application-Vulnerabilities-with-Security-Command-Center/main/index.js

zip cf.zip *.js*

gcloud storage cp cf.zip gs://$GCLOUD_BUCKET/



gcloud functions deploy process-feedback \
    --runtime nodejs20 \
    --entry-point subscribe \
    --trigger-topic feedback \
    --max-instances 1 \
    --no-allow-unauthenticated \
    --source gs://$GCLOUD_BUCKET/cf.zip \
    --allow-unauthenticated
