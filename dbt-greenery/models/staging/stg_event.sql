{{
    config(
        materialized = 'view',
        unique_key = 'event_id'
    )
}}

with event_source as (
    select
        id
        , event_id
        , session_id
        , user_id
        , page_url
        , created_at
        , event_type
    from {{ source('greenery', 'events') }}
)

, event_rename as (
    select
        id as event_id
        , event_id as event_guid
        , session_id as session_guid
        , user_id as user_guid
        , page_url
        , event_type
        , created_at as created_utc_datetime
    from event_source
)

select
    event_id
    , event_guid
    , session_guid
    , user_guid
    , page_url
    , event_type
    , created_utc_datetime
from event_rename