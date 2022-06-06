# The name of this view in Looker is "Product Facts"
view: product_facts {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: public.product_facts ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Image File" in Explore.

  dimension: image_file {
    type: string
    sql: ${TABLE}.image_file ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  measure: count {
    type: count
    drill_fields: [name, products.id, products.item_name]
  }
}
