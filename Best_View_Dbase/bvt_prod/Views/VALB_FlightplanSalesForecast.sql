Drop View [bvt_prod].[VALB_FlightplanSalesForecast]

GO


create view [bvt_prod].[VALB_FlightplanSalesForecast]
as 
select 
	VALB_Flightplan_SalesRate_Daily_VW.idFlight_Plan_Records
	, idkpi_type_FK as idkpi_types_FK
	, idProduct_LU_TBL_FK
	, Forecast_week_Date
	, Sales_Rate_weekly*Volume as Sales_Forecast
from bvt_prod.VALB_Flightplan_SalesRate_Daily_VW
	inner join bvt_prod.VALB_Flightplan_Volume_Forecast_VW
		on VALB_Flightplan_SalesRate_Daily_VW.idFlight_Plan_Records=VALB_Flightplan_Volume_Forecast_VW.idFlight_Plan_Records


