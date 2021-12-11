{{
    config(
        materialized = 'table',
        unique_key = 'web_event_guid'
    )
}}

{%
    set event_types = [
        "add_to_cart",
        "checkout",
        "delete_from_cart",
        "package_shipped",
        "page_view",
        "account_created",
]
%}

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
        {% for event_type in event_types %}
        , ((CASE WHEN event_type = '{{ event_type }}' THEN 1 ELSE 0 END)::INTEGER) AS {{ event_type }}_count
        {% endfor %}
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
    {% for event_type in event_types %}
    , es.{{ event_type }}_count
    {% endfor %}
    , es.created_utc_datetime
FROM web_event_stage es
LEFT OUTER JOIN {{ ref('dim_product') }} dp
    ON es.product_guid = dp.product_guid
