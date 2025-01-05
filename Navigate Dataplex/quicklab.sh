
bq query --use_legacy_sql=false \
'
SELECT * FROM `thelook_gcda.products` WHERE brand IS NOT NULL limit 10;
'




bq query --use_legacy_sql=false \
'
SELECT * FROM `thelook_gcda.orders` limit 10;
'


bq query --use_legacy_sql=false \
'
SELECT * FROM `thelook_gcda.order_items` limit 10;
'


bq query --use_legacy_sql=false \
'
SELECT * FROM `ghcn_daily.ghcnd_1763` limit 10;
'


bq query --use_legacy_sql=false \
'
SELECT
 name AS product_name,
 id AS product_id
FROM
  thelook_gcda.products
LIMIT 10;
'
