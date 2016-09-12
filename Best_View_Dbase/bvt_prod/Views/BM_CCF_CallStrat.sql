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
, Media_Week, CASE WHEN a.Touch_Name LIKE '%Spanish%' THEN 'HISP ' ELSE '' END + a.Channel AS Channel
, SUM(Forecast*ISNULL(PIDPercent,1)) as Calls,
 CASE WHEN a.Touch_Name LIKE '%Hisp%' THEN 'HISP ' ELSE '' END + Coalesce(CAST(CallStrat_ID as Varchar(10)),a.Channel) as CallStrat
from bvt_prod.BM_Forecast_VW a
LEFT JOIN UVAQ_STAGING.bvt_staging.CCF_CallStrat_pID b
on a.idFlight_Plan_Records = b.idFlight_Plan_Records_FK
where Media_Year = 2016 and Product_Code = 'Call'
group by idFlight_Plan_Records, Media_Week, Coalesce(CAST(CallStrat_ID as Varchar(10)),a.Channel), a.Channel, a.Campaign_Name
, a.Touch_Name, a.Media, a.InHome_Date, Source_System_ID, TollFree_Number

GO


