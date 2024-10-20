-- 2NF

-- Service data

-- all data
create table if not exists service_data as
select
	id,
	service,
	service_addr,
	w_name,
	w_exp,
	w_phone,
	wages
from car_service_1nf; 


-- service info
create table if not exists service_2nf as
select
	distinct w_name,
	w_exp,
	w_phone,
	wages,
	service,
	service_addr
from service_data;

alter table service_2nf
add column w_first_name varchar(20),
add column w_last_name varchar(20);

update service_2nf
set 
	w_first_name = split_part(w_name, ' ', 1),
	w_last_name = split_part(w_name, ' ', 2);

alter table service_2nf
drop column w_name;


-- Client data

-- all data
create table if not exists client_data as
select
	id,
	name,
	phone,
	email,
	password
from car_service_1nf; 

create table if not exists client_2nf as
select
	distinct name,
	phone,
	email,
	password
from client_data; 

alter table client_2nf
add column first_name varchar(20),
add column last_name varchar(20);

update client_2nf
set 
	first_name = split_part(name, ' ', 1),
	last_name = split_part(name, ' ', 2);

alter table client_2nf
drop column name;


-- Banking data

-- all data
create table if not exists banking_data as
select
	id,
	card,
	pin,
	payment,
	date,
	name
from car_service_1nf; 

create table if not exists banking_2nf as
select
	distinct card,
	pin,
	payment,
	date,
	name
from banking_data; 

alter table banking_2nf
add column first_name varchar(20),
add column last_name varchar(20);

update banking_2nf
set 
	first_name = split_part(name, ' ', 1),
	last_name = split_part(name, ' ', 2);

alter table banking_2nf
drop column name;


-- Car data

-- all data
create table if not exists car_data as
select
	id,
	car_number,
	vin,
	car,
	mileage,
	color,
	name
from car_service_1nf; 

create table if not exists car_2nf as
select
	distinct car_number,
	vin,
	car,
	mileage,
	color,
	name
from car_data;

alter table car_2nf
add column first_name varchar(20),
add column last_name varchar(20);

update car_2nf
set 
	first_name = split_part(name, ' ', 1),
	last_name = split_part(name, ' ', 2);

alter table car_2nf
drop column name;


-- Worker-Client data

-- all data
create table if not exists worker_client_data as
select
	id,
	w_name,
	name
from car_service_1nf; 

create table if not exists worker_client_2nf as
select
	w_name,
	name
from worker_client_data; 

alter table worker_client_2nf
add column w_first_name varchar(20),
add column w_last_name varchar(20),
add column first_name varchar(20),
add column last_name varchar(20);

update worker_client_2nf
set
	w_first_name = split_part(w_name, ' ', 1),
	w_last_name = split_part(w_name, ' ', 2),
	first_name = split_part(name, ' ', 1),
	last_name = split_part(name, ' ', 2);

alter table worker_client_2nf
drop column w_name,
drop column name;