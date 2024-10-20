-- Create table

create table if not exists car_service (
	date date,
	service varchar(50),
	service_addr varchar(50),
	w_name varchar(50),
	w_exp int,
	w_phone varchar(20),
	wages int,
	card varchar(30),
	payment int,
	pin int,
	name varchar(50),
	phone varchar(50),
	email varchar(50),
	password varchar(10),
	car varchar(20),
	mileage int,
	vin varchar(30),
	car_number varchar(10),
	color varchar(20)
);


-- 1NF

-- Service data

-- fill in null values in wages
update car_service as dst
set wages = src.wages
from car_service as src
where
  dst.w_name = src.w_name
  and dst.wages is null
  and src.wages is not null;

-- fill in null values in w_exp
update car_service as dst
set w_exp = src.w_exp
from car_service as src
where
  dst.w_name = src.w_name
  and dst.w_exp is null
  and src.w_exp is not null;
  
-- fill in empty strings in w_phone
update car_service as dst
set w_phone = src.w_phone
from car_service as src
where
  dst.w_name = src.w_name
  and dst.w_phone = ''
  and src.w_phone != '';

-- check number of unique w_name -> 45
select count(distinct cs.w_name)
from car_service cs;
 
-- check number of unique w_phone -> 44
select count(distinct cs.w_phone)
from car_service cs;
  
-- fill in empty strings in w_name based on w_phone
update car_service as dst
set w_name = src.w_name
from car_service as src
where
  dst.w_phone = src.w_phone
  and dst.w_name = ''
  and src.w_name != '';

-- fill in empty strings in service_addr
update car_service as dst
set service_addr = src.service_addr
from car_service as src
where
  dst.w_name = src.w_name
  and dst.service_addr = ''
  and src.service_addr != '';

-- fill in empty strings in service
update car_service as dst
set service = src.service
from car_service as src
where
  dst.w_name = src.w_name
  and dst.service = ''
  and src.service != '';


-- Client personal data
  
-- fill in empty strings in phone
update car_service as dst
set phone = src.phone
from car_service as src
where
  dst.name = src.name
  and dst.phone = ''
  and src.phone != '';

-- fill in empty strings in email
update car_service as dst
set email = src.email
from car_service as src
where
  dst.name = src.name
  and dst.email = ''
  and src.email != '';

-- fill in empty strings in password
update car_service as dst
set password = src.password
from car_service as src
where
  dst.name = src.name
  and dst.password = ''
  and src.password != '';
  
-- check number of unique name -> 524
select count(distinct cs.name)
from car_service cs;
 
-- check number of unique phone -> 524
select count(distinct cs.phone)
from car_service cs;
  
-- check number of unique email -> 524
select count(distinct cs.email)
from car_service cs;
  
-- fill in empty strings in name based on phone
update car_service as dst
set name = src.name
from car_service as src
where
  dst.phone = src.phone
  and dst.name = ''
  and src.name != '';

  
-- Client banking data
  
-- fill in null values in pin
update car_service as dst
set pin = src.pin
from car_service as src
where
  dst.card = src.card
  and dst.pin is null
  and src.pin is not null;

-- fill in null values in payment
update car_service as dst
set payment = src.payment
from car_service as src
where
  dst.card = src.card
  and dst.payment is null
  and src.payment is not null;
  
-- fill in empty strings in card based on pin
update car_service as dst
set card = src.card
from car_service as src
where
  dst.pin = src.pin
  and dst.card = ''
  and src.card != '';
  
-- fill in empty strings in card based on name
update car_service as dst
set card = src.card
from car_service as src
where
  dst.name = src.name
  and dst.card = ''
  and src.card != '';
  
-- fill in null values in pin based on name
update car_service as dst
set pin = src.pin
from car_service as src
where
  dst.name = src.name
  and dst.pin is null
  and src.pin is not null;
  
-- fill in null values in payment based on name
update car_service as dst
set payment = src.payment
from car_service as src
where
  dst.name = src.name
  and dst.payment is null
  and src.payment is not null;
  
  
-- Client car data

-- fill in empty strings in car
update car_service as dst
set car = src.car
from car_service as src
where
  dst.car_number = src.car_number
  and dst.car = ''
  and src.car != '';

-- fill in empty strings in color
update car_service as dst
set color = src.color
from car_service as src
where
  dst.car_number = src.car_number
  and dst.color = ''
  and src.color != '';
  
-- fill in null values in mileage
update car_service as dst
set mileage = src.mileage
from car_service as src
where
  dst.car_number = src.car_number
  and dst.mileage is null
  and src.mileage is not null;
  
-- fill in empty strings in vin
update car_service as dst
set vin = src.vin
from car_service as src
where
  dst.car_number = src.car_number
  and dst.vin = ''
  and src.vin != '';

-- fill in empty strings in car_number based on vin
update car_service as dst
set car_number = src.car_number
from car_service as src
where
  dst.vin = src.vin
  and dst.car_number = ''
  and src.car_number != '';
