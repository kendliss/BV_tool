


create view [bvt_prod].[XSell_FlightplanKPIForecast]
as 
select 
	XSell_Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records
	, idkpi_types_FK
	, Forecast_DayDate
	, KPI_Daily*Volume as KPI_Forecast
from bvt_prod.XSell_Flightplan_KPIRate_Daily_VW 
	inner join bvt_prod.XSell_Flightplan_Volume_Forecast_VW
		on XSell_Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records=XSell_Flightplan_Volume_Forecast_VW.idFlight_Plan_Records


