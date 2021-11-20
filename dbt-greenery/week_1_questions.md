# Questions

    SET search_path TO dbt_phil_w;
 
### How many users do we have?

*130*

		select 
			count(user_id) 
		from 
			stg_user;

### On average, how many orders do we receive per hour?

*17*
		
		select 
			round(count(order_guid)/date_part('hours', MAX(created_utc_datetime) - MIN(created_utc_datetime))) 
		from 
			stg_order;

### On average, how long does an order take from being placed to being delivered?

*3 days 22 hours 13 minutes 10.504451 seconds*

		select 
			AVG(delivered_utc_datetime - created_utc_datetime)
		from 
			stg_order
		where
			order_status = 'delivered';

### How many users have only made one purchase? Two purchases? Three+ purchases?

*| One Purchase | Two Purchases | Three or more Purchases |*
*+--------------+---------------+-------------------------+*
*|           25 |            22 |                      81 |*
*+--------------+---------------+-------------------------+*

		with grouped_user as (
		select
			stg_user.user_guid,
			count(stg_order.order_guid) as purchase_count
		from
			stg_user
		left join
			stg_order
		ON
			stg_user.user_guid = stg_order.user_guid
		GROUP BY
			stg_user.user_guid
		)
			select
				COUNT(CASE WHEN purchase_count = 1 then 1 ELSE NULL END) as "One Purchase",
				COUNT(CASE WHEN purchase_count = 2 then 1 ELSE NULL END) as "Two Purchases",
				COUNT(CASE WHEN purchase_count > 2 then 1 ELSE NULL END) as "Three or more Purchases"
			FROM
				grouped_user;

### On average, how many unique sessions do we have per hour?

*0.11395659775789366*

	select count(DISTINCT(session_guid))/(Date_Part('days',MAX(created_utc_datetime) - MIN(created_utc_datetime))*24 
			+ Date_Part('hours',MAX(created_utc_datetime) - MIN(created_utc_datetime))) 
	from stg_event;