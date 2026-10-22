-- bronze: raw copy of the source table, no changes
-- source('shop', 'orders') = source "shop" + table "orders" from sources.yml
-- dbt compiles it to: select * from shop.orders
select * from {{ source('shop', 'orders') }}