USE [UVAQ]
GO

/****** Object:  View [bvt_prod].[UVLB_Forecast_Campaign_Summary_BM_VW]    Script Date: 02/17/2016 14:41:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER View [bvt_prod].[UVLB_Forecast_Campaign_Summary_BM_VW]
as

select KPIs.*, costs.Budget
,ISO_Week, MediaMonth, MediaMonth_Year
from
(select * from
	(select 
		idFlight_Plan_Records
		, Campaign_Name
		, InHome_Date
		, Touch_Name
		, Program_Name
		, Tactic
		, Media
		, Campaign_Type
		, Audience
		, Creative_Name
		, Goal
		, Offer
		, KPI_Type+Product_Code as Metric
		, sum(Forecast) as Forecast
	from bvt_prod.UVLB_Best_View_Forecast_VW

	group by idFlight_Plan_Records
		, Campaign_Name
		, InHome_Date
		, Touch_Name
		, Program_Name
		, Tactic
		, Media
		, Campaign_Type
		, Audience
		, Creative_Name
		, Goal
		, Offer
		, Product_Code
		, KPI_Type) as Metrics
	PIVOT
	(Sum(Forecast) For metric in 
		([TeleSalesAccess Line]
		, TeleSalesDSL
		, [TelesalesDSL Direct]
		, TelesalesIPDSL
		, TelesalesHSIA
		, TelesalesUVTV
		, TelesalesVoIP
		, TelesalesDirecTV
		, [TelesalesWRLS Voice]
		, [TelesalesWRLS Family]
		, [TelesalesWRLS Data]
		, [TelesalesWRLS Home]
		, TelesalesConnecTech
		, [TelesalesDigital Life]
		, [TelesalesBolt ons]
		, TelesalesUpgrades
		, [Online_SalesAccess Line]
		, Online_SalesDSL
		, [Online_SalesDSL Direct]
		, Online_SalesIPDSL
		, Online_SalesHSIA
		, Online_SalesUVTV
		, Online_SalesVoIP
		, Online_SalesDirecTV
		, [Online_SalesWRLS Voice]
		, [Online_SalesWRLS Family]
		, [Online_SalesWRLS Data]
		, [Online_SalesWRLS Home]
		, Online_SalesConnecTech
		, [Online_SalesDigital Life]
		, [Online_SalesBolt ons]
		, Online_SalesUpgrades
		, ResponseCall
		, ResponseOnline
		, VolumeVolume)) as pivottable) as KPIs
	
	left join 
	
	(select 
		idFlight_Plan_Records
		, sum(budget) as Budget
	from bvt_prod.UVLB_Financial_Budget_Forecast
	GROUP by idFlight_Plan_Records) as costs

	on KPIs.idFlight_Plan_Records=costs.idFlight_Plan_Records
	JOIN dim.Media_Calendar_Daily c
	on c.Date= KPIs.InHome_Date
	
Where Media in ('FYI','FPC','Onsert','BI') and InHome_Date >='12/28/15'


GO


