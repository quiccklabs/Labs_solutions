# Dialogflow CX: Managing Environments

## Download Blob File

To download the blob file for the quicklab, use the following link:

- [Download Quicklab Blob File](https://github.com/quiccklabs/Labs_solutions/blob/master/Dialogflow%20CX%20Managing%20Environments/quicklab.blob)


## 1. Create Versions

1. **Select Versions** in the main menu.

2. **Click on `Default Start Flow`**.

3. **Click `+ Create`** to create a version of the flow.

   - **Display name**: Enter `Flight booker main v1 chat bot`.

4. **Repeat the versioning steps** to create another version:

   - **Display name**: Enter `Flight booker main v2 chat bot`.

## 2. Create Environments

1. **Create a new environment** called `QA` and use **Version 1**:

   - Go to the **Environments** section.
   - Click **+ Create Environment**.
   - **Name**: Enter `QA`.
   - **Version**: Select `Flight booker main v1 chat bot`.
   - Click **Save** or **Create**.

2. **Create another environment** called `Dev` and use **Version 2**:

   - Go to the **Environments** section.
   - Click **+ Create Environment**.
   - **Name**: Enter `Dev`.
   - **Version**: Select `Flight booker main v2 chat bot`.
   - Click **Save** or **Create**.

## 3. Test the Agent

1. **Open the Test Agent pane** if it’s not already open.

2. **Type `i want to book a flight`** into the **Talk to agent** box.

3. **Test this interaction** in both environments (`QA` and `Dev`) to ensure the chatbot behaves as expected in each version.

## Congratulation !!!