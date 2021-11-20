{% snapshot snap_product %}

{{
    config(
      target_database='dbt',
      target_schema='dbt_phil_w',
      unique_key='product_guid',
      strategy='check',
      check_cols=['product_id','product_description','product_price','product_quantity']
    )
}}

select
    product_id
    , product_guid
    , product_description
    , product_price
    , product_quantity
 from {{ref('stg_product')}}

{% endsnapshot %}