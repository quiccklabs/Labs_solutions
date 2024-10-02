cd helloworld

cat > main.py <<EOF_END
import os

from flask import Flask

app = Flask(__name__)

app_version = "0.0.1"

@app.route("/")
def hello_world():
    return f"Hello! This is version {app_version} of my application."


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
EOF_END



git add .
git commit -m "update version to 0.0.1"

git push


echo -e "\n\nTo see your code, visit this URL:\n \
https://github.com/${GITHUB_USERNAME}/hello-world/blob/main/main.py \n\n"


echo -e "\n\nOnce the build finishes, visit this URL to see your live application:\n \
"$(gcloud run services list | awk '/URL/{print $2}' | head -1)" \n\n"
