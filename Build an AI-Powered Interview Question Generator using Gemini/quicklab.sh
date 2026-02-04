cat <<'EOF' > interview.py
import vertexai
from vertexai.generative_models import GenerativeModel

def interview(prompt: str):
    # Initialize Vertex AI
    vertexai.init()

    # Load Gemini model (lite version)
    model = GenerativeModel("gemini-2.5-flash-lite")

    # Generate content (NO STREAMING)
    response = model.generate_content(
        prompt,
        stream=False
    )

    print(response.text)


if __name__ == "__main__":
    interview(
        "Give me ten interview questions for the role of program manager."
    )
EOF


/usr/bin/python3 interview.py
