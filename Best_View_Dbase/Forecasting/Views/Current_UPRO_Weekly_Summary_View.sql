
create view [Forecasting].[Current_UPRO_Weekly_Summary_View]
as
select coalesce(a.[Media],b.[Media],c.[Media]) as [Media]
,coalesce(a.[Program],b.[Program],c.[Program]) as [Program]
,coalesce(a.reportweek_YYYYWW,b.reportweek_YYYYWW,c.reportweek_YYYYWW) as reportweek_YYYYWW
,coalesce(a.month_long,b.month_long,c.month_long) as month_long
, isnull(Actual_Project_Budget,0) as Actual_Project_Budget
, isnull(Actual_Project_Volume,0) as Actual_Project_Volume
, isnull(Actual_Calls,0) as Actual_Calls
, isnull(Actual_Clicks,0) as Actual_Clicks
, isnull(Actual_Call_Wrls_Voice_Sales,0) as Actual_Call_Wrls_Voice_Sales
, isnull(Actual_Call_WRLS_Family_Sales,0) as Actual_Call_WRLS_Family_Sales
, isnull(Actual_Call_WRLS_Data_Sales,0) as Actual_Call_WRLS_Data_Sales
, isnull(Actual_CALL_Dish_Sales,0) as Actual_CALL_Dish_Sales
, isnull(Actual_Call_DSL_Reg_Sales,0) as Actual_Call_DSL_Reg_Sales
, isnull(Actual_Call_DSL_Dry_Sales,0) as Actual_Call_DSL_Dry_Sales
, isnull(Actual_Call_IPDSL_Sales,0) as Actual_Call_IPDSL_Sales
, isnull(Actual_Call_HSIA_Sales,0) as Actual_Call_HSIA_Sales
, isnull(Actual_Call_TV_Sales,0) as Actual_Call_TV_Sales
, isnull(Actual_CALL_Access_Sales,0) as Actual_CALL_Access_Sales
, isnull(Actual_Call_VOIP_Sales,0) as Actual_Call_VOIP_Sales
, isnull(Actual_ONLINE_Wrls_Voice_Sales,0) as Actual_ONLINE_Wrls_Voice_Sales
, isnull(Actual_ONLINE_WRLS_Family_Sales,0) as Actual_ONLINE_WRLS_Family_Sales
, isnull(Actual_ONLINE_WRLS_Data_Sales,0) as Actual_ONLINE_WRLS_Data_Sales
, isnull(Actual_ONLINE_Dish_Sales,0) as Actual_ONLINE_Dish_Sales
, isnull(Actual_ONLINE_DSL_Reg_Sales,0) as Actual_ONLINE_DSL_Reg_Sales
, isnull(Actual_ONLINE_DSL_Dry_Sales,0) as Actual_ONLINE_DSL_Dry_Sales
, isnull(Actual_ONLINE_IPDSL_Sales,0) as Actual_ONLINE_IPDSL_Sales
, isnull(Actual_ONLINE_HSIA_Sales,0) as Actual_ONLINE_HSIA_Sales
, isnull(Actual_ONLINE_TV_Sales,0) as Actual_ONLINE_TV_Sales
, isnull(Actual_ONLINE_VOIP_Sales,0) as Actual_ONLINE_VOIP_Sales
, isnull(Actual_ONLINE_Access_Sales,0) as Actual_ONLINE_Access_Sales
, isnull(CV_ONLINE_Wrls_Voice_Sales,0) as CV_ONLINE_Wrls_Voice_Sales
, isnull(CV_Call_TV_Sales,0) as CV_Call_TV_Sales
, isnull(CV_ONLINE_Access_Sales,0) as CV_ONLINE_Access_Sales
, isnull(CV_Call_DSL_Reg_Sales,0) as CV_Call_DSL_Reg_Sales
, isnull(CV_ONLINE_WRLS_Family_Sales,0) as CV_ONLINE_WRLS_Family_Sales
, isnull(CV_Drop_Volume,0) as CV_Drop_Volume
, isnull(CV_Call_VOIP_Sales,0) as CV_Call_VOIP_Sales
, isnull(CV_ONLINE_Dish_Sales,0) as CV_ONLINE_Dish_Sales
, isnull(CV_Call_IPDSL_Sales,0) as CV_Call_IPDSL_Sales
, isnull(CV_ONLINE_DSL_Reg_Sales,0) as CV_ONLINE_DSL_Reg_Sales
, isnull(CV_Clicks,0) as CV_Clicks
, isnull(CV_CALL_Access_Sales,0) as CV_CALL_Access_Sales
, isnull(CV_Call_WRLS_Family_Sales,0) as CV_Call_WRLS_Family_Sales
, isnull(CV_CALL_Dish_Sales,0) as CV_CALL_Dish_Sales
, isnull(CV_ONLINE_VOIP_Sales,0) as CV_ONLINE_VOIP_Sales
, isnull(CV_Finance_Budget,0) as CV_Finance_Budget
, isnull(CV_ONLINE_HSIA_Sales,0) as CV_ONLINE_HSIA_Sales
, isnull(CV_ONLINE_DSL_Dry_Sales,0) as CV_ONLINE_DSL_Dry_Sales
, isnull(CV_Calls,0) as CV_Calls
, isnull(CV_Call_Wrls_Voice_Sales,0) as CV_Call_Wrls_Voice_Sales
, isnull(CV_Call_WRLS_Data_Sales,0) as CV_Call_WRLS_Data_Sales
, isnull(CV_ONLINE_TV_Sales,0) as CV_ONLINE_TV_Sales
, isnull(CV_Call_HSIA_Sales,0) as CV_Call_HSIA_Sales
, isnull(CV_ONLINE_WRLS_Data_Sales,0) as CV_ONLINE_WRLS_Data_Sales
, isnull(CV_Call_DSL_Dry_Sales,0) as CV_Call_DSL_Dry_Sales
, isnull(CV_ONLINE_IPDSL_Sales,0) as CV_ONLINE_IPDSL_Sales


/* OLD Uncoalesced Best View Forecast
, isnull(BV_ONLINE_WRLS_Family_Sales,0) as BV_ONLINE_WRLS_Family_Sales
--, isnull(BV_CALL_Access_Sales,0) as BV_CALL_Access_Sales
, isnull(BV_ONLINE_TV_Sales,0) as BV_ONLINE_TV_Sales
--, isnull(BV_CALL_Dish_Sales,0) as BV_CALL_Dish_Sales
--, isnull(BV_Call_DSL_Dry_Sales,0) as BV_Call_DSL_Dry_Sales
, isnull(BV_ONLINE_Dish_Sales,0) as BV_ONLINE_Dish_Sales
, isnull(BV_ONLINE_Access_Sales,0) as BV_ONLINE_Access_Sales
--, isnull(BV_Call_HSIA_Sales,0) as BV_Call_HSIA_Sales
--, isnull(BV_Call_Wrls_Voice_Sales,0) as BV_Call_Wrls_Voice_Sales
--, isnull(BV_Finance_Budget,0) as BV_Finance_Budget
, isnull(BV_ONLINE_IPDSL_Sales,0) as BV_ONLINE_IPDSL_Sales
--, isnull(BV_Calls,0) as BV_Calls
, isnull(BV_ONLINE_DSL_Dry_Sales,0) as BV_ONLINE_DSL_Dry_Sales
, isnull(BV_ONLINE_DSL_Reg_Sales,0) as BV_ONLINE_DSL_Reg_Sales
-, isnull(BV_Call_WRLS_Family_Sales,0) as BV_Call_WRLS_Family_Sales
, isnull(BV_ONLINE_Wrls_Voice_Sales,0) as BV_ONLINE_Wrls_Voice_Sales
--, isnull(BV_Clicks,0) as BV_Clicks
, isnull(BV_ONLINE_WRLS_Data_Sales,0) as BV_ONLINE_WRLS_Data_Sales
--, isnull(BV_Call_TV_Sales,0) as BV_Call_TV_Sales
, isnull(BV_ONLINE_HSIA_Sales,0) as BV_ONLINE_HSIA_Sales
, isnull(BV_ONLINE_VOIP_Sales,0) as BV_ONLINE_VOIP_Sales
--, isnull(BV_Call_DSL_Reg_Sales,0) as BV_Call_DSL_Reg_Sales
--, isnull(BV_Call_WRLS_Data_Sales,0) as BV_Call_WRLS_Data_Sales
--, isnull(BV_Call_VOIP_Sales,0) as BV_Call_VOIP_Sales
--, isnull(BV_Drop_Volume,0) as BV_Drop_Volume
--, isnull(BV_Call_IPDSL_Sales,0) as BV_Call_IPDSL_Sales
*/

---Coalescing actuals and best view to provide a true best view
,isnull(BV_Finance_Budget,0) as BV_Finance_Budget
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Drop_Volume,0)   
  else isnull(Actual_Project_Volume,0) end as BV_Drop_Volume
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Calls,0)   
  else isnull(Actual_Calls,0) end as BV_Calls
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Clicks,0)   
  else isnull(Actual_Clicks,0) end as BV_Clicks
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Call_TV_Sales,0)    
  else isnull(Actual_Call_TV_Sales,0) end as BV_Call_TV_Sales
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Call_HSIA_Sales,0)    
  else isnull(Actual_Call_HSIA_Sales,0) end as BV_Call_HSIA_Sales
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Call_VOIP_Sales,0)    
  else isnull(Actual_Call_VOIP_Sales,0) end as BV_Call_VOIP_Sales
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_CALL_Access_Sales,0)   
  else isnull(Actual_CALL_Access_Sales,0) end as BV_CALL_Access_Sales
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_CALL_Dish_Sales,0)   
  else isnull(Actual_CALL_Dish_Sales,0) end as BV_CALL_Dish_Sales
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Call_DSL_Dry_Sales,0)   
  else isnull(Actual_Call_DSL_Dry_Sales,0) end as BV_Call_DSL_Dry_Sales
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Call_Wrls_Voice_Sales,0)    
  else isnull(Actual_Call_Wrls_Voice_Sales,0) end as BV_Call_Wrls_Voice_Sales
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Call_WRLS_Family_Sales,0)    
  else isnull(Actual_Call_WRLS_Family_Sales,0) end as BV_Call_WRLS_Family_Sales
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Call_DSL_Reg_Sales,0)    
  else isnull(Actual_Call_DSL_Reg_Sales,0) end as BV_Call_DSL_Reg_Sales
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Call_WRLS_Data_Sales,0)    
  else isnull(Actual_Call_WRLS_Data_Sales,0) end as BV_Call_WRLS_Data_Sales
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Call_IPDSL_Sales,0)    
  else isnull(Actual_Call_IPDSL_Sales,0) end as BV_Call_IPDSL_Sales


,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Online_TV_Sales,0)    
  else isnull(Actual_Online_TV_Sales,0) end as BV_Online_TV_Sales
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Online_HSIA_Sales,0)    
  else isnull(Actual_Online_HSIA_Sales,0) end as BV_Online_HSIA_Sales
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Online_VOIP_Sales,0)    
  else isnull(Actual_Online_VOIP_Sales,0) end as BV_Online_VOIP_Sales
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Online_Access_Sales,0)   
  else isnull(Actual_Online_Access_Sales,0) end as BV_Online_Access_Sales
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Online_Dish_Sales,0)   
  else isnull(Actual_Online_Dish_Sales,0) end as BV_Online_Dish_Sales
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Online_DSL_Dry_Sales,0)   
  else isnull(Actual_Online_DSL_Dry_Sales,0) end as BV_Online_DSL_Dry_Sales
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Online_Wrls_Voice_Sales,0)    
  else isnull(Actual_Online_Wrls_Voice_Sales,0) end as BV_Online_Wrls_Voice_Sales
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Online_WRLS_Family_Sales,0)    
  else isnull(Actual_Online_WRLS_Family_Sales,0) end as BV_Online_WRLS_Family_Sales
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Online_DSL_Reg_Sales,0)    
  else isnull(Actual_Online_DSL_Reg_Sales,0) end as BV_Online_DSL_Reg_Sales
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Online_WRLS_Data_Sales,0)    
  else isnull(Actual_Online_WRLS_Data_Sales,0) end as BV_Online_WRLS_Data_Sales
,case when COALESCE(c.weekid, cast(right(a.reportweek_YYYYWW, 2) as integer)) > DATEPART(wk,getdate())-2 then 
	isnull(BV_Online_IPDSL_Sales,0)    
  else isnull(Actual_Online_IPDSL_Sales,0) end as BV_Online_IPDSL_Sales

----------------------------------------------------------------------------------------------
from Forecasting.UV_Prospect_2014_Actuals as a full join 
Forecasting.UV_Prospect_2014_CV_Final as b
on (a.[Media]=b.[Media] and a.[Program]=b.[Program] and a.reportweek_YYYYWW=b.reportweek_YYYYWW
and a.month_long=b.month_long)
full join Forecasting.UV_Prospect_2014_BV_Final as c
on (a.[Media]=c.[Media] and a.[Program]=c.[Program] and a.reportweek_YYYYWW=c.reportweek_YYYYWW
and a.month_long=c.month_long)





