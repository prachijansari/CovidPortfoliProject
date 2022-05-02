--SELECT *
--FROM CovidPortfolioProject..CovidDeaths
--Order by 1,2


--Query 1 : Select the data used

SELECT 
	Location, 
	date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population
FROM 
	CovidPortfolioProject..CovidDeaths
WHERE 
	continent is NOT NULL
ORDER BY
	1,2

--Query 2: Looking at Total Cases vs Total Death : shows the likelihood of dying if you contract COVID

SELECT 
  Location, 
  date, 
  total_cases, 
  total_deaths, 
  (total_deaths / total_cases)* 100 AS DeathPercentage 
FROM 
  CovidPortfolioProject..CovidDeaths 
WHERE 
  Location like '%india%' 
  AND continent is NOT NULL --WHERE continent is NOT NULL
ORDER BY 
  1, 
  2

--Query 3: Looking at Total Cases vs Population to show what percent of population has COVID

SELECT 
  Location, 
  date, 
  total_cases, 
  population, 
  (total_cases / population)* 100 AS CasesPercentage 
FROM 
  CovidPortfolioProject..CovidDeaths 
WHERE 
  Location like '%india%' 
  AND continent is NOT NULL 
ORDER BY 
  1, 
  2

--Query 3: countries with highest infection rate compared to Population

SELECT 
  Location, 
  MAX(total_cases) AS HighestNumberOfCases, 
  population, 
  (
    MAX(total_cases)/ population
  )* 100 AS HighestPercentPopulationInfected
  
FROM 
  CovidPortfolioProject..CovidDeaths --WHERE Location like '%india%'
WHERE 
  continent is NOT NULL 
GROUP BY 
  Location, 
  population
  
ORDER BY 
  HighestPercentPopulationInfected DESC

--Query 3.1 :
SELECT 
  Location, 
  MAX(total_cases) AS HighestNumberOfCases, 
  population, 
  (
    MAX(total_cases)/ population
  )* 100 AS HighestPercentPopulationInfected,
  date
FROM 
  CovidPortfolioProject..CovidDeaths --WHERE Location like '%india%'
WHERE 
  continent is NOT NULL 
GROUP BY 
  Location, 
  population,
  date
ORDER BY 
  HighestPercentPopulationInfected DESC
--Query4 : Showing Countries with Highest Death Count Per Population

SELECT 
  Location, 
  MAX(
    CAST(total_deaths AS int)
  ) AS HighestDeathCount, 
  population, 
  (
    MAX(total_deaths)/ population
  )* 100 AS HighestPercentDeath 
FROM 
  CovidPortfolioProject..CovidDeaths --WHERE Location like '%india%'
WHERE 
  continent is NOT NULL 
GROUP BY 
  Location, 
  population 
ORDER BY 
  HighestPercentDeath DESC


--Query 5: Highest Death count by Continent Data 
SELECT 
  continent, 
  MAX(
    CAST(total_deaths AS int)
  ) AS TotalDeathCount 
FROM 
  CovidPortfolioProject..CovidDeaths --WHERE Location like '%india%'
WHERE 
  continent is NOT NULL 
GROUP BY 
  continent 
ORDER BY 
  TotalDeathCount DESC


-- Query 6:Increase in cases and deaths by date 



SELECT 
  date, 
  SUM(
    CAST(new_deaths AS int)
  ) AS total_death, 
  SUM(new_cases) AS total_cases, 
  SUM(
    CAST(new_deaths AS int)
  )/ SUM(new_cases)* 100 AS DeathPercentage 
FROM 
  CovidPortfolioProject..CovidDeaths --WHERE Location like '%india%'
WHERE 
  continent is NOT NULL 
GROUP BY 
  date 
ORDER BY 
  1, 
  2


--Query 7: Total Cases  


SELECT 
  SUM(
    CAST(new_deaths AS int)
  ) AS total_death, 
  SUM(new_cases) AS total_cases, 
  SUM(
    CAST(new_deaths AS int)
  )/ SUM(new_cases)* 100 AS DeathPercentage 
FROM 
  CovidPortfolioProject..CovidDeaths --WHERE Location like '%india%'
WHERE 
  continent is NOT NULL 
ORDER BY 
  1, 
  2


--Query 8: Total number of vaccinated people vs population 
WITH PopVsVac (
  Location, Date, Population, New_Vaccination, 
  total_vaccine
) AS (
  SELECT 
    death.Location, 
    death.date, 
    death.population, 
    vaccine.new_vaccinations, 
    SUM(
      CAST(vaccine.new_vaccinations AS BIGINT)
    ) OVER (
      PARTITION BY death.location 
      ORDER BY 
        death.location, 
        death.date
    ) AS total_vaccine 
  FROM 
    CovidPortfolioProject..CovidDeaths AS death 
    JOIN CovidPortfolioProject..CovidVaccinations AS vaccine ON death.location = vaccine.location 
    and death.date = vaccine.date 
  WHERE 
    death.continent is not null --ORDER BY 
    --  1, 
    --  2
    ) 
SELECT 
  *, 
  (total_vaccine / Population)* 100 AS vaccinated_percentage 
FROM 
  PopVsVac



  -- Creating View
GO
CREATE VIEW PercentPopulationVaccinateddd
AS   


WITH PopVsVac (
  Location, Date, Population, New_Vaccination, 
  total_vaccine
) AS (
  SELECT 
    death.Location, 
    death.date, 
    death.population, 
    vaccine.new_vaccinations, 
    SUM(
      CAST(vaccine.new_vaccinations AS BIGINT)
    ) OVER (
      PARTITION BY death.location 
      ORDER BY 
        death.location, 
        death.date
    ) AS total_vaccine 
  FROM 
    CovidPortfolioProject..CovidDeaths AS death 
    JOIN CovidPortfolioProject..CovidVaccinations AS vaccine ON death.location = vaccine.location 
    and death.date = vaccine.date 
  WHERE 
    death.continent is not null 
	)
	--ORDER BY 
    --  1, 
    --  2
	
 
SELECT 
*,  (total_vaccine / Population)* 100 AS vaccinated_percentage 
FROM 
  PopVsVac

 
 -- Total Death Count by continent
 SELECT location, SUM(CAST(new_deaths AS int)) as TotalDeathCount
 FROM CovidPortfolioProject..CovidDeaths
 WHERE continent is NULL
 AND location not in ('World', 'European Union', 'International', 'Upper middle income', 'High income', 'Lower middle income', 'Low income')
 GROUP BY location
 ORDER BY TotalDeathCount DESC