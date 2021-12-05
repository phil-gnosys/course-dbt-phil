{{
    config(
        materialized = 'table',
        unique_key = 'web_session_guid'
    )
}}

WITH web_session_stage AS (
    SELECT
        session_guid AS web_session_guid
        , COUNT(DISTINCT session_guid) AS web_session_count
        , COUNT(DISTINCT user_guid) AS web_session_user_count
        , COUNT(event_guid) AS web_session_event_count
        , MIN(created_utc_datetime) AS web_session_start_utc_datetime
        , MAX(created_utc_datetime) AS web_session_end_utc_datetime
        -- could be replaced with jinja macro to generate
        , SUM(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) AS web_session_page_view_count
        , SUM(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS web_session_add_to_cart_count
        , SUM(CASE WHEN event_type = 'delete_from_cart' THEN 1 ELSE 0 END) AS web_session_delete_from_cart_count
        , SUM(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END) AS web_session_checkout_count
        , SUM(CASE WHEN event_type = 'package_shipped' THEN 1 ELSE 0 END) AS web_session_package_shipped_count
        , SUM(CASE WHEN event_type = 'account_created' THEN 1 ELSE 0 END) AS web_session_account_created_count
        , SUM(CASE WHEN event_type NOT IN ('page_view','add_to_cart','delete_from_cart','checkout','account_created','package_shipped') THEN 1 ELSE 0 END ) AS web_session_other_event_count
    FROM {{ ref('stg_event') }}
    GROUP BY session_guid
)

SELECT
    web_session_guid
    , web_session_count
    , web_session_user_count
    , web_session_event_count
    , web_session_start_utc_datetime
    , web_session_end_utc_datetime
    , web_session_page_view_count
    , web_session_add_to_cart_count
    , web_session_delete_from_cart_count
    , web_session_checkout_count
    , web_session_package_shipped_count
    , web_session_account_created_count
    , web_session_other_event_count
FROM web_session_stage
