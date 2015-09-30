DROP VIEW [bvt_prod].[Movers_Forecast_NOSALES_VW]
GO

CREATE VIEW [bvt_prod].[Movers_Forecast_NOSALES_VW]
as
select FPR.idFlight_Plan_Records
	, idProgram_Touch_Definitions_TBL_FK
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
	, [owner_type_matrix_id_FK]

----Metrics
	, Metric_Category
	, KPI_Type
	, Product_Code
	, idkpi_types_FK
	, sum(Forecast) as Forecast

from bvt_prod.Movers_Flight_Plan_VW as FPR

left join
-------------Bring in the Metrics----------------------------------------------------------------------
(select * from 

-------Sales
(


------Response and Saves
(select idFlight_Plan_Records
	, 'Response' as Metric_Category
	, KPI_Type
	, KPI_Type as Product_Code
	, Forecast_DayDate
	, KPI_Forecast as Forecast
	, idkpi_types_FK
from bvt_prod.Movers_FlightplanKPIForecast
 left join bvt_prod.KPI_Types
		on Movers_FlightplanKPIForecast.idkpi_types_FK=KPI_Types.idKPI_Types)
		
union
---------Volume Forecast
(select idFlight_Plan_Records
	, 'Volume' as Metric_Category
	, 'Volume' as KPI_Type
	, 'Volume' as Product_Code
	, Drop_Date as Forecast_DayDate
	, Volume as Forecast
	, NULL AS idkpi_types_FK
from bvt_prod.Movers_Flightplan_Volume_Forecast_VW)) as metricsa) as metrics
	on fpr.idFlight_Plan_Records=metrics.idFlight_Plan_Records
-----------------------------------------------------------------	
--Media Calendar Information-------------------------------------
left join Dim.Media_Calendar_Daily
		on metrics.Forecast_DayDate=Media_Calendar_Daily.Date
-----------------------------------------------------------------

left join
-----Bring in touch definition labels 
(select idProgram_Touch_Definitions_TBL, Touch_Name, Program_Name, Tactic, Media, Audience, Creative_Name, Goal, Offer, Campaign_Type, [owner_type_matrix_id_FK]
		 from bvt_prod.Program_Touch_Definitions_TBL
			left join bvt_prod.Audience_LU_TBL on idAudience_LU_TBL_FK=idAudience_LU_TBL
			left join bvt_prod.Campaign_Type_LU_TBL on idCampaign_Type_LU_TBL_FK=idCampaign_Type_LU_TBL
			left join bvt_prod.Creative_LU_TBL on idCreative_LU_TBL_fk=idCreative_LU_TBL
			left join bvt_prod.Goal_LU_TBL on idGoal_LU_TBL_fk=idGoal_LU_TBL
			left join bvt_prod.Media_LU_TBL on idMedia_LU_TBL_fk=idMedia_LU_TBL
			left join bvt_prod.Offer_LU_TBL on idOffer_LU_TBL_fk=idOffer_LU_TBL
			left join bvt_prod.Program_LU_TBL on idProgram_LU_TBL_fk=idProgram_LU_TBL
			left join bvt_prod.Tactic_LU_TBL on idTactic_LU_TBL_fk=idTactic_LU_TBL) as touchdef
		on FPR.idProgram_Touch_Definitions_TBL_FK=idProgram_Touch_Definitions_TBL

where Tactic <> 'Cost'	
GROUP BY FPR.idFlight_Plan_Records
, idProgram_Touch_Definitions_TBL_FK
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
	, [owner_type_matrix_id_FK]

----Metrics
	, Metric_Category
	, KPI_Type
	, Product_Code
	, idkpi_types_FK