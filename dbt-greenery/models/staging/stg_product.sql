{{
    config(
        materialized = 'view',
        unique_key = 'product_id'
    )
}}

with product_source as (
    select
        id
        , product_id
        , name
        , price
        , quantity
    from {{ source('greenery', 'products') }}
)

, product_rename as (
    select
        id as product_id
        , product_id as product_guid
        , name as product_description
        , price as product_price
        , quantity as product_quantity
    from product_source
)

select
    product_id
    , product_guid
    , product_description
    , product_price
    , product_quantity
from product_rename