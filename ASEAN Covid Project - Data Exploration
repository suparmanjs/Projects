--- Welcome to Jaya Suparman's Portfolio Project
--- This project will focus on data about covid 19 in South East Asia, Particularlly the ASEAN country members

--- the data we have contain international data for covid 19

SELECT * FROM coviddeaths



--- therefore, we will create a tempt table #asean_covid_deaths

SELECT
	*
INTO 
	asean_covid_deaths
FROM
	coviddeaths
WHERE
	location in ('Brunei', 'Cambodia', 'Indonesia', 'Laos', 'Malaysia', 'Myanmar', 'Philippines', 'Singapore', 'Thailand', 'Vietnam')



--- To make sure that we've successfully create the tempt table

SELECT * FROM asean_covid_deaths



--- select data that we are going to start with

SELECT
	Location, date, population, total_cases, new_cases, total_deaths
FROM
	asean_covid_deaths
ORDER BY
	1,2



--- Total cases VS. Total deaths
--- Shows likelyhood of dying if you contract covid in one these counties

SELECT
	Location, date, total_cases, total_deaths, (total_cases/total_deaths)*100 AS death_persentage
FROM
	asean_covid_deaths
-- WHERE
-------- location = 'Indonesia'			--- If you are from Indonesia
ORDER BY 
	1,2 DESC



--- Total cases VS. population
--- Shows how many persent of the population that infected with covid

SELECT	
	location, population, total_cases, (total_cases/population)*100 AS percent_population_infected
FROM
	asean_covid_deaths
ORDER BY
	1,2


--- Countries with Highest Infection Rate compared to Population

SELECT
	location, population, MAX(CAST(total_cases AS int)) AS Highest_infection_country, MAX(total_cases/population)*100 AS Percent_population_infected
FROM
	asean_covid_deaths
GROUP BY
	location, population
ORDER BY 
	Percent_population_infected DESC


--- Countries with Highset total deaths count

SELECT
	location, MAX(CAST(total_deaths AS int)) AS total_death_count
FROM
	asean_covid_deaths
GROUP BY 
	location
ORDER BY 
	total_death_count DESC


--- ASEAN NUMBERS

SELECT 
	SUM(CAST(new_cases AS int)) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, SUM(CAST(new_deaths AS int))/SUM(CAST(new_cases AS int))*100 AS death_persentage
FROM
	asean_covid_deaths
ORDER BY
	1,2
--- The actual percentage is below zero (0.01%)


--- Now, we are going to move into our second table dbo.covidvaccinations

SELECT * FROM covidvaccinations



--- and we are going to amke the same temp table as before which contain only data from ASEAN counties member

SELECT
	*
INTO
	asean_covid_vaccinations
FROM 
	covidvaccinations
WHERE
	location in ('Brunei', 'Cambodia', 'Indonesia', 'Laos', 'Malaysia', 'Myanmar', 'Philippines', 'Singapore', 'Thailand', 'Vietnam')

--- To make sure that we've successfully create the tempt table

SELECT * FROM asean_covid_vaccinations


--- Total population VS. total vactination
--- This shows the rolling number of the people that has recieved at least one vaccinations

SELECT
	dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(numeric,vac.new_vaccinations)) OVER (Partition By dea.location ORDER BY dea.location, dea.date) AS Rolling_people_vaccinated
FROM
	asean_covid_deaths dea
JOIN
	asean_covid_vaccinations vac
		ON dea.location=vac.location
		AND dea.date=vac.date
ORDER BY
	1,2

--- To count the percentage of Population that has recieved at least one Covid Vaccine
---  Using CTE to perform Calculation on Partition By in previous query

WITH PopvsVac (location, date, population, new_vaccinations, Rolling_people_vaccinated)
	AS
	(
	SELECT
		dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM(CONVERT(numeric,vac.new_vaccinations)) OVER (Partition By dea.location ORDER BY dea.location, dea.date) AS Rolling_people_vaccinated
	FROM
		asean_covid_deaths dea
	JOIN
		asean_covid_vaccinations vac
			ON dea.location=vac.location
			AND dea.date=vac.date
--	ORDER BY
--		1,2
	)
SELECT
	*, (Rolling_people_vaccinated/population)*100 AS Percentage_population_vaccinated
FROM
	PopvsVac



--- Using Temp Table to perform Calculation on Partition By in previous query

SELECT
	dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(numeric,vac.new_vaccinations)) OVER (Partition By dea.location ORDER BY dea.location, dea.date) AS Rolling_people_vaccinated
INTO #Rolling_people_vaccinated		-- To create tempt table
FROM
	asean_covid_deaths dea
JOIN
	asean_covid_vaccinations vac
		ON dea.location=vac.location
		AND dea.date=vac.date
ORDER BY
	1,2

Select 
	*,
	(Rolling_people_vaccinated/population)*100 AS Percentage_population_vacinated
from
	#Rolling_people_vaccinated




--- Create View to store data for later visualization

CREATE VIEW Percentage_population_Vaccinated AS
SELECT
	dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(numeric,vac.new_vaccinations)) OVER (Partition By dea.location ORDER BY dea.location, dea.date) AS Rolling_people_vaccinated
FROM
	asean_covid_deaths dea
JOIN
	asean_covid_vaccinations vac
		ON dea.location=vac.location
		AND dea.date=vac.date

select * from Percentage_population_Vaccinated
