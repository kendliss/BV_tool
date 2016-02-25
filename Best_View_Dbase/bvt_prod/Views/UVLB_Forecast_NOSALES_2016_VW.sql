USE [UVAQ]
GO

/****** Object:  View [bvt_prod].[UVLB_Forecast_NOSALES_2016_VW]    Script Date: 01/25/2016 09:34:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [bvt_prod].[UVLB_Forecast_NOSALES_2016_VW]
as
select FPR.idFlight_Plan_Records
	, [idProgram_Touch_Definitions_TBL_FK]
	, FPR.Campaign_Name
	, FPR.InHome_Date
	
---Media_Calendar_Info
	, Media_Calendar_Daily.ISO_Week_Year as Media_Year
	, Media_Calendar_Daily.ISO_Week as Media_Week
	, Media_Calendar_Daily.MediaMonth as Media_Month
	
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
	, idkpi_types_FK
	, sum(Forecast) as Forecast

from bvt_prod.UVLB_Flight_Plan_VW as FPR

left join
-------------Bring in the Metrics----------------------------------------------------------------------
(select * from 


(--This is where sales was cut from 

(select idFlight_Plan_Records
	, 'Response' as Metric_Category
	, KPI_Type
	, KPI_Type as Product_Code
	, Forecast_DayDate
	, KPI_Forecast as Forecast
	, idkpi_types_FK
from bvt_prod.UVLB_FlightplanKPIForecast_2016
 left join bvt_prod.KPI_Types
		on UVLB_FlightplanKPIForecast_2016.idkpi_types_FK=KPI_Types.idKPI_Types)
		
union

(select idFlight_Plan_Records
	, 'Volume' as Metric_Category
	, 'Volume' as KPI_Type
	, 'Volume' as Product_Code
	, dropdate as Forecast_DayDate
	, Volume as Forecast
	, null as idkpi_types_FK
from bvt_prod.UVLB_Flightplan_Volume_Forecast_VW)) as metricsa) as metrics
	on fpr.idFlight_Plan_Records=metrics.idFlight_Plan_Records
-----------------------------------------------------------------	
--Media Calendar Information-------------------------------------
left join Dim.Media_Calendar_Daily
		on metrics.Forecast_DayDate=Media_Calendar_Daily.Date
-----------------------------------------------------------------

left join
-----Bring in touch definition labels 
[bvt_prod].[Touch_Definition_VW] as touchdef
		on FPR.idProgram_Touch_Definitions_TBL_FK=idProgram_Touch_Definitions_TBL

where ISO_Week_Year is not null
GROUP BY FPR.idFlight_Plan_Records
	, [idProgram_Touch_Definitions_TBL_FK]
	, FPR.Campaign_Name
	, FPR.InHome_Date
	
---Media_Calendar_Info
	, Media_Calendar_Daily.ISO_Week_Year
	, Media_Calendar_Daily.ISO_Week
	, Media_Calendar_Daily.MediaMonth
	
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
	, idkpi_types_FK

GO


