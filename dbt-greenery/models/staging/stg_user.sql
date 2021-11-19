{{
    config(
        materialized = 'view',
        unique_key = 'user_id'
    )
}}

with user_source as (
    select
        id
        , user_id
        , address_id
        , first_name
        , last_name
        , email
        , phone_number
        , created_at
        , updated_at
    from {{ source('greenery', 'users') }}
)

, user_rename as (
    select
        id as user_id
        , user_id as user_guid
        , address_id as address_guid
        , first_name
        , last_name
        , email
        , phone_number
        , created_at as created_utc_datetime
        , updated_at as updated_utc_datetime
    from user_source
)

select
    user_id
    , user_guid
    , address_guid
    , first_name
    , last_name
    , email
    , phone_number
    , created_utc_datetime
    , updated_utc_datetime
from user_rename