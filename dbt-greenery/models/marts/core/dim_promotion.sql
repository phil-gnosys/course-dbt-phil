{{
    config(
        materialized = 'table',
        unique_key = 'address_guid'
    )
}}

WITH promotion_stage AS (
    SELECT
        promotion_id
        , 'Promotion' AS promotion_type
        , promotion_code
        , promotion_discount_percentage
        , promotion_status
    FROM {{ ref('stg_promotion') }}
    UNION
    SELECT 
        0
        , 'No Promotion'
        , 'No Promotion'
        , 0.00
        , 'No Promotion'
)

SELECT
    promotion_id
    , promotion_type
    , promotion_code
    , promotion_discount_percentage
    , promotion_status
FROM promotion_stage
