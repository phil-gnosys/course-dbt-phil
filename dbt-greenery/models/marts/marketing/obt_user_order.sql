{{
    config(
        materialized = 'table',
        unique_key = 'user_guid,order_guid'
    )
}}

SELECT
    du.user_guid
    , fo.order_guid
    , du.user_address
    , du.user_zipcode
    , du.user_state
    , du.user_country
    , du.email
    , du.phone_number
    , du.user_since_utc_date
    , fo.order_utc_date
    , fo.order_count
    , fo.order_total_amount
    , dp.promotion_type
    , dp.promotion_code
FROM {{ ref('fact_order') }} fo
INNER JOIN {{ ref('dim_user') }} du
    ON fo.user_guid = du.user_guid
INNER JOIN {{ ref('dim_promotion') }} dp 
    ON fo.promotion_code = dp.promotion_code
INNER JOIN {{ ref('dim_order_date') }} dod
    ON fo.order_utc_date = dod.order_utc_date

