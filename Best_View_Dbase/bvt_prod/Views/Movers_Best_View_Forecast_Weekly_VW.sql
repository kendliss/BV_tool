CREATE VIEW [bvt_prod].[Movers_Best_View_Forecast_Weekly_VW]
	AS select
	idFlight_Plan_Records
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
	, [owner_type_matrix_id_FK]

----Metrics
	, KPI_Type
	, Product_Code
	, sum(Forecast) as Forecast

from [bvt_prod].[Movers_Best_View_Forecast_VW]
group by 
	idFlight_Plan_Records
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
	, [owner_type_matrix_id_FK]

----Metrics
	, KPI_Type
	, Product_Code
