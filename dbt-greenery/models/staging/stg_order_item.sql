{{
    config(
        materialized = 'view',
        unique_key = 'order_id, product_id'
    )
}}

with order_item_source as (
    select
        id
        , order_id
        , product_id
        , quantity
    from {{ source('greenery', 'order_items') }}
)

, order_item_rename as (
    select
        id as order_item_id
        , order_id as order_guid
        , product_id as product_guid
        , quantity
    from order_item_source
)

select
    order_item_id
    , order_guid
    , product_guid
    , quantity
from order_item_rename