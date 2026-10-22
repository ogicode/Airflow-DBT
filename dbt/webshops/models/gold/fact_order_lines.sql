select
    ol.order_id,
    o.order_date as date,
    o.customer_id,
    ol.product_id,
    ol.qty,
    ol.qty * p.price as revenue,
    ol.returned
from {{ ref('order_lines') }} ol
join {{ ref('orders') }} o on o.order_id = ol.order_id
join {{ ref('products') }} p on p.product_id = ol.product_id
