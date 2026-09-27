select customer_id, name, country, signup_date
from {{ ref('customers') }}
