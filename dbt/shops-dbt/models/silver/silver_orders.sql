-- silver: cleaned orders
select
    order_id,
    customer_id,
    -- cast to a number with 2 decimals (up to 10 digits total)
    amount::numeric(10, 2) as amount
-- ref() points to the bronze model, dbt builds it first
from {{ ref('bronze_orders') }}
-- drop orders without an amount
where amount is not null