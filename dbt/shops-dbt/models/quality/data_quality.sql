-- data quality checks on raw source tables, one row per check
select 'customers' as table_name, 'total rows' as check_name, count(*) as value
from {{ source('shop', 'customers') }}
union all
select 'customers', 'missing name', count(*) - count(name)
from {{ source('shop', 'customers') }}
union all
select 'customers', 'duplicate customer_id', count(*) - count(distinct customer_id)
from {{ source('shop', 'customers') }}
union all
select 'orders', 'total rows', count(*)
from {{ source('shop', 'orders') }}
union all
select 'orders', 'missing amount', count(*) - count(amount)
from {{ source('shop', 'orders') }}
union all
select 'orders', 'duplicate order_id', count(*) - count(distinct order_id)
from {{ source('shop', 'orders') }}