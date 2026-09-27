select
    d::date as date,
    extract(year from d)::int as year,
    extract(month from d)::int as month,
    to_char(d, 'Mon') as month_name,
    extract(isodow from d)::int as weekday
from generate_series('2025-01-01'::date, '2026-12-31'::date, '1 day') as d
