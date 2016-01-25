USE [UVAQ]
GO

/****** Object:  View [bvt_prod].[UVLB_Forecast_WithSales_2016_VW]    Script Date: 01/25/2016 09:35:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [bvt_prod].[UVLB_Forecast_WithSales_2016_VW]
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
	, Channel

----Metrics
	, Metric_Category
	, KPI_Type
	, Product_Code
	, Forecast

from bvt_prod.UVLB_Forecast_NOSALES_2016_VW where Media_Year>2015)

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
	, Channel

----Metrics
	, Metric_Category
	, KPI_Type
	, Product_Code
	, Forecast
from [bvt_prod].[UVLB_SaleForecast_Weekly_2016_VW])

GO


