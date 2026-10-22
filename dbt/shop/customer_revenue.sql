-- rebuild the table from scratch on every run
drop table if exists shop.customer_revenue;
-- total revenue per customer name
create table shop.customer_revenue as
select c.name, sum(o.amount) as revenue
from shop.customers c
-- inner join: customers without orders are left out
join shop.orders o on o.customer_id = c.customer_id
group by c.name;