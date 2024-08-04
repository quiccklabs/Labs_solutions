
gcloud config set compute/region $REGION
export PROJECT_ID=$(gcloud config get-value project)


mkdir quicklab && cd quicklab

cat > index.php <<'EOF_END'
<?php
use Google\CloudFunctions\FunctionsFramework;
use Psr\Http\Message\ServerRequestInterface;

// Register the function with Functions Framework.
// This enables omitting the `FUNCTIONS_SIGNATURE_TYPE=http` environment
// variable when deploying. The `FUNCTION_TARGET` environment variable should
// match the first parameter.
FunctionsFramework::http('helloHttp', 'helloHttp');

function helloHttp(ServerRequestInterface $request): string
{
  $name = 'World';
  $body = $request->getBody()->getContents();
  if (!empty($body)) {
    $json = json_decode($body, true);
    if (json_last_error() != JSON_ERROR_NONE) {
      throw new RuntimeException(sprintf(
        'Could not parse body: %s',
        json_last_error_msg()
      ));
    }
    $name = $json['name'] ?? $name;
  }
  $queryString = $request->getQueryParams();
  $name = $queryString['name'] ?? $name;

  return sprintf('Hello, %s!', htmlspecialchars($name));
}

EOF_END


cat > composer.json <<EOF_END
{
   "require": {
       "google/cloud-functions-framework": "^1.1"
   }
}

EOF_END

gcloud functions deploy cf-demo \
  --gen2 \
  --runtime php82 \
  --entry-point helloHttp \
  --source . \
  --region $REGION \
  --trigger-http \
  --allow-unauthenticated \
  --quiet
