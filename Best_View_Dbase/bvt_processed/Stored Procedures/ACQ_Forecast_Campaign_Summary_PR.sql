
drop proc [bvt_processed].[ACQ_Forecast_Campaign_Summary_PR]
go

CREATE proc [bvt_processed].[ACQ_Forecast_Campaign_Summary_PR]
as


select KPIs.*, costs.Budget
, c.MediaMonth, MediaMonth_Year, ISO_Week

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
		, Channel
		, Product_Code
		, sum(Forecast) as Forecast
	from bvt_prod.ACQ_Best_View_Forecast_VW

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
	
	(select 
		idFlight_Plan_Records
		, sum(budget) as Budget
	from bvt_prod.ACQ_Financial_Budget_Forecast
	GROUP by idFlight_Plan_Records) as costs

	on KPIs.idFlight_Plan_Records=costs.idFlight_Plan_Records
	JOIN dim.Media_Calendar_Daily c on c.Date = KPIs.InHome_Date
	






GO


