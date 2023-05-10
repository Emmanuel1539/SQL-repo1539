 SELECT first_name,
		last_name,
        points,
        (points + 10) * 100 as 'discount_fator'
FROM store.customers;


select *
from store.customers
where birth_date <= '1990-01-01' and points <= 1000;

select *
from customers
where state in ('VA', 'FL', 'GA');

select *
from products
where quantity_in_stock in (49, 38,72);

select *
from customers
where points between 1000 and 3000;

select *
from customers
where birth_date between '1990-01-01' and '2000-01-01';

select *
from customers
where last_name regexp 'field|mac|rose';

-- this expression could be in form of 
-- ^ begginning
-- $ end
-- | logical or
-- [abcd]
-- [a-f]

-- Get the customers whose first name are ELKA or AMBUR

select *
from customers
where first_name regexp 'elka|ambur';

-- Get the customers whose last_name end with EY or ON

select *
from customers
where last_name regexp 'ey$|ron$';

-- Get the customers whose last name start with or contains SE
select *
from customers
where last_name regexp '^my|se';

-- Get the customers whose last name contains B followed bu R or uninstal
select *
from customers
where last_name regexp 'B[rU]';

-- Joining tables 
select order_id, first_name, last_name, o.customer_id
from orders o
join customers c
	on o.customer_id = c.customer_id;
    
-- Combing columns from different databases
select *
from order_items oi
join sql_inventory.products p
	on oi.product_id = p.product_id;
    

select order_id, p.product_id, quantity, oi.unit_price
from order_items oi
join products p 
	on oi.product_id = p.product_id;
 
 -- Joining multiple tables
select 
	o.customer_id,
    o.order_date,
    c.first_name,
    c.last_name,
    os.name as status
from orders o
join customers c
	on o.customer_id = c.customer_id
join order_statuses os
	on o.status = os.order_status_id;
    
select p.payment_id,
	p.invoice_id,
    p.amount,
    p.date,
    p.payment_method,
    c.name,
    c.state,
    pm.name
from payments p
join clients c
	on p.client_id = c.client_id
join payment_methods pm
	on pm.payment_method_id = p.payment_method;

select *
from order_items oi
join order_item_notes oin
	on oi.order_id = oin.order_id
    and oi.product_id = oin.product_id;

  -- implicit join syntax
  use store;
  select * 
  from orders o , customers c 
  where o.customer_id = c.customer_id;
  SELECT * FROM store.customers;

-- Outer join
select c.customer_id,
		c.first_name,
        o.order_id
from customers c
    left join orders o
		on c.customer_id = o.customer_id
	order by c.customer_id;
		
 select p.product_id,
		p.name,
        o.quantity
from products p 
    left join order_items o
		on p.product_id = o.product_id
	order by p.product_id;

  -- Joining multiple joins( inner and outer)
select
	c.customer_id,
	c.first_name,
	o.order_id
from customers c 
left join orders o 
	on c.customer_id = o.customer_id
left join shippers sh 
	on o.shipper_id = sh.shipper_id
order by c.customer_id;

-- USING clause (Use using clause where there's comon columns
select
	c.customer_id,
	c.first_name,
	o.order_id
from customers c 
join orders o 
	using(customer_id)
join shippers sh
	using(shipper_id);
  
  -- NATURAL JOIN 
  select 
	o.order_id,
    c.first_name
  from orders o
  natural join customers c;
  
-- UNION (combines row / records in table. 
use store;
select first_name
from customers
union
select name
from shippers;

-- Union must return same number of querrie
-- this example will produce an error
select first_name, last_name
from customers
union
select name
from shippers;

select customer_id, first_name, points, 'Bronze' as Type
from customers 
where points < 2000
UNION 
select customer_id, first_name, points, 'Silver' as Type
from customers
where points between 2000 and 3000
UNION
select customer_id, first_name, points, 'Gold' as Type
from customers
where points > 3000
order by first_name;

-- creating tables from tables
use sql_invoicing;

create table invoices_archived as
select 
	i.invoice_id,
    i.number,
    c.name as client,
    i.invoice_total,
    i.payment_total,
    i.invoice_date,
    i.payment_date,
    i.due_date
from invoices i
join clients c 
	using (client_id)
where payment_date is not null;ll

-- UPDATING TABLE
update invoices
set payment_total = default, payment_date = null
where invoice_id = 1;

update invoices
set payment_total = invoice_total * 0.5, 
	payment_date = due_date
where invoice_id = 	
				(select client_id
				from clients
				where name = 'Myworks');l

-- updating multiple rows 

	update invoices
	set payment_total = invoice_total * 0.5, 
		payment_date = due_date
	where invoice_id in	
					(select client_id
					from clients
					where state in ('CA', 'NY'))

update orders
set
	comments = 'Gold customer'
where customer_id in (
						select customer_id
						from customers
						where points > 3000)


-- Deleting records from tables

delet from invoices
where client_id = (
		select * 
        from clients
        where name = 'Myworks')








