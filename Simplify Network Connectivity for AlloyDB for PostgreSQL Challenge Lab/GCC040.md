
## 🚀 Simplify Network Connectivity for AlloyDB for PostgreSQL: Challenge Lab | [GCC040](https://www.youtube.com/@quick_lab/videos)

### 🔗 **Solution Video:** [Watch Here](https://youtu.be/1p6VJZ0rweE)

---

## ⚠️ **Disclaimer:**
This script and guide are provided for educational purposes to help you understand the lab process. Before using the script, I encourage you to open and review it to understand each step. Please make sure you follow Qwiklabs' terms of service and YouTube’s community guidelines. The goal is to enhance your learning experience, not to bypass it.


## 🌐 **Quick Start Guide:**

**Launch Cloud Shell:**
Start your Google CloudShell session by [clicking here](https://console.cloud.google.com/home/dashboard?project=&pli=1&cloudshell=true).



```bash
curl -LO raw.githubusercontent.com/quiccklabs/Labs_solutions/refs/heads/master/Simplify%20Network%20Connectivity%20for%20AlloyDB%20for%20PostgreSQL%20Challenge%20Lab/quicklabgcc040.sh
sudo chmod +x quicklabgcc040.sh
./quicklabgcc040.sh
```
- This runs the script to set up your environment for the lab. It will provision resources and configure them as needed.
---

- SSH into the ``cloud-vm`` VM instance

```bash
psql -h REPLACE_IP -U postgres -d postgres
```
---
```bash

CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    medical_record_number VARCHAR(100) UNIQUE,
    last_visit_date DATE,
    primary_physician VARCHAR(100)
);


INSERT INTO patients (patient_id, first_name, last_name, date_of_birth, medical_record_number, last_visit_date, primary_physician)
VALUES 
(1, 'John', 'Doe', '1985-07-12', 'MRN123456', '2024-02-20', 'Dr. Smith'),
(2, 'Jane', 'Smith', '1990-11-05', 'MRN654321', '2024-02-25', 'Dr. Johnson');


CREATE TABLE clinical_trials (
    trial_id INT PRIMARY KEY,
    trial_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    lead_researcher VARCHAR(100),
    number_of_participants INT,
    trial_status VARCHAR(20)
);


INSERT INTO clinical_trials (trial_id, trial_name, start_date, end_date, lead_researcher, number_of_participants, trial_status)
VALUES 
    (1, 'Trial A', '2025-01-01', '2025-12-31', 'Dr. John Doe', 200, 'Ongoing'),
    (2, 'Trial B', '2025-02-01', '2025-11-30', 'Dr. Jane Smith', 150, 'Completed');
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
