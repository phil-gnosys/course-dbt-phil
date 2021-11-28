{{
    config(
        materialized = 'table',
        unique_key = 'web_event_type'
    )
}}

WITH web_event_type_stage AS (
    SELECT DISTINCT
        event_type AS web_event_type
    FROM {{ ref('stg_event') }}
)

SELECT 
    web_event_type
FROM web_event_type_stage