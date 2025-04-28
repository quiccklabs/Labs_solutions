echo ""
echo ""

read -p "Export USERNAME 2 :- " USERNAME_2

echo ${USERNAME_2}

PROJECT_ID=`gcloud config get-value project`

export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")



cat <<EOF > deidentify-template.json
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
    "displayName": "De-identify Credit Card Numbers"
  },
  "locationId": "global",
  "templateId": "us_ccn_deidentify"
}
EOF


curl -X POST -s \
-H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
-H "Content-Type: application/json" \
-d @deidentify-template.json \
"https://dlp.googleapis.com/v2/projects/$DEVSHELL_PROJECT_ID/locations/global/deidentifyTemplates"


export TEMPLATE_ID=$(curl -s \
--request GET \
--url "https://dlp.googleapis.com/v2/projects/$DEVSHELL_PROJECT_ID/locations/global/deidentifyTemplates/us_ccn_deidentify" \
--header "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
--header "Content-Type: application/json" \
| jq -r '.name')



cat > job-configuration.json << EOM
{
  "jobId": "us_ccn_deidentify",
  "inspectJob": {
    "actions": [
      {
        "deidentify": {
          "fileTypesToTransform": [
            "TEXT_FILE",
            "IMAGE",
            "CSV",
            "TSV"
          ],
          "transformationDetailsStorageConfig": {
            "table": {
              "projectId": "$DEVSHELL_PROJECT_ID",
              "datasetId": "cs_transformations",
              "tableId": "deidentify_ccn"
            }
          },
          "transformationConfig": {
            "structuredDeidentifyTemplate": "$TEMPLATE_ID"
          },
          "cloudStorageOutput": "gs://$DEVSHELL_PROJECT_ID-car-owners-transformed"
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
          "IMAGE",
          "WORD",
          "PDF",
          "AVRO",
          "CSV",
          "TSV",
          "EXCEL",
          "POWERPOINT"
        ],
        "fileSet": {
          "url": "gs://$DEVSHELL_PROJECT_ID-car-owners/**"
        }
      }
    }
  }
}
EOM

sleep 15


curl -s \
  -X POST \
  -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
  -H "Content-Type: application/json" \
  "https://dlp.googleapis.com/v2/projects/$DEVSHELL_PROJECT_ID/dlpJobs" \
  -d @job-configuration.json


gcloud resource-manager tags keys create SPII \
    --parent=projects/$PROJECT_NUMBER \
    --description="Flag for sensitive personally identifiable information (SPII)"


TAG_KEY_ID=$(gcloud resource-manager tags keys list --parent="projects/${PROJECT_NUMBER}" --format="value(NAME)")



gcloud resource-manager tags values create Yes \
    --parent=$TAG_KEY_ID \
    --description="Contains sensitive personally identifiable information (SPII)"

gcloud resource-manager tags values create No \
    --parent=$TAG_KEY_ID \
    --description="Does not contain sensitive personally identifiable information (SPII)"




// gcloud projects get-iam-policy $DEVSHELL_PROJECT_ID --format=json > policy.json

export ETAG=$(gcloud projects get-iam-policy $DEVSHELL_PROJECT_ID --format="value(etag)")

cat > policy.json <<EOF_END
{
  "bindings": [
    {
      "members": [
        "serviceAccount:${PROJECT_ID}@${PROJECT_ID}.iam.gserviceaccount.com"
      ],
      "role": "roles/bigquery.admin"
    },
    {
      "members": [
        "serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com"
      ],
      "role": "roles/cloudbuild.builds.builder"
    },
    {
      "members": [
        "serviceAccount:service-${PROJECT_NUMBER}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
      ],
      "role": "roles/cloudbuild.serviceAgent"
    },
    {
      "members": [
        "serviceAccount:service-${PROJECT_NUMBER}@compute-system.iam.gserviceaccount.com"
      ],
      "role": "roles/compute.serviceAgent"
    },
    {
      "members": [
        "serviceAccount:service-${PROJECT_NUMBER}@container-engine-robot.iam.gserviceaccount.com"
      ],
      "role": "roles/container.serviceAgent"
    },
    {
      "members": [
        "serviceAccount:service-${PROJECT_NUMBER}@dlp-api.iam.gserviceaccount.com"
      ],
      "role": "roles/dlp.projectdriver"
    },
    {
      "members": [
        "serviceAccount:service-${PROJECT_NUMBER}@dlp-api.iam.gserviceaccount.com"
      ],
      "role": "roles/dlp.serviceAgent"
    },
    {
      "members": [
        "serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com",
        "serviceAccount:${PROJECT_NUMBER}@cloudservices.gserviceaccount.com"
      ],
      "role": "roles/editor"
    },
    {
      "members": [
        "serviceAccount:service-${PROJECT_NUMBER}@gcp-sa-notebooks.iam.gserviceaccount.com"
      ],
      "role": "roles/notebooks.serviceAgent"
    },
    {
      "members": [
        "serviceAccount:admiral@qwiklabs-services-prod.iam.gserviceaccount.com",
        "serviceAccount:${PROJECT_ID}@${PROJECT_ID}.iam.gserviceaccount.com",
        "user:${USER_EMAIL}"
      ],
      "role": "roles/owner"
    },
    {
      "members": [
        "serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com",
        "serviceAccount:service-${PROJECT_NUMBER}@dlp-api.iam.gserviceaccount.com"
      ],
      "role": "roles/storage.admin"
    },
    {
      "members": [
        "user:${USER_EMAIL}"
      ],
      "role": "roles/viewer"
    },
    {
      "members": [
        "user:${USERNAME_2}"
      ],
      "role": "roles/browser",
      "condition": {
        "title": "No SPII Access Only",
        "description": "Access only to BigQuery datasets tagged as SPII=No",
        "expression": "resource.matchTag('${PROJECT_ID}/SPII', 'No')"
      }
    },
    {
      "members": [
        "user:${USERNAME_2}"
      ],
      "role": "roles/bigquery.dataViewer",
      "condition": {
        "title": "No SPII Access Only",
        "description": "Access only to BigQuery datasets tagged as SPII=No",
        "expression": "resource.matchTag('${PROJECT_ID}/SPII', 'No')"
      }
    }
  ],
  "etag": "${ETAG}",
  "version": 1
}
EOF_END



gcloud projects set-iam-policy $DEVSHELL_PROJECT_ID policy.json

