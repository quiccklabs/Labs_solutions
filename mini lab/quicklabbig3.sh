PROJECT_ID=`gcloud config get-value project`

bq ls --format=json $PROJECT_ID:Inventory



bq query --use_legacy_sql=false "
SELECT DISTINCT products.product_name, products.price
FROM \`$PROJECT_ID.Inventory.products\` AS products
INNER JOIN \`$PROJECT_ID.Inventory.category\` AS category
ON products.category_id = category.category_id
WHERE products.category_id = 1;"


bq query --use_legacy_sql=false "
CREATE VIEW \`$PROJECT_ID.Inventory.Product_View\` AS
SELECT DISTINCT products.product_name, products.price
FROM \`$PROJECT_ID.Inventory.products\` AS products
INNER JOIN \`$PROJECT_ID.Inventory.category\` AS category
ON products.category_id = category.category_id
WHERE products.category_id = 1;"
