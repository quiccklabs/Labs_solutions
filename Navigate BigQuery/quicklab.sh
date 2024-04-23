




bq query --use_legacy_sql=false \
"SELECT o.order_id,p.name,p.brand,o.sale_price,o.created_at, o.status
FROM \`thelook_gcda.order_items\` as o
JOIN \`thelook_gcda.products\` as p ON o.product_id=p.id
WHERE UPPER(p.category) LIKE \"SWIM\"
AND UPPER(o.status) NOT IN ('RETURNED','CANCELED','CANCELLED')
AND o.created_at >= '2023-06-01'
AND o.created_at < '2023-07-01';
"




bq query --use_legacy_sql=false \
"
SELECT
first_name,
last_name,
team_name,
sum(points) as total_points
FROM \`bigquery-public-data.ncaa_basketball.mbb_players_games_sr\`
group by first_name, last_name, team_name
order by total_points desc;
"





bq query --use_legacy_sql=false \
"
WITH rankings AS (
SELECT
RANK() OVER (ORDER BY points DESC) AS ranking,
first_name,
last_name,
team_name,
points
FROM
\`bigquery-public-data.ncaa_basketball.mbb_players_games_sr\`
)
SELECT
ranking ,
first_name,
last_name,
team_name,
points
FROM
rankings
WHERE
ranking<=10
ORDER BY
ranking;
"