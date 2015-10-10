DROP VIEW [bvt_prod].[Movers_Forecast_WithSales_VW]
GO

CREATE VIEW [bvt_prod].[Movers_Forecast_WithSales_VW]
	AS 
(select idFlight_Plan_Records
	, Campaign_Name
	, InHome_Date
	
---Media_Calendar_Info
	, Media_Year
	, Media_Month
	, Media_Week
	
---Touch Lookup Tables
	, Touch_Name
	, Program_Name
	, Tactic
	, Media
	, Campaign_Type
	, Audience
	, Creative_Name
	, Goal
	, Offer

----Metrics
	, Metric_Category
	, KPI_Type
	, Product_Code
	, Forecast

from bvt_prod.Movers_Forecast_NOSALES_VW)

union

(select idFlight_Plan_Records
	, Campaign_Name
	, InHome_Date
	
---Media_Calendar_Info
	, Media_Year
	, Media_Month
	, Media_Week
	
---Touch Lookup Tables
	, Touch_Name
	, Program_Name
	, Tactic
	, Media
	, Campaign_Type
	, Audience
	, Creative_Name
	, Goal
	, Offer

----Metrics
	, Metric_Category
	, KPI_Type
	, Product_Code
	, Forecast
from [bvt_prod].[Movers_SaleForecast_Weekly_VW])