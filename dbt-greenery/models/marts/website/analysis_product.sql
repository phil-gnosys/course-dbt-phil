
{{
    config(
        materialized = 'view',
        unique_key = 'product_guid'
    )
}}

WITH session_product AS
(
  SELECT
    f.web_session_guid
    , f.product_guid
    , dp.product_description
    , SUM(f.add_to_cart_count) AS add_to_cart_count
    , MAX(ds.web_session_checkout_count) AS product_checkout
  FROM {{ ref('fact_web_event') }} f
  INNER JOIN {{ ref('dim_web_session') }} ds
    ON f.web_session_guid = ds.web_session_guid
  INNER JOIN {{ ref('dim_product') }} dp
    ON f.product_guid = dp.product_guid
  WHERE f.product_guid <> 'Not Applicable'
  GROUP BY
    f.web_session_guid
    , f.product_guid
    , dp.product_description
)

SELECT
  product_guid
  , product_description
  , ((SUM(product_checkout) / SUM(add_to_cart_count)) * 100)::NUMERIC(5,2) AS product_conversion_rate
FROM session_product
WHERE add_to_cart_count IN (0,1)
GROUP BY
  product_guid
  , product_description
ORDER BY
  product_description

