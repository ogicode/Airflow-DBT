select
    c.name,
    sum(o.amount) as revenue
from {{ ref('silver_customers') }} c
join {{ ref('silver_orders') }} o on o.customer_id = c.customer_id
group by c.name
