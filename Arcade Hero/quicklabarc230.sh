gcloud config set compute/region $REGION
export PROJECT_ID=$(gcloud config get-value project)


mkdir quicklab && cd quicklab


cat > function.go <<'EOF_END'
package helloworld

import (
  "encoding/json"
  "fmt"
  "html"
  "net/http"

  "github.com/GoogleCloudPlatform/functions-framework-go/functions"
)

func init() {
   functions.HTTP("HelloHTTP", helloHTTP)
}

// helloHTTP is an HTTP Cloud Function with a request parameter.
func helloHTTP(w http.ResponseWriter, r *http.Request) {
  var d struct {
    Name string `json:"name"`
  }
  if err := json.NewDecoder(r.Body).Decode(&d); err != nil {
    fmt.Fprint(w, "Hello, World!")
    return
  }
  if d.Name == "" {
    fmt.Fprint(w, "Hello, World!")
    return
  }
  fmt.Fprintf(w, "Hello, %s!", html.EscapeString(d.Name))
}

EOF_END


cat > go.mod <<EOF_END
module example.com/gcf

require (
  github.com/GoogleCloudPlatform/functions-framework-go v1.5.2
)
EOF_END

sleep 30

gcloud functions deploy cf-demo \
  --gen2 \
  --runtime go122 \
  --entry-point HelloHTTP \
  --source . \
  --region $REGION \
  --trigger-http \
  --allow-unauthenticated \
  --quiet


gcloud functions deploy cf-demo \
  --gen2 \
  --runtime go122 \
  --entry-point HelloHTTP \
  --source . \
  --region $REGION \
  --trigger-http \
  --allow-unauthenticated \
  --quiet
