-- 1) Simple Query 
-- Fetch top 5 successful BUY orders based on price

select order_id, date(created_at), metal_id, metal_quantity, price 
from orders
where order_status = 2 and order_type = 'buy'
order by price desc
limit 5;

-- 2) Aggregate 
-- Fetch total quantity bought and sold for each metal successfully

select m.metal_name, o.order_type, sum(o.metal_quantity) as total_quantity
from orders o, metals m
where o.metal_id = m.metal_id
and o.order_status = 2
group by 1,2
order by 2,1;

-- 3) Inner join/ Outer join
-- Find customers who have spent at least $100 on successful buy transactions

select c.first_name, c.last_name, c.phone, c.email, m.metal_name, sum(o.price) as total_spent
from orders o
left outer join customers c on c.cust_id = o.cust_id
left outer join metals m on m.metal_id = o.metal_id
where o.order_status = 2
group by 1,2,3,4,5
having sum(o.price) >= 100
order by 6 desc;

-- 4) Nested Query
-- Find agents who have referred at least 3 customers

select a.first_name, a.last_name, a.phone, a.email, a.city
from agents a
where a.referral_code in (select referred_by
						from customers
                        group by 1
                        having count(*) >= 3);
                        
-- 5) Correlated Query
-- Find customers who have made at least 4 transactions

select distinct c.first_name, c.last_name
from transactions t, orders o, customers c
where t.order_id = o.order_id and c.cust_id = o.cust_id
and 4 <= (select count(*)
				from transactions t2, orders o2, customers c2
                where t2.order_id = o2.order_id
                and o2.cust_id = c2.cust_id
                and c2.cust_id = c.cust_id);
                
-- 6) >=All/ >Any/ Exists/ Not Exists
-- Fetch largest successful order for each metal based on quantity

select m.metal_name, o.metal_quantity
from orders o, metals m
where o.metal_id = m.metal_id
and o.order_status = 2
and o.metal_quantity >= ALL (select o2.metal_quantity
								from orders o2
                                where o2.order_status = 2
                                and o2.metal_id = o.metal_id)
order by 1;

-- 7) Set Operations (Union)
-- Fetch all BUY orders which were placed in Miami or Los Angeles or have a price of more than $300

select o.order_id, o.created_at, m.metal_name, o.metal_quantity, o.price, o.city
from orders o, metals m
where o.metal_id = m.metal_id
and o.order_status = 2 and o.order_type = 'buy'
and o.price > 300
union
select o.order_id, o.created_at, m.metal_name, o.metal_quantity, o.price, o.city
from orders o, metals m
where o.metal_id = m.metal_id
and o.order_status = 2 and o.order_type = 'buy'
and o.city in ('Los Angeles','Miami');

-- 8) Subqueries in Select and From
-- Fetch day-on-day total buy orders, successful buy orders, sell orders and successful sell orders
select distinct date(w.created_at) as date,
(select count(*) 
	from orders o 
    where date(o.created_at) = date(w.created_at) 
    and o.order_type = 'buy') as buy_orders,
(select count(*) 
	from orders o2 
    where date(o2.created_at) = date(w.created_at) 
    and o2.order_type = 'buy' 
    and o2.order_status = 2) as successful_buy_orders,
(select count(*) 
	from orders o 
    where date(o.created_at) = date(w.created_at) 
    and o.order_type = 'sell') as sell_orders,
(select count(*) 
	from orders o2 
    where date(o2.created_at) = date(w.created_at) 
    and o2.order_type = 'sell' 
    and o2.order_status = 2) as successful_sell_orders
from webactivity w
order by 1;