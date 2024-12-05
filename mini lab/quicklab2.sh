

cat > lifecycle.json << EOF
{
    "rule": [
      {
        "action": {
          "storageClass": "NEARLINE",
          "type": "SetStorageClass"
        },
        "condition": {
          "daysSinceNoncurrentTime": 30,
          "matchesPrefix": [
            "/projects/active/"
          ]
        }
      },
      {
        "action": {
          "storageClass": "NEARLINE",
          "type": "SetStorageClass"
        },
        "condition": {
          "daysSinceNoncurrentTime": 90,
          "matchesPrefix": [
            "/archive/"
          ]
        }
      },
      {
        "action": {
          "storageClass": "COLDLINE",
          "type": "SetStorageClass"
        },
        "condition": {
          "daysSinceNoncurrentTime": 180,
          "matchesPrefix": [
            "/archive/"
          ]
        }
      },
      {
        "action": {
          "type": "Delete"
        },
        "condition": {
          "age": 7,
          "matchesPrefix": [
            "/processing/temp_logs/"
          ]
        }
      }
    ]
  }
EOF

export PROJECT_ID=$(gcloud config get-value project)

gsutil lifecycle set lifecycle.json gs://$PROJECT_ID-bucket
