{{
    config(
        materialized = 'view',
        unique_key = 'estimated_delivery_utc_date'
    )
}}

WITH estimated_delivery_date_stage AS (
    SELECT
        calendar_date AS estimated_delivery_utc_date
        , calendar_year AS estimated_delivery_utc_year
        , calendar_month AS estimated_delivery_utc_month
        , calendar_day AS estimated_delivery_utc_day
    FROM {{ ref('dim_date')}}
)

SELECT
    estimated_delivery_utc_date
    , estimated_delivery_utc_year
    , estimated_delivery_utc_month
    , estimated_delivery_utc_day
FROM estimated_delivery_date_stage