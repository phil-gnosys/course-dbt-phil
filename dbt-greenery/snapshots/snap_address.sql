{% snapshot snap_address %}

{{
    config(
      target_database='dbt',
      target_schema='dbt_phil_w',
      unique_key='address_guid',
      strategy='check',
      check_cols=['address','zipcode','state','country']
    )
}}

select
    address_id
    , address_guid
    , address
    , zipcode
    , state
    , country
 from {{ref('stg_address')}}

{% endsnapshot %}