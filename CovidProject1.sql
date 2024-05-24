--Select *
--From Project1.dbo.CovidDeaths$

--SELECT location, Population, MAX(cast(total_cases as int)) as HighestInfectionCount, (MAX(total_cases)/population)*100 as DeathPercentage
--From  Project1.dbo.CovidDeaths$
--Where continent is not null 
--Group by location, population
--Order by DeathPercentage desc

--SELECT continent, MAX(cast(total_cases as int)) as HighestInfectionCount
--From  Project1.dbo.CovidDeaths$
--Where continent is not null 
--Group by continent
--Order by HighestInfectionCount desc

--Global Numbers

--SELECT continent, sum(total_cases)
--From  Project1.dbo.CovidDeaths$
--Where continent is not null 
--Group by continent
--Order by 1,2

--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as Rollingpeoplevaccinated 
--FROM Project1.dbo.CovidDeaths$ dea
--JOIN Project1.dbo.CovidVaccinations$ vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--Where dea.continent is not null
----order by 2,3

--WITH Popvsvac (continent, location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)

--as
--(
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--From Project1.dbo.CovidDeaths$ dea
--JOIN Project1.dbo.CovidVaccinations$ vac
--	ON dea.location = vac.location 
--	and dea.date = vac.date
--Where dea.continent is not null
--)


CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From Project1.dbo.CovidDeaths$ dea
JOIN Project1.dbo.CovidVaccinations$ vac
	ON dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null



Select *, (RollingPeopleVaccinated/population)*100 as RollPeopleVaccinatedPercentage
From #PercentPopulationVaccinated

