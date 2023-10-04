
## Building an Application with MongoDB Atlas and Natural Language API hosted on Cloud Run

**Task 1**

**Click Activate Cloud Shell Activate Cloud Shell icon at the top of the Google Cloud console.**

**Run the following commands**

```bash
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable language.googleapis.com
git clone https://github.com/mongodb-developer/Google-Cloud-MongoDB-Atlas-Workshop.git
```
 
**In Cloud Shell, click the Open Editor Open Editor icon icon. If prompted, click Open in a new window. You should see your cloned project on the left.**

Open the file **Google-Cloud-MongoDB-Atlas-Workshop/src/environments/environment.prod.ts** and paste the below content .

```bash
export const environment = {
  production: true,
  APP_ID: 'bakery-ieppw',
  GRAPHQL_URI: 'https://us-east4.gcp.realm.mongodb.com/api/client/v2.0/app/bakery-ieppw/graphql',
  API_KEY: 'MSgYh1cXK3cDU8ni9PmdHAI92xh7Wdb6Buh4uKKPRBkyhvIAjhb4PvRBxX6GSkH7'
};
```


**TASK 2**


Name the database **Bakery** and the collection cakes, then click Create 


***Delete what is currently in the box, add the following cake document, and then press Insert:***

```bash
{
"name":"Chocolate Cake",
"shortDescription":"Chocolate cake is a cake flavored with melted chocolate, cocoa powder, or sometimes both.",
"description":"Chocolate cake is made with chocolate; it can be made with other ingredients, as well. These ingredients include fudge, vanilla creme, and other sweeteners. The history of chocolate cake goes back to 1764, when Dr. James Baker discovered how to make chocolate by grinding cocoa beans between two massive circular millstones.",
"image":"https://addapinch.com/wp-content/uploads/2020/04/chocolate-cake-DSC_1768.jpg",
"ingredients":[
   "flour",
   "sugar",
   "cocoa powder"
],
"stock": 25
}
```

###
###

```bash
{
"name":"Cheese Cake",
"shortDescription":"Cheesecake is a sweet dessert consisting of one or more layers. The main, and thickest, layer consists of a mixture of a soft, fresh cheese (typically cottage cheese, cream cheese or ricotta), eggs, and sugar. ",
"description":"Cheesecake is a sweet dessert consisting of one or more layers. The main, and thickest, layer consists of a mixture of a soft, fresh cheese (typically cottage cheese, cream cheese or ricotta), eggs, and sugar. If there is a bottom layer, it most often consists of a crust or base made from crushed cookies (or digestive biscuits), graham crackers, pastry, or sometimes sponge cake.[1] Cheesecake may be baked or unbaked (and is usually refrigerated).",
"image":"https://sallysbakingaddiction.com/wp-content/uploads/2018/05/perfect-cheesecake-recipe.jpg",
"ingredients":[
   "flour",
   "sugar",
   "eggs"
],
"stock": 40
}
```


 
**Add a new document to this new comments collection and add the following code**

```bash
{
"cakeId": "<ID of Cake Document>",
"date": "...",
"name":"Quicklab",
"text":"Like Share & Subscribe"
}
```




**Congratulations !!!**


