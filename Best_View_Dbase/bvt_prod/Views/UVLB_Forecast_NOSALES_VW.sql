DROP VIEW [bvt_prod].[UVLB_Forecast_NOSALES_VW]
GO

CREATE VIEW [bvt_prod].[UVLB_Forecast_NOSALES_VW]
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

----Metrics
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
	, 'Response' as KPI_Type
	, KPI_Type as Product_Code
	, Forecast_DayDate
	, KPI_Forecast as Forecast
	, idkpi_types_FK
from bvt_prod.UVLB_FlightplanKPIForecast
 left join bvt_prod.KPI_Types
		on UVLB_FlightplanKPIForecast.idkpi_types_FK=KPI_Types.idKPI_Types)
		
union

(select idFlight_Plan_Records
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

----Metrics
	, KPI_Type
	, Product_Code
	, idkpi_types_FK