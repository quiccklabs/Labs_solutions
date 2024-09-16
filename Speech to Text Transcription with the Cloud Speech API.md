
## 🚀 Speech to Text Transcription with the Cloud Speech API | [GSP048](https://www.cloudskillsboost.google/focuses/2187?parent=catalog)

### 🔗 **Solution Video:** [Watch Here]()

---

### Disclaimer:
This script and guide are provided for educational purposes to help you understand the lab process. Before using the script, I encourage you to open and review it to understand each step. Please make sure you follow Qwiklabs' terms of service and YouTube’s community guidelines. The goal is to enhance your learning experience, not to bypass it.

## 🌐 **Quick Start Guide:**

**Create API Key:** [clicking here](https://console.cloud.google.com/apis/credentials?project=).

**Launch VM SSH Shell:** [clicking here](https://console.cloud.google.com/compute/instances?referrer=search&project=).

--

```bash
read -p "API_KEY:" API_KEY

cat > request.json <<EOF

{
  "config": {
      "encoding":"FLAC",
      "languageCode": "en-US"
  },
  "audio": {
      "uri":"gs://cloud-samples-data/speech/brooklyn_bridge.flac"
  }
}

EOF

curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > result.json
```
--

## Now Check the score for Task 3 Then only move ahead with next command.


--

```bash
rm request.json

cat >> request.json <<EOF

 {
  "config": {
      "encoding":"FLAC",
      "languageCode": "fr"
  },
  "audio": {
      "uri":"gs://cloud-samples-data/speech/corbeau_renard.flac"
  }
}

EOF


curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > result.json
```


---

## 🎉 **Lab Completed!**

You've successfully completed the lab! Great job on working through the process.

### 🌟 **Stay Connected!**

- 🔔 **Join our [Telegram Channel](https://t.me/quiccklab)** for the latest updates.
- 🗣 **Participate in the [Discussion Group](https://t.me/Quicklabchat)** to engage with other learners.
- 💬 **Join our [Discord Server](https://discord.gg/7fAVf4USZn)** for more interactive discussions.
- 💼 **Follow us on [LinkedIn](https://www.linkedin.com/company/quicklab-linkedin/)** for news and opportunities.
- 🐦 **Follow us on [Twitter/X](https://x.com/quicklab7)** for the latest updates.


---
---

**Keep up the great work and continue your learning journey!**

# [QUICKLAB☁️](https://www.youtube.com/@quick_lab) - Don't Forget to Subscribe!
