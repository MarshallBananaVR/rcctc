use rcttc;

-- Find all performances in the last quarter of 2021 (Oct. 1, 2021 - Dec. 31 2021).

select * from performance 
where show_date between '2021-10-01' and '2022-01-01';

-- List customers without duplication.

select distinct first_name, last_name, customer_id
 from customer; 

-- Find all customers without a .com email address.

select * from customer 
where not email_address like '%.com' ;

-- Find the three cheapest shows.

select 
	  s.title,
      p.show_id
from performance p 
inner join shows s on p.show_id= s.show_id 
order by p.price asc
 limit 3;

-- List customers and the show they're attending with no duplication.

select 	distinct 	c.first_name,
					c.last_name,
					s.title
from customer c
inner join ticket t on c.customer_id = t.customer_id
inner join performance p on t.performance_id = p.performance_id
inner join shows s on p.show_id = s.show_id;

-- List customer, show, theater, and seat number in one query.

select 	c.first_name, 
		c.last_name,
		s.title,
		th.theater_name,
		t.seat_name
from customer c
inner join ticket t on c.customer_id = t.customer_id
inner join performance p on t.performance_id = p.performance_id
inner join shows s on s.show_id = p.show_id
inner join theater th on p.theater_id = th.theater_id;

-- Find customers without an address.

select * from customer 
where address = '';

-- Recreate the spreadsheet data with a single query.

select 	c.first_name, 
		c.last_name,
        c.email_address,
        c.phone,
        c.physical_address,
        t.seat_name,
        s.title,
        p.price,
        p.show_date,
        th.theater_name ,
        th.theater_address,
        th.phone,
        th.email
from customer c
inner join ticket t on c.customer_id = t.customer_id
inner join performance p on t.performance_id = p.performance_id
inner join shows s on s.show_id = p.show_id
inner join theater th on p.theater_id = th.theater_id;


-- Count total tickets purchased per customer.

select 	c.first_name, c.last_name, 
	count(t.seat_name)  as customer_tickets
from customer c
inner join ticket t on c.customer_id = t.customer_id
group by c.customer_id;


-- Calculate the total revenue per show based on tickets sold.

select
p.show_name,
sum(p.ticket_price) revenue
from performance p
join ticket t on t.performance_id = p.performance_id
group by p.show_name;

-- Calculate the total revenue per theater based on tickets sold.

select th.theater_name, sum(p.price) as total_revenue
from theater th
inner join performance p on th.theater_id = p.theater_id
inner join ticket t on p.performance_id = t.performance_id 
group by p.theater_id;

-- Who is the biggest supporter of RCTTC? Who spent the most in 2021?

select 	c.first_name, c.last_name, sum(p.price) as purchases
from customer c 
inner join ticket t on c.customer_id = t.customer_id
inner join performance p on t.performance_id = p.performance_id
group by c.customer_id
order by purchases desc 
limit 1;