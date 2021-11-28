{{
    config(
        materialized = 'table',
        unique_key = 'product_guid'
    )
}}

WITH product_stage AS (
    SELECT
        product_id
        , product_guid
        , product_description
        , product_unit_price
        , product_on_hand_quantity
        , product_on_hand_value
    FROM {{ ref('stg_product') }}
    UNION
    SELECT
        -1
        , 'Not Applicable'
        , 'Not Applicable'
        , 0
        , 0
        , 0
)

SELECT
    product_id
    , product_guid
    , product_description
    , product_unit_price
    , product_on_hand_quantity
    , product_on_hand_value
FROM product_stage