select count(*) from alltrips;      

select weekday, count(*)
from alltrips
group by weekday
order by weekday desc;

##losing my mind ,cuz there was a problem with "trips_duration" data
select * from alltrips limit 1000;

select *,cast((ended_at - started_at) as time) as tripsduration from alltrips limit 1000;

select cast(trips_duration as time) from alltrips;

select time(trips_duration) from alltrips;

truncate table alltrips;

select * from alltrips;

select * from alltrips limit 1000;

truncate table alltrips;   ##figured the problem in the "trips_duration" column, it was set to datetime which caused an error

alter table alltrips modify trips_duration time;                      ##fixed it ;)

select weekday,
member_casual,
sec_to_time(avg(time_to_sec(trips_duration))) as avg_trips_duration,
count(*) as "no_of_trips"
from alltrips
group by member_casual,weekday;       ##query to check the no of rides and average trip duration of members and casuals on different days of the week

select
member_casual,
sec_to_time(avg(time_to_sec(trips_duration))) as avg_trips_duration,
count(*) as "no_of_trips"
from alltrips
group by member_casual;       ##query to check the no of rides and average trip duration of members and casuals in general

select month,
member_casual,
count(*),sec_to_time(avg(time_to_sec(trips_duration))) as duration
from alltrips
group by member_casual,month
order by month;                ##query to check the no of rides and average trip duration of members and casuals in the different seasons

select member_casual,
 start_station_name,
 count(*)
from alltrips
where start_station_name not like "N/A"
group by member_casual,start_station_name;       ## checked the number of trips taken from each station to determine the least and most popular stations for members and casuals






