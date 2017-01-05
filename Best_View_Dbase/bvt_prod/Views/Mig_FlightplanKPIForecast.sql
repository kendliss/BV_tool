Drop View [bvt_prod].[Mig_FlightplanKPIForecast]


create view [bvt_prod].[Mig_FlightplanKPIForecast]
as 
select 
	Mig_Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records
	, idkpi_types_FK
	, Forecast_DayDate
	, KPI_Daily*Volume as KPI_Forecast
from bvt_prod.Mig_Flightplan_KPIRate_Daily_VW 
	inner join bvt_prod.Mig_Flightplan_Volume_Forecast_VW
		on Mig_Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records=Mig_Flightplan_Volume_Forecast_VW.idFlight_Plan_Records


