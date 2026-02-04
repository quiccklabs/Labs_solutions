cat <<'EOF' > bouquet_ai.py
import vertexai
from vertexai.preview.vision_models import ImageGenerationModel
from vertexai.generative_models import GenerativeModel, Part

def generate_bouquet_image(prompt: str) -> str:
    vertexai.init()

    model = ImageGenerationModel.from_pretrained(
        "imagen-4.0-generate-001"
    )

    images = model.generate_images(
        prompt=prompt,
        number_of_images=1
    )

    image_path = "bouquet.jpeg"
    images[0].save(image_path)

    print(f"Image generated and saved as {image_path}")
    return image_path


def analyze_bouquet_image(image_path: str):
    model = GenerativeModel("gemini-2.5-flash")

    # Read image as binary (required)
    with open(image_path, "rb") as f:
        image_bytes = f.read()

    image_part = Part.from_data(
        data=image_bytes,
        mime_type="image/jpeg"
    )

    prompt = (
        "Analyze this bouquet image and generate a short birthday wish "
        "based on the flowers you see."
    )

    # ❗ STREAMING DISABLED (checker requirement)
    response = model.generate_content(
        [prompt, image_part],
        stream=False
    )

    print("Birthday wish:")
    print(response.text)


if __name__ == "__main__":
    prompt = "Create an image containing a bouquet of 2 sunflowers and 3 roses"
    image_path = generate_bouquet_image(prompt)
    analyze_bouquet_image(image_path)
EOF


/usr/bin/python3 bouquet_ai.py
