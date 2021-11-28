{{
    config(
        materialized = 'view',
        unique_key = 'order_guid'
    )
}}

WITH order_source AS (
    SELECT
        id
        , order_id
        , user_id
        , promo_id
        , address_id
        , created_at
        , order_cost
        , shipping_cost
        , order_total
        , tracking_id
        , shipping_service
        , estimated_delivery_at
        , delivered_at
        , status
    FROM {{ source('greenery', 'orders') }}
)

, order_transform AS (
    SELECT
        id
        , order_id
        , user_id
        , INITCAP(promo_id) AS promo_id
        , address_id
        , created_at
        , (order_cost::NUMERIC(15,2))
        , (shipping_cost::NUMERIC(15,2))
        , (order_total::NUMERIC(15,2))
        , tracking_id
        , INITCAP(shipping_service) AS shipping_service
        , estimated_delivery_at
        , delivered_at
        , INITCAP(status) AS status
    FROM order_source
)

, order_rename AS (
    SELECT
        id as order_id
        , order_id AS order_guid
        , user_id AS user_guid
        , promo_id AS promotion_code
        , address_id AS address_guid
        , created_at AS created_utc_datetime
        , order_cost AS order_product_amount
        , shipping_cost AS order_shipping_amount
        , order_total AS order_total_amount
        , tracking_id AS tracking_guid
        , shipping_service AS shipping_service_code
        , estimated_delivery_at AS estimated_delivery_utc_datetime
        , delivered_at AS delivered_utc_datetime
        , status AS order_status
    FROM order_transform
)

SELECT
    order_id
    , order_guid
    , user_guid
    , promotion_code
    , address_guid
    , created_utc_datetime    
    , order_product_amount
    , order_shipping_amount
    , order_total_amount
    , tracking_guid
    , shipping_service_code
    , estimated_delivery_utc_datetime
    , delivered_utc_datetime
    , order_status
FROM order_rename