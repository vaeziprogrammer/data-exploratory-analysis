-- This is going to be a data exploratory analysis from a dataset about covid19 that published on https://ourworldindata.org/covid-deaths
-- we are going to select data that we are going to be using 

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.coviddeath
ORDER BY 1,2

-- now we are going to be looking at total_caes vs total_deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS 'death percentage'
FROM PortfolioProject.coviddeath
ORDER BY 1,2

-- we can also see our country's status to see how many deaths were there.

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS 'death percentage'
FROM PortfolioProject.coviddeath
WHERE location LIKE '%Afghanistan%'
ORDER BY 1,2

-- looking at total_caes vs population
-- this shows what percentage of population got covid

SELECT location, date, population, total_cases, (total_cases/population) * 100 AS 'percet population infected'
FROM PortfolioProject.coviddeath
ORDER BY 1,2

-- Looking at countries with highset infection compared to population 

SELECT location, population, MAX(total_cases) AS 'Highest Infection Rate', MAX((total_cases/population)) * 100 AS 'percet population infected'
				FROM PortfolioProject.coviddeath
				GROUP BY location, population
				ORDER BY 'percet population infected' DESC
				
-- now, we are showing countries with highest death count per population 

SELECT location, MAX(total_deaths) AS 'total death count'
FROM PortfolioProject.coviddeath 
GROUP BY location
ORDER BY 2 DESC 

-- trying to convert the total_deaths format to INT and then excluding continent is NULL

SELECT location, MAX(CAST(total_deaths AS SIGNED)) AS totalDeathCount
FROM PortfolioProject.coviddeath
WHERE continent IS NOT NULL 
GROUP BY location
ORDER BY totalDeathCount DESC
				
-- Let's break things down by continent

SELECT continent, MAX(CAST(total_deaths AS SIGNED)) AS totalDeathCount
FROM PortfolioProject.coviddeath
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY totalDeathCount DESC

-- GLOBAL NUMBER 
SELECT date, SUM(new_cases), SUM(cast(new_deaths as SIGNED)), SUM(CAST(new_deaths as SIGNED))/SUM(new_cases)*100 as deathpercentage
FROM PortfolioProject.coviddeath
WHERE continent is not null 
GROUP BY date
ORDER BY 1,2

-- Let's join two table together
SELECT *
FROM PortfolioProject.coviddeath dea
JOIN PortfolioProject.covidvaccination vac
	on dea.location = vac.location 
	and dea.date = vac.date
	
-- USE CTE 

WITH Popvsvac AS (
    SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS SIGNED)) OVER (
            PARTITION BY dea.location
            ORDER BY dea.date
        ) AS rollingpeoplevaccinated
    FROM
        PortfolioProject.coviddeath dea
        JOIN PortfolioProject.covidvaccination vac ON dea.location = vac.location AND dea.date = vac.date
    WHERE
        dea.continent IS NOT NULL
)
SELECT
    *,
    (rollingpeoplevaccinated / CAST(dea.population AS DECIMAL)) * 100 AS vaccination_percentage
FROM
    Popvsvac;

-- creating view to store data for later visulazations 
CREATE view percentpoppulationvaccinated AS
SELECT dea.continent 
