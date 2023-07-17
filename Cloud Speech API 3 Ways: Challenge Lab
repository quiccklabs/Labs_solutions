


export API_KEY=""

task_2_file_name=""

task_3_request_file=""

task_3_response_file=""

task_4_sentence=""

task_4_file=""

task_5_sentence=""

task_5_file=""



export PROJECT_ID=$(gcloud config get-value project)

source venv/bin/activate


cat > synthesize-text.json <<EOF

{
    'input':{
        'text':'Cloud Text-to-Speech API allows developers to include
           natural-sounding, synthetic human speech as playable audio in
           their applications. The Text-to-Speech API converts text or
           Speech Synthesis Markup Language (SSML) input into audio data
           like MP3 or LINEAR16 (the encoding used in WAV files).'
    },
    'voice':{
        'languageCode':'en-gb',
        'name':'en-GB-Standard-A',
        'ssmlGender':'FEMALE'
    },
    'audioConfig':{
        'audioEncoding':'MP3'
    }
}

EOF


curl -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
  -H "Content-Type: application/json; charset=utf-8" \
  -d @synthesize-text.json "https://texttospeech.googleapis.com/v1/text:synthesize" \
  > $task_2_file_name



cat > tts_decode.py <<EOF
import argparse
from base64 import decodebytes
import json
"""
Usage:
        python tts_decode.py --input "synthesize-text.txt" \
        --output "synthesize-text-audio.mp3"
"""
def decode_tts_output(input_file, output_file):
    """ Decode output from Cloud Text-to-Speech.
    input_file: the response from Cloud Text-to-Speech
    output_file: the name of the audio file to create
    """
    with open(input_file) as input:
        response = json.load(input)
        audio_data = response['audioContent']
        with open(output_file, "wb") as new_file:
            new_file.write(decodebytes(audio_data.encode('utf-8')))
if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="Decode output from Cloud Text-to-Speech",
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--input',
                       help='The response from the Text-to-Speech API.',
                       required=True)
    parser.add_argument('--output',
                       help='The name of the audio file to create',
                       required=True)
    args = parser.parse_args()
    decode_tts_output(args.input, args.output)
EOF

python tts_decode.py --input "$task_2_file_name" --output "synthesize-text-audio.mp3"



# Define variables

audio_uri="gs://cloud-samples-data/speech/corbeau_renard.flac"

# Generate speech_request.json file
cat > "$task_3_request_file" <<EOF
{
  "config": {
    "encoding": "FLAC",
    "sampleRateHertz": 44100,
    "languageCode": "fr-FR"
  },
  "audio": {
    "uri": "$audio_uri"
  }
}
EOF

# Make API call for French transcription
curl -s -X POST -H "Content-Type: application/json" \
    --data-binary @"$task_3_request_file" \
    "https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" \
    -o "$task_3_response_file"



sudo apt-get update
sudo apt-get install -y jq


# Set the variables for the Translation API request
source_lang="ja"
target_lang="en"

# Make the Translation API request using curl
response=$(curl -s -X POST \
  -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
  -H "Content-Type: application/json; charset=utf-8" \
  -d "{\"q\": \"$task_4_sentence\"}" \
  "https://translation.googleapis.com/language/translate/v2?key=${API_KEY}&source=${source_lang}&target=${target_lang}")

# Check if the response contains an error
if [[ $response == *"error"* ]]; then
  echo "Translation API returned an error:"
  echo "$response"
else
  translation=$(jq -r '.data.translations[].translatedText' <<< "$response")
  if [[ -z "$translation" ]]; then
    echo "Translation is empty or null."
  else
    echo "$translation" > "$task_4_file"
    echo "Translation saved to $task_4_file:"
    cat "$task_4_file"
  fi
fi



# URL-decode the sentence
decoded_sentence=$(python -c "import urllib.parse; print(urllib.parse.unquote('$task_5_sentence'))")

# Make the Language Detection API request using curl
curl -s -X POST \
  -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
  -H "Content-Type: application/json; charset=utf-8" \
  -d "{\"q\": [\"$decoded_sentence\"]}" \
  "https://translation.googleapis.com/language/translate/v2/detect?key=${API_KEY}" \
  -o "$task_5_file"












