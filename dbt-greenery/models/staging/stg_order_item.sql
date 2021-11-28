{{
    config(
        materialized = 'view',
        unique_key = 'order_guid, product_guid'
    )
}}

WITH order_item_source AS (
    SELECT
        id
        , order_id
        , product_id
        , quantity
    FROM {{ source('greenery', 'order_items') }}
)

, order_item_rename AS (
    SELECT
        id AS order_item_id
        , order_id AS order_guid
        , product_id AS product_guid
        , quantity AS order_product_quantity
    FROM order_item_source
)

SELECT
    order_item_id
    , order_guid
    , product_guid
    , order_product_quantity
FROM order_item_rename