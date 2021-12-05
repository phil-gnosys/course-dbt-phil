# Ran out of time, may complete today / tomorrow if work permits.

# (1) Create new models to answer the first two questions (answer questions in README file)

## What is our overall conversion rate?

Query:
```sql
    SELECT SUM(web_session_checkout_count)/SUM(web_session_count) AS web_session_conversion_rate FROM dim_web_session;
```
```sql
-- definition of the web session dimension (fact)
{{
    config(
        materialized = 'table',
        unique_key = 'web_session_guid'
    )
}}

WITH web_session_stage AS (
    SELECT
        session_guid AS web_session_guid
        , COUNT(DISTINCT session_guid) AS web_session_count
        , COUNT(DISTINCT user_guid) AS web_session_user_count
        , COUNT(event_guid) AS web_session_event_count
        , MIN(created_utc_datetime) AS web_session_start_utc_datetime
        , MAX(created_utc_datetime) AS web_session_end_utc_datetime
        -- could be replaced with jinja macro to generate
        , SUM(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) AS web_session_page_view_count
        , SUM(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS web_session_add_to_cart_count
        , SUM(CASE WHEN event_type = 'delete_from_cart' THEN 1 ELSE 0 END) AS web_session_delete_from_cart_count
        , SUM(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END) AS web_session_checkout_count
        , SUM(CASE WHEN event_type = 'package_shipped' THEN 1 ELSE 0 END) AS web_session_package_shipped_count
        , SUM(CASE WHEN event_type = 'account_created' THEN 1 ELSE 0 END) AS web_session_account_created_count
        , SUM(CASE WHEN event_type NOT IN ('page_view','add_to_cart','delete_from_cart','checkout','account_created','package_shipped') THEN 1 ELSE 0 END ) AS web_session_other_event_count
    FROM {{ ref('stg_event') }}
    GROUP BY session_guid
)

SELECT
    web_session_guid
    , web_session_count
    , web_session_user_count
    , web_session_event_count
    , web_session_start_utc_datetime
    , web_session_end_utc_datetime
    , web_session_page_view_count
    , web_session_add_to_cart_count
    , web_session_delete_from_cart_count
    , web_session_checkout_count
    , web_session_package_shipped_count
    , web_session_account_created_count
    , web_session_other_event_count
FROM web_session_stage
```

Result: Our overall conversion rate is `36.10%`

## What is our conversion rate by product?

-- I have not guite got this right and ran out of time.

Query:
```sql
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
    , SUM(f.product_add_count - f.product_delete_count) AS product_in_cart
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
  , ((SUM(product_checkout) / SUM(product_in_cart)) * 100)::NUMERIC(5,2) AS product_conversion_rate
FROM session_product
WHERE product_in_cart IN (0,1)
GROUP BY
  product_guid
  , product_description
ORDER BY
  product_description
```

## (2) Create a macro to simplify part of a model(s).

TODO
```yml
```

## (3) Add a post hook to your project to apply grants to the role “reporting”

TODO

## (4) Install a package (i.e. dbt-utils, dbt-expectations) and apply one or more of the macros to your project

```yml
packages:
  - package: dbt-labs/dbt_utils
    version: 0.7.4
```

* `dbt_utils` was used across the project to simplify the development of some queries;

## Lineage Graph?

TODO - but build of underying facts and metrics to adhere to the DRY
