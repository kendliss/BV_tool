USE [UVAQ]
GO

/****** Object:  StoredProcedure [bvt_processed].[UVLB_Forecast_Campaign_Summary_PR]    Script Date: 02/16/2016 16:17:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER proc [bvt_processed].[UVLB_BM_Forecast_Campaign_Summary_PR]
as
--declare @lst_load datetime
--select @lst_load = (select MAX(load_dt) from bvt_processed.UVLB_Best_View_Forecast)

select KPIs.*, costs.Budget, c.MediaMonth, MediaMonth_Year, ISO_Week

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
		, Product_Code
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
		, Product_Code) as Metrics
	PIVOT
	(Sum(Forecast) For Product_Code in 
		([Access Line]
		, DSL
		, [DSL Direct]
		, IPDSL
		, HSIA
		, UVTV
		, VoIP
		, Satellite
		, [WRLS Voice]
		, [WRLS Family]
		, [WRLS Data]
		, [WRLS Home]
		, ConnecTech
		, [Digital Life]
		, [Bolt ons]
		, Upgrades
		, [Call]
		, [Online]
		, Volume)) as pivottable) as KPIs
	
	left join 
	
	(select 
		idFlight_Plan_Records
		, sum(budget) as Budget
	from bvt_prod.UVLB_Financial_Budget_Forecast
	GROUP by idFlight_Plan_Records) as costs

	on KPIs.idFlight_Plan_Records=costs.idFlight_Plan_Records
	JOIN dim.Media_Calendar_Daily c on c.Date = KPIs.InHome_Date
	
	Where media in ('bi','FYI','FPC','Onsert', 'OE','RE')
	

GO


