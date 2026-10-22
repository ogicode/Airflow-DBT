select product_id, product_name, category, price, stock_qty
from {{ ref('products') }}
