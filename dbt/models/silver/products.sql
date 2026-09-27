select distinct
    product_id::int as product_id,
    trim(product_name) as product_name,
    initcap(trim(category)) as category,
    price::numeric(10,2) as price,
    stock_qty::int as stock_qty
from {{ source('bronze', 'products') }}
