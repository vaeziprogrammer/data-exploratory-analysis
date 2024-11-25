# world life expectancy project (data cleaning) we called our table as 'WLE' which stands world life expectancy as it's short and easy to write.


SELECT * 
FROM world_Life_expectency.wle
;

#first, let's find duplicte values in our rows 

SELECT Country, Year, CONCAT(country,' ', year), COUNT(CONCAT(country,' ', year))
FROM WLE
GROUP BY Country, Year, CONCAT(Country, year)
HAVING COUNT(CONCAT(Country, year)) > 1
;

# this is a simplified version:

SELECT Country, Year, COUNT(*) AS DuplicateCount
FROM WLE
GROUP BY Country, Year
HAVING COUNT(*) > 1;


# this code is specifically designed for identifying duplicate rows in our WorldLifeExpectancy dataset based on the combination of Country and Year.
SELECT *
FROM (
	SELECT Row_ID,
    CONCAT(Country, Year),
    ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
    FROM WLE
    ) AS Row_Table 
WHERE Row_Num > 1
;

# we found 3 duplicate rows in our dataset, let's delet this

DELETE FROM WLE
WHERE Row_ID IN (
    SELECT Row_ID FROM (
        SELECT Row_ID,
               ROW_NUMBER() OVER (PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
        FROM WLE
    ) AS Row_Table
    WHERE Row_Num > 1
);

# we need to turn off SQL safe mode update.
SET SQL_SAFE_UPDATES = 0;
-------


# first we need to indentify how many status are empty or NULLs


select *
from wle 
where status = ''
;

select *
from wle 
where status is null
;

SELECT COUNT(*)
FROM WLE
WHERE status is NULL
;

# and then we want to see only the unique values assigned status.
SELECT distinct(status)
From WLE
WHERE Status <> ''
;
# and then, seeing what counties are assigned to 'developing'
select distinct (Country), status
From WLE
where status = 'Developing';

# and the other way around
select distinct (Country), status
From WLE
where status = 'developed';

#so now we need to update that using JOIN clause:

UPDATE WLE t1
JOIN WLE t2
	ON t1.country = t2.country 
SET t1.status ='Developing' 
WHERE t1.status is NULL
AND t2.status IS NOT NULL
AND t2.status = 'Developing'
;

UPDATE WLE t1
JOIN WLE t2 
	ON t1.country = t2.country 
SET t1.status ='Developed'
WHERE t1.status is NULL
AND t2.status IS NOT NULL
AND t2.status = 'Developed'
;

select *
from wle;

SELECT Country, Year, COALESCE('life expectancy', 0) AS LifeExpectancy
FROM wle;


ALTER TABLE wle RENAME COLUMN `Life expectancy` TO life_expectancy;

UPDATE wle
SET life_expectancy = (
    SELECT avg_life_expectancy
    FROM (SELECT ROUND(life_expectancy) AS avg_life_expectancy
          FROM wle
          WHERE life_expectancy IS NOT NULL) AS avg_table
)
WHERE life_expectancy IS NULL;

UPDATE wle
SET life_expectancy = (
    SELECT avg_life_expectancy
    FROM (
        SELECT Country, AVG(life_expectancy) AS avg_life_expectancy
        FROM wle
        WHERE life_expectancy IS NOT NULL
        GROUP BY Country
    ) AS derived_table
    WHERE derived_table.Country = wle.Country
)
WHERE life_expectancy IS NULL;

UPDATE wle
SET life_expectancy = ROUND(life_expectancy, 1);



  




