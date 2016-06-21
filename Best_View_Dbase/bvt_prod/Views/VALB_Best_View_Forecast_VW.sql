USE [UVAQ]
GO

/****** Object:  View [bvt_prod].[VALB_Best_View_Forecast_VW_FOR_LINK]    Script Date: 02/22/2016 12:26:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







alter view [bvt_prod].[VALB_Best_View_Forecast_VW]
as
select FPR.idFlight_Plan_Records

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
	, owner_type_matrix_id_FK

----Metrics
	, KPI_Type
	, Product_Code
	, Forecast_week_Date
	, Forecast

from bvt_prod.VALB_Flight_Plan_VW as FPR

left join
-------------Bring in the Metrics----------------------------------------------------------------------
(select * from 


((select idFlight_Plan_Records
	, case when idkpi_types_FK=1 then 'Telesales'
		when idkpi_types_FK=2 then 'Online_sales'
		else 'CHECK' end as KPI_Type 
	, Product_Code
	, Forecast_week_Date
	, Sales_Forecast as Forecast
from bvt_prod.VALB_FlightplanSalesForecast
 left join bvt_prod.Product_LU_TBL
		on VALB_FlightplanSalesForecast.idProduct_LU_TBL_FK=Product_LU_TBL.idProduct_LU_TBL)

union 

(select idFlight_Plan_Records
	, 'Response' as KPI_Type
	, KPI_Type as Product_Code
	, Forecast_Week_Date
	, KPI_Forecast as Forecast
from bvt_prod.VALB_FlightplanKPIForecast
 left join bvt_prod.KPI_Types
		on VALB_FlightplanKPIForecast.idkpi_types_FK=KPI_Types.idKPI_Types)
		
union

(select idFlight_Plan_Records
	, 'Volume' as KPI_Type
	, 'Volume' as Product_Code
	, dropdate as Forecast_Week_Date
	, Volume as Forecast
from bvt_prod.VALB_Flightplan_Volume_Forecast_VW)) as metricsa) as metrics
	on fpr.idFlight_Plan_Records=metrics.idFlight_Plan_Records
-----------------------------------------------------------------	
--Media Calendar Information-------------------------------------
left join Dim.Media_Calendar_Daily
		on metrics.Forecast_week_Date=Media_Calendar_Daily.Date
-----------------------------------------------------------------

left join
-----Bring in touch definition labels 
bvt_prod.Touch_Definition_VW as touchdef
		on FPR.idProgram_Touch_Definitions_TBL_FK=idProgram_Touch_Definitions_TBL

	






GO


