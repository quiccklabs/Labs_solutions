echo ""
echo ""

# STEP 1: Set region
read -p "Export REGION :- " REGION

# STEP 2: Create working directory
mkdir ~/hello-go && cd ~/hello-go

# STEP 3: Create main.go file
cat > main.go <<EOF_END
package function

import (
    "fmt"
    "net/http"
)

// HelloGo is the entry point
func HelloGo(w http.ResponseWriter, r *http.Request) {
    fmt.Fprint(w, "Hello from Cloud Functions (Go 2nd Gen)!")
}
EOF_END

# STEP 4: Create go.mod file
cat > go.mod <<EOF_END
module example.com/hellogo

go 1.21
EOF_END

# STEP 5: Deploy the Go-based Cloud Function
gcloud functions deploy cf-go \
  --gen2 \
  --runtime=go121 \
  --region=$REGION \
  --trigger-http \
  --allow-unauthenticated \
  --entry-point=HelloGo \
  --source=. \
  --min-instances=5



echo "n" | gcloud functions deploy cf-pubsub \
  --gen2 \
  --region=$REGION \
  --runtime=go121 \
  --trigger-topic=cf-pubsub \
  --min-instances=5 \
  --entry-point=helloWorld \
  --source=. \
  --allow-unauthenticated

