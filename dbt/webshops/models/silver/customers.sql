-- mostly postgres syntax
-- drops duplicates
select distinct
-- converts the ID to an integer
customer_id::int as customer_id,
-- removes spaces at the start and end of the name
trim(name) as name,
-- removes spaces and makes it uppercase
upper(trim(country)) as country,
-- converts it to a date
signup_date::date as signup_date
-- reads from the table bronze.customers
from {{ source('bronze', 'customers') }}

-- dbt run --select customers
-- starts from, select, distinct