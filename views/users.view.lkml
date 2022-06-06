# The name of this view in Looker is "Users"
include: location.view
view: users {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  #Lab5
  extends: [location]
  sql_table_name: public.users ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.


  filter: select_traffic_source {
    type: string
    suggest_explore: order_items
    suggest_dimension: users.traffic_source
  }


  dimension: hidden_traffic_source_filter {
    hidden: yes
    type: yesno
    sql: {% condition select_traffic_source %} ${traffic_source} {% endcondition %} ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Age" in Explore.

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_age {
    type: sum
    sql: ${age} ;;
  }

  measure: average_age {
    type: average
    sql: ${age} ;;
  }


  dimension: city_link {
    type: string
    sql: ${TABLE}.city ;;
    link: {
      label: "Search the web"
      url: "http://www.google.com/search?q={{ value | url_encode }}"
      icon_url: "http://www.google.com/s2/favicons?domain=www.{{ value | url_encode }}.com"
    }
  }

  dimension: order_history_button {
    label: "Order History"
    sql: ${TABLE}.id ;;
    html: <a href="/explore/liquid_gamboalopez/order_items?fields=order_items.order_item_id, users.first_name, users.last_name, users.id, order_items.order_item_count, order_items.total_revenue&f[users.id]={{ value }}"><button>Order History</button></a> ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: state_link {
    type: string
    sql: ${TABLE}.state ;;
    map_layer_name: us_states
    html: {% if _explore._name == "order_items" %}
          <a href="/explore/liquid_gamboalopez/order_items?fields=order_items.detail*&f[users.state]= {{ value }}">{{ value }}</a>
        {% else %}
          <a href="/explore/liquid_gamboalopez/users?fields=users.detail*&f[users.state]={{ value }}">{{ value }}</a>
        {% endif %} ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, orders.count]
  }


  measure: dynamic_count {
    type: count_distinct
    sql: ${id} ;;
    filters: [ hidden_traffic_source_filter: "Yes" ]
  }
}
