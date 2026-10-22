select
    customer_id,
    amount::numeric(10, 2) as amount
from {{ ref('bronze_orders') }}
where amount is not null
