{{
    config(
        materialized = 'view',
        unique_key = 'promo_id'
    )
}}

with promotion_source as (
    select
        id
        , promo_id
        , discout
        , status
    from {{ source('greenery', 'promos') }}
)

, promotion_rename as (
    select
        id as promotion_id
        , promo_id as promotion_code
        , discout as promotion_discount
        , status as promotion_status
    from promotion_source
)

select
    promotion_id
    , promotion_code
    , promotion_discount
    , promotion_status
from promotion_rename