
# Prompt the user to enter the GCP Project ID
GCP_PROJECT_ID=`gcloud config get-value project`


# Enable the BigQuery Migration API
gcloud services enable bigquerymigration.googleapis.com

# Create the source_teradata.txt file
cat <<EOF > source_teradata.txt
-- Create a new table named "Customers"
CREATE TABLE Customers (
  CustomerID INTEGER PRIMARY KEY,
  FirstName VARCHAR(255),
  LastName VARCHAR(255),
  Email VARCHAR(255)
);

-- Insert some data into the "Customers" table
INSERT INTO Customers (CustomerID, FirstName, LastName, Email)
VALUES (1, 'John', 'Doe', 'johndoe@example.com');

INSERT INTO Customers (CustomerID, FirstName, LastName, Email)
VALUES (2, 'Jane', 'Smith', 'janesmith@example.com');

INSERT INTO Customers (CustomerID, FirstName, LastName, Email)
VALUES (3, 'Bob', 'Johnson', 'bobjohnson@example.com');

-- Select all data from the "Customers" table
SELECT * FROM Customers;

-- Add a new column to the "Customers" table
ALTER TABLE Customers ADD Address VARCHAR(255);

-- Update the email address for a specific customer
UPDATE Customers SET Email = 'johndoe2@example.com' WHERE CustomerID = 1;

-- Delete a customer record from the "Customers" table
DELETE FROM Customers WHERE CustomerID = 3;

-- Select customers whose first name starts with 'J'
SELECT * FROM Customers WHERE FirstName LIKE 'J%';
EOF

# Create the Google Cloud Storage bucket
gsutil mb gs://$GCP_PROJECT_ID

# Copy the source_teradata.txt file to the bucket
gsutil cp source_teradata.txt gs://$GCP_PROJECT_ID/source/source_teradata.txt


## echo -e "\033[33mhttp://console.cloud.google.com/bigquery/migrations/batch-translation?project=\033[0m"
