-- data quality checks on raw source tables, one row per check

-- step 1: compute every check as one row
-- value = actual result, min/max = allowed range (null = no limit), severity = how bad a failure is
with checks as (
    -- customers: table must have between 1 and 100 rows
    select 'customers' as table_name, 'total rows' as check_name, count(*) as value,
           1 as min_value, 100 as max_value, 'fail' as severity
    from {{ source('shop', 'customers') }}
    union all
    -- customers: count(name) skips nulls, so the difference = rows with no name
    select 'customers', 'missing name', count(*) - count(name), 0, 0, 'warn'
    from {{ source('shop', 'customers') }}
    union all
    -- customers: all rows minus distinct ids = number of duplicate ids
    select 'customers', 'duplicate customer_id', count(*) - count(distinct customer_id), 0, 0, 'fail'
    from {{ source('shop', 'customers') }}
    union all
    -- customers: names longer than 100 characters (likely bad input)
    select 'customers', 'name too long', count(*) filter (where length(name) > 100), 0, 0, 'warn'
    from {{ source('shop', 'customers') }}
    union all
    -- orders: table must have between 1 and 100 rows
    select 'orders', 'total rows', count(*), 1, 100, 'fail'
    from {{ source('shop', 'orders') }}
    union all
    -- orders: rows with no amount
    select 'orders', 'missing amount', count(*) - count(amount), 0, 0, 'warn'
    from {{ source('shop', 'orders') }}
    union all
    -- orders: number of duplicate order ids
    select 'orders', 'duplicate order_id', count(*) - count(distinct order_id), 0, 0, 'fail'
    from {{ source('shop', 'orders') }}
    union all
    -- orders: amount must be above 0 and at most 1 billion
    -- count(*) filter counts only rows matching the condition
    select 'orders', 'amount out of range', count(*) filter (where amount <= 0 or amount > 1000000000), 0, 0, 'fail'
    from {{ source('shop', 'orders') }}
)

-- step 2: compare each value to its range and set the status
select
    table_name,
    check_name,
    value,
    min_value,
    max_value,
    severity,
    -- coalesce(min_value, value): if there is no limit, compare value to itself, which always passes
    -- inside the range = pass, outside = the check's severity (warn or fail)
    case
        when value >= coalesce(min_value, value)
         and value <= coalesce(max_value, value) then 'pass'
        else severity
    end as status,
    -- time of this dbt run
    now() as checked_at
from checks