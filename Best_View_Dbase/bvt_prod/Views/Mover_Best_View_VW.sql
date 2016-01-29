drop view [bvt_prod].[Mover_Best_View_VW]
GO

CREATE VIEW [bvt_prod].[Mover_Best_View_VW]
	AS 
	select 
		coalesce(forecast_cv.[idFlight_Plan_Records_FK],actual_volume.[idFlight_Plan_Records_FK],actual_results.[idFlight_Plan_Records_FK]) as [idFlight_Plan_Records_FK],
		coalesce(forecast_cv.[Campaign_Name],actual_volume.[Campaign_Name],actual_results.[Campaign_Name]) as [Campaign_Name],
		coalesce(forecast_cv.[InHome_Date],actual_volume.[InHome_Date],actual_results.[InHome_Date]) as [InHome_Date],
		coalesce(forecast_cv.[Media_Year],actual_volume.[Media_Year],actual_results.[Media_Year]) as [Media_Year],
		coalesce(forecast_cv.[Media_Week],actual_volume.[Media_Week],actual_results.[Media_Week]) as [Media_Week],
		coalesce(forecast_cv.[Media_Month],actual_volume.[Media_Month],actual_results.Media_Month) as [Media_Month],
		coalesce(forecast_cv.[Touch_Name],actual_volume.[Touch_Name],actual_results.[Touch_Name]) as [Touch_Name], 
		coalesce(forecast_cv.[Program_Name],actual_volume.[Program_Name],actual_results.[Program_Name]) as [Program_Name], 
		coalesce(forecast_cv.[Tactic],actual_volume.[Tactic],actual_results.[Tactic]) as [Tactic], 
		coalesce(forecast_cv.[Media], actual_volume.[Media],actual_results.[Media]) as [Media],
		coalesce(forecast_cv.[Campaign_Type], actual_volume.[Campaign_Type],actual_results.[Campaign_Type]) as [Campaign_Type],
		coalesce(forecast_cv.[Audience], actual_volume.[Audience],actual_results.[Audience]) as [Audience],
		coalesce(forecast_cv.[Creative_Name], actual_volume.[Creative_Name],actual_results.[Creative_Name]) as [Creative_Name],
		coalesce(forecast_cv.[Goal], actual_volume.[Goal],actual_results.[Goal]) as [Goal],
		coalesce(forecast_cv.[Offer], actual_volume.[Offer],actual_results.[Offer]) as [Offer],
		coalesce(forecast_cv.[KPI_Type], actual_volume.[KPI_Type],actual_results.[KPI_Type]) as [KPI_Type],
		coalesce(forecast_cv.[Product_Code], actual_volume.[Product_Code],actual_results.[Product_Code]) as [Product_Code]
		,isnull(Forecast,0) as Forecast
		,isnull(Commitment,0) as Commitment
		,isnull(coalesce(actual_volume.Actual,actual_results.Actual),0) as Actual
		,case when forecast_cv.Media_Week>(case when DATEPART(weekday,getdate()) <= 5 then DATEPART(wk,getdate())-2 else DATEPART(wk,getdate())-1	end) then Forecast
			--Short term work around for missing volume in scorecard
			when forecast_cv.[KPI_Type]='Volume' then Forecast
			--work around to prevent double counting forecast and actual volumes due to mismatched drop date timing
			when actual_volume.KPI_type='Volume'  and forecast_cv.KPI_Type is null then 0
				---Remove when volume problem fixed
			else coalesce(actual_volume.Actual,actual_results.Actual)
			end as Best_View
		
	FROM	
	---select to join the forecast and CV
	(SELECT 
	   Coalesce(forecast.[idFlight_Plan_Records], cv.[id_Flight_Plan_Records_FK]) as idFlight_Plan_Records_FK
      ,Coalesce(forecast.[Campaign_Name], cv.[Campaign_Name]) as Campaign_Name
      ,coalesce(forecast.[InHome_Date], cv.[InHome_Date]) as InHome_Date
      ,coalesce(forecast.[Touch_Name], cv.[Touch_Name]) as [Touch_Name]
      ,coalesce(forecast.[Program_Name], cv.[Program_Name]) as [Program_Name]
      ,coalesce(forecast.[Tactic], cv.[Tactic]) as [Tactic]
      ,coalesce(forecast.[Media], cv.[Media]) as [Media]
      ,coalesce(forecast.[Campaign_Type], cv.[Campaign_Type]) as [Campaign_Type]
      ,coalesce(forecast.[Audience], cv.[Audience]) as [Audience]
      ,coalesce(forecast.[Creative_Name], cv.[Creative_Name]) as [Creative_Name]
      ,coalesce(forecast.[Goal], cv.[Goal]) as [Goal]
      ,coalesce(forecast.[Offer], cv.[Offer]) as [Offer]
      ,coalesce(forecast.[KPI_Type], cv.[KPI_Type]) as [KPI_Type]
      ,coalesce(forecast.[Product_Code], cv.[Product_Code]) as [Product_Code]
	  ,coalesce(forecast.media_year, cv.media_year) as media_year
	  ,coalesce(forecast.media_month, cv.media_month) as media_month
	  ,coalesce(forecast.media_week, cv.media_week) as media_week
      ,sum(forecast.[Forecast]) as Forecast
	  ,sum(CV.forecast) as Commitment 
	  FROM 
	  
	  (select 
	  [idFlight_Plan_Records]
      ,Campaign_Name
      , InHome_Date
      , [Touch_Name]
      , Media_Year
      , Media_Month
      , Media_Week
      ,[Program_Name]
      ,[Tactic]
      ,[Media]
      ,[Campaign_Type]
      ,[Audience]
      ,[Creative_Name]
      ,[Goal]
      ,[Offer]
      ,[KPI_Type]
      ,[Product_Code]
	  ,SUM(Forecast) as forecast
	  from
	  [bvt_prod].[Movers_Best_View_Forecast_VW]
	   
	  group by [idFlight_Plan_Records]
      ,Campaign_Name
      , InHome_Date
      , [Touch_Name]
      ,[Program_Name]
      ,[Tactic]
      ,[Media]
      ,[Campaign_Type]
      ,[Audience]
      ,[Creative_Name]
      ,[Goal]
      ,[Offer]
      ,[KPI_Type]
      ,[Product_Code]
      , Media_Year
      , Media_Month
      , Media_Week) as forecast
		
		---Join CV to Current Forecast Table
		full join 
			(select [id_Flight_Plan_Records_FK], [idProgram_Touch_Definitions_TBL_FK], [Campaign_Name], [InHome_Date], 
			[Media_Year], [Media_Month], [Media_Week], [KPI_TYPE], [Product_Code], 
			case when kpi_type='Volume' and campaign_name like '%TFN%'
				then 0 else sum([Forecast]) end as forecast, 
			[Touch_Name], [Program_Name], [Tactic], [Media], [Audience], [Creative_Name], [Goal], [Offer], [Campaign_Type]
			from [bvt_processed].[Commitment_Views] 
				-----Bring in touch definition labels 
				left join [bvt_prod].[Touch_Definition_VW] on [Commitment_Views].[idProgram_Touch_Definitions_TBL_FK]=[Touch_Definition_VW].[idProgram_Touch_Definitions_TBL]
			where CV_Submission in('Movers 2016 Submission 20160125','Movers CV Restatement Aug 2015') --extract_date='2015-08-26'
			GROUP BY [id_Flight_Plan_Records_FK], [idProgram_Touch_Definitions_TBL_FK], [Campaign_Name], [InHome_Date], 
			[Media_Year], [Media_Month], [Media_Week], [KPI_TYPE], [Product_Code],
			[Touch_Name], [Program_Name], [Tactic], [Media], [Audience], [Creative_Name], [Goal], [Offer], [Campaign_Type] ) as CV
		 on forecast.[idFlight_Plan_Records]=cv.[id_Flight_Plan_Records_FK] 
			and forecast.media_year=cv.Media_Year
			and forecast.media_week=cv.Media_Week
			and forecast.kpi_type=cv.kpi_type
			and forecast.product_code=cv.product_code
	
	  group by Coalesce(forecast.[idFlight_Plan_Records], cv.[id_Flight_Plan_Records_FK]) 
      ,Coalesce(forecast.[Campaign_Name], cv.[Campaign_Name]) 
      ,coalesce(forecast.[InHome_Date], cv.[InHome_Date]) 
      ,coalesce(forecast.[Touch_Name], cv.[Touch_Name]) 
      ,coalesce(forecast.[Program_Name], cv.[Program_Name])
      ,coalesce(forecast.[Tactic], cv.[Tactic]) 
      ,coalesce(forecast.[Media], cv.[Media])
      ,coalesce(forecast.[Campaign_Type], cv.[Campaign_Type]) 
      ,coalesce(forecast.[Audience], cv.[Audience]) 
      ,coalesce(forecast.[Creative_Name], cv.[Creative_Name]) 
      ,coalesce(forecast.[Goal], cv.[Goal]) 
      ,coalesce(forecast.[Offer], cv.[Offer])
      ,coalesce(forecast.[KPI_Type], cv.[KPI_Type])
      ,coalesce(forecast.[Product_Code], cv.[Product_Code])
	  ,coalesce(forecast.media_year, cv.media_year)
	  ,coalesce(forecast.media_month, cv.media_month)
	  ,coalesce(forecast.media_week, cv.media_week)) as forecast_cv

----Join Actuals
		--Volume and Budget
		full outer join 
			(select idFlight_Plan_Records_FK, [Campaign_Name], iso_week_year as Media_Year, mediamonth as Media_Month, iso_week as Media_Week, 
			inhome_date, [Touch_Name], [Program_Name], [Tactic], [Media], 
			[Campaign_Type], [Audience], [Creative_Name], [Goal], [Offer],
			KPI_TYPE, Product_Code, Actual

			from 
			(select idFlight_Plan_Records_FK, Start_Date

			, case when kpiproduct='CTD_Quantity' then 'Volume'
				when kpiproduct='CTD_Budget' then 'Budget'
				end as
			KPI_type

			, case when kpiproduct='CTD_Quantity' then 'Volume'
				when kpiproduct='CTD_Budget' then 'Budget'
				end as
			Product_Code

			, sum(Actuals.Actual) as Actual

			from (select idFlight_Plan_Records_FK, Start_Date, CTD_Quantity, CTD_Budget 
				from bvt_prod.Movers_Actuals_VW 
				group by idFlight_Plan_Records_FK, Start_Date, CTD_Quantity, CTD_Budget) as actual_query

				UNPIVOT (Actual for kpiproduct in 
					([CTD_Quantity], [CTD_Budget])) as Actuals
			GROUP BY idFlight_Plan_Records_FK, Start_Date
				, case when kpiproduct='CTD_Quantity' then 'Volume'
					when kpiproduct='CTD_Budget' then 'Budget'
					end 
				, case when kpiproduct='CTD_Quantity' then 'Volume'
					when kpiproduct='CTD_Budget' then 'Budget'
					end) as pivotmetrics
			inner join dim.media_calendar_daily on start_date=[date]
			inner join [bvt_prod].[Movers_Flight_Plan_VW] on idFlight_Plan_Records_FK=[idFlight_Plan_Records]
			inner join [bvt_prod].[Touch_Definition_VW] on [idProgram_Touch_Definitions_TBL]=[idProgram_Touch_Definitions_TBL_FK]) as actual_volume --END OF VOLUME BUDGET QUERY

		on forecast_cv.[idFlight_Plan_Records_FK]=actual_volume.idFlight_plan_records_FK and forecast_cv.media_year=actual_volume.media_year
		 and forecast_cv.media_week=actual_volume.media_week and forecast_cv.kpi_type=actual_volume.KPI_Type
		 and forecast_cv.Product_Code=actual_volume.Product_Code


-----Join Response and Sales
		full outer join 
		(select idFlight_Plan_Records_FK, Media_Year, Media_Week,  MediaMonth as Media_Month,
			inhome_date, [Touch_Name], [Program_Name], [Tactic], [Media], [Campaign_Name],
			[Campaign_Type], [Audience], [Creative_Name], [Goal], [Offer],
			KPI_TYPE, Product_Code, Actual
		from
		(select idFlight_Plan_Records_FK, Report_Year as Media_Year, Report_Week as Media_Week

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
	when kpiproduct like '%DISH%' then 'Satellite'
	when kpiproduct like '%DSL_DRY%' then 'DSL Direct'
	when kpiproduct like '%DSL_REG%' then 'DSL'
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

from bvt_prod.Movers_Actuals_VW

UNPIVOT (Actual for kpiproduct in 
			([ITP_Dir_Calls], [ITP_Dir_Clicks], 
			[ITP_Dir_Sales_TS_CING_VOICE_N], [ITP_Dir_Sales_TS_CING_FAMILY_N], 
			[ITP_Dir_Sales_TS_CING_DATA_N], [ITP_Dir_Sales_TS_DISH_N], [ITP_Dir_Sales_TS_DSL_REG_N], 
			[ITP_Dir_Sales_TS_DSL_DRY_N], [ITP_Dir_Sales_TS_DSL_IP_N], [ITP_Dir_Sales_TS_UVRS_HSIA_N], [ITP_Dir_Sales_TS_UVRS_TV_N], 
			[ITP_Dir_Sales_TS_UVRS_BOLT_N], [ITP_Dir_Sales_TS_LOCAL_ACCL_N], [ITP_Dir_Sales_TS_UVRS_VOIP_N], [ITP_Dir_Sales_TS_CTECH_N], 
			[ITP_Dir_Sales_TS_DLIFE_N], [ITP_Dir_sales_TS_CING_WHP_N], [ITP_Dir_Sales_TS_Migrations], 
			[ITP_Dir_Sales_ON_CING_VOICE_N], [ITP_Dir_Sales_ON_CING_FAMILY_N], [ITP_Dir_Sales_ON_CING_DATA_N], [ITP_Dir_Sales_ON_DISH_N], 
			[ITP_Dir_Sales_ON_DSL_REG_N], [ITP_Dir_Sales_ON_DSL_DRY_N], [ITP_Dir_Sales_ON_DSL_IP_N], 
			[ITP_Dir_Sales_ON_UVRS_HSIA_N], [ITP_Dir_Sales_ON_UVRS_TV_N], [ITP_Dir_Sales_ON_UVRS_BOLT_N], [ITP_Dir_Sales_ON_LOCAL_ACCL_N], 
			[ITP_Dir_Sales_ON_UVRS_VOIP_N], [ITP_Dir_Sales_ON_DLIFE_N], [ITP_Dir_Sales_ON_CING_WHP_N], [ITP_Dir_Sales_ON_Migrations])) as Actuals
GROUP BY idFlight_Plan_Records_FK, Report_Year, Report_Week

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
	when kpiproduct like '%DISH%' then 'Satellite'
	when kpiproduct like '%DSL_DRY%' then 'DSL Direct'
	when kpiproduct like '%DSL_REG%' then 'DSL'
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
	inner join [bvt_prod].[Movers_Flight_Plan_VW] on idFlight_Plan_Records_FK=[idFlight_Plan_Records]
	inner join [bvt_prod].[Touch_Definition_VW] on [idProgram_Touch_Definitions_TBL]=[idProgram_Touch_Definitions_TBL_FK]
	inner join (Select distinct ISO_week, ISO_Week_Year, MediaMonth from DIM.Media_Calendar_Daily) d
on Media_week = d.ISO_Week and Media_Year = d.ISO_Week_Year) as actual_results
	  
	 ON forecast_cv.[idFlight_Plan_Records_FK]=actual_results.idFlight_plan_records_FK and forecast_cv.media_year=actual_results.media_year
		 and forecast_cv.media_week=actual_results.media_week and forecast_cv.kpi_type=actual_results.KPI_Type 
		 and forecast_cv.product_code=actual_results.product_code
GO
