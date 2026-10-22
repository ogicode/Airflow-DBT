select
    customer_id,
    trim(name) as name
from {{ ref('bronze_customers') }}
