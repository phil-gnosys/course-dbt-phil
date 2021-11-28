{{
    config(
        materialized = 'view',
        unique_key = 'promo_code'
    )
}}

WITH promotion_source AS (
    SELECT
        id
        , promo_id
        , discout
        , status
    FROM {{ source('greenery', 'promos') }}
)

, promotion_transform AS (
    SELECT
        id
        , INITCAP(promo_id) AS promo_id
        , (discout::NUMERIC(5,2))
        , INITCAP(status) AS status
    FROM promotion_source
)

, promotion_rename AS (
    SELECT
        id AS promotion_id
        , promo_id AS promotion_code
        , discout AS promotion_discount_percentage
        , status AS promotion_status
    FROM promotion_transform
)

SELECT
    promotion_id
    , promotion_code
    , promotion_discount_percentage
    , promotion_status
FROM promotion_rename