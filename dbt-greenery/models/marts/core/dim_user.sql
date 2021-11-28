{{
    config(
        materialized = 'table',
        unique_key = 'user_guid'
    )
}}

WITH address_stage AS (
    SELECT
        address_guid
        , address AS user_address
        , zipcode AS user_zipcode
        , state AS user_state
        , country AS user_country
    FROM {{ ref('stg_address') }}
)

, user_stage AS (
    SELECT
        user_id
        , user_guid
        , address_guid
        , first_name
        , last_name
        , CONCAT(first_name,' ',last_name) AS full_name
        , email
        , phone_number
        , (created_utc_datetime::DATE) AS user_since_utc_date
        , updated_utc_datetime
    FROM {{ ref('stg_user') }}
)

SELECT
    us.user_id
    , us.user_guid
    , us.first_name
    , us.last_name
    , us.full_name
    , us.email
    , us.phone_number
    , a.user_address
    , a.user_zipcode
    , a.user_state
    , a.user_country    
    , us.user_since_utc_date
FROM user_stage us
INNER JOIN address_stage a
    ON us.address_guid = a.address_guid