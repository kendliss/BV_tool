CREATE VIEW [bvt_prod].[BM_FlightplanKPIForecast]
as 
select 
	BM_Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records
	, idkpi_types_FK
	, Forecast_DayDate
	, KPI_Daily*Volume as KPI_Forecast
from bvt_prod.BM_Flightplan_KPIRate_Daily_VW 
	inner join bvt_prod.BM_Flightplan_Volume_Forecast_VW
		on BM_Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records=BM_Flightplan_Volume_Forecast_VW.idFlight_Plan_Records


