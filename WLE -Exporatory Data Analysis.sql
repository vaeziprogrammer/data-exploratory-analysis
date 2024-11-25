# World Life Expectancy Project (Exporatory Data Analysis)

SELECT *
From wle
;

#first let's see the Min and Max of each counrie's life EX.

-- This query calculates the minimum and maximum life expectancy for each country, 
-- the difference between the maximum and minimum life expectancy (rounded to 1 decimal place),
-- and sorts the countries by the life expectancy increase in descending order.
-- It filters out countries where either the minimum or maximum life expectancy is 0.

SELECT Country, 
MIN(Life_expectancy), 
MAX(Life_expectancy),
ROUND(MAX(Life_expectancy) - MIN(Life_expectancy),1) AS Life_increase_15_Years
FROM wle
GROUP BY Country
HAVING MIN(Life_expectancy) <> 0
AND MAX(Life_expectancy) <> 0
ORDER BY Life_increase_15_Years DESC
; 

-- This query calculates the average life expectancy for each year,
-- rounding the result to 2 decimal places, 
-- and sorts the data in chronological order by year.
-- It filters out rows where life expectancy is 0.

select year, ROUND(AVG(life_expectancy),2) as ROUNDED
FROM wle 
WHERE life_expectancy <> 0
GROUP BY year
ORDER BY Year
;

select country, ROUND(AVG(life_expectancy), 1) AS Life_EXP, ROUND(AVG(GDP),1) AS GDP
FROM wle 
GROUP BY country
;

# let's see any 0 of Life_EXP
select country, ROUND(AVG(life_expectancy), 1) AS Life_EXP, ROUND(AVG(GDP),1) AS GDP
FROM wle 
GROUP BY country
ORDER BY Life_EXP ASC
;  

-- This query calculates the average life expectancy and average GDP for each country,
-- rounding both values to 1 decimal place. It filters out countries where either the average
-- life expectancy or average GDP is 0 or less. The results are then sorted by life expectancy 
-- in descending order.

select country, ROUND(AVG(life_expectancy), 1) AS Life_EXP, ROUND(AVG(GDP),1) AS GDP
FROM wle 
GROUP BY country
HAVING Life_EXP > 0
AND GDP > 0
ORDER BY Life_EXP DESC
;

-- This query categorizes and analyzes data based on GDP levels (>= 1500 or <= 1500):
-- "If the condition is true (GDP >= 1500), it adds 1; otherwise, it adds 0."

SELECT 
    SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) AS High_GDP_Count,
    AVG(CASE WHEN GDP >= 1500 THEN life_expectancy ELSE NULL END) AS High_GDP_life_expectancy,
    SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) AS Low_GDP_Count,
    AVG(CASE WHEN GDP <= 1500 THEN life_expectancy ELSE NULL END) AS Low_GDP_life_expectancy
FROM wle;

------  

SELECT Status, ROUND(AVG(life_expectancy),1)
FROM wle
GROUP BY Status
;

SELECT status, COUNT(distinct country), ROUND(AVG(life_expectancy),1)
from wle 
group by status
;

------

-- let's comparing 

select country, round(avg(life_expectancy),1) as life_exp, round(avg(bmi),1) as bmi
from wle
group by country
having life_exp > 0
and bmi > 0
order by bmi asc
;

-------

-- let's take a look at 'Adult mortanlity' 

select country,
year,
life_expectancy,
'Adult Mortality',
sum('Adult Mortality') over(partition by country order by year) as rolling_total
from wle
where country like '%united%'
;






 


    

