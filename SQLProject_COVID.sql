Select*
FROM PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--Select*
--FROM PortfolioProject..CovidVaccinations
--order by 3,4

SELECT Location,Date,total_cases,new_cases,total_deaths,population
FROM PortfolioProject..CovidDeaths
order by 1,2

--Looking at Total Cases vs Total Deaths 
--Shows the likelyhood of dying if you contract covid in your country 
SELECT Location,Date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
where location like '%canada%'
order by 1,2

--Looking of total cases vs population 
--shows what percentage of population got covid 
SELECT Location,date,total_cases,population,(total_cases/population)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
where location like '%canada%'
order by 1,2

--Looking at countries with highest infection rate compared to populaton 
SELECT Location,population,Max(total_cases) as HighestInfectionCount,Max((total_cases/population))*100 as PercentPopulationInfected 
FROM PortfolioProject..CovidDeaths
--where location like '%canada%'
Group by location,population
order by PercentPopulationInfected desc

--Showing countries with highest death count per population 
SELECT Location,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--where location like '%canada%'
where continent is not null 
Group by location
order by TotalDeathCount desc

--Let's break things down by Continent 
SELECT location,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--where location like '%canada%'
where continent is null
Group by location
order by TotalDeathCount desc


--Showing the continents with the highest death count
SELECT continent,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--where location like '%canada%'
where continent is null
Group by continent
order by TotalDeathCount desc

--Global Numbers 
SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int))as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--where location like '%canada%'
where continent is not null 
--Group by date
order by 1,2

--Total population vs vaccinations 

Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
order by 2,3

--Using CTE 
With PopvsVac (Continent,location, date, population,New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select*, (RollingPeopleVaccinated/population)*100
From PopvsVac


--Temp Table

DROP TABLE if exists #PercentPopulationVaccinated 
Create Table #PercentPopulationVaccinated
(
Continent nvarchar (255), 
Location nvarchar (255), 
Date datetime, 
Population numeric, 
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3
Select*, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated

--Creating view
Create View PercentPopulationVaccinated1 as 
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
--order by 2,3


Select* 
FROM PercentPopulationVaccinated1