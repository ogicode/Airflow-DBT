-- gold: revenue per customer
select
    c.customer_id,
    c.name,
    -- sum of all order amounts, 0 if the customer has no orders
    coalesce(sum(o.amount), 0) as revenue
-- ref() points to the silver model, dbt builds it first
from {{ ref('silver_customers') }} c
-- left join keeps customers without orders
left join {{ ref('silver_orders') }} o on o.customer_id = c.customer_id
-- one row per customer
group by c.customer_id, c.name