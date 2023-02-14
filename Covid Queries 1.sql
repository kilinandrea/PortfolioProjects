

SELECT *
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT *
--FROM CovidVaccinations
--ORDER BY 3,4


--Select Data that I am going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Looking at the total cases vs total deaths
-- Shows the likelihood of dying if you contract covid in your country at the specified dates

SELECT location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Looking at the total cases vs the population in Sweden at any given date, including the population which got covid

SELECT location, date, total_cases, population, (total_cases/population)*100 AS InfectionRate
FROM CovidDeaths
WHERE continent IS NOT NULL
-- WHERE location like '%Sweden%'
ORDER BY 1,2


-- Looking at countries with highest infection rate compared to population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)) *100 AS InfectionRate
FROM CovidDeaths
WHERE continent IS NOT NULL
-- WHERE location like '%Sweden%'
GROUP BY population, location
ORDER BY InfectionRate DESC

-- Showing countries with the highest death count per population 

SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount, MAX((total_deaths/population))*100 AS DeathRate
FROM CovidDeaths
WHERE continent IS NOT NULL
-- WHERE location like '%Sweden%'
GROUP BY location
ORDER BY TotalDeathCount DESC


-- I will break things down by continent (where Canada isn't included in North America)

SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount, MAX((total_deaths/population))*100 AS DeathRate
FROM CovidDeaths
WHERE continent IS NOT NULL
-- WHERE location like '%Sweden%'
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Let's look at continents one more time, to include Canada in NA

SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount, MAX((total_deaths/population))*100 AS DeathRate
FROM CovidDeaths
WHERE continent IS NULL
-- WHERE location like '%Sweden%'
GROUP BY location
ORDER BY TotalDeathCount DESC




-- Let's look at highest deathrate per continent

SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount, MAX((total_deaths/population))*100 AS DeathRate
FROM CovidDeaths
WHERE continent IS NULL
-- WHERE location like '%Sweden%'
GROUP BY location
ORDER BY DeathRate DESC


-- GLOBAL NUMBERS

SELECT date, SUM(new_cases) AS GlobalNewCases, SUM(cast(new_deaths AS int)) AS GlobalAllDeaths, SUM(cast(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage--total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY date
ORDER BY 1,2 

-- Simple summary of global numbers, up to date

SELECT SUM(new_cases) AS GlobalNewCases, SUM(cast(new_deaths AS int)) AS GlobalAllDeaths, SUM(cast(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage--total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY 1,2 



-- Moving over to vaccinations
--Looking at total population versus vaccinations, we need to join the two tables

SELECT vac.continent, vac.location, dea.date, dea.population, vac.new_vaccinations 
,SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccinations
-- , (RollingVaccinations/population)*100 --> this doesn't work, so we will try with temp tables and CTE
FROM CovidVaccinations vac
JOIN CovidDeaths dea
	ON vac.location = dea.location AND vac.date = dea.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3 

-- with CTE 

WITH PopVsVac (continent, location, date, population, new_vaccinations, RollingVaccinations) -- this has to have the same columns as the select query below)
AS
(
SELECT vac.continent, vac.location, dea.date, dea.population, vac.new_vaccinations 
,SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccinations
FROM CovidVaccinations vac
JOIN CovidDeaths dea
	ON vac.location = dea.location AND vac.date = dea.date
WHERE dea.continent IS NOT NULL
-- ORDER BY 2,3 
)

SELECT *, (RollingVaccinations/population)*100
FROM PopVsVac -- remember to run this query together with the CTE




-- as a temp table 

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingVaccinations int
)

INSERT INTO #PercentPopulationVaccinated

SELECT vac.continent, vac.location, dea.population, vac.new_vaccinations 
,SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccinations
FROM CovidVaccinations vac
JOIN CovidDeaths dea
	ON vac.location = dea.location AND vac.date = dea.date
WHERE dea.continent IS NOT NULL 
-- ORDER BY 2,3 


SELECT *, (RollingVaccinations/population)*100 AS VaccinationRate
FROM #PercentPopulationVaccinated


-- Create view  to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS 
SELECT vac.continent, vac.location, dea.population, vac.new_vaccinations 
,SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccinations
FROM CovidVaccinations vac
JOIN CovidDeaths dea
	ON vac.location = dea.location AND vac.date = dea.date
WHERE dea.continent IS NOT NULL 

