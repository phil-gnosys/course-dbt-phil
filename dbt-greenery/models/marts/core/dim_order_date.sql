{{
    config(
        materialized = 'view',
        unique_key = 'order_utc_date'
    )
}}

WITH order_date_stage AS (
    SELECT
        calendar_date AS order_utc_date
        , calendar_year AS order_utc_year
        , calendar_month AS order_utc_month
        , calendar_day AS order_utc_day
    FROM {{ ref('dim_date')}}
)

SELECT
    order_utc_date
    , order_utc_year
    , order_utc_month
    , order_utc_day
FROM order_date_stage