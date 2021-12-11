{{
    config(
        materialized = 'view',
        unique_key = 'session_guid'
    )
}}

WITH web_session_fact AS
(
  SELECT
    web_session_guid
    , site_visit_indicator
    , page_view_indicator
    , add_to_cart_indicator
    , checkout_indicator
  FROM {{ ref('fact_web_session') }}
)

SELECT
    SUM(site_visit_indicator) AS site_visit_indicator
    , SUM(page_view_indicator) AS page_view_indicator
    , SUM(add_to_cart_indicator) AS add_to_cart_indicator
    , SUM(checkout_indicator) AS checkout_indicator
    , (SUM(page_view_indicator * 100.00) / SUM(site_visit_indicator))::NUMERIC(5,2) AS page_view_percentage
    , (SUM(add_to_cart_indicator * 100.00) / SUM(site_visit_indicator))::NUMERIC(5,2) AS add_to_cart_percentage
    , (SUM(checkout_indicator * 100.00) / SUM(site_visit_indicator))::NUMERIC(5,2) AS checkout_percentage
FROM web_session_fact