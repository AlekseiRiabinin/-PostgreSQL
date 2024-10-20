-- 3NF

-- worker
drop table if exists workers;

create table if not exists workers (
	id int primary key generated always as identity,
	w_first_name varchar(20),
	w_last_name varchar(20),
	w_exp int,
	w_phone varchar(20),
	wages int
);

insert into workers (
	w_first_name,
	w_last_name,
	w_exp,
	w_phone,
	wages
)
select
	w_first_name,
	w_last_name,
	w_exp,
	w_phone,
	wages
from service_2nf
order by w_first_name;


alter table workers
add constraint unique_worker_id unique (id),
add constraint unique_worker_name unique (w_first_name, w_last_name);

create index w_name_idx on workers (w_first_name, w_last_name);

select * from workers;


-- address
drop table if exists addresses;

create table if not exists addresses (
	id int primary key generated always as identity,
	worker_id serial,
	service_addr varchar(50),
	service varchar(50)
);

insert into addresses (
	service_addr,
	service
)
select
	service_addr,
	service
from service_2nf;

alter table addresses
add constraint fk_addresses_workers
   	foreign key (worker_id)
   	references workers (id);

create index service_idx on addresses (service); 	

select * from addresses;


-- client
drop table if exists clients;

create table if not exists clients (
	id int primary key generated always as identity,
	first_name varchar(20),
	last_name varchar(20),
	phone varchar(50),
	email varchar(50),
	password varchar(10)
);

insert into clients (
	first_name,
	last_name,
	phone,
	email,
	password
)
select
	first_name,
	last_name,
	phone,
	email,
	password
from client_2nf
order by first_name;

alter table clients
add constraint unique_client_id unique (id),
add constraint unique_client_name unique (first_name, last_name);

create index name_idx on clients (first_name, last_name);

select * from clients;


-- worker-client
drop table if exists workers_clients;

create table if not exists workers_clients (
	id int primary key generated always as identity,
	worker_id int references workers (id),
	client_id int references clients (id),
	w_first_name varchar(20),
	w_last_name varchar(20),
	first_name varchar(20),
	last_name varchar(20)
);

insert into workers_clients (
	w_first_name,
	w_last_name,
	first_name,
	last_name
)
select
	w_first_name,
	w_last_name,
	first_name,
	last_name
from worker_client_2nf
order by w_first_name;

alter table workers_clients
add constraint unique_worker_client_id unique (id);

update workers_clients wc
set worker_id = (
	select w.id
	from workers w
	where w.w_first_name = wc.w_first_name
		and w.w_last_name = wc.w_last_name
);

update workers_clients wc
set client_id = (
	select c.id
	from clients c
	where c.first_name = wc.first_name
		and c.last_name = wc.last_name
);

alter table workers_clients
drop column w_first_name,
drop column w_last_name,
drop column first_name,
drop column last_name;

select * from workers_clients;
	

-- card
drop table if exists cards;

create table if not exists cards (
	id int primary key generated always as identity,
	client_id int references clients (id),
	card varchar(30),
	pin int,
	first_name varchar(20),
	last_name varchar(20)
);

insert into cards (
	card,
	pin,
	first_name,
	last_name
)
select
	card,
	pin,
	first_name,
	last_name
from banking_2nf
order by card;

alter table cards
add constraint unique_card_id unique (id);

update cards ca
set client_id = (
	select cl.id
	from clients cl
	where cl.first_name = ca.first_name
		and cl.last_name = ca.last_name
);

alter table cards
drop column first_name,
drop column last_name;

create index card_idx on cards (card);

select * from cards;


-- payment
drop table if exists payments;

create table if not exists payments (
	id int primary key generated always as identity,
	client_id int references clients (id),
	date date,
	payment int,
	first_name varchar(20),
	last_name varchar(20)
);

insert into payments (
	date,
	payment,
	first_name,
	last_name
)
select
	date,
	payment,
	first_name,
	last_name
from banking_2nf
order by date desc;

alter table payments
add constraint unique_payment_id unique (id);

update payments p
set client_id = (
	select c.id
	from clients c
	where c.first_name = p.first_name
		and c.last_name = p.last_name
);

alter table payments
drop column first_name,
drop column last_name;

create index payment_idx on payments (payment);

select * from payments;


-- vehicle
drop table if exists vehicles;

create table if not exists vehicles (
	id int primary key generated always as identity,
	client_id int references clients (id),
	car_number varchar(10),
	vin varchar(30),
	first_name varchar(20),
	last_name varchar(20)
);

insert into vehicles (
	car_number,
	vin,
	first_name,
	last_name
)
select
	car_number,
	vin,
	first_name,
	last_name
from car_2nf
order by car_number;

alter table vehicles
add constraint unique_vehicle_id unique (id);

update vehicles v
set client_id = (
	select c.id
	from clients c
	where c.first_name = v.first_name
		and c.last_name = v.last_name
);

alter table vehicles
drop column first_name,
drop column last_name;

create index car_number_idx on vehicles (car_number);

select * from vehicles;


-- mileage
drop table if exists mileages;

create table if not exists mileages (
	id int primary key generated always as identity,
	client_id int references clients (id),
	mileage int,
	first_name varchar(20),
	last_name varchar(20)
);

insert into mileages (
	mileage,
	first_name,
	last_name
)
select
	distinct mileage,
	first_name,
	last_name
from car_2nf
order by mileage desc;

alter table mileages
add constraint unique_mileage_id unique (id);

update mileages m
set client_id = (
	select c.id
	from clients c
	where c.first_name = m.first_name
		and c.last_name = m.last_name
);

alter table mileages
drop column first_name,
drop column last_name;

create index mileage_idx on mileages (mileage);

select * from mileages;
  	

-- client-model
drop table if exists clients_models;

create table if not exists clients_models (
	id int primary key generated always as identity,	
	client_id int references clients (id),
	car_id int,
	car varchar(20),
	first_name varchar(20),
	last_name varchar(20)
);

insert into clients_models (
	car,
	first_name,
	last_name
)
select
	distinct car,
	first_name,
	last_name
from car_2nf
order by car;

alter table clients_models
add constraint unique_model_id unique (id);

update clients_models cm
set client_id = (
	select cl.id
	from clients cl
	where cl.first_name = cm.first_name
		and cl.last_name = cm.last_name
);

alter table clients_models
drop column first_name,
drop column last_name;

with ranked_data as (
select *,
	dense_rank() over (order by car) as category_rank
from clients_models
)
update clients_models
set car_id = ranked_data.category_rank
from ranked_data
where clients_models.id = ranked_data.id;

select * from clients_models;


-- models
drop table if exists models;

create table if not exists models (
	id int primary key generated always as identity,
	car varchar(20)
);

insert into models (car)
select car
from clients_models 
group by car
order by car;

alter table models
add constraint unique_car_id unique (id);

create index car_idx on models (car);

alter table clients_models
add constraint fk_car
foreign key (car_id)
references models (id)
on delete cascade;

alter table clients_models
drop column car;

select * from models;


-- clent-color
drop table if exists clients_colors;

create table if not exists clients_colors (
	id int primary key generated always as identity,
	client_id int references clients (id),
	color_id int,
	color varchar(20),
	first_name varchar(20),
	last_name varchar(20)
);

insert into clients_colors (
	color,
	first_name,
	last_name
)
select
	distinct color,
	first_name,
	last_name
from car_2nf
order by color;

alter table clients_colors
add constraint unique_color_id unique (id);

update clients_colors cc
set client_id = (
	select cl.id
	from clients cl
	where cl.first_name = cc.first_name
		and cl.last_name = cc.last_name
);

alter table clients_colors
drop column first_name,
drop column last_name;

with ranked_data as (
select *,
	dense_rank() over (order by color) as category_rank
from clients_colors
)
update clients_colors
set color_id = ranked_data.category_rank
from ranked_data
where clients_colors.id = ranked_data.id;

drop index color_idx;

select * from clients_colors;

-- colors
drop table if exists colors;

create table if not exists colors (
	id int primary key generated always as identity,
	color varchar(20)
);

insert into colors (color)
select color
from clients_colors 
group by color
order by color;

alter table colors
add constraint unique_color_id unique (id);

create index color_idx on colors (color);

alter table clients_colors
add constraint fk_color
foreign key (color_id)
references colors (id)
on delete cascade;

alter table clients_colors
drop column color;

select * from colors;