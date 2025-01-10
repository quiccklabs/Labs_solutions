

bq mk --connection \
  --connection_type=CLOUD_RESOURCE \
  --location=US \
  gemini_conn


SERVICE_ACCOUNT=$(bq show --location=US --connection gemini_conn | grep "serviceAccountId" | awk -F'"' '{print $4}')

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member="serviceAccount:${SERVICE_ACCOUNT}" \
  --role="roles/aiplatform.user"



gcloud storage buckets add-iam-policy-binding gs://$DEVSHELL_PROJECT_ID-bucket \
  --member="serviceAccount:${SERVICE_ACCOUNT}" \
  --role="roles/storage.objectAdmin"

bq --location=US mk gemini_demo




bq query --use_legacy_sql=false \
"
CREATE SCHEMA IF NOT EXISTS \`$DEVSHELL_PROJECT_ID.gemini_demo\`
OPTIONS(location='US');
"



bq query --use_legacy_sql=false \
"
LOAD DATA OVERWRITE gemini_demo.customer_reviews
(customer_review_id INT64, customer_id INT64, location_id INT64, review_datetime DATETIME, review_text STRING, social_media_source STRING, social_media_handle STRING)
FROM FILES (
  format = 'CSV',
  uris = ['gs://$DEVSHELL_PROJECT_ID-bucket/gsp1249/customer_reviews.csv']);
"


bq query --use_legacy_sql=false \
"
SELECT * FROM \`gemini_demo.customer_reviews\`
ORDER BY review_datetime
"


bq query --use_legacy_sql=false \
"
CREATE OR REPLACE MODEL \`gemini_demo.gemini_pro\`
REMOTE WITH CONNECTION \`us.gemini_conn\`
OPTIONS (endpoint = 'gemini-pro')
"

#####

bq query --use_legacy_sql=false \
"
CREATE OR REPLACE MODEL \`gemini_demo.gemini_pro_vision\`
REMOTE WITH CONNECTION \`us.gemini_conn\`
OPTIONS (endpoint = 'gemini-pro-vision')
"



bq query --use_legacy_sql=false "
CREATE OR REPLACE TABLE
\`gemini_demo.customer_reviews_analysis\` AS (
  SELECT 
    ml_generate_text_llm_result, 
    social_media_source, 
    review_text, 
    customer_id, 
    location_id, 
    review_datetime
  FROM
    ML.GENERATE_TEXT(
      MODEL \`gemini_demo.gemini_pro\`,
      (
        SELECT 
          social_media_source, 
          customer_id, 
          location_id, 
          review_text, 
          review_datetime, 
          CONCAT(
            'Classify the sentiment of the following text as positive or negative: ',
            review_text, 
            '. In your response, don\'t include the sentiment explanation. Remove all extraneous information from your response; it should be a boolean response either positive or negative.'
          ) AS prompt
        FROM 
          \`gemini_demo.customer_reviews\`
      ),
      STRUCT(
        0.2 AS temperature, 
        TRUE AS flatten_json_output
      )
    )
);
"



bq query --use_legacy_sql=false \
"
SELECT * FROM \`gemini_demo.customer_reviews_analysis\`
ORDER BY review_datetime
"




bq query --use_legacy_sql=false \
"
CREATE OR REPLACE VIEW gemini_demo.cleaned_data_view AS
SELECT REPLACE(REPLACE(LOWER(ml_generate_text_llm_result), '.', ''), ' ', '') AS sentiment,
REGEXP_REPLACE(
      REGEXP_REPLACE(
            REGEXP_REPLACE(social_media_source, r'Google(\+|\sReviews|\sLocal|\sMy\sBusiness|\sreviews|\sMaps)?', 'Google'),
            'YELP', 'Yelp'
      ),
      r'SocialMedia1?', 'Social Media'
   ) AS social_media_source,
review_text, customer_id, location_id, review_datetime
FROM \`gemini_demo.customer_reviews_analysis\`;
"


bq query --use_legacy_sql=false \
"
CREATE OR REPLACE TABLE
\`gemini_demo.customer_reviews_keywords\` AS (
SELECT ml_generate_text_llm_result, social_media_source, review_text, customer_id, location_id, review_datetime
FROM
ML.GENERATE_TEXT(
MODEL \`gemini_demo.gemini_pro\`,
(
   SELECT social_media_source, customer_id, location_id, review_text, review_datetime, CONCAT(
      'For each review, provide keywords from the review. Answer in JSON format with one key: keywords. Keywords should be a list.',
      review_text) AS prompt
   FROM \`gemini_demo.customer_reviews\`
),
STRUCT(
   0.2 AS temperature, TRUE AS flatten_json_output)));
"


bq query --use_legacy_sql=false \
"
SELECT * FROM \`gemini_demo.customer_reviews_keywords\`
"


bq query --use_legacy_sql=false "
CREATE OR REPLACE TABLE \`gemini_demo.customer_reviews_analysis\` AS (
  SELECT 
    ml_generate_text_llm_result, 
    social_media_source, 
    review_text, 
    customer_id, 
    location_id, 
    review_datetime
  FROM
    ML.GENERATE_TEXT(
      MODEL \`gemini_demo.gemini_pro\`,
      (
        SELECT 
          social_media_source, 
          customer_id, 
          location_id, 
          review_text, 
          review_datetime, 
          CONCAT(
            'Classify the sentiment of the following text as positive or negative.',
            review_text, 
            'In your response don\'t include the sentiment explanation. Remove all extraneous information from your response, it should be a boolean response either positive or negative.'
          ) AS prompt
        FROM \`gemini_demo.customer_reviews\`
      ),
      STRUCT(
        0.2 AS temperature, 
        TRUE AS flatten_json_output
      )
    )
);
"



bq query --use_legacy_sql=false \
"
SELECT * FROM \`gemini_demo.customer_reviews_analysis\`
ORDER BY review_datetime
"


bq query --use_legacy_sql=false \
"
CREATE OR REPLACE VIEW gemini_demo.cleaned_data_view AS
SELECT REPLACE(REPLACE(LOWER(ml_generate_text_llm_result), '.', ''), ' ', '') AS sentiment, 
REGEXP_REPLACE(
      REGEXP_REPLACE(
            REGEXP_REPLACE(social_media_source, r'Google(\+|\sReviews|\sLocal|\sMy\sBusiness|\sreviews|\sMaps)?', 'Google'), 
            'YELP', 'Yelp'
      ),
      r'SocialMedia1?', 'Social Media'
   ) AS social_media_source,
review_text, customer_id, location_id, review_datetime
FROM \`gemini_demo.customer_reviews_analysis\`;
"


bq query --use_legacy_sql=false \
"
SELECT * FROM \`gemini_demo.cleaned_data_view\`
ORDER BY review_datetime
"


bq query --use_legacy_sql=false \
"
SELECT sentiment, COUNT(*) AS count
FROM \`gemini_demo.cleaned_data_view\`
WHERE sentiment IN ('positive', 'negative')
GROUP BY sentiment; 
"

bq query --use_legacy_sql=false \
"
CREATE OR REPLACE MODEL \`gemini_demo.gemini_pro\`
REMOTE WITH CONNECTION \`us.gemini_conn\`
OPTIONS (endpoint = 'gemini-pro')
"

#####

bq query --use_legacy_sql=false \
"
CREATE OR REPLACE MODEL \`gemini_demo.gemini_pro_vision\`
REMOTE WITH CONNECTION \`us.gemini_conn\`
OPTIONS (endpoint = 'gemini-pro-vision')
"



bq query --use_legacy_sql=false "
CREATE OR REPLACE TABLE
\`gemini_demo.customer_reviews_analysis\` AS (
  SELECT 
    ml_generate_text_llm_result, 
    social_media_source, 
    review_text, 
    customer_id, 
    location_id, 
    review_datetime
  FROM
    ML.GENERATE_TEXT(
      MODEL \`gemini_demo.gemini_pro\`,
      (
        SELECT 
          social_media_source, 
          customer_id, 
          location_id, 
          review_text, 
          review_datetime, 
          CONCAT(
            'Classify the sentiment of the following text as positive or negative: ',
            review_text, 
            '. In your response, don\'t include the sentiment explanation. Remove all extraneous information from your response; it should be a boolean response either positive or negative.'
          ) AS prompt
        FROM 
          \`gemini_demo.customer_reviews\`
      ),
      STRUCT(
        0.2 AS temperature, 
        TRUE AS flatten_json_output
      )
    )
);
"



bq query --use_legacy_sql=false \
"
SELECT * FROM \`gemini_demo.customer_reviews_analysis\`
ORDER BY review_datetime
"




bq query --use_legacy_sql=false \
"
CREATE OR REPLACE VIEW gemini_demo.cleaned_data_view AS
SELECT REPLACE(REPLACE(LOWER(ml_generate_text_llm_result), '.', ''), ' ', '') AS sentiment,
REGEXP_REPLACE(
      REGEXP_REPLACE(
            REGEXP_REPLACE(social_media_source, r'Google(\+|\sReviews|\sLocal|\sMy\sBusiness|\sreviews|\sMaps)?', 'Google'),
            'YELP', 'Yelp'
      ),
      r'SocialMedia1?', 'Social Media'
   ) AS social_media_source,
review_text, customer_id, location_id, review_datetime
FROM \`gemini_demo.customer_reviews_analysis\`;
"


bq query --use_legacy_sql=false \
"
CREATE OR REPLACE TABLE
\`gemini_demo.customer_reviews_keywords\` AS (
SELECT ml_generate_text_llm_result, social_media_source, review_text, customer_id, location_id, review_datetime
FROM
ML.GENERATE_TEXT(
MODEL \`gemini_demo.gemini_pro\`,
(
   SELECT social_media_source, customer_id, location_id, review_text, review_datetime, CONCAT(
      'For each review, provide keywords from the review. Answer in JSON format with one key: keywords. Keywords should be a list.',
      review_text) AS prompt
   FROM \`gemini_demo.customer_reviews\`
),
STRUCT(
   0.2 AS temperature, TRUE AS flatten_json_output)));
"


bq query --use_legacy_sql=false \
"
SELECT * FROM \`gemini_demo.customer_reviews_keywords\`
"


bq query --use_legacy_sql=false "
CREATE OR REPLACE TABLE \`gemini_demo.customer_reviews_analysis\` AS (
  SELECT 
    ml_generate_text_llm_result, 
    social_media_source, 
    review_text, 
    customer_id, 
    location_id, 
    review_datetime
  FROM
    ML.GENERATE_TEXT(
      MODEL \`gemini_demo.gemini_pro\`,
      (
        SELECT 
          social_media_source, 
          customer_id, 
          location_id, 
          review_text, 
          review_datetime, 
          CONCAT(
            'Classify the sentiment of the following text as positive or negative.',
            review_text, 
            'In your response don\'t include the sentiment explanation. Remove all extraneous information from your response, it should be a boolean response either positive or negative.'
          ) AS prompt
        FROM \`gemini_demo.customer_reviews\`
      ),
      STRUCT(
        0.2 AS temperature, 
        TRUE AS flatten_json_output
      )
    )
);
"



bq query --use_legacy_sql=false \
"
SELECT * FROM \`gemini_demo.customer_reviews_analysis\`
ORDER BY review_datetime
"


bq query --use_legacy_sql=false \
"
CREATE OR REPLACE VIEW gemini_demo.cleaned_data_view AS
SELECT REPLACE(REPLACE(LOWER(ml_generate_text_llm_result), '.', ''), ' ', '') AS sentiment, 
REGEXP_REPLACE(
      REGEXP_REPLACE(
            REGEXP_REPLACE(social_media_source, r'Google(\+|\sReviews|\sLocal|\sMy\sBusiness|\sreviews|\sMaps)?', 'Google'), 
            'YELP', 'Yelp'
      ),
      r'SocialMedia1?', 'Social Media'
   ) AS social_media_source,
review_text, customer_id, location_id, review_datetime
FROM \`gemini_demo.customer_reviews_analysis\`;
"


bq query --use_legacy_sql=false \
"
SELECT * FROM \`gemini_demo.cleaned_data_view\`
ORDER BY review_datetime
"


bq query --use_legacy_sql=false \
"
SELECT sentiment, COUNT(*) AS count
FROM \`gemini_demo.cleaned_data_view\`
WHERE sentiment IN ('positive', 'negative')
GROUP BY sentiment; 
"

bq query --use_legacy_sql=false \
"
CREATE OR REPLACE MODEL \`gemini_demo.gemini_pro\`
REMOTE WITH CONNECTION \`us.gemini_conn\`
OPTIONS (endpoint = 'gemini-pro')
"

#####

bq query --use_legacy_sql=false \
"
CREATE OR REPLACE MODEL \`gemini_demo.gemini_pro_vision\`
REMOTE WITH CONNECTION \`us.gemini_conn\`
OPTIONS (endpoint = 'gemini-pro-vision')
"



bq query --use_legacy_sql=false "
CREATE OR REPLACE TABLE
\`gemini_demo.customer_reviews_analysis\` AS (
  SELECT 
    ml_generate_text_llm_result, 
    social_media_source, 
    review_text, 
    customer_id, 
    location_id, 
    review_datetime
  FROM
    ML.GENERATE_TEXT(
      MODEL \`gemini_demo.gemini_pro\`,
      (
        SELECT 
          social_media_source, 
          customer_id, 
          location_id, 
          review_text, 
          review_datetime, 
          CONCAT(
            'Classify the sentiment of the following text as positive or negative: ',
            review_text, 
            '. In your response, don\'t include the sentiment explanation. Remove all extraneous information from your response; it should be a boolean response either positive or negative.'
          ) AS prompt
        FROM 
          \`gemini_demo.customer_reviews\`
      ),
      STRUCT(
        0.2 AS temperature, 
        TRUE AS flatten_json_output
      )
    )
);
"



bq query --use_legacy_sql=false \
"
SELECT * FROM \`gemini_demo.customer_reviews_analysis\`
ORDER BY review_datetime
"




bq query --use_legacy_sql=false \
"
CREATE OR REPLACE VIEW gemini_demo.cleaned_data_view AS
SELECT REPLACE(REPLACE(LOWER(ml_generate_text_llm_result), '.', ''), ' ', '') AS sentiment,
REGEXP_REPLACE(
      REGEXP_REPLACE(
            REGEXP_REPLACE(social_media_source, r'Google(\+|\sReviews|\sLocal|\sMy\sBusiness|\sreviews|\sMaps)?', 'Google'),
            'YELP', 'Yelp'
      ),
      r'SocialMedia1?', 'Social Media'
   ) AS social_media_source,
review_text, customer_id, location_id, review_datetime
FROM \`gemini_demo.customer_reviews_analysis\`;
"


bq query --use_legacy_sql=false \
"
CREATE OR REPLACE TABLE
\`gemini_demo.customer_reviews_keywords\` AS (
SELECT ml_generate_text_llm_result, social_media_source, review_text, customer_id, location_id, review_datetime
FROM
ML.GENERATE_TEXT(
MODEL \`gemini_demo.gemini_pro\`,
(
   SELECT social_media_source, customer_id, location_id, review_text, review_datetime, CONCAT(
      'For each review, provide keywords from the review. Answer in JSON format with one key: keywords. Keywords should be a list.',
      review_text) AS prompt
   FROM \`gemini_demo.customer_reviews\`
),
STRUCT(
   0.2 AS temperature, TRUE AS flatten_json_output)));
"


bq query --use_legacy_sql=false \
"
SELECT * FROM \`gemini_demo.customer_reviews_keywords\`
"


bq query --use_legacy_sql=false "
CREATE OR REPLACE TABLE \`gemini_demo.customer_reviews_analysis\` AS (
  SELECT 
    ml_generate_text_llm_result, 
    social_media_source, 
    review_text, 
    customer_id, 
    location_id, 
    review_datetime
  FROM
    ML.GENERATE_TEXT(
      MODEL \`gemini_demo.gemini_pro\`,
      (
        SELECT 
          social_media_source, 
          customer_id, 
          location_id, 
          review_text, 
          review_datetime, 
          CONCAT(
            'Classify the sentiment of the following text as positive or negative.',
            review_text, 
            'In your response don\'t include the sentiment explanation. Remove all extraneous information from your response, it should be a boolean response either positive or negative.'
          ) AS prompt
        FROM \`gemini_demo.customer_reviews\`
      ),
      STRUCT(
        0.2 AS temperature, 
        TRUE AS flatten_json_output
      )
    )
);
"



bq query --use_legacy_sql=false \
"
SELECT * FROM \`gemini_demo.customer_reviews_analysis\`
ORDER BY review_datetime
"


bq query --use_legacy_sql=false \
"
CREATE OR REPLACE VIEW gemini_demo.cleaned_data_view AS
SELECT REPLACE(REPLACE(LOWER(ml_generate_text_llm_result), '.', ''), ' ', '') AS sentiment, 
REGEXP_REPLACE(
      REGEXP_REPLACE(
            REGEXP_REPLACE(social_media_source, r'Google(\+|\sReviews|\sLocal|\sMy\sBusiness|\sreviews|\sMaps)?', 'Google'), 
            'YELP', 'Yelp'
      ),
      r'SocialMedia1?', 'Social Media'
   ) AS social_media_source,
review_text, customer_id, location_id, review_datetime
FROM \`gemini_demo.customer_reviews_analysis\`;
"


bq query --use_legacy_sql=false \
"
SELECT * FROM \`gemini_demo.cleaned_data_view\`
ORDER BY review_datetime
"


bq query --use_legacy_sql=false \
"
SELECT sentiment, COUNT(*) AS count
FROM \`gemini_demo.cleaned_data_view\`
WHERE sentiment IN ('positive', 'negative')
GROUP BY sentiment; 
"

####





