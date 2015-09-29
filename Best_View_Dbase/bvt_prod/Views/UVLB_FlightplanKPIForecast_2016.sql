CREATE VIEW [bvt_prod].[UVLB_FlightplanKPIForecast_2016]
as 
select 
	UVLB_Flightplan_KPIRate_Daily_2016_VW.idFlight_Plan_Records
	, idkpi_types_FK
	, Forecast_DayDate
	, KPI_Daily*Volume as KPI_Forecast
from bvt_prod.UVLB_Flightplan_KPIRate_Daily_2016_VW 
	inner join bvt_prod.UVLB_Flightplan_Volume_Forecast_VW
		on UVLB_Flightplan_KPIRate_Daily_2016_VW.idFlight_Plan_Records=UVLB_Flightplan_Volume_Forecast_VW.idFlight_Plan_Records


