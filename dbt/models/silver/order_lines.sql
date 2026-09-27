select distinct
    order_id::int as order_id,
    product_id::int as product_id,
    qty::int as qty,
    (lower(trim(returned)) = 'yes') as returned
from {{ source('bronze', 'order_lines') }}
