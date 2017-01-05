
Drop View  [bvt_prod].[Mig_FlightplanSalesForecast]
GO

create view [bvt_prod].[Mig_FlightplanSalesForecast]
as 
select 
	Mig_Flightplan_SalesRate_Daily_VW.idFlight_Plan_Records
	, idkpi_type_FK as idkpi_types_FK
	, idProduct_LU_TBL_FK
	, Forecast_DayDate
	, Sales_Rate_Daily*Volume as Sales_Forecast
from bvt_prod.Mig_Flightplan_SalesRate_Daily_VW
	inner join bvt_prod.Mig_Flightplan_Volume_Forecast_VW
		on Mig_Flightplan_SalesRate_Daily_VW.idFlight_Plan_Records=Mig_Flightplan_Volume_Forecast_VW.idFlight_Plan_Records


