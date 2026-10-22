select
    c.customer_id,
    c.name,
    coalesce(sum(o.amount), 0) as revenue
from {{ ref('silver_customers') }} c
left join {{ ref('silver_orders') }} o on o.customer_id = c.customer_id
group by c.customer_id, c.name
