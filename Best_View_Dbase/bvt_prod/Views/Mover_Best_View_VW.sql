drop view [bvt_prod].[Mover_Best_View_VW]
GO

CREATE VIEW [bvt_prod].[Mover_Best_View_VW]
	AS 
	select 
		forecast_cv.[idFlight_Plan_Records_FK], [Campaign_Name], forecast_cv.[InHome_Date], forecast_cv.[Media_Year], 
		forecast_cv.[Media_Week], [Media_Month], [Touch_Name], [Program_Name], [Tactic], [Media], 
		[Campaign_Type], [Audience], [Creative_Name], [Goal], [Offer], forecast_cv.[KPI_Type], forecast_cv.[Product_Code], 
		Forecast
		,Commitment
		,coalesce(actual_volume.Actual,actual_results.Actual) as Actual
		,case when forecast_cv.Media_Week>(case when DATEPART(weekday,getdate()) <= 5 then DATEPART(wk,getdate())-2 else DATEPART(wk,getdate())-1	end) then Forecast
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
	  ,coalesce(forecast.media_week, cv.media_year) as media_week
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
	  [bvt_processed].[Movers_Best_View_Forecast]
	   where [load_dt]=(select max([load_dt]) from [bvt_processed].[Movers_Best_View_Forecast])
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
			[Media_Year], [Media_Month], [Media_Week], [KPI_TYPE], [Product_Code], sum([Forecast]) as forecast, 
			[Touch_Name], [Program_Name], [Tactic], [Media], [Audience], [Creative_Name], [Goal], [Offer], [Campaign_Type]
			from [bvt_processed].[Commitment_Views] 
				-----Bring in touch definition labels 
				left join [bvt_prod].[Touch_Definition_VW] on [Commitment_Views].[idProgram_Touch_Definitions_TBL_FK]=[Touch_Definition_VW].[idProgram_Touch_Definitions_TBL]
			where extract_date='2014-12-18'
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
	  ,coalesce(forecast.media_week, cv.media_year)) as forecast_cv

----Join Actuals
		--Volume and Budget
		left join 
			(select idFlight_Plan_Records_FK, iso_week_year as Media_Year, iso_week as Media_Week, KPI_TYPE, Product_Code, Actual

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

			from bvt_prod.Movers_Actuals_VW

				UNPIVOT (Actual for kpiproduct in 
					([CTD_Quantity], [CTD_Budget])) as Actuals
			GROUP BY idFlight_Plan_Records_FK, Start_Date
				, case when kpiproduct='CTD_Quantity' then 'Volume'
					when kpiproduct='CTD_Budget' then 'Budget'
					end 
				, case when kpiproduct='CTD_Quantity' then 'Volume'
					when kpiproduct='CTD_Budget' then 'Budget'
					end) as pivotmetrics
			inner join dim.media_calendar_daily on start_date=[date]) as actual_volume --END OF VOLUME BUDGET QUERY

		on forecast_cv.[idFlight_Plan_Records_FK]=actual_volume.idFlight_plan_records_FK and forecast_cv.media_year=actual_volume.media_year
		 and forecast_cv.media_week=actual_volume.media_week and forecast_cv.kpi_type=actual_volume.KPI_Type
		 and forecast_cv.Product_Code=actual_volume.Product_Code


-----Join Response and Sales
		left join (select idFlight_Plan_Records_FK, Report_Year as Media_Year, Report_Week as Media_Week

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
	) as actual_results
	  
	 ON forecast_cv.[idFlight_Plan_Records_FK]=actual_results.idFlight_plan_records_FK and forecast_cv.media_year=actual_results.media_year
		 and forecast_cv.media_week=actual_results.media_week and forecast_cv.kpi_type=actual_results.KPI_Type 
		 and forecast_cv.product_code=actual_results.product_code
GO
