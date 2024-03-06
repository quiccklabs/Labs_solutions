
# ```Looker Developer - Qwik Start```




### First, on the bottom left of the Looker User Interface, click the toggle button to enter Development mode.

![Alt text](https://cdn.qwiklabs.com/uUCbNuedSCOYQmL%2BIubjqvusmGAeS7Wjj3f6xByL174%3D)


***Click the Develop tab and then select the qwiklabs-ecommerce LookML project.***

***To create the file at the project’s root level, click the + button at the top of the file browser in the Looker IDE.***

***Select Create View. Name the file ***```users_limited```***. Click Create.***


```
view: users_limited {
  sql_table_name: `cloud-training-demos.looker_ecomm.users` ;;
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }
  measure: count {
    type: count
    drill_fields: [id, last_name, first_name]
  }
  }
```

***In the file browser, under the models folder, navigate to the ```training_ecommerce.model``` file.***

```
connection: "bigquery_public_data_looker"

# include all the views
include: "/views/*.view"
include: "/z_tests/*.lkml"
include: "/**/*.dashboard"

datagroup: training_ecommerce_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: training_ecommerce_default_datagroup

label: "E-Commerce Training"

explore: order_items {
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }



  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: events {
  join: event_session_facts {
    type: left_outer
    sql_on: ${events.session_id} = ${event_session_facts.session_id} ;;
    relationship: many_to_one
  }
  join: event_session_funnel {
    type: left_outer
    sql_on: ${events.session_id} = ${event_session_funnel.session_id} ;;
    relationship: many_to_one
  }
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  join: users_limited {
    type: left_outer
    sql_on: ${events.user_id} = ${users_limited.id};;
    relationship: many_to_one
  }
}

```

### Commit Changes and Deploy to Production

1. Click **Validate LookML**.
2. Click **Commit Changes & Push**.
3. Add a commit message and click **Commit**.
4. Lastly, click **Deploy to Production**.


### Now check the score.