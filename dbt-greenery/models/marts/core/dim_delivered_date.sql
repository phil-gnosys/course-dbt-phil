{{
    config(
        materialized = 'view',
        unique_key = 'delivered_utc_date'
    )
}}

WITH delivered_date_stage AS (
    SELECT
        calendar_date AS delivered_utc_date
        , calendar_year AS delivered_utc_year
        , calendar_month AS delivered_utc_month
        , calendar_day AS delivered_utc_day
    FROM {{ ref('dim_date')}}
)

SELECT
    delivered_utc_date
    , delivered_utc_year
    , delivered_utc_month
    , delivered_utc_day
FROM delivered_date_stage