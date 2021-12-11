{{
    config(
        materialized = 'table',
        unique_key = 'web_session_guid'
    )
}}

WITH web_session_stage AS (
    SELECT
          session_guid AS web_session_guid
        , (1::INTEGER) AS web_session_count
        , MAX((CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END)::INTEGER) AS product_view_count     
        , MAX((CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END)::INTEGER) AS product_add_count
        , MAX((CASE WHEN event_type = 'delete_from_cart' THEN 1 ELSE 0 END)::INTEGER) AS product_delete_count            
        , MAX((CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END)::INTEGER) AS order_placed_count
        , MAX((CASE WHEN event_type = 'account_created' THEN 1 ELSE 0 END)::INTEGER) AS account_created_count
        , MAX((CASE WHEN event_type = 'package_shipped' THEN 1 ELSE 0 END)::INTEGER) AS order_shipped_count
    FROM {{ ref('stg_event') }}
    GROUP BY session_guid
)

SELECT
    wss.web_session_guid
    , wss.web_session_count
    , wss.product_view_count
    , wss.product_add_count
    , wss.product_delete_count
    , wss.account_created_count    
    , wss.order_placed_count
    , wss.order_shipped_count
FROM web_session_stage wss
