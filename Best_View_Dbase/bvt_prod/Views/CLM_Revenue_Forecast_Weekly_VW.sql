CREATE VIEW [bvt_prod].[CLM_Revenue_Forecast_Weekly_VW]
	as
select idFlight_Plan_Records
	, Campaign_Name
	, InHome_Date
	
---Media_Calendar_Info
	, Media_Year
	, Media_Week
	, Media_Month
	
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
	, KPI_Type
	, Product_Code
	, sum(Forecast) as Forecast

from [bvt_prod].[CLM_Revenue_Forecast_VW]

GROUP BY idFlight_Plan_Records
	, Campaign_Name
	, InHome_Date
	
---Media_Calendar_Info
	, Media_Year
	, Media_Week
	, Media_Month
	
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
	, KPI_Type
	, Product_Code