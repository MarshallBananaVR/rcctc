 use rcttc;

insert into customer (first_name, last_name, address, email, phone)
select distinct customer_first,
				customer_last,
                customer_address,
                customer_email,
				customer_phone
from rcttc_data;
select * from customer;


insert into theater (theater_name, tt_address, tt_email, tt_phone)
select distinct 	theater,
					theater_address,
                    theater_email,
					theater_phone
from rcttc_data;
select * from theater;


insert into shows (title)
select distinct 'show' from rcttc_data;
insert into shows (title)
	values 	("High School Musical"),
	("Ocean: the life of Frank Ocean as performed by Frank Ocean"),
	("Wen");
select * from shows;
	
        
insert into performance (show_id, theater_id, show_date, price)
select distinct s.show_id ,
				t.theater_id,
                d.date,
                d.ticket_price
		from rcttc_data d
inner join shows s on d.show = s.title
inner join theater t on d.theater = t.name;

select * from performance;

insert into ticket (customer_id, performance_id, seat)
select distinct c.customer_id,
				p.performance_id,
                d.seat
from rcttc_data d
inner join customer c on d.customer_email  = c.email
inner join performance p 
on d.date = p.date 
and d.ticket_price = p.price;


select * from customer;
select * from theater;
select * from shows;
select * from performance;
select * from ticket;

-- The Little Fitz's 2021-03-01 performance of *The Sky Lit Up* is listed with a $20 ticket price. 
-- The actual price is $22.25 because of a visiting celebrity actor. (Customers were notified.) 
-- Update the ticket price for that performance only.

 select * from ticket
    where performance_id = 1 or performance_id = 2 or performance_id = 3 or performance_id = 4;

select distinct * from performance
where show_date = "2021-03-01"; -- 5

update performance 
set price = 22.25
    where performance_id = 5;

select * from performance 
where performance_id = 5; -- check the price change from $20.00 to $22.25.

-- In the Little Fitz's 2021-03-01 performance of *The Sky Lit Up*, Pooh Bedburrow and Cullen Guirau seat reservations aren't 
-- in the same row. Adjust seating so all groups are seated together in a row. This may require updates to all reservations 
-- for that performance. Confirm that no seat is double-booked and that everyone 
-- who has a ticket is as close to their original seat as possible.

select
c.first_name,
c.last_name,
t.seat,
p.show_date,
p.show_name
from customer c
join ticket t on t.customer_id = c.customer_id
join performance p on p.performance_id = t.performance_id
join theater th on th.theater_id = p.theater_id
where p.show_name = 'The Sky Lit Up' and p.show_date = '2021-03-01';

select * from ticket;

-- pooh ci = 37, cullen ci = 38, chiarra ci = 39, pi = 5

update ticket set
seat = 'B4'
where ticket_id = 98;

update ticket set
seat = 'C2'
where ticket_id = 100;

update ticket set
seat = 'A4'
where ticket_id = 101;

update customer set
phone = '1-801-EAT-CAKE'
where customer_id = 48;

select
th.theater_name,
c.first_name,
count(t.seat)
from customer c
join ticket t on t.customer_id = c.customer_id
join performance p on p.performance_id = t.performance_id
join theater th on th.theater_id = p.theater_id
where th.theater_name = '10 Pin'
group by first_name;

select 	p.performance_id ,
		c.customer_id ,
        c.first_name, 
        c.last_name ,
        th.name as theater_name,
        p.date,
        s.title, 
        p.price, 
        t.seat

from ticket t 
inner join customer c on t.customer_id = c.customer_id
inner join performance p on t.performance_id = p.performance_id 
inner join `show` s on p.show_id = s.show_id
inner join theater th on p.theater_id = th.theater_id
where date = "2021-03-01" and p.performance_id = 5
order by t.seat asc;

update ticket 
set seat = 'B4'
where performance_id = 5
and customer_id = 37 
and seat = 'A4';

update ticket 
set seat = 'C2'
where performance_id = 5
and customer_id = 38
and seat = 'B4';

update ticket 
set seat = 'A4'
where performance_id = 5
and customer_id = 39
and seat = 'C2';

-- Update Jammie Swindles's phone number from "801-514-8648" to "1-801-EAT-CAKE".

select  customer_id,
		first_name, 
		last_name,
        phone
from customer 
where first_name = "Jammie";

update customer
set phone = "1-801-EAT-CAKE"
where customer_id = 48;

-- Deletes

-- Delete *all* single-ticket reservations at the 10 Pin. (You don't have to do it with one query.)

select 	p.performance_id ,
		c.customer_id ,
        c.first_name, 
        c.last_name ,
        th.name,
        p.date,
        s.title, 
        p.price, 
        count(t.seat)

from ticket t 
inner join customer c on t.customer_id = c.customer_id
inner join performance p on t.performance_id = p.performance_id 
inner join `show` s on p.show_id = s.show_id
inner join theater th on p.theater_id = th.theater_id
where th.name = "10 pin"
group by customer_id , p.performance_id
having count(t.seat) = 1;

-- 2) Delete the customer Liv Egle of Germany. It appears their reservations were an elaborate joke.

select 	p.performance_id ,
		c.customer_id ,
        c.first_name, 
        c.last_name ,
        th.name,
        p.date,
        s.title, 
        p.price, 
        t.seat

from ticket t 
inner join customer c on t.customer_id = c.customer_id
inner join performance p on t.performance_id = p.performance_id 
inner join `show` s on p.show_id = s.show_id
inner join theater th on p.theater_id = th.theater_id
where c.first_name = "Liv";

-- customer_id 		= 65
-- performance_id 	= 11

-- delete
delete from ticket where customer_id = 65 and performance_id = 11;

-- check if the reservation for the customer_id 65 still available 
select * from ticket
where customer_id = 65




