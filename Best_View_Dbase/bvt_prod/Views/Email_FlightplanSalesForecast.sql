


create view [bvt_prod].[Email_FlightplanSalesForecast]
as 
select 
	Email_Flightplan_SalesRate_Daily_VW.idFlight_Plan_Records
	, idkpi_type_FK as idkpi_types_FK
	, idProduct_LU_TBL_FK
	, Forecast_DayDate
	, Sales_Rate_Daily*Volume as Sales_Forecast
from bvt_prod.Email_Flightplan_SalesRate_Daily_VW
	inner join bvt_prod.Email_Flightplan_Volume_Forecast_VW
		on Email_Flightplan_SalesRate_Daily_VW.idFlight_Plan_Records=Email_Flightplan_Volume_Forecast_VW.idFlight_Plan_Records


