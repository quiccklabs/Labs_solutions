


echo ""
echo ""
echo "Please export the values."


# Prompt user to input three regions
read -p "Enter REGION: " REGION


PROJECT_ID=$(gcloud config get-value project)
echo "PROJECT_ID=${PROJECT_ID}"
echo "REGION=${REGION}"

USER=$(gcloud config get-value account 2> /dev/null)
echo "USER=${USER}"

gcloud services enable cloudaicompanion.googleapis.com --project ${PROJECT_ID}
gcloud services enable aiplatform.googleapis.com --project ${PROJECT_ID}

gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/cloudaicompanion.user
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/serviceusage.serviceUsageViewer

bq mk --dataset --location=US $PROJECT_ID:gemini_demo

bq query --use_legacy_sql=false \
"CREATE OR REPLACE EXTERNAL TABLE \`gemini_demo.movie_posters\`
WITH CONNECTION \`us.gemini_conn\`
OPTIONS (
  object_metadata = 'SIMPLE',
  uris = ['gs://cloud-samples-data/vertex-ai/dataset-management/datasets/classic-movie-posters/*']
);"

bq query --use_legacy_sql=false \
"CREATE OR REPLACE MODEL \`gemini_demo.gemini_pro\`
REMOTE WITH CONNECTION \`us.gemini_conn\`
OPTIONS (endpoint = 'gemini-pro');"

bq query --use_legacy_sql=false \
"CREATE OR REPLACE MODEL \`gemini_demo.gemini_pro_vision\`
REMOTE WITH CONNECTION \`us.gemini_conn\`
OPTIONS (endpoint = 'gemini-pro-vision');"


bq query --use_legacy_sql=false \
"CREATE OR REPLACE TABLE \`gemini_demo.movie_posters_results\` AS (
SELECT
    uri,
    ml_generate_text_llm_result
FROM
    ML.GENERATE_TEXT(
        MODEL \`gemini_demo.gemini_pro_vision\`,
        TABLE \`gemini_demo.movie_posters\`,
        STRUCT(
            0.2 AS temperature,
            'For the movie represented by this poster, what is the movie title and year of release? Answer in JSON format with two keys: title, year. title should be string, year should be integer.' AS PROMPT,
            TRUE AS FLATTEN_JSON_OUTPUT
        )
    )
);"



bq query --use_legacy_sql=false \
"
CREATE OR REPLACE TABLE
  \`gemini_demo.movie_posters_results_formatted\` AS (
  SELECT
    uri,
    JSON_QUERY(RTRIM(LTRIM(results.ml_generate_text_llm_result, ' \`\`\`json'), '\`\`\`'), '$.title') AS title,
    JSON_QUERY(RTRIM(LTRIM(results.ml_generate_text_llm_result, ' \`\`\`json'), '\`\`\`'), '$.year') AS year
  FROM
    \`gemini_demo.movie_posters_results\` results )
"


bq query --use_legacy_sql=false \
"
SELECT
  uri,
  title,
  year,
  prompt,
  ml_generate_text_llm_result
  FROM
 ML.GENERATE_TEXT( MODEL \`gemini_demo.gemini_pro\`,
   (
   SELECT
     CONCAT('Provide a short summary of movie titled ',title, ' from the year ',year,'.') AS prompt,
     uri,
     title,
     year
   FROM
     \`gemini_demo.movie_posters_results_formatted\`
   LIMIT
     20 ),
   STRUCT(0.2 AS temperature,
     TRUE AS FLATTEN_JSON_OUTPUT));
"



bq query --use_legacy_sql=false \
"CREATE OR REPLACE MODEL \`gemini_demo.text_embedding\`
REMOTE WITH CONNECTION \`us.gemini_conn\`
OPTIONS (endpoint = 'text-multilingual-embedding-002');"



bq query --use_legacy_sql=false \
"CREATE OR REPLACE TABLE \`gemini_demo.movie_posters_results_embeddings\` AS (
  SELECT
    *
  FROM
    ML.GENERATE_EMBEDDING(
      MODEL \`gemini_demo.text_embedding\`,
      (
        SELECT
          CONCAT('The movie titled ', title, ' from the year ', year, '.') AS content,
          title,
          year,
          uri
        FROM
          \`gemini_demo.movie_posters_results_formatted\`
      ),
      STRUCT(TRUE AS flatten_json_output)
    )
);"



bq query --use_legacy_sql=false \
"CREATE OR REPLACE VIEW \`gemini_demo.imdb_movies\` AS (
  WITH reviews AS (
    SELECT
      reviews.movie_id AS movie_id,
      title.primary_title AS title,
      title.start_year AS year,
      reviews.review AS review
    FROM
      \`bigquery-public-data.imdb.reviews\` reviews
    LEFT JOIN
      \`bigquery-public-data.imdb.title_basics\` title
    ON
      reviews.movie_id = title.tconst
  )
  SELECT
    DISTINCT(movie_id),
    title,
    year
  FROM
    reviews
  WHERE
    year < 1935
);"



bq query --use_legacy_sql=false \
"CREATE OR REPLACE TABLE \`gemini_demo.imdb_movies_embeddings\` AS (
  SELECT
    *
  FROM
    ML.GENERATE_EMBEDDING(
      MODEL \`gemini_demo.text_embedding\`,
      (
        SELECT
          CONCAT('The movie titled ', title, ' from the year ', year, '.') AS content,
          title,
          year,
          movie_id
        FROM
          \`gemini_demo.imdb_movies\`
      ),
      STRUCT(TRUE AS flatten_json_output)
    )
  WHERE
    ml_generate_embedding_status = ''
);"





bq query --use_legacy_sql=false \
"SELECT
  query.uri AS poster_uri,
  query.title AS poster_title,
  query.year AS poster_year,
  base.title AS imdb_title,
  base.year AS imdb_year,
  base.movie_id AS imdb_movie_id,
  distance
FROM
  VECTOR_SEARCH(
    TABLE \`gemini_demo.imdb_movies_embeddings\`,
    'ml_generate_embedding_result',
    TABLE \`gemini_demo.movie_posters_results_embeddings\`,
    'ml_generate_embedding_result',
    top_k => 1,
    distance_type => 'COSINE'
  );"


bq query --use_legacy_sql=false \
"SELECT
  query.uri AS poster_uri,
  query.title AS poster_title,
  query.year AS poster_year,
  base.title AS imdb_title,
  base.year AS imdb_year,
  base.movie_id AS imdb_movie_id,
  distance,
  imdb.average_rating,
  imdb.num_votes
FROM
  VECTOR_SEARCH(
    TABLE \`gemini_demo.imdb_movies_embeddings\`,
    'ml_generate_embedding_result',
    TABLE \`gemini_demo.movie_posters_results_embeddings\`,
    'ml_generate_embedding_result',
    top_k => 1,
    distance_type => 'COSINE'
  ) DATA
LEFT JOIN
  \`bigquery-public-data.imdb.title_ratings\` imdb
ON
  DATA.base.movie_id = imdb.tconst
ORDER BY
  imdb.average_rating DESC;"
