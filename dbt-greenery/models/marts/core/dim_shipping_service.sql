{{
    config(
        materialized = 'table',
        unique_key = 'shipping_service_code'
    )
}}

WITH shipping_service_stage AS (
    SELECT DISTINCT
        COALESCE(shipping_service_code,'Not Applicable') AS shipping_service_code
    FROM {{ ref('stg_order') }}
)

SELECT 
    shipping_service_code
FROM shipping_service_stage