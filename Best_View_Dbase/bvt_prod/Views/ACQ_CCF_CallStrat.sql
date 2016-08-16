USE [UVAQ]
GO

/****** Object:  View [bvt_prod].[ACQ_CCF_CallStrat]    Script Date: 06/09/2016 15:57:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [bvt_prod].[ACQ_CCF_CallStrat]

	AS	
	
Select a.Touch_Name, a.Media, Campaign_Name, idFlight_Plan_Records, b.Source_System_ID as ParentID, a.InHome_Date, Media_Week, SUM(Forecast*ISNULL(PIDPercent,1)) as Calls
,  CASE WHEN a.Touch_Name LIKE '%Hisp%' THEN 'HISP ' ELSE '' END + Coalesce(CAST(CallStrat_ID as Varchar(10)),c.Channel) as CallStrat
, CASE WHEN a.Touch_Name LIKE '%Hisp%' THEN 'HISP ' ELSE '' END + Channel AS Channel
from (Select Touch_Name, Media, Campaign_Name, idFlight_Plan_Records, InHome_Date, Media_Week, SUM(Forecast) as Forecast
	  from bvt_prod.ACQ_Best_View_Forecast_VW
	  Where Product_Code = 'Call' and Media_Year = 2016
	  Group by Touch_Name, Media, Campaign_Name, idFlight_Plan_Records, InHome_Date, Media_Week) a
LEFT JOIN UVAQ_STAGING.bvt_staging.CCF_CallStrat_pID b
on a.idFlight_Plan_Records = b.idFlight_Plan_Records_FK 
JOIN bvt_prod.Touch_Definition_VW c
on a.Touch_Name = c.Touch_Name and c.Program_Name = 'ACQ'
group by a.Touch_Name, a.Media, a.Campaign_Name, idFlight_Plan_Records, b.Source_System_ID, Channel, a.InHome_Date, Media_Week
, Coalesce(CAST(CallStrat_ID AS VARCHAR(10)),c.Channel)


GO


