
create view bvt_prod.FlightplanKPIForecast
as 
select 
	Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records
	, idkpi_types_FK
	, Forecast_DayDate
	, KPI_Daily*Volume as KPI_Forecast
from bvt_prod.Flightplan_KPIRate_Daily_VW 
	inner join bvt_prod.Flightplan_Volume_Forecast_VW
		on Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records=Flightplan_Volume_Forecast_VW.idFlight_Plan_Records
