
-- Select the database for the project
USE ProjectDB
GO

/*
This is a Covid 19 Data Exploration Project 
Skills used: SELECT, Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Data Types Casting/Conversion
*/

-- A quick overview of the Covid deaths table
SELECT *
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,		-- order by location (i.e column 3)
         4		-- order by date (i.e column 4)

----------------------------------------------------------

-- Selecting Specific data for the analysis

SELECT
  location, 
  date, 
  total_cases, 
  total_deaths,
  population
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date;

-------------------------------------------------------------------
-- Total Cases vs Total Deaths for all locations
-- Shows likelihood of dying if you contract covid per country

SELECT
  location, 
  date, 
  total_cases, 
  total_deaths,
  (total_deaths/total_cases) * 100 AS DeathPercent
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;
-------------------------------------------------------------------

-- Total Cases vs Total Deaths for locations that jas the word States in them
-- This Shows the likelihood of dying should one contract covid in UNited states

SELECT
  location, 
  date, 
  total_cases, 
  total_deaths,
  (total_deaths/total_cases) * 100 AS DeathPercent
FROM CovidDeaths
WHERE location LIKE '%states%'
AND continent IS NOT NULL
ORDER BY 1, 2;

-------------------------------------------------------------------
-- Total Cases vs Population
-- Shows what percentage of population is infected with Covid

SELECT
  location, 
  date, 
  population,
  total_cases, 
  (total_cases/population) * 100 AS PercentPopInfected
FROM CovidDeaths
ORDER BY 1, 2;
-------------------------------------------------------------------

-- Retrieve are the Countries with Highest Infection Rate compared to Population ?

SELECT
  location, 
  population,
  MAX(total_cases) AS HighestInfected, 
  MAX((total_cases/population)) * 100 AS PercentPopInfected
FROM CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopInfected DESC;

-------------------------------------------------------------------

-- Retrieve Countries with Highest Death Count per Population

SELECT
  Location, 
  MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount  --Total deaths needed to be converted to an integer
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC;		-- United States has the highest deathcount from Covid


-------------------------------------------------------------------
-- Showing contintents with the highest death count per population

SELECT 
  continent,
  MAX(CAST(Total_deaths AS INT)) AS TotalDeath
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeath DESC;

-------------------------------------------------------------------
-- To retrieve overall new_cases, new_deaths and Deathrate
SELECT 
  SUM(new_cases) AS total_cases,
  SUM(CAST(new_deaths AS INT)) AS total_deaths,		--new_deaths is nvarchar and needs to be converted to Integer
  SUM(CAST(new_deaths AS INT)) * 100 / SUM(new_cases) AS DeathRate
FROM CovidDeaths
WHERE continent IS NOT NULL

-------------------------------------------------------------------

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT 
  cd.continent, 
  cd.location,
  cd.date,
  cd.population,
  cv.new_vaccinations,
  SUM(CAST(cv.new_vaccinations AS INT)) OVER ( PARTITION BY cd.location ORDER BY cd.location, cd.date) AS RollingVaccinated
FROM CovidDeaths AS cd
JOIN CovidVaccinations AS cv
ON 
 cd.location = cv.location
 AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY cd.location, cd.date;

-------------------------------------------------------------------

/* Using Common Table Expression (CTE) to perform Calculation on Partition By in previous 
query can help have a clean query and still arrives at the same answer */


WITH populationvaccinated (continent, location, date, population, new_vaccinations, RollingVaccinated)

AS
(SELECT 
  cd.continent, 
  cd.location,
  cd.date,
  cd.population,
  cv.new_vaccinations,
  SUM(CAST(cv.new_vaccinations AS INT)) OVER ( PARTITION BY cd.location ORDER BY cd.location, cd.date) AS RollingVaccinated
FROM CovidDeaths AS cd
JOIN CovidVaccinations AS cv
ON 
 cd.location = cv.location
 AND cd.date = cv.date
WHERE cd.continent IS NOT NULL)

-- Selecting the necessary columns and the DeathRate
SELECT *, (RollingVaccinated/Population)*100 AS DeathRate
FROM populationvaccinated;

-------------------------------------------------------------------
-- Temporary table can also be used to compute the previous exercise
-- Using Temp Table to perform Calculation on Partition By in previous query

DROP TABLE IF EXISTS #PopVaccinatedPercent		-- # makes the table a Temp Table
CREATE TABLE #PopVaccinatedPercent

(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingVaccinated numeric
)

INSERT INTO #PopVaccinatedPercent

SELECT 
  cd.continent, 
  cd.location,
  cd.date,
  cd.population,
  cv.new_vaccinations,
  SUM(CAST(cv.new_vaccinations AS INT)) OVER ( PARTITION BY cd.location ORDER BY cd.location, cd.date) AS RollingVaccinated
FROM CovidDeaths AS cd
JOIN CovidVaccinations AS cv
ON 
 cd.location = cv.location
 AND cd.date = cv.date
-- WHERE cd.continent IS NOT NULL

Select *, (RollingVaccinated/Population)*100
From #PopVaccinatedPercent;

--------------------------------------------------------------
/*  In case of connecting to visualization softwares such as Power BI, Tableau, etc
 It is pertinent to create a view to store data */

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

CREATE VIEW vPopulationVaccinatedPercent
AS

SELECT 
  cd.continent, 
  cd.location,
  cd.date,
  cd.population,
  cv.new_vaccinations,
  SUM(CAST(cv.new_vaccinations AS INT)) OVER ( PARTITION BY cd.location ORDER BY cd.location, cd.date) AS RollingVaccinated
FROM CovidDeaths AS cd
JOIN CovidVaccinations AS cv
ON 
 cd.location = cv.location
 AND cd.date = cv.date
WHERE cd.continent IS NOT NULL;

-- Selecting the view just created
SELECT * 
FROM vPopulationVaccinatedPercent;