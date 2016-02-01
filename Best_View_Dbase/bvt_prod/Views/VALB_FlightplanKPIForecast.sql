


create view [bvt_prod].[VALB_FlightplanKPIForecast]
as 
select 
	VALB_Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records
	, idkpi_types_FK
	, Forecast_DayDate
	, KPI_Daily*Volume as KPI_Forecast
from bvt_prod.VALB_Flightplan_KPIRate_Daily_VW 
	inner join bvt_prod.VALB_Flightplan_Volume_Forecast_VW
		on VALB_Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records=VALB_Flightplan_Volume_Forecast_VW.idFlight_Plan_Records


