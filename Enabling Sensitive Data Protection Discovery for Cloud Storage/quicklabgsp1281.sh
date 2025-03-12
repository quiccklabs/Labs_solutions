


export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")

PROJECT_ID=`gcloud config get-value project`




#!/bin/bash

# Get the current project ID
PROJECT_ID=$(gcloud config get-value project)

# Step 1: Retrieve the Template ID (Auto-created profiler template)
TEMPLATE_ID=$(curl -s -X GET -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    "https://dlp.googleapis.com/v2/projects/$PROJECT_ID/locations/global/inspectTemplates" \
    | jq -r '.inspectTemplates[] | select(.displayName | startswith("Auto-created profiler template")) | .name' \
    | awk -F'/' '{print $NF}')

# Check if TEMPLATE_ID was found
if [ -z "$TEMPLATE_ID" ]; then
  echo "❌ No auto-created profiler template found!"
  exit 1
fi

echo "✅ Found Template ID: $TEMPLATE_ID"

# Step 2: Update the Inspection Template JSON
cat <<EOF > update_inspect_template.json
{
  "inspectTemplate": {
    "displayName": "Inspection Template for US SSN",
    "description": "This template was created as part of a Sensitive Data Protection profiler configuration and was modified for deeper inspection for US Social Security numbers.",
    "inspectConfig": {
      "infoTypes": [
        {
          "name": "US_SOCIAL_SECURITY_NUMBER"
        }
      ],
      "minLikelihood": "UNLIKELY"
    }
  }
}
EOF

echo "✅ JSON for update created."

# Step 3: Update the Template Using API
curl -X PATCH -H "Authorization: Bearer $(gcloud auth print-access-token)" \
     -H "Content-Type: application/json" \
     -d @update_inspect_template.json \
     "https://dlp.googleapis.com/v2/projects/$PROJECT_ID/locations/global/inspectTemplates/$TEMPLATE_ID"

echo "✅ Template updated successfully!"

# Step 4: Verify the Update
echo "🔎 Verifying the update..."
curl -s -X GET -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    "https://dlp.googleapis.com/v2/projects/$PROJECT_ID/locations/global/inspectTemplates/$TEMPLATE_ID" \
    | jq '.inspectTemplate'

echo "🎯 Task Completed! Go back to the lab and click 'Check my progress'."



echo "✅ JSON for update created."


cat <<EOF > deidentify_template.json
{
  "deidentifyTemplate": {
    "deidentifyConfig": {
      "recordTransformations": {
        "fieldTransformations": [
          {
            "fields": [
              {
                "name": "ssn"
              },
              {
                "name": "email"
              }
            ],
            "primitiveTransformation": {
              "replaceConfig": {
                "newValue": {
                  "stringValue": "[redacted]"
                }
              }
            }
          },
          {
            "fields": [
              {
                "name": "message"
              }
            ],
            "infoTypeTransformations": {
              "transformations": [
                {
                  "primitiveTransformation": {
                    "replaceWithInfoTypeConfig": {}
                  }
                }
              ]
            }
          }
        ]
      }
    },
    "displayName": "De-identification Template for US SSN"
  },
  "locationId": "global",
  "templateId": "us_ssn_deidentify"
}
EOF

echo "✅ Template updated successfully!"
echo "🔎 Verifying the update..."

curl -X POST -H "Authorization: Bearer $(gcloud auth print-access-token)" \
     -H "Content-Type: application/json" \
     -d @deidentify_template.json \
     "https://dlp.googleapis.com/v2/projects/$PROJECT_ID/locations/global/deidentifyTemplates"


echo "🎯 Task Completed! Go back to the lab and click 'Check my progress'."



echo "✅ JSON for update created."

cat <<EOF > job-configuration.json
{
  "jobId": "us_ssn_inspection",
  "inspectJob": {
    "actions": [
      {
        "saveFindings": {
          "outputConfig": {
            "table": {
              "projectId": "$DEVSHELL_PROJECT_ID",
              "datasetId": "cloudstorage_inspection",
              "tableId": "us_ssn"
            }
          }
        }
      },
      {
        "publishSummaryToCscc": {}
      }
    ],
    "inspectConfig": {
      "infoTypes": [
        {
          "name": "ADVERTISING_ID"
        },
        {
          "name": "AGE"
        },
        {
          "name": "ARGENTINA_DNI_NUMBER"
        },
        {
          "name": "AUSTRALIA_TAX_FILE_NUMBER"
        },
        {
          "name": "BELGIUM_NATIONAL_ID_CARD_NUMBER"
        },
        {
          "name": "BRAZIL_CPF_NUMBER"
        },
        {
          "name": "CANADA_SOCIAL_INSURANCE_NUMBER"
        },
        {
          "name": "CHILE_CDI_NUMBER"
        },
        {
          "name": "CHINA_RESIDENT_ID_NUMBER"
        },
        {
          "name": "COLOMBIA_CDC_NUMBER"
        },
        {
          "name": "CREDIT_CARD_NUMBER"
        },
        {
          "name": "CREDIT_CARD_TRACK_NUMBER"
        },
        {
          "name": "DATE_OF_BIRTH"
        },
        {
          "name": "DENMARK_CPR_NUMBER"
        },
        {
          "name": "EMAIL_ADDRESS"
        },
        {
          "name": "ETHNIC_GROUP"
        },
        {
          "name": "FDA_CODE"
        },
        {
          "name": "FINLAND_NATIONAL_ID_NUMBER"
        },
        {
          "name": "FRANCE_CNI"
        },
        {
          "name": "FRANCE_NIR"
        },
        {
          "name": "FRANCE_TAX_IDENTIFICATION_NUMBER"
        },
        {
          "name": "GENDER"
        },
        {
          "name": "GERMANY_IDENTITY_CARD_NUMBER"
        },
        {
          "name": "GERMANY_TAXPAYER_IDENTIFICATION_NUMBER"
        },
        {
          "name": "HONG_KONG_ID_NUMBER"
        },
        {
          "name": "IBAN_CODE"
        },
        {
          "name": "IMEI_HARDWARE_ID"
        },
        {
          "name": "INDIA_AADHAAR_INDIVIDUAL"
        },
        {
          "name": "INDIA_GST_INDIVIDUAL"
        },
        {
          "name": "INDIA_PAN_INDIVIDUAL"
        },
        {
          "name": "INDONESIA_NIK_NUMBER"
        },
        {
          "name": "IRELAND_PPSN"
        },
        {
          "name": "ISRAEL_IDENTITY_CARD_NUMBER"
        },
        {
          "name": "JAPAN_INDIVIDUAL_NUMBER"
        },
        {
          "name": "KOREA_RRN"
        },
        {
          "name": "MAC_ADDRESS"
        },
        {
          "name": "MEXICO_CURP_NUMBER"
        },
        {
          "name": "NETHERLANDS_BSN_NUMBER"
        },
        {
          "name": "NORWAY_NI_NUMBER"
        },
        {
          "name": "PARAGUAY_CIC_NUMBER"
        },
        {
          "name": "PASSPORT"
        },
        {
          "name": "PERSON_NAME"
        },
        {
          "name": "PERU_DNI_NUMBER"
        },
        {
          "name": "PHONE_NUMBER"
        },
        {
          "name": "POLAND_NATIONAL_ID_NUMBER"
        },
        {
          "name": "PORTUGAL_CDC_NUMBER"
        },
        {
          "name": "SCOTLAND_COMMUNITY_HEALTH_INDEX_NUMBER"
        },
        {
          "name": "SINGAPORE_NATIONAL_REGISTRATION_ID_NUMBER"
        },
        {
          "name": "SPAIN_CIF_NUMBER"
        },
        {
          "name": "SPAIN_DNI_NUMBER"
        },
        {
          "name": "SPAIN_NIE_NUMBER"
        },
        {
          "name": "SPAIN_NIF_NUMBER"
        },
        {
          "name": "SPAIN_SOCIAL_SECURITY_NUMBER"
        },
        {
          "name": "STORAGE_SIGNED_URL"
        },
        {
          "name": "STREET_ADDRESS"
        },
        {
          "name": "SWEDEN_NATIONAL_ID_NUMBER"
        },
        {
          "name": "SWIFT_CODE"
        },
        {
          "name": "THAILAND_NATIONAL_ID_NUMBER"
        },
        {
          "name": "TURKEY_ID_NUMBER"
        },
        {
          "name": "UK_NATIONAL_HEALTH_SERVICE_NUMBER"
        },
        {
          "name": "UK_NATIONAL_INSURANCE_NUMBER"
        },
        {
          "name": "UK_TAXPAYER_REFERENCE"
        },
        {
          "name": "URUGUAY_CDI_NUMBER"
        },
        {
          "name": "US_BANK_ROUTING_MICR"
        },
        {
          "name": "US_EMPLOYER_IDENTIFICATION_NUMBER"
        },
        {
          "name": "US_HEALTHCARE_NPI"
        },
        {
          "name": "US_INDIVIDUAL_TAXPAYER_IDENTIFICATION_NUMBER"
        },
        {
          "name": "US_SOCIAL_SECURITY_NUMBER"
        },
        {
          "name": "VEHICLE_IDENTIFICATION_NUMBER"
        },
        {
          "name": "VENEZUELA_CDI_NUMBER"
        },
        {
          "name": "WEAK_PASSWORD_HASH"
        },
        {
          "name": "AUTH_TOKEN"
        },
        {
          "name": "AWS_CREDENTIALS"
        },
        {
          "name": "AZURE_AUTH_TOKEN"
        },
        {
          "name": "BASIC_AUTH_HEADER"
        },
        {
          "name": "ENCRYPTION_KEY"
        },
        {
          "name": "GCP_API_KEY"
        },
        {
          "name": "GCP_CREDENTIALS"
        },
        {
          "name": "JSON_WEB_TOKEN"
        },
        {
          "name": "HTTP_COOKIE"
        },
        {
          "name": "XSRF_TOKEN"
        }
      ],
      "minLikelihood": "POSSIBLE"
    },
    "inspectTemplateName": "$TEMPLATE_ID",
    "storageConfig": {
      "cloudStorageOptions": {
        "filesLimitPercent": 100,
        "fileTypes": [
          "TEXT_FILE",
          "CSV"
        ],
        "fileSet": {
          "url": "gs://$DEVSHELL_PROJECT_ID-input/**"
        }
      }
    }
  }
}
EOF

echo "✅ Template updated successfully!"
echo "🔎 Verifying the update..."


curl -s \
  -X POST \
  -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
  -H "Content-Type: application/json" \
  "https://dlp.googleapis.com/v2/projects/$PROJECT_ID/dlpJobs" \
  -d @job-configuration.json

echo "🎯 Task Completed! Go back to the lab and click 'Check my progress'."

echo "✅ JSON for update created."

cat <<EOF > job-configuration.json 
{
  "jobId": "us_ssn_deidentify",
  "inspectJob": {
    "actions": [
      {
        "deidentify": {
          "fileTypesToTransform": [
            "TEXT_FILE",
            "CSV"
          ],
          "transformationDetailsStorageConfig": {
            "table": {
              "projectId": "$PROJECT_ID",
              "datasetId": "cloudstorage_transformations",
              "tableId": "deidentify_ssn_csv"
            }
          },
          "transformationConfig": {
            "structuredDeidentifyTemplate": "projects/$PROJECT_ID/locations/global/deidentifyTemplates/us_ssn_deidentify"
          },
          "cloudStorageOutput": "gs://$PROJECT_ID-output"
        }
      }
    ],
    "inspectConfig": {
      "infoTypes": [
        {
          "name": "ADVERTISING_ID"
        },
        {
          "name": "AGE"
        },
        {
          "name": "ARGENTINA_DNI_NUMBER"
        },
        {
          "name": "AUSTRALIA_TAX_FILE_NUMBER"
        },
        {
          "name": "BELGIUM_NATIONAL_ID_CARD_NUMBER"
        },
        {
          "name": "BRAZIL_CPF_NUMBER"
        },
        {
          "name": "CANADA_SOCIAL_INSURANCE_NUMBER"
        },
        {
          "name": "CHILE_CDI_NUMBER"
        },
        {
          "name": "CHINA_RESIDENT_ID_NUMBER"
        },
        {
          "name": "COLOMBIA_CDC_NUMBER"
        },
        {
          "name": "CREDIT_CARD_NUMBER"
        },
        {
          "name": "CREDIT_CARD_TRACK_NUMBER"
        },
        {
          "name": "DATE_OF_BIRTH"
        },
        {
          "name": "DENMARK_CPR_NUMBER"
        },
        {
          "name": "EMAIL_ADDRESS"
        },
        {
          "name": "ETHNIC_GROUP"
        },
        {
          "name": "FDA_CODE"
        },
        {
          "name": "FINLAND_NATIONAL_ID_NUMBER"
        },
        {
          "name": "FRANCE_CNI"
        },
        {
          "name": "FRANCE_NIR"
        },
        {
          "name": "FRANCE_TAX_IDENTIFICATION_NUMBER"
        },
        {
          "name": "GENDER"
        },
        {
          "name": "GERMANY_IDENTITY_CARD_NUMBER"
        },
        {
          "name": "GERMANY_TAXPAYER_IDENTIFICATION_NUMBER"
        },
        {
          "name": "HONG_KONG_ID_NUMBER"
        },
        {
          "name": "IBAN_CODE"
        },
        {
          "name": "IMEI_HARDWARE_ID"
        },
        {
          "name": "INDIA_AADHAAR_INDIVIDUAL"
        },
        {
          "name": "INDIA_GST_INDIVIDUAL"
        },
        {
          "name": "INDIA_PAN_INDIVIDUAL"
        },
        {
          "name": "INDONESIA_NIK_NUMBER"
        },
        {
          "name": "IRELAND_PPSN"
        },
        {
          "name": "ISRAEL_IDENTITY_CARD_NUMBER"
        },
        {
          "name": "JAPAN_INDIVIDUAL_NUMBER"
        },
        {
          "name": "KOREA_RRN"
        },
        {
          "name": "MAC_ADDRESS"
        },
        {
          "name": "MEXICO_CURP_NUMBER"
        },
        {
          "name": "NETHERLANDS_BSN_NUMBER"
        },
        {
          "name": "NORWAY_NI_NUMBER"
        },
        {
          "name": "PARAGUAY_CIC_NUMBER"
        },
        {
          "name": "PASSPORT"
        },
        {
          "name": "PERSON_NAME"
        },
        {
          "name": "PERU_DNI_NUMBER"
        },
        {
          "name": "PHONE_NUMBER"
        },
        {
          "name": "POLAND_NATIONAL_ID_NUMBER"
        },
        {
          "name": "PORTUGAL_CDC_NUMBER"
        },
        {
          "name": "SCOTLAND_COMMUNITY_HEALTH_INDEX_NUMBER"
        },
        {
          "name": "SINGAPORE_NATIONAL_REGISTRATION_ID_NUMBER"
        },
        {
          "name": "SPAIN_CIF_NUMBER"
        },
        {
          "name": "SPAIN_DNI_NUMBER"
        },
        {
          "name": "SPAIN_NIE_NUMBER"
        },
        {
          "name": "SPAIN_NIF_NUMBER"
        },
        {
          "name": "SPAIN_SOCIAL_SECURITY_NUMBER"
        },
        {
          "name": "STORAGE_SIGNED_URL"
        },
        {
          "name": "STREET_ADDRESS"
        },
        {
          "name": "SWEDEN_NATIONAL_ID_NUMBER"
        },
        {
          "name": "SWIFT_CODE"
        },
        {
          "name": "THAILAND_NATIONAL_ID_NUMBER"
        },
        {
          "name": "TURKEY_ID_NUMBER"
        },
        {
          "name": "UK_NATIONAL_HEALTH_SERVICE_NUMBER"
        },
        {
          "name": "UK_NATIONAL_INSURANCE_NUMBER"
        },
        {
          "name": "UK_TAXPAYER_REFERENCE"
        },
        {
          "name": "URUGUAY_CDI_NUMBER"
        },
        {
          "name": "US_BANK_ROUTING_MICR"
        },
        {
          "name": "US_EMPLOYER_IDENTIFICATION_NUMBER"
        },
        {
          "name": "US_HEALTHCARE_NPI"
        },
        {
          "name": "US_INDIVIDUAL_TAXPAYER_IDENTIFICATION_NUMBER"
        },
        {
          "name": "US_SOCIAL_SECURITY_NUMBER"
        },
        {
          "name": "VEHICLE_IDENTIFICATION_NUMBER"
        },
        {
          "name": "VENEZUELA_CDI_NUMBER"
        },
        {
          "name": "WEAK_PASSWORD_HASH"
        },
        {
          "name": "AUTH_TOKEN"
        },
        {
          "name": "AWS_CREDENTIALS"
        },
        {
          "name": "AZURE_AUTH_TOKEN"
        },
        {
          "name": "BASIC_AUTH_HEADER"
        },
        {
          "name": "ENCRYPTION_KEY"
        },
        {
          "name": "GCP_API_KEY"
        },
        {
          "name": "GCP_CREDENTIALS"
        },
        {
          "name": "JSON_WEB_TOKEN"
        },
        {
          "name": "HTTP_COOKIE"
        },
        {
          "name": "XSRF_TOKEN"
        }
      ],
      "minLikelihood": "POSSIBLE"
    },
    "storageConfig": {
      "cloudStorageOptions": {
        "filesLimitPercent": 100,
        "fileTypes": [
          "TEXT_FILE",
          "CSV"
        ],
        "fileSet": {
          "regexFileSet": {
            "bucketName": "$PROJECT_ID-input",
            "includeRegex": [],
            "excludeRegex": [
              "ignore"
            ]
          }
        }
      }
    }
  }
}
EOF

echo "✅ Template updated successfully!"
echo "🔎 Verifying the update..."


curl -s \
  -X POST \
  -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
  -H "Content-Type: application/json" \
  "https://dlp.googleapis.com/v2/projects/$PROJECT_ID/dlpJobs" \
  -d @job-configuration.json


echo "🎯 Task Completed! Go back to the lab and click 'Check my progress'."



TEMPLATE_ID=$(curl -s -X GET -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    "https://dlp.googleapis.com/v2/projects/$PROJECT_ID/locations/global/inspectTemplates" \
    | jq -r '.inspectTemplates[] | select(.displayName=="Inspection Template for US SSN") | .name')

echo "✅ Full TEMPLATE_ID: $TEMPLATE_ID"


cat <<EOF > job-configuration.json
{
  "jobId": "us_ssn_inspection",
  "inspectJob": {
    "inspectTemplateName": "$TEMPLATE_ID",
    "storageConfig": {
      "cloudStorageOptions": {
        "fileSet": {
          "url": "gs://$DEVSHELL_PROJECT_ID-input/**"
        }
      }
    },
    "actions": [
      {
        "saveFindings": {
          "outputConfig": {
            "table": {
              "projectId": "$DEVSHELL_PROJECT_ID",
              "datasetId": "cloudstorage_inspection",
              "tableId": "us_ssn"
            }
          }
        }
      },
      {
        "publishSummaryToCscc": {}
      }
    ]
  }
}
EOF


curl -s \
  -X POST \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type: application/json" \
  "https://dlp.googleapis.com/v2/projects/$PROJECT_ID/dlpJobs" \
  -d @job-configuration.json


  echo "🎯 Task Completed! Go back to the lab and click 'Check my progress'."
