{{
    config(
        materialized = 'view',
        unique_key = 'address_id'
    )
}}

with address_source as (
    select
        id
        , address_id
        , address
        , zipcode
        , state
        , country
    from {{ source('greenery', 'addresses') }}
)

, address_rename as (
    select
        id as address_id
        , address_id as address_guid
        , address
        , zipcode
        , state
        , country
    from address_source
)

select
    address_id
    , address_guid
    , address
    , zipcode
    , state
    , country
from address_rename