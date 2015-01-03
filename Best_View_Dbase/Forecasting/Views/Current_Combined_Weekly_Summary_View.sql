CREATE view forecasting.Current_Combined_Weekly_Summary_View
as
select case when [Program] like '%NA%' then 'NA'
      else 'UPRO'
      end as [Program Type]
      ,[Media]
      ,[Program] as [Project]
      ,[reportweek_YYYYWW]
      ,[month_long]
      ,[Actual_Project_Budget]
      ,[Actual_Project_Volume]
      ,[Actual_Calls]
      ,[Actual_Clicks]
      ,[Actual_Call_Wrls_Voice_Sales]
      ,[Actual_Call_WRLS_Family_Sales]
      ,[Actual_Call_WRLS_Data_Sales]
      ,[Actual_CALL_Dish_Sales]
      ,[Actual_Call_DSL_Reg_Sales]
      ,[Actual_Call_DSL_Dry_Sales]
      ,[Actual_Call_IPDSL_Sales]
      ,[Actual_Call_HSIA_Sales]
      ,[Actual_Call_TV_Sales]
      ,[Actual_CALL_Access_Sales]
      ,[Actual_Call_VOIP_Sales]
      ,[Actual_ONLINE_Wrls_Voice_Sales]
      ,[Actual_ONLINE_WRLS_Family_Sales]
      ,[Actual_ONLINE_WRLS_Data_Sales]
      ,[Actual_ONLINE_Dish_Sales]
      ,[Actual_ONLINE_DSL_Reg_Sales]
      ,[Actual_ONLINE_DSL_Dry_Sales]
      ,[Actual_ONLINE_IPDSL_Sales]
      ,[Actual_ONLINE_HSIA_Sales]
      ,[Actual_ONLINE_TV_Sales]
      ,[Actual_ONLINE_VOIP_Sales]
      ,[Actual_ONLINE_Access_Sales]
      ,[CV_ONLINE_Wrls_Voice_Sales]
      ,[CV_Call_TV_Sales]
      ,[CV_ONLINE_Access_Sales]
      ,[CV_Call_DSL_Reg_Sales]
      ,[CV_ONLINE_WRLS_Family_Sales]
      ,[CV_Drop_Volume]
      ,[CV_Call_VOIP_Sales]
      ,[CV_ONLINE_Dish_Sales]
      ,[CV_Call_IPDSL_Sales]
      ,[CV_ONLINE_DSL_Reg_Sales]
      ,[CV_Clicks]
      ,[CV_CALL_Access_Sales]
      ,[CV_Call_WRLS_Family_Sales]
      ,[CV_CALL_Dish_Sales]
      ,[CV_ONLINE_VOIP_Sales]
      ,[CV_Finance_Budget]
      ,[CV_ONLINE_HSIA_Sales]
      ,[CV_ONLINE_DSL_Dry_Sales]
      ,[CV_Calls]
      ,[CV_Call_Wrls_Voice_Sales]
      ,[CV_Call_WRLS_Data_Sales]
      ,[CV_ONLINE_TV_Sales]
      ,[CV_Call_HSIA_Sales]
      ,[CV_ONLINE_WRLS_Data_Sales]
      ,[CV_Call_DSL_Dry_Sales]
      ,[CV_ONLINE_IPDSL_Sales]
      ,[BV_ONLINE_WRLS_Family_Sales]
      ,[BV_CALL_Access_Sales]
      ,[BV_ONLINE_TV_Sales]
      ,[BV_CALL_Dish_Sales]
      ,[BV_Call_DSL_Dry_Sales]
      ,[BV_ONLINE_Dish_Sales]
      ,[BV_ONLINE_Access_Sales]
      ,[BV_Call_HSIA_Sales]
      ,[BV_Call_Wrls_Voice_Sales]
      ,[BV_Finance_Budget]
      ,[BV_ONLINE_IPDSL_Sales]
      ,[BV_Calls]
      ,[BV_ONLINE_DSL_Dry_Sales]
      ,[BV_ONLINE_DSL_Reg_Sales]
      ,[BV_Call_WRLS_Family_Sales]
      ,[BV_ONLINE_Wrls_Voice_Sales]
      ,[BV_Clicks]
      ,[BV_ONLINE_WRLS_Data_Sales]
      ,[BV_Call_TV_Sales]
      ,[BV_ONLINE_HSIA_Sales]
      ,[BV_ONLINE_VOIP_Sales]
      ,[BV_Call_DSL_Reg_Sales]
      ,[BV_Call_WRLS_Data_Sales]
      ,[BV_Call_VOIP_Sales]
      ,[BV_Drop_Volume]
      ,[BV_Call_IPDSL_Sales]
from Forecasting.Current_UPRO_Weekly_Summary_View
UNION
select case when [Project] like 'NA' then 'NA'
      else 'UVLB'
      end as [Program Type]
      ,case when [Media_Type] ='DM' then 'Direct Mail'
      when [Media_Type] ='CA' then 'Catalog'
      when [Media_Type] ='BI' then 'Bill Insert'
      when [Media_Type] ='EM' then 'Email'
      when [Media_Type] ='FYI' then 'Bill Media'
      when [Media_Type] ='SharedM' then 'Shared Mail'
	else [Media_Type]
	end as [Media]
,[Project]
,b.ISO_Week_YYYYWW as [reportweek_YYYYWW]
,b.[Month_Long]
, sum(isnull([Actual_Budget],0)) as Actual_Project_Budget
, sum(isnull([Actual_Volume],0)) as Actual_Project_Volume
, sum(isnull(Actual_Calls,0)) as Actual_Calls
, sum(isnull(Actual_Clicks,0)) as Actual_Clicks
, sum(isnull(Actual_Call_Wrls_Voice_Sales,0)) as Actual_Call_Wrls_Voice_Sales
, sum(isnull(Actual_Call_WRLS_Family_Sales,0)) as Actual_Call_WRLS_Family_Sales
, sum(isnull(Actual_Call_WRLS_Data_Sales,0)) as Actual_Call_WRLS_Data_Sales
, sum(isnull(Actual_CALL_Dish_Sales,0)) as Actual_CALL_Dish_Sales
, sum(isnull(Actual_Call_DSL_Reg_Sales,0)) as Actual_Call_DSL_Reg_Sales
, sum(isnull(Actual_Call_DSL_Dry_Sales,0)) as Actual_Call_DSL_Dry_Sales
, sum(isnull(Actual_Call_IPDSL_Sales,0)) as Actual_Call_IPDSL_Sales
, sum(isnull(Actual_Call_HSIA_Sales,0)) as Actual_Call_HSIA_Sales
, sum(isnull([Actual_Call_TV],0)) as Actual_Call_TV_Sales
, sum(isnull(Actual_CALL_Access_Sales,0)) as Actual_CALL_Access_Sales
, sum(isnull(Actual_Call_VOIP_Sales,0)) as Actual_Call_VOIP_Sales
, sum(isnull(Actual_ONLINE_Wrls_Voice_Sales,0)) as Actual_ONLINE_Wrls_Voice_Sales
, sum(isnull(Actual_ONLINE_WRLS_Family_Sales,0)) as Actual_ONLINE_WRLS_Family_Sales
, sum(isnull(Actual_ONLINE_WRLS_Data_Sales,0)) as Actual_ONLINE_WRLS_Data_Sales
, sum(isnull(Actual_ONLINE_Dish_Sales,0)) as Actual_ONLINE_Dish_Sales
, sum(isnull(Actual_ONLINE_DSL_Reg_Sales,0)) as Actual_ONLINE_DSL_Reg_Sales
, sum(isnull(Actual_ONLINE_DSL_Dry_Sales,0)) as Actual_ONLINE_DSL_Dry_Sales
, sum(isnull(Actual_ONLINE_IPDSL_Sales,0)) as Actual_ONLINE_IPDSL_Sales
, sum(isnull(Actual_ONLINE_HSIA_Sales,0)) as Actual_ONLINE_HSIA_Sales
, sum(isnull(Actual_ONLINE_TV_Sales,0)) as Actual_ONLINE_TV_Sales
, sum(isnull(Actual_ONLINE_VOIP_Sales,0)) as Actual_ONLINE_VOIP_Sales
, sum(isnull(Actual_ONLINE_Access_Sales,0)) as Actual_ONLINE_Access_Sales
, sum(isnull(CV_ONLINE_Wrls_Voice_Sales,0)) as CV_ONLINE_Wrls_Voice_Sales
, sum(isnull(CV_Call_TV_Sales,0)) as CV_Call_TV_Sales
, sum(isnull(CV_ONLINE_Access_Sales,0)) as CV_ONLINE_Access_Sales
, sum(isnull(CV_Call_DSL_Reg_Sales,0)) as CV_Call_DSL_Reg_Sales
, sum(isnull(CV_ONLINE_WRLS_Family_Sales,0)) as CV_ONLINE_WRLS_Family_Sales
, sum(isnull(CV_Drop_Volume,0)) as CV_Drop_Volume
, sum(isnull(CV_Call_VOIP_Sales,0)) as CV_Call_VOIP_Sales
, sum(isnull(CV_ONLINE_Dish_Sales,0)) as CV_ONLINE_Dish_Sales
, sum(isnull(CV_Call_IPDSL_Sales,0)) as CV_Call_IPDSL_Sales
, sum(isnull(CV_ONLINE_DSL_Reg_Sales,0)) as CV_ONLINE_DSL_Reg_Sales
, sum(isnull(CV_Clicks,0)) as CV_Clicks
, sum(isnull(CV_CALL_Access_Sales,0)) as CV_CALL_Access_Sales
, sum(isnull(CV_Call_WRLS_Family_Sales,0)) as CV_Call_WRLS_Family_Sales
, sum(isnull(CV_CALL_Dish_Sales,0)) as CV_CALL_Dish_Sales
, sum(isnull(CV_ONLINE_VOIP_Sales,0)) as CV_ONLINE_VOIP_Sales
, sum(isnull(CV_Finance_Budget,0)) as CV_Finance_Budget
, sum(isnull(CV_ONLINE_HSIA_Sales,0)) as CV_ONLINE_HSIA_Sales
, sum(isnull(CV_ONLINE_DSL_Dry_Sales,0)) as CV_ONLINE_DSL_Dry_Sales
, sum(isnull(CV_Calls,0)) as CV_Calls
, sum(isnull(CV_Call_Wrls_Voice_Sales,0)) as CV_Call_Wrls_Voice_Sales
, sum(isnull(CV_Call_WRLS_Data_Sales,0)) as CV_Call_WRLS_Data_Sales
, sum(isnull(CV_ONLINE_TV_Sales,0)) as CV_ONLINE_TV_Sales
, sum(isnull(CV_Call_HSIA_Sales,0)) as CV_Call_HSIA_Sales
, sum(isnull(CV_ONLINE_WRLS_Data_Sales,0)) as CV_ONLINE_WRLS_Data_Sales
, sum(isnull(CV_Call_DSL_Dry_Sales,0)) as CV_Call_DSL_Dry_Sales
, sum(isnull(CV_ONLINE_IPDSL_Sales,0)) as CV_ONLINE_IPDSL_Sales
, sum(isnull(BV_ONLINE_WRLS_Family_Sales,0)) as BV_ONLINE_WRLS_Family_Sales
, sum(isnull(BV_CALL_Access_Sales,0)) as BV_CALL_Access_Sales
, sum(isnull(BV_ONLINE_TV_Sales,0)) as BV_ONLINE_TV_Sales
, sum(isnull(BV_CALL_Dish_Sales,0)) as BV_CALL_Dish_Sales
, sum(isnull(BV_Call_DSL_Dry_Sales,0)) as BV_Call_DSL_Dry_Sales
, sum(isnull(BV_ONLINE_Dish_Sales,0)) as BV_ONLINE_Dish_Sales
, sum(isnull(BV_ONLINE_Access_Sales,0)) as BV_ONLINE_Access_Sales
, sum(isnull(BV_Call_HSIA_Sales,0)) as BV_Call_HSIA_Sales
, sum(isnull(BV_Call_Wrls_Voice_Sales,0)) as BV_Call_Wrls_Voice_Sales
, sum(isnull(BV_Finance_Budget,0)) as BV_Finance_Budget
, sum(isnull(BV_ONLINE_IPDSL_Sales,0)) as BV_ONLINE_IPDSL_Sales
, sum(isnull(BV_Calls,0)) as BV_Calls
, sum(isnull(BV_ONLINE_DSL_Dry_Sales,0)) as BV_ONLINE_DSL_Dry_Sales
, sum(isnull(BV_ONLINE_DSL_Reg_Sales,0)) as BV_ONLINE_DSL_Reg_Sales
, sum(isnull(BV_Call_WRLS_Family_Sales,0)) as BV_Call_WRLS_Family_Sales
, sum(isnull(BV_ONLINE_Wrls_Voice_Sales,0)) as BV_ONLINE_Wrls_Voice_Sales
, sum(isnull(BV_Clicks,0)) as BV_Clicks
, sum(isnull(BV_ONLINE_WRLS_Data_Sales,0)) as BV_ONLINE_WRLS_Data_Sales
, sum(isnull(BV_Call_TV_Sales,0)) as BV_Call_TV_Sales
, sum(isnull(BV_ONLINE_HSIA_Sales,0)) as BV_ONLINE_HSIA_Sales
, sum(isnull(BV_ONLINE_VOIP_Sales,0)) as BV_ONLINE_VOIP_Sales
, sum(isnull(BV_Call_DSL_Reg_Sales,0)) as BV_Call_DSL_Reg_Sales
, sum(isnull(BV_Call_WRLS_Data_Sales,0)) as BV_Call_WRLS_Data_Sales
, sum(isnull(BV_Call_VOIP_Sales,0)) as BV_Call_VOIP_Sales
, sum(isnull(BV_Drop_Volume,0)) as BV_Drop_Volume
, sum(isnull(BV_Call_IPDSL_Sales,0)) as BV_Call_IPDSL_Sales
 FROM [UVAQ].[Forecasting].[Current_UVAQ_Best_View_Weekly_2014] as a
 join (select iso_week, iso_week_YYYYWW, month_long 
		from dim.Media_Calendar 
		where Week_Year=2014
		group by iso_week, iso_week_YYYYWW, month_long) as b
	on a.[Media_Week]=b.iso_week
 group by [Media_Type]
,[Project]
,b.ISO_Week_YYYYWW
,b.[Month_Long]