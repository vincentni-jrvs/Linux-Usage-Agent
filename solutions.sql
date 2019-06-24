-- PGPASSWORD=password psql -U postgres -h localhost -f query.sql
-- connect host_agent;
--1.
select cpu_number, id as host_id, total_mem from host_info order by cpu_number, total_mem desc;

--2.
select a.hostid, a.hostname, a.total_mem, avg(used_memory) over(partition by round_time) as used_memory_percentage_avg
from
(select u.host_id as hostid, i.hostname as hostname, i.total_mem as total_mem, (i.total_mem - u.memory_free) * 100 / i.total_mem as used_memory,
date_trunc('hour',u."timestamp") + interval '5 minute' * round(date_part('minute', u."timestamp") / 5.0) as round_time
from host_usage as u
inner join host_info as i
on u.host_id = i.id) as a
group by a.hostid, a.hostname, a.total_mem, used_memory, round_time


