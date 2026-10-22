drop table if exists shop.customer_revenue;
create table shop.customer_revenue as
select c.name, sum(o.amount) as revenue
from shop.customers c
join shop.orders o on o.customer_id = c.customer_id
group by c.name;