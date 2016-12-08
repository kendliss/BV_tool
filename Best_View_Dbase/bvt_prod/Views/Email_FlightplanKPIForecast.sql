


create view [bvt_prod].[Email_FlightplanKPIForecast]
as 
select 
	Email_Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records
	, idkpi_types_FK
	, Forecast_DayDate
	, KPI_Daily*Volume as KPI_Forecast
from bvt_prod.Email_Flightplan_KPIRate_Daily_VW 
	inner join bvt_prod.Email_Flightplan_Volume_Forecast_VW
		on Email_Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records=Email_Flightplan_Volume_Forecast_VW.idFlight_Plan_Records


