


create view [bvt_prod].[UVLB_FlightplanKPIForecast]
as 
select 
	UVLB_Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records
	, idkpi_types_FK
	, Forecast_DayDate
	, KPI_Daily*Volume as KPI_Forecast
from bvt_prod.UVLB_Flightplan_KPIRate_Daily_VW 
	inner join bvt_prod.UVLB_Flightplan_Volume_Forecast_VW
		on UVLB_Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records=UVLB_Flightplan_Volume_Forecast_VW.idFlight_Plan_Records


