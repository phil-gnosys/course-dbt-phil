{{
    config(
        materialized = 'view',
        unique_key = 'user_guid'
    )
}}

WITH user_source AS (
    SELECT
        id
        , user_id
        , address_id
        , first_name
        , last_name
        , email
        , phone_number
        , created_at
        , updated_at
    FROM {{ source('greenery', 'users') }}
)

, user_rename AS (
    SELECT
        id AS user_id
        , user_id AS user_guid
        , address_id AS address_guid
        , first_name
        , last_name
        , email
        , phone_number
        , created_at AS created_utc_datetime
        , updated_at AS updated_utc_datetime
    FROM user_source
)

SELECT
    user_id
    , user_guid
    , address_guid
    , first_name
    , last_name
    , email
    , phone_number
    , created_utc_datetime
    , updated_utc_datetime
FROM user_rename