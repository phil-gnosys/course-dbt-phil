{{
    config(
        materialized = 'table',
        unique_key = 'order_guid'
    )
}}

WITH promotion_stage AS (
    SELECT
        promotion_code
        , promotion_discount_percentage
        , promotion_status
    FROM {{ ref('dim_promotion') }}
)

, order_item_stage AS (
    SELECT
        order_guid
        , SUM(order_product_quantity) AS order_product_quantity
        , COUNT(product_guid) AS order_product_count
    FROM {{ ref('stg_order_item') }}
    GROUP BY
        order_guid
)

, order_stage AS (
    SELECT
        order_id
        , order_guid
        , user_guid
        , COALESCE(promotion_code,'No Promotion') AS promotion_code
        , address_guid
        , tracking_guid
        , COALESCE(shipping_service_code,'Not Applicable') AS shipping_service_code
        , order_status
        , order_product_amount
        , order_shipping_amount
        , order_total_amount
        , created_utc_datetime::DATE AS order_utc_date    
        , estimated_delivery_utc_datetime::DATE AS estimated_delivery_utc_date
        , delivered_utc_datetime::DATE AS delivered_utc_date
    FROM {{ ref('stg_order') }}
)

SELECT
    os.order_guid
    , os.user_guid
    , os.promotion_code
    , os.address_guid
    , os.tracking_guid
    , os.shipping_service_code
    , os.order_status
    , os.order_utc_date
    , os.estimated_delivery_utc_date
    , os.delivered_utc_date
    , (1::INTEGER) AS order_count
    , ((CASE
        WHEN os.order_status = 'Delivered' THEN 1
        ELSE 0
        END)::INTEGER) order_delivered_count
    , ((CASE 
        WHEN os.order_status = 'Delivered' AND os.delivered_utc_date > os.estimated_delivery_utc_date THEN 1
        ELSE 0
        END)::INTEGER) order_late_delivery_count
    , ((os.order_total_amount / ((100 - ps.promotion_discount_percentage)/100))::NUMERIC(15,2)) AS order_gross_amount
    , (((os.order_total_amount / ((100 - ps.promotion_discount_percentage)/100)) - os.order_total_amount)::NUMERIC(15,2)) AS order_discount_amount
    , os.order_total_amount
    , os.order_product_amount
    , os.order_shipping_amount
    , ois.order_product_count
    , ois.order_product_quantity
FROM order_stage os
INNER JOIN order_item_stage ois
    ON os.order_guid = ois.order_guid
LEFT OUTER JOIN promotion_stage ps
    ON os.promotion_code = ps.promotion_code

