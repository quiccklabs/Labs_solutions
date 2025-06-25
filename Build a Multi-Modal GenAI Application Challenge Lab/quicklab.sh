
export PROJECT_ID=$(gcloud config get-value project)
export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")


cat > GenerateImage.py <<EOF_TASK_ONE

import argparse

import vertexai
from vertexai.preview.vision_models import ImageGenerationModel

def generate_bouquet_image(
    project_id: str, location: str, output_file: str, prompt: str ) -> vertexai.preview.vision_models.ImageGenerationResponse:
    """Generate an image using a text prompt.
    Args:
      project_id: Google Cloud project ID, used to initialize Vertex AI.
      location: Google Cloud region, used to initialize Vertex AI.
      output_file: Local path to the output image file.
      prompt: The text prompt describing what you want to see."""

    vertexai.init(project=project_id, location=location)

    model = ImageGenerationModel.from_pretrained("imagen-3.0-generate-002")

    images = model.generate_images(
        prompt=prompt,
        # Optional parameters
        number_of_images=1,
        seed=1,
        add_watermark=False,
    )

    images[0].save(location=output_file)

    return images

generate_bouquet_image(
    project_id='$PROJECT_ID',
    location='$REGION',
    output_file='image.jpeg',
    prompt='Create an image containing a bouquet of 2 sunflowers and 3 roses',
    )
EOF_TASK_ONE


/usr/bin/python3 GenerateImage.py
#========================================
#Task #2 new code with stream
#==============================================
cat > Gentext.py <<EOF_TASK_TWO
import vertexai
from vertexai.generative_models import GenerativeModel, Part, Image, Content

def analyze_bouquet_image(project_id: str, location: str):
    # Initialize Vertex AI
    vertexai.init(project=project_id, location=location)

    # Load the Gemini multimodal model (version 2.0 flash)
    model = GenerativeModel("gemini-2.0-flash-001")

    # Load the image from file
    image_path = "/home/student/image.jpeg"  # Update if your path is different
    image_part = Part.from_image(Image.load_from_file(image_path))

    # Ask initial question about image content
    print("📷 Image Analysis: ", end="", flush=True)
    response_stream = model.generate_content(
        [image_part, Part.from_text("Generate birthday wishes based on this image")],
        stream=True
    )

    full_response = ""
    for chunk in response_stream:
        if chunk.text:
            print(chunk.text, end="", flush=True)
            full_response += chunk.text
    print("\n")


# Set your project and location
project_id = "$PROJECT_ID"
location = "$REGION"

# Run the function
analyze_bouquet_image(project_id, location)
EOF_TASK_TWO


/usr/bin/python3 Gentext.py
