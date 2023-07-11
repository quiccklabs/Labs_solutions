

#Define APIKEY for task 1

export API_KEY=""

# Define variables for file names

task_2_request_file=""

task_2_response_file=""

task_3_request_file=""

task_3_response_file=""



# Generate speech_request_en.json file
cat > "$task_2_request_file" <<EOF
{
  "config": {
    "encoding": "LINEAR16",
    "languageCode": "en-US",
    "audioChannelCount": 2
  },
  "audio": {
    "uri": "gs://spls/arc131/question_en.wav"
  }
}
EOF

# Make API call for English transcription
curl -s -X POST -H "Content-Type: application/json" --data-binary @"$task_2_request_file" \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > "$task_2_response_file"

# Generate request_sp.json file
cat > "$task_3_request_file" <<EOF
{
  "config": {
    "encoding": "FLAC",
    "languageCode": "es-ES"
  },
  "audio": {
    "uri": "gs://spls/arc131/multi_es.flac"
  }
}
EOF

# Make API call for Spanish transcription
curl -s -X POST -H "Content-Type: application/json" --data-binary @"$task_3_request_file" \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > "$task_3_response_file"



