{{
    config(
        materialized = 'table',
        unique_key = 'address_guid'
    )
}}

WITH address_stage AS (
    SELECT
        address_id
        , address_guid
        , address
        , zipcode
        , state
        , country
    FROM {{ ref('stg_address') }}
)

SELECT
        address_id
        , address_guid
        , address
        , zipcode
        , state
        , country
FROM address_stage