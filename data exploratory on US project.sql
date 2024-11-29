# US Houshold income Explioratory data analysis

select *
from houseus; -- we have an ID column

select *
from uhi; -- we have an ID column

select state_name, SUM(Aland), SUM(awater)
from houseus
group by state_name
order by 3 DESC
limit 10; 

select d1.state_name, county, type, 'primary', mean, median
from houseus d1
inner join uhi d2
	on d1.id = d2.id
where mean <> 0;


# This query generates a row number for each row based on the average 'mean' in descending order.
# Selects the 'state_name' column from the 'houseus' table (aliased as d1) to show the state for each row.
# Calculates the average of the 'mean' column from the 'uhi' table, rounded to 1 decimal place, and labels it as 'avg_mean'.
# Calculates the average of the 'median' column from the 'uhi' table, rounded to 1 decimal place, and labels it as 'avg_median'.
# Performs an INNER JOIN between the 'houseus' table (d1) and the 'uhi' table (d2) based on the common 'id' column.

SELECT 
    ROW_NUMBER() OVER (ORDER BY AVG(mean) DESC) AS row_num, 
    d1.state_name, 
    ROUND(AVG(mean), 1) AS avg_mean, 
    ROUND(AVG(median), 1) AS avg_median
FROM houseus d1
INNER JOIN uhi d2
    ON d1.id = d2.id
WHERE mean <> 0
GROUP BY state_name
ORDER BY avg_mean DESC
LIMIT 10;

----

select type, count(type), round(avg(mean),1), round(avg(median),1)
from houseus d1
inner join uhi d2
	on d1.id = d2.id
where mean <> 0 
group by 1
order by 3 DESC
limit 20;
---- 

# let's remove outlires

select type, count(type), round(avg(mean),1), round(avg(median),1)
from houseus d1
inner join uhi d2
	on d1.id = d2.id
where mean <> 0 
group by 1
having count(type) > 100
order by 3 DESC
limit 20;

# we just filtered our type column by having filter 

select d1.state_name, city, round(avg(mean),1), round(avg(median),1)
from houseus d1
join uhi d2
	on d1.id = d2.id
group by d1.state_name, city
order by round(avg(mean),1) desc;
