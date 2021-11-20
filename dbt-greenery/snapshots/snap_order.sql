{% snapshot snap_order %}

{{
    config(
      target_database='dbt',
      target_schema='dbt_phil_w',
      unique_key='order_guid',
      strategy='check',
      check_cols=['order_id','user_guid','promotion_code','address_guid','order_amount','shipping_amount','total_amount','tracking_guid','shipping_service','estimated_delivery_utc_datetime','delivered_utc_datetime','order_status']
    )
}}

select
    order_id
    , order_guid
    , user_guid
    , promotion_code
    , address_guid
    , order_amount
    , shipping_amount
    , total_amount
    , tracking_guid
    , shipping_service
    , estimated_delivery_utc_datetime
    , delivered_utc_datetime
    , order_status
 from {{ref('stg_order')}}

{% endsnapshot %}