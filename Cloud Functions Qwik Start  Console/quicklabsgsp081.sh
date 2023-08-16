


mkdir quicklab && cd quicklab

cat > index.js <<EOF_END
/**
 * Responds to any HTTP request.
 *
 * @param {!express:Request} req HTTP request context.
 * @param {!express:Response} res HTTP response context.
 */
exports.GCFunction = (req, res) => {
    let message = req.query.message || req.body.message || 'Subscribe to quicklab';
    res.status(200).send(message);
  };
  
EOF_END


cat > package.json <<EOF_END
{
    "name": "sample-http",
    "version": "0.0.1"
  }
  
EOF_END


gsutil mb -p $DEVSHELL_PROJECT_ID gs://$DEVSHELL_PROJECT_ID


gcloud functions deploy GCFunction \
  --region=$REGION \
  --trigger-http \
  --runtime=nodejs20 \
  --allow-unauthenticated \
  --max-instances=5




DATA=$(printf 'Subscribe to quicklab' | base64) && gcloud functions call GCFunction --region=$REGION --data '{"data":"'$DATA'"}'
