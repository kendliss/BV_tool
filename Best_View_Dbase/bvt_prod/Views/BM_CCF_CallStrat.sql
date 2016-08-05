USE [UVAQ]
GO

/****** Object:  View [bvt_prod].[BM_CCF_CallStrat]    Script Date: 06/09/2016 15:57:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Alter VIEW [bvt_prod].[BM_CCF_CallStrat]

	AS	
	
Select a.Touch_Name, a.Media, Campaign_Name, idFlight_Plan_Records, a.InHome_Date, Source_System_ID, TOLLFREE_NUMBER
, Media_Week, CASE WHEN a.Touch_Name LIKE '%Hisp%' THEN 'HISP ' ELSE '' END + Channel AS Channel
, SUM(Forecast*ISNULL(PIDPercent,1)) as Calls,
 CASE WHEN a.Touch_Name LIKE '%Hisp%' THEN 'HISP ' ELSE '' END + Coalesce(CAST(CallStrat_ID as Varchar(10)),c.Channel) as CallStrat
from (Select Touch_Name, Media, Campaign_Name, InHome_Date, idFlight_Plan_Records, Media_Week, SUM(Forecast) as Forecast
	  from bvt_prod.UVLB_Best_View_Forecast_VW
	  Where Product_Code = 'Call' and Media_Year = 2016
	  and media in ('BAM','BI','FPC','FYI','OE','Onsert','RE')
	  Group by Touch_Name, Media, Campaign_Name, InHome_Date, idFlight_Plan_Records, Media_Week
	  UNION Select Touch_Name, Media, Campaign_Name, InHome_Date, idFlight_Plan_Records, Media_Week, SUM(Forecast) as Forecast
	  from bvt_prod.VALB_Best_View_Forecast_VW
	  Where Product_Code = 'Call' and Media_Year = 2016
	  and media in ('BAM','BI','FPC','FYI','OE','Onsert','RE')
	  Group by Touch_Name, Media, Campaign_Name, InHome_Date, idFlight_Plan_Records, Media_Week) a
LEFT JOIN UVAQ_STAGING.bvt_staging.CCF_CallStrat_pID b
on a.idFlight_Plan_Records = b.idFlight_Plan_Records_FK 
JOIN bvt_prod.Touch_Definition_VW c
on a.Touch_Name = c.Touch_Name and c.Program_Name in ('UVLB','VALB')
group by idFlight_Plan_Records, Media_Week, Coalesce(CAST(CallStrat_ID as Varchar(10)),c.Channel), Channel, a.Campaign_Name
, a.Touch_Name, a.Media, a.InHome_Date, Source_System_ID, TollFree_Number

GO


