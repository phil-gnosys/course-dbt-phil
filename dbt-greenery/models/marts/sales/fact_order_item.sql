{{
    config(
        materialized = 'table',
        unique_key = 'order_guid,product_guid'
    )
}}

WITH order_stage AS (
    SELECT
        order_guid
        , user_guid
        , address_guid
        , (created_utc_datetime::DATE) AS order_utc_date
    FROM {{ ref('stg_order') }}
)

, order_item_stage AS (
    SELECT
        order_item_id
        , order_guid
        , product_guid
        , order_product_quantity
    FROM {{ ref('stg_order_item') }}
)

SELECT
    ois.order_item_id
    , ois.order_guid
    , ois.product_guid
    , os.user_guid
    , os.address_guid
    , os.order_utc_date
    , ois.order_product_quantity
FROM order_item_stage ois
INNER JOIN order_stage os
    ON ois.order_guid = os.order_guid
