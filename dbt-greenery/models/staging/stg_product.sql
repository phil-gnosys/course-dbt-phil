{{
    config(
        materialized = 'view',
        unique_key = 'product_guid'
    )
}}

WITH product_source AS (
    SELECT
        id
        , product_id
        , name
        , price::NUMERIC(7,2)
        , quantity
    FROM {{ source('greenery', 'products') }}
)

, product_rename AS (
    SELECT
        id AS product_id
        , product_id AS product_guid
        , name AS product_description
        , price AS product_unit_price
        , quantity AS product_on_hand_quantity
        , (price * quantity) AS product_on_hand_value
    FROM product_source
)

SELECT
    product_id
    , product_guid
    , product_description
    , product_unit_price
    , product_on_hand_quantity
    , product_on_hand_value
FROM product_rename