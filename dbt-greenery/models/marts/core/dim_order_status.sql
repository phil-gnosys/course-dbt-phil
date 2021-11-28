{{
    config(
        materialized = 'table',
        unique_key = 'order_status'
    )
}}

WITH order_status_stage AS (
    SELECT DISTINCT
        order_status
    FROM {{ ref('stg_order') }}
)

SELECT 
    order_status
FROM order_status_stage