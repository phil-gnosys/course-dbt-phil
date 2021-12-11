{{
    config(
        materialized = 'table',
        unique_key = 'web_session_guid'
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

WITH web_session_stage AS (
    SELECT
          session_guid AS web_session_guid
        , (1::INTEGER) AS site_visit_indicator
        {% for event_type in event_types %}
        , (MAX(CASE WHEN event_type = '{{ event_type }}' THEN 1 ELSE 0 END)::INTEGER) AS {{ event_type }}_indicator
        {% endfor %}
    FROM {{ ref('stg_event') }}
    GROUP BY session_guid
)

SELECT
    web_session_guid
    , site_visit_indicator
    {% for event_type in event_types %}
    , {{ event_type }}_indicator
    {% endfor %}
FROM web_session_stage
