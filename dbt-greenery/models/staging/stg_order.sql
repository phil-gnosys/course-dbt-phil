{{
    config(
        materialized = 'view',
        unique_key = 'order_id'
    )
}}

with order_source as (
    select
        id
        , order_id
        , user_id
        , promo_id
        , address_id
        , order_cost
        , shipping_cost
        , order_total
        , tracking_id
        , shipping_service
        , estimated_delivery_at
        , delivered_at
        , status
    from {{ source('greenery', 'orders') }}
)

, order_rename as (
    select
        id as order_id
        , order_id as order_guid
        , user_id as user_guid
        , promo_id as promotion_code
        , address_id as address_guid
        , order_cost as order_amount
        , shipping_cost as shipping_amount
        , order_total as total_amount
        , tracking_id as tracking_guid
        , shipping_service
        , estimated_delivery_at as estimated_delivery_utc_datetime
        , delivered_at as delivered_utc_datetime
        , status as order_status
    from order_source
)

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
from order_rename