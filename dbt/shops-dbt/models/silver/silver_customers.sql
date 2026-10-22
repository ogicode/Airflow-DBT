-- silver: cleaned customers
select
    customer_id,
    -- remove leading and trailing spaces from the name
    trim(name) as name
-- ref() points to the bronze model, dbt builds it first
from {{ ref('bronze_customers') }}