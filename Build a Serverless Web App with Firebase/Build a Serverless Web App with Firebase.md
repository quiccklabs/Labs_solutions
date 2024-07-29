
# Build a Serverless Web App with Firebase

```
export REGION=
```

```
curl -LO raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Build%20a%20Serverless%20Web%20App%20with%20Firebase/quicklab.sh
source quicklab.sh
```

## Task 5. Register your app

After completing the last step, you should be in the Firebase Console. If you
close that page, you open another incognito tab and use the following link to
the [Firebase Console](https://console.firebase.google.com/?authuser=0).

1. Select the **web icon** (highlighted below) from the list of "Get started by adding Firebase to your app" icons:

2. When prompted for an "App nickname", type in **```Pet Theory```**

3. Then check the box next to "Also set up **Firebase hosting** for this app".

4. Click on the **Register app** button.

5. Click **Next** > **Next** > **Continue to console**. You should now be on the following page:



## Task 6. Authenticate to Firebase and Deploy

Use the IDE to connect to Firebase and deploy your application. Type the
commands in the terminal available in the editor.

  1. Authenticate to Firebase:
  ##

```
firebase login --no-localhost
```
  2. Enter in **Y** if asked if Firebase can collect error reporting information and press **Enter**.

  3. **Copy and paste the URL** generated in a new **incognito browser tab** and press **Enter** (directly clicking on the link results in an error).

  4. Select your labs account and then click **Allow**. Click on **Yes, I just ran this command** to proceed, then confirm your session ID by clicking **Yes, this is my session ID**. You will then be given an access code:

  5. Copy the access code, paste it in the Cloud Shell prompt **Enter authorization code:** , and press **Enter**. You should receive output similar to the following response:


```
firebase init
```



[![Screenshot-2024-07-29-at-6-22-25-PM.png](https://i.postimg.cc/W43RrM1p/Screenshot-2024-07-29-at-6-22-25-PM.png)](https://postimg.cc/QFRnZK7v)


## **Deploy Firebase:-**

```
curl -LO raw.githubusercontent.com/quiccklabs/Labs_solutions/master/Build%20a%20Serverless%20Web%20App%20with%20Firebase/quicklab11.sh
source quicklab11.sh
```

## **Congratulation!!!**
