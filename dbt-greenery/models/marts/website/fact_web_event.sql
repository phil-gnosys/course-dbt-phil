{{
    config(
        materialized = 'table',
        unique_key = 'event_guid'
    )
}}

WITH web_event_stage AS (
    SELECT
        event_id AS web_event_id
        , event_guid AS web_event_guid
        , session_guid AS web_session_guid
        , user_guid
        , page_url AS web_page_url
        , REPLACE(page_url,'https://greenary.com/product/','') AS product_guid   
        , event_type AS web_event_type
        , (1::INTEGER) AS web_event_count
        , ((CASE WHEN event_type = 'account_created' THEN 1 ELSE 0 END)::INTEGER) AS account_created_count
        , ((CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END)::INTEGER) AS product_view_count             
        , ((CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END)::INTEGER) AS product_add_count
        , ((CASE WHEN event_type = 'delete_from_cart' THEN 1 ELSE 0 END)::INTEGER) AS product_delete_count
        , ((CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END)::INTEGER) AS order_placed_count
        , ((CASE WHEN event_type = 'package_shipped' THEN 1 ELSE 0 END)::INTEGER) AS order_shipped_count
        , created_utc_datetime
    FROM {{ ref('stg_event') }}
)

SELECT
   es.web_event_id
    , es.web_event_guid
    , es.web_session_guid
    , es.user_guid
    , es.web_page_url
    , COALESCE(dp.product_guid,'Not Applicable') product_guid
    , es.web_event_type
    , es.web_event_count
    , es.account_created_count
    , es.product_view_count
    , es.product_add_count
    , es.product_delete_count
    , es.order_placed_count
    , es.order_shipped_count
    , es.created_utc_datetime
FROM web_event_stage es
LEFT OUTER JOIN {{ ref('dim_product') }} dp
    ON es.product_guid = dp.product_guid
