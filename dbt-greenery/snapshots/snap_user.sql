{% snapshot snap_user %}

{{
    config(
      target_database='dbt',
      target_schema='dbt_phil_w',
      unique_key='user_guid',
      strategy='timestamp',
      updated_at='updated_utc_datetime',
    )
}}

select
    user_id
    , user_guid
    , address_guid
    , first_name
    , last_name
    , email
    , phone_number
    , created_utc_datetime
    , updated_utc_datetime
 from {{ref('stg_user')}}

{% endsnapshot %}