{{
    config(
        materialized = 'view',
        unique_key = 'address_guid'
    )
}}

WITH address_source AS (
    SELECT
        id
        , address_id
        , address
        , zipcode
        , state
        , country
    FROM {{ source('greenery', 'addresses') }}
)

, address_rename AS (
    SELECT
        id AS address_id
        , address_id AS address_guid
        , address
        , zipcode
        , state
        , country
    FROM address_source
)

SELECT
    address_id
    , address_guid
    , address
    , zipcode
    , state
    , country
FROM address_rename