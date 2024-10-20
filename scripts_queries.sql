-- 1. Создать таблицу скидок и дать скидку самым частым клиентам
select *,
	case
		when t.payment_count > 190 then t.payment_sum * 0.9
		else t.payment_sum * 1.0
	end as payment_discount
from (
	select 
		c.first_name,
		c.last_name,
		sum(p.payment) payment_sum,
		count(p.payment) payment_count
	from clients c
	join payments p on c.id = p.client_id
	group by
		c.first_name,
		c.last_name
	order by payment_count desc
) t;

-- 2. Поднять зарплату трем самым результативным механикам на 10%
select *,
	(t.wages * 1.1) new_wages
from (
	select
		w.w_first_name,
		w.w_last_name,
		w.wages,
		sum(p.payment) payment_sum
	from workers w
	join workers_clients wc on w.id = wc.worker_id
	join clients c on c.id = wc.client_id
	join payments p on c.id = p.client_id
	group by
		w.w_first_name,
		w.w_last_name,
		w.wages
	order by payment_sum desc
	limit 3
) t;

-- 3. Сделать представление для директора: филиал, количество заказов за последний месяц,
-- заработанная сумма, заработанная сумма за вычетом зарплат
select 
	a.service branch_office,
	count(p."date") orders_number_dec,
	sum(p.payment) payments_sum,
    (sum(p.payment) - sum(w.wages)) payments_wages_diff    
from workers w 
join addresses a on w.id = a.worker_id
join workers_clients wc on w.id = wc.worker_id
join clients c on c.id = wc.client_id
join payments p on p.client_id = wc.id
where extract (month from p."date") = 12
group by branch_office
order by payments_wages_diff desc;

-- 4. Сделать рейтинг самых надежных и ненадежных авто
select 
	m.car model,
	count(p."date") times_repare
from clients c 
join clients_models cm on c.id = cm.client_id
join models m on cm.client_id = m.id
join payments p on c.id = p.client_id
group by model
order by times_repare;

-- 5. Самый "удачный" цвет для каждой модели авто
select 
	m.car,
	c.color,
	sum(p.payment) payment_sum
from clients cl
join clients_models cm on cl.id = cm.client_id
join models m on cm.client_id = m.id
join payments p on cl.id = p.client_id
join clients_colors cc on cl.id = cc.client_id
join colors c on cc.color_id = c.id
group by
	m.car,
	c.color
order by payment_sum desc;
