

export MONOLITH_IDENTIFIER=

export CLUSTER_NAME=

export ORDERS_IDENTIFIER=

export PRODUCTS_IDENTIFIER=

export FRONTEND_IDENTIFIER=

git clone https://github.com/googlecodelabs/monolith-to-microservices.git

cd ~/monolith-to-microservices
./setup.sh

cd ~/monolith-to-microservices/monolith
npm start


=======================================================================================================================================



gcloud services enable cloudbuild.googleapis.com
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/$MONOLITH_IDENTIFIER:1.0.0 .


gcloud config set compute/zone us-central1-a
gcloud services enable container.googleapis.com
gcloud container clusters create $CLUSTER_NAME --num-nodes 3

kubectl create deployment $MONOLITH_IDENTIFIER --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/$MONOLITH_IDENTIFIER:1.0.0
kubectl expose deployment $MONOLITH_IDENTIFIER --type=LoadBalancer --port 80 --target-port 8080


cd ~/monolith-to-microservices/microservices/src/orders
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/$ORDERS_IDENTIFIER:1.0.0 .

cd ~/monolith-to-microservices/microservices/src/products
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/$PRODUCTS_IDENTIFIER:1.0.0 .


kubectl create deployment $ORDERS_IDENTIFIER --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/$ORDERS_IDENTIFIER:1.0.0
kubectl expose deployment $ORDERS_IDENTIFIER --type=LoadBalancer --port 80 --target-port 8081

kubectl create deployment $PRODUCTS_IDENTIFIER --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/$PRODUCTS_IDENTIFIER:1.0.0
kubectl expose deployment $PRODUCTS_IDENTIFIER --type=LoadBalancer --port 80 --target-port 8082


cd ~/monolith-to-microservices/react-app


cd ~/monolith-to-microservices/microservices/src/frontend
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/$FRONTEND_IDENTIFIER:1.0.0 .


kubectl create deployment $FRONTEND_IDENTIFIER --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/$FRONTEND_IDENTIFIER:1.0.0

kubectl expose deployment $FRONTEND_IDENTIFIER --type=LoadBalancer --port 80 --target-port 8080


