

bq mk \
  --connection \
  --location=US \
  --project_id=${DEVSHELL_PROJECT_ID} \
  --connection_type=CLOUD_RESOURCE \
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
LOAD DATA OVERWRITE gemini_demo.customer_reviews
(customer_review_id INT64, customer_id INT64, location_id INT64, review_datetime DATETIME, review_text STRING, social_media_source STRING, social_media_handle STRING)
FROM FILES (
  format = 'CSV',
  uris = ['gs://$DEVSHELL_PROJECT_ID-bucket/gsp1246/customer_reviews.csv']);
"


bq query --use_legacy_sql=false \
"
CREATE OR REPLACE EXTERNAL TABLE
  \`gemini_demo.review_images\`
WITH CONNECTION \`us.gemini_conn\`
OPTIONS (
  object_metadata = 'SIMPLE',
  uris = ['gs://$DEVSHELL_PROJECT_ID-bucket/gsp1246/images/*']
  );
"



bq query --use_legacy_sql=false \
"
CREATE OR REPLACE MODEL \`gemini_demo.gemini_pro\`
REMOTE WITH CONNECTION \`us.gemini_conn\`
OPTIONS (endpoint = 'gemini-pro')
"


bq query --use_legacy_sql=false \
"
CREATE OR REPLACE MODEL \`gemini_demo.gemini_pro_vision\`
REMOTE WITH CONNECTION \`us.gemini_conn\`
OPTIONS (endpoint = 'gemini-pro-vision')
"



bq query --use_legacy_sql=false \
"
CREATE OR REPLACE TABLE
\`gemini_demo.review_images_results\` AS (
SELECT
    uri,
    ml_generate_text_llm_result
FROM
    ML.GENERATE_TEXT( MODEL \`gemini_demo.gemini_pro_vision\`,
    TABLE \`gemini_demo.review_images\`,
    STRUCT( 0.2 AS temperature,
        'For each image, provide a summary of what is happening in the image and keywords from the summary. Answer in JSON format with two keys: summary, keywords. Summary should be a string, keywords should be a list.' AS PROMPT,
        TRUE AS FLATTEN_JSON_OUTPUT)));
"



bq query --use_legacy_sql=false \
"
SELECT * FROM \`gemini_demo.review_images_results\`
"


bq query --use_legacy_sql=false \
'
CREATE OR REPLACE TABLE
  `gemini_demo.review_images_results_formatted` AS (
  SELECT
    uri,
    JSON_QUERY(RTRIM(LTRIM(results.ml_generate_text_llm_result, " ```json"), "```"), "$.summary") AS summary,
    JSON_QUERY(RTRIM(LTRIM(results.ml_generate_text_llm_result, " ```json"), "```"), "$.keywords") AS keywords
  FROM
    `gemini_demo.review_images_results` results )
'


bq query --use_legacy_sql=false \
"
SELECT * FROM \`gemini_demo.review_images_results_formatted\`
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
SELECT sentiment, social_media_source, COUNT(*) AS count
FROM \`gemini_demo.cleaned_data_view\`
WHERE sentiment IN ('positive') OR sentiment IN ('negative')
GROUP BY sentiment, social_media_source
ORDER BY sentiment, count;    
"


bq query --use_legacy_sql=false \
"
CREATE OR REPLACE TABLE
\`gemini_demo.customer_reviews_marketing\` AS (
SELECT ml_generate_text_llm_result, social_media_source, review_text, customer_id, location_id, review_datetime
FROM
ML.GENERATE_TEXT(
MODEL \`gemini_demo.gemini_pro\`,
(
   SELECT social_media_source, customer_id, location_id, review_text, review_datetime, CONCAT(
      'You are a marketing representative. How could we incentivise this customer with this positive review? Provide a single response, and should be simple and concise, do not include emojis. Answer in JSON format with one key: marketing. Marketing should be a string.', review_text) AS prompt
   FROM \`gemini_demo.customer_reviews\`
   WHERE customer_id = 5576
),
STRUCT(
   0.2 AS temperature, TRUE AS flatten_json_output)));
"


bq query --use_legacy_sql=false \
"
SELECT * FROM \`gemini_demo.customer_reviews_marketing\`
"


bq query --use_legacy_sql=false \
'
CREATE OR REPLACE TABLE
`gemini_demo.customer_reviews_marketing_formatted` AS (
SELECT
   review_text,
   JSON_QUERY(RTRIM(LTRIM(results.ml_generate_text_llm_result, " ```json"), "```"), "$.marketing") AS marketing,
   social_media_source, customer_id, location_id, review_datetime
FROM
   `gemini_demo.customer_reviews_marketing` results )
'


bq query --use_legacy_sql=false \
"
SELECT * FROM \`gemini_demo.customer_reviews_marketing_formatted\`
"


bq query --use_legacy_sql=false \
"
CREATE OR REPLACE TABLE
\`gemini_demo.customer_reviews_cs_response\` AS (
SELECT ml_generate_text_llm_result, social_media_source, review_text, customer_id, location_id, review_datetime
FROM
ML.GENERATE_TEXT(
MODEL \`gemini_demo.gemini_pro\`,
(
   SELECT social_media_source, customer_id, location_id, review_text, review_datetime, CONCAT(
      'How would you respond to this customer review? If the customer says the coffee is weak or burnt, respond stating "thank you for the review we will provide your response to the location that you did not like the coffee and it could be improved." Or if the review states the service is bad, respond to the customer stating, "the location they visited has been notfied and we are taking action to improve our service at that location." From the customer reviews provide actions that the location can take to improve. The response and the actions should be simple, and to the point. Do not include any extraneous or special characters in your response. Answer in JSON format with two keys: Response, and Actions. Response should be a string. Actions should be a string.', review_text) AS prompt
   FROM \`gemini_demo.customer_reviews\`
   WHERE customer_id = 8844
),
STRUCT(
   0.2 AS temperature, TRUE AS flatten_json_output)));
"


bq query --use_legacy_sql=false \
"
SELECT * FROM \`gemini_demo.customer_reviews_cs_response\`
"



bq query --use_legacy_sql=false \
'
CREATE OR REPLACE TABLE
`gemini_demo.customer_reviews_cs_response_formatted` AS (
SELECT
   review_text,
   JSON_QUERY(RTRIM(LTRIM(results.ml_generate_text_llm_result, " ```json"), "```"), "$.Response") AS Response,
   JSON_QUERY(RTRIM(LTRIM(results.ml_generate_text_llm_result, " ```json"), "```"), "$.Actions") AS Actions,
   social_media_source, customer_id, location_id, review_datetime
FROM
   `gemini_demo.customer_reviews_cs_response` results )
'


bq query --use_legacy_sql=false \
"
SELECT * FROM \`gemini_demo.customer_reviews_cs_response_formatted\`
"


bq query --use_legacy_sql=false '
CREATE OR REPLACE TABLE
`gemini_demo.review_images_results` AS (
SELECT
    uri,
    ml_generate_text_llm_result
FROM
    ML.GENERATE_TEXT( MODEL `gemini_demo.gemini_pro_vision`,
    TABLE `gemini_demo.review_images`,
    STRUCT( 0.2 AS temperature,
        "For each image, provide a summary of what is happening in the image and keywords from the summary. Answer in JSON format with two keys: summary, keywords. Summary should be a string, keywords should be a list." AS PROMPT,
        TRUE AS FLATTEN_JSON_OUTPUT)));'



bq query --use_legacy_sql=false \
"
SELECT * FROM \`gemini_demo.review_images_results\`
"


bq query --use_legacy_sql=false \
'
CREATE OR REPLACE TABLE
  `gemini_demo.review_images_results_formatted` AS (
  SELECT
    uri,
    JSON_QUERY(RTRIM(LTRIM(results.ml_generate_text_llm_result, " ```json"), "```"), "$.summary") AS summary,
    JSON_QUERY(RTRIM(LTRIM(results.ml_generate_text_llm_result, " ```json"), "```"), "$.keywords") AS keywords
  FROM
    `gemini_demo.review_images_results` results )
'


bq query --use_legacy_sql=false \
"
SELECT * FROM \`gemini_demo.review_images_results_formatted\`
"
