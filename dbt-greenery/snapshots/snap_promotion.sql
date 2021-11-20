{% snapshot snap_promotion %}

{{
    config(
      target_database='dbt',
      target_schema='dbt_phil_w',
      unique_key='promotion_code',
      strategy='check',
      check_cols=['promotion_id','promotion_discount','promotion_status']
    )
}}

select
    promotion_id
    , promotion_code
    , promotion_discount
    , promotion_status
 from {{ref('stg_promotion')}}

{% endsnapshot %}