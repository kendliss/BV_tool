USE [UVAQ]
GO

/****** Object:  StoredProcedure [bvt_processed].[VALB_XSell_Forecast_Campaign_Summary_PR]    Script Date: 02/26/2016 09:12:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE proc [bvt_processed].[BM_Forecast_Campaign_Summary_PR]
as


select KPIs.*, costs.Budget
, c.MediaMonth, MediaMonth_Year, ISO_Week
from
(select * from
	(select 
		idFlight_Plan_Records_FK
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
		, Channel
		, Product_Code
		, sum(Forecast) as Forecast
	from bvt_prod.Combined_Old_Best_View_VW

	group by idFlight_Plan_Records_FK
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
		, Channel
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
		, DirecTV
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
	(Select idFlight_Plan_Records, SUM(budget) as budget
	from bvt_prod.VALB_Financial_Budget_Forecast
	group  by idFlight_Plan_Records
	UNION Select idFLight_Plan_records, SUM(Budget) as Budget
		from bvt_prod.UVLB_Financial_Budget_Forecast
		GROUP BY idFlight_Plan_Records) as costs
	

	on KPIs.idFlight_Plan_Records_FK=costs.idFlight_Plan_Records

	JOIN dim.Media_Calendar_Daily c on c.Date = KPIs.InHome_Date
	Where Media in ('BI','BAM','FPC','FYI','Onsert','OE','RE')
	




GO


