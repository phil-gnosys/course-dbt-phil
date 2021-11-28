{{
    config(
        materialized = 'table',
        unique_key = 'calendar_date'
    )
}}

WITH date_spine AS
(
    {{
        dbt_utils.date_spine(
            datepart="day"
            , start_date="to_date('2018-01-01','YYYY-MM-DD')"
            , end_date="to_date('2025-12-31','YYYY-MM-DD')"
        )
    }}
)

, date_transform AS (
    SELECT
        (date_day::DATE) AS calendar_date
        , (DATE_PART('year',date_day)::INTEGER) AS calendar_year
        , (DATE_PART('month',date_day)::INTEGER) AS calendar_month
        , (DATE_PART('day',date_day)::INTEGER) AS calendar_day
        -- complete with other date parts
    FROM date_spine
)

SELECT 
    calendar_date
    , calendar_year
    , calendar_month
    , calendar_day
FROM date_transform

