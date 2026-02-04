cat <<'EOF' > generate_image.py
import vertexai
from vertexai.preview.vision_models import ImageGenerationModel

def generate_image(prompt: str):
    # Initialize Vertex AI
    vertexai.init()

    # Load Imagen 3 model
    model = ImageGenerationModel.from_pretrained(
        "imagen-3.0-generate-002"
    )

    # Generate image
    images = model.generate_images(
        prompt=prompt,
        number_of_images=1
    )

    # Save the generated image
    image = images[0]
    image.save("image.jpeg")

    print("Image generated and saved as image.jpeg")

if __name__ == "__main__":
    generate_image(
        "Create an image of a cricket ground in the heart of Los Angeles"
    )
EOF


/usr/bin/python3 generate_image.py
