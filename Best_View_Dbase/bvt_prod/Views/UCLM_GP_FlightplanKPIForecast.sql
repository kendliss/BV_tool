

create view [bvt_prod].[UCLM_GP_FlightplanKPIForecast]
as 
select 
	UCLM_GP_Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records
	, idkpi_types_FK
	, Forecast_DayDate
	, KPI_Daily*Volume as KPI_Forecast
from bvt_prod.UCLM_GP_Flightplan_KPIRate_Daily_VW 
	inner join bvt_prod.UCLM_GP_Flightplan_Volume_Forecast_VW
		on UCLM_GP_Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records=UCLM_GP_Flightplan_Volume_Forecast_VW.idFlight_Plan_Records

