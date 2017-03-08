Drop view [bvt_prod].[XSell_Best_View_Calendar_VW]
GO

CREATE VIEW [bvt_prod].[XSell_Best_View_Calendar_VW]
	AS 
	select 
		coalesce(forecast_cv.[idFlight_Plan_Records_FK], actual_volume.[idFlight_Plan_Records_FK], actual_results.[idFlight_Plan_Records_FK]) as idFlight_Plan_Records_FK,
		coalesce(forecast_cv.[Campaign_Name], actual_volume.[Campaign_Name], actual_results.[Campaign_Name]) as Campaign_Name,
		coalesce(forecast_cv.[InHome_Date], actual_volume.[InHome_Date], actual_results.[InHome_Date]) as InHome_Date,
		coalesce(forecast_cv.[Strategy_Eligibility], '') as Strategy_Eligibility,
		coalesce(forecast_cv.[Lead_Offer], '') as Lead_Offer,
		coalesce(forecast_cv.[Media_Year], actual_volume.[Media_Year], actual_results.[Media_Year]) as Media_Year,
		coalesce(forecast_cv.[Media_Week], actual_volume.[Media_Week], actual_results.[Media_Week]) as Media_Week,
		coalesce(forecast_cv.[Media_Month], actual_volume.[Media_Month], actual_results.Media_Month) as Media_Month,
		coalesce(forecast_cv.[Calendar_Year], actual_volume.[Calendar_Year], actual_results.[Calendar_Year]) as Calendar_Year,
		coalesce(forecast_cv.[Calendar_Month], actual_volume.[Calendar_Month], actual_results.[Calendar_Month]) as Calendar_Month,
		coalesce(forecast_cv.[Touch_Name], actual_volume.[Touch_Name], actual_results.[Touch_Name]) as Touch_Name, 
		coalesce(forecast_cv.[Program_Name], actual_volume.[Program_Name], actual_results.[Program_Name]) as Program_Name, 
		coalesce(forecast_cv.[Tactic], actual_volume.[Tactic], actual_results.[Tactic]) as Tactic, 
		coalesce(forecast_cv.[Media], actual_volume.[Media], actual_results.[Media]) as Media,
		coalesce(forecast_cv.[Campaign_Type], actual_volume.[Campaign_Type], actual_results.[Campaign_Type]) as Campaign_Type,
		coalesce(forecast_cv.[Audience], actual_volume.[Audience], actual_results.[Audience]) as Audience,
		coalesce(forecast_cv.[Creative_Name], actual_volume.[Creative_Name], actual_results.[Creative_Name]) as Creative_Name,
		coalesce(forecast_cv.[Goal], actual_volume.[Goal],actual_results.[Goal]) as Goal,
		coalesce(forecast_cv.[Offer], actual_volume.[Offer], actual_results.[Offer]) as Offer,
		coalesce(forecast_cv.[Channel], actual_volume.[Channel], actual_results.[Channel]) as Channel,
		coalesce(forecast_cv.[Scorecard_Group], actual_volume.[Scorecard_Group], actual_results.[Scorecard_Group]) as Scorecard_Group,
		coalesce(forecast_cv.[Scorecard_Program_Channel], actual_volume.[Scorecard_Program_Channel], actual_results.[Scorecard_Program_Channel]) as Scorecard_Program_Channel,
		coalesce(forecast_cv.[KPI_Type], actual_volume.[KPI_Type], actual_results.[KPI_Type]) as KPI_Type,
		coalesce(forecast_cv.[Product_Code], actual_volume.[Product_Code],  actual_results.[Product_Code]) as Product_Code
		,isnull([Forecast],0) as Forecast
		,isnull([Commitment],0) as Commitment
		,isnull(coalesce(actual_volume.[Actual], actual_results.[Actual]),0) as Actual
-- complex case statement to determine if you should be using forecast or actuals for the best view

--First are these telesales or other metrics as telesales require a lagging
		,case when coalesce(forecast_cv.[KPI_Type], actual_volume.[KPI_Type], actual_results.[KPI_Type]) = 'Telesales'
		--IS the forecast YYYYWW two weeks less than the current report week available 
			then (case when forecast_cv.[media_YYYYWW] <= (case when DATEPART(weekday,getdate()) <= 5 
						then (select [ISO_Week_YYYYWW] from dim.media_calendar_daily where [date] = cast(dateadd(wk,-4,getdate()) as date)) 
						else (select [ISO_Week_YYYYWW] from dim.media_calendar_daily where [date] = cast(dateadd(wk,-3,getdate()) as date)) end)
					then actual_results.[Actual]
					when forecast_cv.[media_YYYYWW] is null then actual_results.[Actual]
					else isnull([Forecast],0)
					end)
----END OF TELESALES LAG CONCERNS
--Non telesale report through current available week
		when forecast_cv.[media_YYYYWW] <= (case when DATEPART(weekday,getdate())<= 5 
						then (select [ISO_Week_YYYYWW] from dim.media_calendar_daily where [date] = cast(dateadd(wk,-2,getdate()) as date)) 
						else (select [ISO_Week_YYYYWW] from dim.media_calendar_daily where [date] = cast(dateadd(wk,-1,getdate()) as date)) end)
			then coalesce(actual_volume.[Actual], actual_results.[Actual])

		when forecast_cv.[media_YYYYWW] is null then coalesce(actual_volume.[Actual], actual_results.[Actual])
		else isnull([Forecast],0)

		end as Best_View
		
	FROM	
	---select to join the forecast and CV
	(SELECT 
	   Coalesce(forecast.[idFlight_Plan_Records], cv.[id_Flight_Plan_Records_FK]) as idFlight_Plan_Records_FK
      ,Coalesce(forecast.[Campaign_Name], cv.[Campaign_Name]) as Campaign_Name
      ,coalesce(forecast.[InHome_Date], cv.[InHome_Date]) as InHome_Date
      ,coalesce(forecast.[Strategy_Eligibility], '') as Strategy_Eligibility
      ,coalesce(forecast.[Lead_Offer], '') as Lead_Offer
      ,coalesce(forecast.[Touch_Name], cv.[Touch_Name]) as Touch_Name
      ,coalesce(forecast.[Program_Name], cv.[Program_Name]) as Program_Name
      ,coalesce(forecast.[Tactic], cv.[Tactic]) as Tactic
      ,coalesce(forecast.[Media], cv.[Media]) as Media
      ,coalesce(forecast.[Campaign_Type], cv.[Campaign_Type]) as Campaign_Type
      ,coalesce(forecast.[Audience], cv.[Audience]) as Audience
      ,coalesce(forecast.[Creative_Name], cv.[Creative_Name]) as Creative_Name
      ,coalesce(forecast.[Goal], cv.[Goal]) as Goal
      ,coalesce(forecast.[Offer], cv.[Offer]) as Offer
      ,coalesce(forecast.[Channel], cv.[Channel]) as Channel
      ,coalesce(forecast.[Scorecard_Group], cv.[Scorecard_Group]) as Scorecard_Group
      ,coalesce(forecast.[Scorecard_Program_Channel], cv.[Scorecard_Program_Channel]) as Scorecard_Program_Channel
      ,coalesce(forecast.[KPI_Type], cv.[KPI_Type]) as KPI_Type
      ,coalesce(forecast.[Product_Code], cv.[Product_Code]) as Product_Code
	  ,coalesce(forecast.[media_year], cv.[media_year]) as media_year
	  ,coalesce(forecast.[media_month], cv.[media_month]) as media_month
	  ,coalesce(forecast.[media_week], cv.[media_week]) as media_week
	  ,coalesce(forecast.[Calendar_Year], cv.[Calendar_Year]) as Calendar_Year
	  ,coalesce(forecast.[Calendar_Month], cv.[Calendar_Month]) as Calendar_Month
	  ,case when cv.[Media_Week] < 10 
		then coalesce(forecast.[Media_YYYYWW], cast((cast(cv.[media_year] as char(4))+'0'+cast(cv.[media_week] as char(1))) as int))
		else coalesce(forecast.[Media_YYYYWW], cast((cast(cv.[media_year] as char(4))+cast(cv.[media_week] as char(2))) as int))
		end as Media_YYYYWW
      ,sum(forecast.[Forecast]) as Forecast
	  ,sum(CV.forecast) as Commitment 
	  FROM 
	  
	  (select 
	    a.[idFlight_Plan_Records]
      , a.[Campaign_Name]
      , a.[InHome_Date]
      , a.[Strategy_Eligibility]
      , a.[Lead_Offer]
      , a.[Touch_Name]
      , a.[Media_Year]
      , a.[Media_Month]
      , a.[Media_Week]
      , a.[Media_YYYYWW]
      , a.[Calendar_Year]
      , a.[Calendar_Month]
      , a.[Program_Name]
      , a.[Tactic]
      , a.[Media]
      , a.[Campaign_Type]
      , a.[Audience]
      , a.[Creative_Name]
      , a.[Goal]
      , a.[Offer]
      , a.[Channel]
      , b.[Scorecard_Group]
      , b.[Scorecard_Program_Channel]
      , a.[KPI_Type]
      , a.[Product_Code]
	  , SUM(a.[Forecast]) as forecast
	  from
	  bvt_prod.XSell_Best_View_Forecast_VW a
	  JOIN bvt_prod.Touch_Definition_VW b
	  on a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
	  group by 	    
	    a.[idFlight_Plan_Records]
      , a.[Campaign_Name]
      , a.[InHome_Date]
      , a.[Strategy_Eligibility]
      , a.[Lead_Offer]
      , a.[Touch_Name]
      , a.[Media_Year]
      , a.[Media_Month]
      , a.[Media_Week]
      , a.[Calendar_Year]
      , a.[Calendar_Month]
      , a.[Program_Name]
      , a.[Tactic]
      , a.[Media]
      , a.[Campaign_Type]
      , a.[Audience]
      , a.[Creative_Name]
      , a.[Goal]
      , a.[Offer]
      , a.[Channel]
      , b.[Scorecard_Group]
      , b.[Scorecard_Program_Channel]
      , a.[KPI_Type]
      , a.[Product_Code]
      , a.[Media_YYYYWW]) as forecast
		
		---Join CV to Current Forecast Table
		full join 
			(select [id_Flight_Plan_Records_FK], [idProgram_Touch_Definitions_TBL_FK], [Campaign_Name], [InHome_Date], 
			[Media_Year], [Media_Month], [Media_Week], [Calendar_Year], [Calendar_Month], [KPI_TYPE], [Product_Code],  SUM([forecast]) as Forecast, 
			[Touch_Name], [Program_Name], [Tactic], [Media], [Audience], [Creative_Name], [Goal], [Offer], [Campaign_Type], [Channel],
			[Scorecard_Group], [Scorecard_Program_Channel]
			from bvt_processed.Commitment_Views
				-----Bring in touch definition labels 
				left join bvt_prod.Touch_Definition_VW on Commitment_Views.[idProgram_Touch_Definitions_TBL_FK] = Touch_Definition_VW.[idProgram_Touch_Definitions_TBL]
			where CV_Submission in ('XSell 2016 Submission Adj 20160426', 'XSell 2017 Adj Submission 20170227') 
			GROUP BY [id_Flight_Plan_Records_FK], [idProgram_Touch_Definitions_TBL_FK], [Campaign_Name], [InHome_Date], 
			[Media_Year], [Media_Month], [Media_Week], [Calendar_Year], [Calendar_Month], [KPI_TYPE], [Product_Code],
			[Touch_Name], [Program_Name], [Tactic], [Media], [Audience], [Creative_Name], [Goal], [Offer], [Campaign_Type], [Channel],
			[Scorecard_Group], [Scorecard_Program_Channel]) as CV
		 on forecast.[idFlight_Plan_Records] = cv.[id_Flight_Plan_Records_FK] 
			and forecast.[media_year] = cv.[Media_Year]
			and forecast.[media_week] = cv.[Media_Week]
			and forecast.[Calendar_Month] = cv.[Calendar_Month]
			and forecast.[Calendar_Year] = cv.[Calendar_Year]
			and forecast.[kpi_type] = cv.[kpi_type]
			and forecast.[product_code] = cv.[product_code]
	
	  group by Coalesce(forecast.[idFlight_Plan_Records], cv.[id_Flight_Plan_Records_FK]) 
      ,Coalesce(forecast.[Campaign_Name], cv.[Campaign_Name]) 
      ,coalesce(forecast.[InHome_Date], cv.[InHome_Date]) 
      ,coalesce(forecast.[Strategy_Eligibility], '')
      ,coalesce(forecast.[Lead_Offer], '')
      ,coalesce(forecast.[Touch_Name], cv.[Touch_Name]) 
      ,coalesce(forecast.[Program_Name], cv.[Program_Name])
      ,coalesce(forecast.[Tactic], cv.[Tactic]) 
      ,coalesce(forecast.[Media], cv.[Media])
      ,coalesce(forecast.[Campaign_Type], cv.[Campaign_Type]) 
      ,coalesce(forecast.[Audience], cv.[Audience]) 
      ,coalesce(forecast.[Creative_Name], cv.[Creative_Name]) 
      ,coalesce(forecast.[Goal], cv.[Goal]) 
      ,coalesce(forecast.[Offer], cv.[Offer])
      ,coalesce(forecast.[Channel], cv.[Channel])
      ,coalesce(forecast.[Scorecard_Group], cv.[Scorecard_Group])
      ,coalesce(forecast.[Scorecard_Program_Channel], cv.[Scorecard_Program_Channel])
      ,coalesce(forecast.[KPI_Type], cv.[KPI_Type])
      ,coalesce(forecast.[Product_Code], cv.[Product_Code])
	  ,coalesce(forecast.[media_year], cv.[media_year])
	  ,coalesce(forecast.[media_month], cv.[media_month])
	  ,coalesce(forecast.[media_week], cv.[media_week])
	  ,coalesce(forecast.[Calendar_Year], cv.[Calendar_Year])
	  ,coalesce(forecast.[Calendar_Month], cv.[Calendar_Month])
	  ,case when cv.[Media_Week] < 10 
		then coalesce(forecast.[Media_YYYYWW], cast((cast(cv.[media_year] as char(4))+'0'+cast(cv.[media_week] as char(1))) as int))
		else coalesce(forecast.[Media_YYYYWW], cast((cast(cv.[media_year] as char(4))+cast(cv.[media_week] as char(2))) as int))
		end) as forecast_cv

----Join Actuals
		--Volume and Budget
		full outer join 
			(select [idFlight_Plan_Records_FK], [Campaign_Name], [iso_week_year] as Media_Year, [mediamonth] as Media_Month, [iso_week] as Media_Week, 
			YEAR(Start_Date) as [Calendar_Year], MONTH(Start_Date) as [Calendar_Month], [inhome_date], [Touch_Name], [Program_Name], [Tactic], [Media], 
			[Campaign_Type], [Audience], [Creative_Name], [Goal], [Offer], [Channel], [Scorecard_Group], [Scorecard_Program_Channel],
			[KPI_TYPE], [Product_Code], Actual

			from 
			(select [idFlight_Plan_Records_FK], [Start_Date]

			, case when kpiproduct='CTD_Quantity' then 'Volume'
				when kpiproduct='CTD_Budget' then 'Budget'
				end as
			KPI_type

			, case when kpiproduct='CTD_Quantity' then 'Volume'
				when kpiproduct='CTD_Budget' then 'Budget'
				end as
			Product_Code

			, sum(Actuals.[Actual]) as Actual

			from (select idFlight_Plan_Records_FK, Start_Date, sum(CTD_Quantity) as CTD_Quantity, sum(CTD_Budget) as CTD_Budget
					from 
					(
					select idFlight_Plan_Records_FK, parentid, Start_Date, CTD_Quantity, CTD_Budget 
						from bvt_prod.XSell_Actuals_VW 
					group by idFlight_Plan_Records_FK, parentid, Start_Date, CTD_Quantity, CTD_Budget
					) A
				group by idFlight_Plan_Records_FK, Start_Date) as actual_query

				UNPIVOT (Actual for kpiproduct in 
					([CTD_Quantity], [CTD_Budget])) as Actuals
			GROUP BY idFlight_Plan_Records_FK, Start_Date
				, case when kpiproduct='CTD_Quantity' then 'Volume'
					when kpiproduct='CTD_Budget' then 'Budget'
					end 
				, case when kpiproduct='CTD_Quantity' then 'Volume'
					when kpiproduct='CTD_Budget' then 'Budget'
					end) as pivotmetrics
			inner join dim.media_calendar_daily on [Start_Date] = [date]
			inner join bvt_prod.XSell_Flight_Plan_VW on [idFlight_Plan_Records_FK] = [idFlight_Plan_Records]
			inner join bvt_prod.Touch_Definition_VW on [idProgram_Touch_Definitions_TBL] = [idProgram_Touch_Definitions_TBL_FK]) as actual_volume --END OF VOLUME BUDGET QUERY

		on forecast_cv.[idFlight_Plan_Records_FK] = actual_volume.[idFlight_plan_records_FK] and forecast_cv.[media_year] = actual_volume.[media_year]
		 and forecast_cv.[media_week] = actual_volume.[media_week] and forecast_cv.[KPI_Type] = actual_volume.[KPI_Type]
		 and forecast_cv.[Product_Code] = actual_volume.[Product_Code] and forecast_cv.[Calendar_Year] = actual_volume.[Calendar_Year] 
		 and forecast_cv.[Calendar_Month] = actual_volume.[Calendar_Month]



-----Join Response and Sales
		full outer join 
		(select [idFlight_Plan_Records_FK], [Media_Year], [Media_Week],  [MediaMonth] as Media_Month, [Calendar_Year], [Calendar_Month],
			[inhome_date], [Touch_Name], [Program_Name], [Tactic], [Media], [Campaign_Name],
			[Campaign_Type], [Audience], [Creative_Name], [Goal], [Offer], [Channel],
			[Scorecard_Group], [Scorecard_Program_Channel],
			[KPI_TYPE], [Product_Code], Actual
		from
		(select [idFlight_Plan_Records_FK], [Report_Year] as Media_Year, [Report_Week] as Media_Week, [Calendar_Year], [Calendar_Month]

, case 
	when kpiproduct='ITP_Dir_Calls' then 'Response'
	when kpiproduct='ITP_Dir_Clicks' then 'Response'
	when kpiproduct like '%Sales_TS%' then 'Telesales'
	when kpiproduct like '%Sales_ON%' then 'Online_sales'
	end as
	KPI_type

, case
	when kpiproduct='ITP_Dir_Calls' then 'Call'
	when kpiproduct='ITP_Dir_Clicks' then 'Online'
	when kpiproduct like '%CING_VOICE%' then 'WRLS Voice'
	when kpiproduct like '%CING_FAMILY%' then 'WRLS Family'
	when kpiproduct like '%CING_DATA%' then 'WRLS Data'
	when kpiproduct like '%DISH%' then 'DirecTV'
	when kpiproduct like '%DSL_DRY%' then 'DSL Direct'
	when kpiproduct like '%DSL_REG%' then 'DSL'
	when kpiproduct like '%HSIAG%' then 'Fiber'
	when kpiproduct like '%HSIA%' then 'HSIA'
	when kpiproduct like '%DSL_IP%' then 'IPDSL'
	when kpiproduct like '%UVRS_TV%' then 'UVTV'
	when kpiproduct like '%VOIP%' then 'VoIP' 
	when kpiproduct like '%ACCL%' then 'Access Line'
	when kpiproduct like '%BOLT%' then 'Bolt ons'
	when kpiproduct like '%Migrations%' then 'Upgrades'
	when kpiproduct like '%CTECH%' then 'ConnecTech'
	when kpiproduct like '%DLIFE%' then 'Digital Life'
	when kpiproduct like '%WHP%' then 'WRLS Home'
	end as
	Product_Code

, sum(Actuals.Actual) as Actual

from bvt_prod.XSell_Actuals_VW

UNPIVOT (Actual for kpiproduct in 
			([ITP_Dir_Calls], [ITP_Dir_Clicks], 
			[ITP_Dir_Sales_TS_CING_VOICE_N], [ITP_Dir_Sales_TS_CING_FAMILY_N], 
			[ITP_Dir_Sales_TS_CING_DATA_N], [ITP_Dir_Sales_TS_DISH_N], [ITP_Dir_Sales_TS_DSL_REG_N], 
			[ITP_Dir_Sales_TS_DSL_DRY_N], [ITP_Dir_Sales_TS_DSL_IP_N], [ITP_Dir_Sales_TS_UVRS_HSIAG_N], [ITP_Dir_Sales_TS_UVRS_HSIA_N], [ITP_Dir_Sales_TS_UVRS_TV_N], 
			[ITP_Dir_Sales_TS_UVRS_BOLT_N], [ITP_Dir_Sales_TS_LOCAL_ACCL_N], [ITP_Dir_Sales_TS_UVRS_VOIP_N], [ITP_Dir_Sales_TS_CTECH_N], 
			[ITP_Dir_Sales_TS_DLIFE_N], [ITP_Dir_sales_TS_CING_WHP_N], [ITP_Dir_Sales_TS_Migrations], 
			[ITP_Dir_Sales_ON_CING_VOICE_N], [ITP_Dir_Sales_ON_CING_FAMILY_N], [ITP_Dir_Sales_ON_CING_DATA_N], [ITP_Dir_Sales_ON_DISH_N], 
			[ITP_Dir_Sales_ON_DSL_REG_N], [ITP_Dir_Sales_ON_DSL_DRY_N], [ITP_Dir_Sales_ON_DSL_IP_N], [ITP_Dir_Sales_ON_UVRS_HSIAG_N],
			[ITP_Dir_Sales_ON_UVRS_HSIA_N], [ITP_Dir_Sales_ON_UVRS_TV_N], [ITP_Dir_Sales_ON_UVRS_BOLT_N], [ITP_Dir_Sales_ON_LOCAL_ACCL_N], 
			[ITP_Dir_Sales_ON_UVRS_VOIP_N], [ITP_Dir_Sales_ON_DLIFE_N], [ITP_Dir_Sales_ON_CING_WHP_N], [ITP_Dir_Sales_ON_Migrations])) as Actuals
GROUP BY [idFlight_Plan_Records_FK], [Report_Year], [Report_Week], [Calendar_Year], [Calendar_Month]

, case
	when kpiproduct='ITP_Dir_Calls' then 'Response'
	when kpiproduct='ITP_Dir_Clicks' then 'Response'
	when kpiproduct like '%Sales_TS%' then 'Telesales'
	when kpiproduct like '%Sales_ON%' then 'Online_sales'
	end 

, case 
	when kpiproduct='ITP_Dir_Calls' then 'Call'
	when kpiproduct='ITP_Dir_Clicks' then 'Online'
	when kpiproduct like '%CING_VOICE%' then 'WRLS Voice'
	when kpiproduct like '%CING_FAMILY%' then 'WRLS Family'
	when kpiproduct like '%CING_DATA%' then 'WRLS Data'
	when kpiproduct like '%DISH%' then 'DirecTV'
	when kpiproduct like '%DSL_DRY%' then 'DSL Direct'
	when kpiproduct like '%DSL_REG%' then 'DSL'
	when kpiproduct like '%HSIAG%' then 'Fiber'
	when kpiproduct like '%HSIA%' then 'HSIA'
	when kpiproduct like '%DSL_IP%' then 'IPDSL'
	when kpiproduct like '%UVRS_TV%' then 'UVTV'
	when kpiproduct like '%VOIP%' then 'VoIP' 
	when kpiproduct like '%ACCL%' then 'Access Line'
	when kpiproduct like '%BOLT%' then 'Bolt ons'
	when kpiproduct like '%Migrations%' then 'Upgrades'
	when kpiproduct like '%CTECH%' then 'ConnecTech'
	when kpiproduct like '%DLIFE%' then 'Digital Life'
	when kpiproduct like '%WHP%' then 'WRLS Home'
	end 
	) as actuals 
	inner join bvt_prod.XSell_Flight_Plan_VW on [idFlight_Plan_Records_FK] = [idFlight_Plan_Records]
	inner join bvt_prod.Touch_Definition_VW on [idProgram_Touch_Definitions_TBL] = [idProgram_Touch_Definitions_TBL_FK]
	inner join (Select distinct [ISO_week], [ISO_Week_Year], [MediaMonth] from DIM.Media_Calendar_Daily) d
on [Media_week] = d.[ISO_Week] and [Media_Year] = d.[ISO_Week_Year]) as actual_results
  
	 ON forecast_cv.[idFlight_Plan_Records_FK] = actual_results.[idFlight_Plan_Records_FK] and forecast_cv.[media_year] = actual_results.[media_year]
		 and forecast_cv.[media_week] = actual_results.[media_week] and forecast_cv.[KPI_Type] =actual_results.[KPI_Type]
		 and forecast_cv.[Product_Code] = actual_results.[product_code] and forecast_cv.[Calendar_Year] =actual_results.[Calendar_Year]
		 and forecast_cv.[Calendar_Month] = actual_results.[Calendar_Month] 
GO
GO


GO
