-- bronze: raw copy of the source table, no changes
-- source('shop', 'customers') = source "shop" + table "customers" from sources.yml
-- dbt compiles it to: select * from shop.customers
select * from {{ source('shop', 'customers') }}