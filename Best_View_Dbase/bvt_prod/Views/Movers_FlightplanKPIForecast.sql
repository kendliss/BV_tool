

create view [bvt_prod].[Movers_FlightplanKPIForecast]
as 
select 
	Movers_Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records
	, idkpi_types_FK
	, Forecast_DayDate
	, KPI_Daily*Volume as KPI_Forecast
from bvt_prod.Movers_Flightplan_KPIRate_Daily_VW 
	inner join bvt_prod.Movers_Flightplan_Volume_Forecast_VW
		on Movers_Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records=Movers_Flightplan_Volume_Forecast_VW.idFlight_Plan_Records

