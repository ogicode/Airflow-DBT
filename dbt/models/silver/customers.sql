select distinct
    customer_id::int as customer_id,
    trim(name) as name,
    upper(trim(country)) as country,
    signup_date::date as signup_date
from {{ source('bronze', 'customers') }}