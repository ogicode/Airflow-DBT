select distinct
    order_id::int as order_id,
    customer_id::int as customer_id,
    order_date::date as order_date
from {{ source('bronze', 'orders') }}
