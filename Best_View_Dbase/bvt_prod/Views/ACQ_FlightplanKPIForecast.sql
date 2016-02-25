


create view [bvt_prod].[ACQ_FlightplanKPIForecast]
as 
select 
	ACQ_Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records
	, idkpi_types_FK
	, Forecast_DayDate
	, KPI_Daily*Volume as KPI_Forecast
from bvt_prod.ACQ_Flightplan_KPIRate_Daily_VW 
	inner join bvt_prod.ACQ_Flightplan_Volume_Forecast_VW
		on ACQ_Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records=ACQ_Flightplan_Volume_Forecast_VW.idFlight_Plan_Records


