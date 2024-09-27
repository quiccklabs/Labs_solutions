// # Copyright 2023 Google LLC
// #
// # Licensed under the Apache License, Version 2.0 (the "License");
// # you may not use this file except in compliance with the License.
// # You may obtain a copy of the License at
// #
// #      http://www.apache.org/licenses/LICENSE-2.0
// #
// # Unless required by applicable law or agreed to in writing, software
// # distributed under the License is distributed on an "AS IS" BASIS,
// # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// # See the License for the specific language governing permissions and
// # limitations under the License.
// Init Express.js
import express, { Express, Request, Response } from "express";
let app = express();
export default app;

import cors from 'cors';
app.use(cors());

// Init env variables (from .env or at runtime from Cloud Run)
import dotenv from "dotenv";
dotenv.config();
const port = process.env.PORT;

var firestore;

// Product object definition
interface Product {
  id?: string; // optional because when we write a new obj to Firestore, we let Firestore set the id.
  name: string;
  price: number; // in USD
  quantity: number; // how many of this product are in stock?
  imgfile: string; // The path to the product image in the uploaded frontend (Cloud Storage)
  timestamp: Date; // A manual or randomly generated timestamp (force X images to have been added in the last week)
  actualdateadded: Date; // The actual datetime the product was added to Firestore (for debugging)
}

// ---------------- HANDLERS ------------------------------------------------
app.get("/", (req: Request, res: Response) => {
  res.send("🍎 Hello! This is the Cymbal Superstore Inventory API.");
});

app.get("/health", (req: Request, res: Response) => {
  res.send("✅ ok");
});

// Get all products from the database
app.get("/products", async (req: Request, res: Response) => {
  const products = await firestore.collection("inventory").get();
  const productsArray: any[] = [];
  products.forEach((product) => {
    const p: Product = {
      id: product.id,
      name: product.data().name,
      price: product.data().price,
      quantity: product.data().quantity,
      imgfile: product.data().imgfile,
      timestamp: product.data().timestamp,
      actualdateadded: product.data().actualdateadded,
    };
    productsArray.push(p);
  });
  res.send(productsArray);
});

// Get product by ID
app.get("/products/:id", async (req: Request, res: Response) => {
  const q_id = req.params.id;
  const product = await firestore.collection("inventory").doc(q_id).get();
  // is product empty?
  if (!product.exists) {
    res.status(404).send("Product not found.");
    return;
  }

  const p: Product = {
    id: product.id,
    name: product.data().name,
    price: product.data().price,
    quantity: product.data().quantity,
    imgfile: product.data().imgfile,
    timestamp: product.data().timestamp,
    actualdateadded: product.data().actualdateadded,
  };
  res.send(p);
});


// Your code for the GET /newproducts endpoint goes here.
app.get("/newproducts", async (req: Request, res: Response) => {
  // Your code goes here.
  const products = await firestore.collection("inventory").get();
  const productsArray: any[] = [];
  products.forEach((product) => {
    if (product.data().quantity > 0) {
      const p: Product = {
        id: product.id,
        name: product.data().name,
        price: product.data().price,
        quantity: product.data().quantity,
        imgfile: product.data().imgfile,
        timestamp: product.data().timestamp,
        actualdateadded: product.data().actualdateadded,
      };
      productsArray.push(p);
    }
  });
  // Filter products to only include those added in the last 7 days
  const newProducts = productsArray.filter(
    (product) =>
      product.timestamp.getTime() > Date.now() - 7 * 24 * 60 * 60 * 1000
  );
  res.send(newProducts);
});

// ------------------- ------------------- ------------------- ------------------- -------------------


// ------------------- ------------------- ------------------- ------------------- -------------------
// START EXPRESS SERVER
// ------------------- ------------------- ------------------- ------------------- -------------------
  // Init Firestore client with product inventory
  const { Firestore } = require("@google-cloud/firestore");
  firestore = new Firestore();
  initFirestoreCollection();

  var server; 
if (process.env.NODE_ENV !== "test") {
 server = app.listen(port, () => {
    console.log(`🍏 Cymbal Superstore: Inventory API running on port: ${port}`);
  });
}

// ------------------- ------------------- ------------------- ------------------- -------------------
// HELPERS -- SEED THE INVENTORY DATABASE (PRODUCTS)
// ------------------- ------------------- ------------------- ------------------- -------------------

// This will overwrite products in the database - this is intentional, to keep the date-added fresh. (always have a list of products added < 1 week ago, so that
// the new products page always has items to show.
function initFirestoreCollection() {
  const oldProducts = [
    "Apples",
    "Bananas",
    "Milk",
    "Whole Wheat Bread",
    "Eggs",
    "Cheddar Cheese",
    "Whole Chicken",
    "Rice",
    "Black Beans",
    "Bottled Water",
    "Apple Juice",
    "Cola",
    "Coffee Beans",
    "Green Tea",
    "Watermelon",
    "Broccoli",
    "Jasmine Rice",
    "Yogurt",
    "Beef",
    "Shrimp",
    "Walnuts",
    "Sunflower Seeds",
    "Fresh Basil",
    "Cinnamon",
  ];
  // iterate over product names
  // add "old" products to firestore - all added between 1 month and 12 months ago
  // (none of these should show up in the new products list.)
  for (let i = 0; i < oldProducts.length; i++) {
    const oldProduct = {
      name: oldProducts[i],
      price: Math.floor(Math.random() * 10) + 1,
      quantity: Math.floor(Math.random() * 500) + 1,
      imgfile:
        "product-images/" +
        oldProducts[i].replace(/\s/g, "").toLowerCase() +
        ".png",
      // generate a random timestamp at least 3 months ago (but not more than 12 months ago)
      timestamp: new Date(
        Date.now() - Math.floor(Math.random() * 31536000000) - 7776000000
      ),

      actualdateadded: new Date(Date.now()),
    };
    console.log(
      "⬆️ Adding (or updating) product in firestore: " + oldProduct.name
    );
    addOrUpdateFirestore(oldProduct);
  }
  // Add recent products (force add last 7 days)
  const recentProducts = [
    "Parmesan Crisps",
    "Pineapple Kombucha",
    "Maple Almond Butter",
    "Mint Chocolate Cookies",
    "White Chocolate Caramel Corn",
    "Acai Smoothie Packs",
    "Smores Cereal",
    "Peanut Butter and Jelly Cups",
  ];
  for (let j = 0; j < recentProducts.length; j++) {
    const recent = {
      name: recentProducts[j],
      price: Math.floor(Math.random() * 10) + 1,
      quantity: Math.floor(Math.random() * 100) + 1,
      imgfile:
        "product-images/" +
        recentProducts[j].replace(/\s/g, "").toLowerCase() +
        ".png",
      timestamp: new Date(
        Date.now() - Math.floor(Math.random() * 518400000) + 1
      ),
      actualdateadded: new Date(Date.now()),
    };
    console.log("🆕 Adding (or updating) product in firestore: " + recent.name);
    addOrUpdateFirestore(recent);
  }

  // add recent products that are out of stock (To test demo query- only want to show in stock items.)
  const recentProductsOutOfStock = ["Wasabi Party Mix", "Jalapeno Seasoning"];
  for (let k = 0; k < recentProductsOutOfStock.length; k++) {
    const oosProduct = {
      name: recentProductsOutOfStock[k],
      price: Math.floor(Math.random() * 10) + 1,
      quantity: 0,
      imgfile:
        "product-images/" +
        recentProductsOutOfStock[k].replace(/\s/g, "").toLowerCase() +
        ".png",
      timestamp: new Date(
        Date.now() - Math.floor(Math.random() * 518400000) + 1
      ),
      actualdateadded: new Date(Date.now()),
    };
    console.log(
      "😱 Adding (or updating) out of stock product in firestore: " +
        oosProduct.name
    );
    addOrUpdateFirestore(oosProduct);
  }
}

// Helper - add Firestore doc if not exists, otherwise update
// pass in a Product as the parameter
function addOrUpdateFirestore(product) {
  firestore
    .collection("inventory")
    .where("name", "==", product.name)
    .get()
    .then((querySnapshot) => {
      if (querySnapshot.empty) {
        firestore.collection("inventory").add(product);
      } else {
        querySnapshot.forEach((doc) => {
          firestore.collection("inventory").doc(doc.id).update(product);
        });
      }
    });
}
