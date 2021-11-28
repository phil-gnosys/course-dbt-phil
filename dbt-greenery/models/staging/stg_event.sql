{{
    config(
        materialized = 'view',
        unique_key = 'event_guid'
    )
}}

WITH event_source AS (
    SELECT
        id
        , event_id
        , session_id
        , user_id
        , page_url
        , created_at
        , event_type
    FROM {{ source('greenery', 'events') }}
)

, event_rename AS (
    SELECT
        id AS event_id
        , event_id AS event_guid
        , session_id AS session_guid
        , user_id AS user_guid
        , page_url
        , event_type
        , created_at AS created_utc_datetime
    FROM event_source
)

SELECT
    event_id
    , event_guid
    , session_guid
    , user_guid
    , page_url
    , event_type
    , created_utc_datetime
FROM event_rename