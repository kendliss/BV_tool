

CREATE view [Forecasting].[Weekly_Best_View_Flat]
as

/*This is the Forecast portion of the data pull*/
select Touch_Type_FK,
   Audience,
   (flight_plan_record.Touch_Name + ' ' + flight_plan_record.Touch_Name_2) as Project,
   Media_Type,
   Program_Owner,
   Media_Week,
   Mediamonth_Long, 
   InHome_Date,
   Source_Data,
   Metric,
   Value 
   
from 

-----------forecasted response unpivoted-----------
(select Flight_Plan_Record_ID, Media_Week, MediaMonth_Long, 'Best_View' as Source_Data, Metric, Value

from 

(select Flight_Plan_Record_ID, sum(Day_Call_Forecast) as Calls, sum(Day_Click_Forecast) as Clicks, [ISO_Week] as Media_Week, MediaMonth_Long   
 from Forecasting.Current_UVAQ_Flightplan_Forecast_ByDay LEFT JOIN  
  DIM.Media_Calendar_Daily  
 ON Forecasting.Current_UVAQ_Flightplan_Forecast_ByDay.Forecast_DayDate=DIM.Media_Calendar_Daily.[Date]  
 where MediaMonth_Year=2014  
 Group by Flight_Plan_Record_ID,[ISO_Week], MediaMonth_Long) as response_query
 UNPIVOT
 (value for Metric in (Calls, Clicks))as unpvt
 
 -----------------------------------------------------
 union
 -----------Forecasted sales unpivoted----------------
 select Flight_Plan_Record_ID, Media_Week, MediaMonth_Long, 'Best_View' as Source_Data, Metric, Value
 
 from 
 
 (SELECT Flight_Plan_Record_ID, [ISO_Week] as Media_Week, MediaMonth_Long,  
 SUM(CASE WHEN Product_FK=1 then day_call_sales ELSE 0 END) as Call_TV_Sales,  
 SUM(CASE WHEN Product_FK=1 then day_click_sales ELSE 0 END) as Online_TV_Sales,  
 SUM(CASE WHEN Product_FK=3 then day_call_sales ELSE 0 END) as Call_HSIA_Sales,  
 SUM(CASE WHEN Product_FK=3 then day_click_sales ELSE 0 END) as Online_HSIA_Sales,  
 SUM(CASE WHEN Product_FK=9 then day_call_sales ELSE 0 END) as Call_VOIP_Sales,  
 SUM(CASE WHEN Product_FK=9 then day_click_sales ELSE 0 END) as Online_VOIP_Sales,  
   
   
 SUM(CASE WHEN Product_FK=4 then day_call_sales ELSE 0 END) as Call_DSL_Reg_Sales,  
 SUM(CASE WHEN Product_FK=5 then day_call_sales ELSE 0 END) as Call_DSL_Dry_Sales,  
 SUM(CASE WHEN Product_FK=6 then day_call_sales ELSE 0 END) as Call_Access_Sales,  
 SUM(CASE WHEN Product_FK=8 then day_call_sales ELSE 0 END) as Call_Wrls_Voice_Sales,  
 SUM(CASE WHEN Product_FK=10 then day_call_sales ELSE 0 END) as Call_Dish_Sales,  
 SUM(CASE WHEN Product_FK=12 then day_call_sales ELSE 0 END) as Call_WRLS_Family_Sales,  
 SUM(CASE WHEN Product_FK=13 then day_call_sales ELSE 0 END) as Call_WRLS_Data_Sales,  
 SUM(CASE WHEN Product_FK=14 then day_call_sales ELSE 0 END) as Call_IPDSL_Sales,  
   
   
 SUM(CASE WHEN Product_FK=4 then day_click_sales ELSE 0 END) as Online_DSL_Reg_Sales,  
 SUM(CASE WHEN Product_FK=5 then day_click_sales ELSE 0 END) as Online_DSL_Dry_Sales,  
 SUM(CASE WHEN Product_FK=6 then day_click_sales ELSE 0 END) as Online_Access_Sales,  
 SUM(CASE WHEN Product_FK=8 then day_click_sales ELSE 0 END) as Online_Wrls_Voice_Sales,  
 SUM(CASE WHEN Product_FK=10 then day_click_sales ELSE 0 END) as Online_Dish_Sales,  
 SUM(CASE WHEN Product_FK=12 then day_click_sales ELSE 0 END) as Online_WRLS_Family_Sales,  
 SUM(CASE WHEN Product_FK=13 then day_click_sales ELSE 0 END) as Online_WRLS_Data_Sales,  
 SUM(CASE WHEN Product_FK=14 then day_click_sales ELSE 0 END) as Online_IPDSL_Sales
    
 FROM  
 Forecasting.Current_UVAQ_Flightplan_Forecast_Sales_ByDay   
 LEFT JOIN DIM.Media_Calendar_Daily  
 ON Forecast_DayDate=DIM.Media_Calendar_Daily.[Date]
 where MediaMonth_Year=2014  
GROUP BY Flight_Plan_Record_ID, [ISO_Week], MediaMonth_Long) as subquery_sales  

UNPIVOT

(value for metric in (Call_TV_Sales,  
 Online_TV_Sales,  
 Call_HSIA_Sales,  
 Online_HSIA_Sales,  
 Call_VOIP_Sales,  
 Online_VOIP_Sales,  
   
 Call_DSL_Reg_Sales,  
 Call_DSL_Dry_Sales,  
 Call_Access_Sales,  
 Call_Wrls_Voice_Sales,  
 Call_Dish_Sales,  
 Call_WRLS_Family_Sales,  
 Call_WRLS_Data_Sales,  
 Call_IPDSL_Sales,  
   
 Online_DSL_Reg_Sales,  
 Online_DSL_Dry_Sales,  
 Online_Access_Sales,  
 Online_Wrls_Voice_Sales,  
 Online_Dish_Sales,  
 Online_WRLS_Family_Sales,  
 Online_WRLS_Data_Sales,  
 Online_IPDSL_Sales)) as unpvt
 ---------------------------------------------------------------------------------------
 UNION all
 ------------------Volume Query---------------------------------------------------------
 select Flight_Plan_Record_ID,  [ISO_Week] as Media_Week, MediaMonth_Long, 'Best_View' as Source_Data, 
		'Volume' as metric, Volume_Forecast AS VALUE 
 from Forecasting.Current_UVAQ_Flightplan_Forecast_View  
  left join DIM.Media_Calendar_Daily  
 ON Drop_Date=DIM.Media_Calendar_Daily.[Date]  
 where MediaMonth_Year=2014
 ---------------------------------------------------------------------------------------
 UNION ALL
 ------------------Project Budget Query-------------------------------------------------
 select Flight_Plan_Record_ID, [ISO_Week] as Media_Week, MediaMonth_Long, 'Best_View' as Source_Data, 
		'Budget' as metric, Budget_Forecast AS VALUE 
 from Forecasting.Current_UVAQ_Flightplan_Forecast_View  
  INNER JOIN DIM.Media_Calendar_Daily ON InHome_Date=DIM.Media_Calendar_Daily.[Date]  
  where ISO_Week_Year=2014 ) as forecast_query 
 ---------------------------------------------------------------------------------------
 inner join 
 ---Subquery to pull in the necessary information about the touch type----------------------------------  
  (SELECT Flight_Plan_Record_ID, Media_Type, Touch_Type_FK, Touch_Name, Touch_Name_2, Audience_Type_Name as Audience, Program_Owner, InHome_Date   
    from Forecasting.Flight_Plan_Records AS A, Forecasting.Touch_Type as B, Forecasting.Media_Type as C, Forecasting.Audience as D,   
     Forecasting.Program_Owners as E  
    Where A.Touch_Type_FK=B.Touch_Type_ID and B.Media_Type_FK=C.Media_Type_ID and B.Audience_FK=D.Audience_ID   
     and B.Program_Owner_FK=E.Program_Owner_ID) as flight_plan_record  
  
ON forecast_query.Flight_Plan_Record_ID=flight_plan_record.Flight_Plan_Record_ID  

 /*End of the Forecast portion of the data pull*/
unION

/*Commitment portion of the data pull*/
select Touch_Type_FK,
   Audience,
   Project,
   Media_Type,
   Program_Owner,
   Media_Week,
   Mediamonth_Long, 
   InHome_Date,
   'Commitment_View' as Source_data,
   Metric,
   Value
   
 from 

(select
   Touch_Type_FK,
   Audience,
   Project,
   Media_Type,
   Program_Owner,
   Media_Week,
   Mediamonth_Long, 
   InHome_Date,
sum(CV_Project_Budget) as   Budget,
sum(  CV_Drop_Volume) as  Volume,
sum(  CV_Calls) as   Calls,
sum(  CV_Clicks) as   Clicks,
sum(  CV_Call_TV_Sales) as   Call_TV_Sales,
sum(  CV_Online_TV_Sales) as   Online_TV_Sales,
sum(  CV_Call_HSIA_Sales) as   Call_HSIA_Sales,
sum(  CV_Online_HSIA_Sales) as   Online_HSIA_Sales,
sum(  CV_Call_VOIP_Sales) as   Call_VOIP_Sales,
sum(  CV_Online_VOIP_Sales) as   Online_VOIP_Sales,
sum(  CV_Call_DSL_Reg_Sales) as   Call_DSL_Reg_Sales,
sum(  CV_Call_DSL_Dry_Sales) as   Call_DSL_Dry_Sales,
sum(  CV_Call_Access_Sales ) as   Call_Access_Sales ,
sum(  CV_Call_Wrls_Voice_Sales) as   Call_Wrls_Voice_Sales,
sum(  CV_Call_Dish_Sales) as   Call_Dish_Sales,
sum(  CV_Call_WRLS_Family_Sales) as   Call_WRLS_Family_Sales,
sum(  CV_Call_WRLS_Data_Sales) as   Call_WRLS_Data_Sales,
sum(  CV_Call_IPDSL_Sales) as   Call_IPDSL_Sales,
sum(  CV_Online_DSL_Reg_Sales) as   Online_DSL_Reg_Sales,
sum(  CV_Online_DSL_Dry_Sales) as   Online_DSL_Dry_Sales,
sum(  CV_Online_Access_Sales) as   Online_Access_Sales,
sum(  CV_Online_Wrls_Voice_Sales) as   Online_Wrls_Voice_Sales,
sum(  CV_Online_Dish_Sales) as   Online_Dish_Sales,
sum(  CV_Online_WRLS_Family_Sales) as   Online_WRLS_Family_Sales,
sum(  CV_Online_WRLS_Data_Sales) as   Online_WRLS_Data_Sales,
sum(  CV_Online_IPDSL_Sales) as   Online_IPDSL_Sales


  
 FROM  
  
 Commitment_Versions.CV_2014_Final_20131206_Volume_Calls_Clicks_Sales_v2
    as cv_bill_resp  
   left join dim.Media_Calendar_Daily as calendar on cv_bill_resp.InHome_Date=calendar.Date
   
 GROUP BY   
   Touch_Type_FK,
   Audience,
   Project,
   Media_Type,
   Program_Owner,
   Media_Week,
      Mediamonth_Long, 
   InHome_Date) cv_pivt
   
   UNPIVOT
   
   (value for metric in (Budget, Volume, Calls, Clicks, Call_TV_Sales,  
 Online_TV_Sales,  
 Call_HSIA_Sales,  
 Online_HSIA_Sales,  
 Call_VOIP_Sales,  
 Online_VOIP_Sales,  
   
 Call_DSL_Reg_Sales,  
 Call_DSL_Dry_Sales,  
 Call_Access_Sales,  
 Call_Wrls_Voice_Sales,  
 Call_Dish_Sales,  
 Call_WRLS_Family_Sales,  
 Call_WRLS_Data_Sales,  
 Call_IPDSL_Sales,  
   
 Online_DSL_Reg_Sales,  
 Online_DSL_Dry_Sales,  
 Online_Access_Sales,  
 Online_Wrls_Voice_Sales,  
 Online_Dish_Sales,  
 Online_WRLS_Family_Sales,  
 Online_WRLS_Data_Sales,  
 Online_IPDSL_Sales)) as unpvt
 /*End of Commitment View Data Pull*/
 -------------------------------------------------------------------------------------------------------------
 UNION
 -------------------------------------------------------------------------------------------------------------- 
 /*Begin Actuals Data pull*/
 
 select 
 Touch_Type_FK,
   Audience,
   Project,
   Media_Type,
   Program_Owner,
   Media_Week,
   Mediamonth_Long, 
   InHome_Date,
   'Actual' as Source_data,
   Metric,
   Value
  
 from 
  
 (SELECT A.Touch_type_FK,  
  E.Audience_Type_Name as Audience,  
     Case When touch_type_fk=0 then ('2013 Unaccounted Overflow' + ' ' + A.Media_Type)  
  ELSE isnull((Touch_Name + ' ' + Touch_Name_2),'Unplanned')  
  END as Project,  
 COALESCE(C.Media_Type,A.Media_Type) as Media_Type,   
 isnull(Program_Owner,'2013 Flowover') as Program_Owner,  
 A.Report_Week as Media_Week,  
 Mediamonth_long,
 case when COALESCE(C.Media_Type,A.Media_Type) in ('EM','BI','FYI','SharedM') then a.start_date
	when COALESCE(C.Media_Type,A.Media_Type) = 'CA' then Dateadd(day,11,A.[Start_Date]) 
	when COALESCE(C.Media_Type,A.Media_Type) = 'DM' then Dateadd(day,14,A.[Start_Date])
	else dateadd(day,7,a.Start_Date) END
	as InHome_Date,  
 isnull(round(sum(A.Actual_Budget),0),0) as Budget, 
 isnull(round(sum(A.Actual_Volume),0),0) as Volume, 
 isnull(round(sum(Calls),0),0) as Calls,  
 isnull(round(sum(Clicks),0),0) as Clicks,  
 isnull(round(sum(UVERSE_TV_Call_Sales),0),0) as Call_TV_Sales, 
 isnull(round(sum(Wireless_Voice_Call_Sales), 0), 0) as Call_Wrls_Voice_Sales,  
 isnull(round(sum(Wireless_Voice_Click_Sales), 0), 0) as Online_Wrls_Voice_Sales,  
 isnull(round(sum(Wireless_Family_Call_Sales), 0), 0) as Call_WRLS_Family_Sales,  
 isnull(round(sum(Wireless_Family_Click_Sales), 0), 0) as Online_WRLS_Family_Sales,  
 isnull(round(sum(Wireless_Data_Call_Sales), 0), 0) as Call_WRLS_Data_Sales,  
 isnull(round(sum(Wireless_Data_Click_Sales), 0), 0) as Online_WRLS_Data_Sales,  
 isnull(round(sum(DirectTV_Call_Sales), 0), 0) as Call_Dish_Sales,  
 isnull(round(sum(DirectTV_Click_Sales), 0), 0) as Online_Dish_Sales,  
 isnull(round(sum(DSL_Direct_Call_Sales), 0), 0) as Call_DSL_Reg_Sales,  
 isnull(round(sum(DSL_Direct_Click_Sales), 0), 0) as Online_DSL_Reg_Sales,  
 isnull(round(sum(DSL_Dry_Loop_Call_Sales), 0), 0) as Call_DSL_Dry_Sales,  
 isnull(round(sum(DSL_Dry_Loop_Click_Sales), 0), 0) as Online_DSL_Dry_Sales,  
 isnull(round(sum(IPDSLAM_Call_Sales), 0), 0) as Call_IPDSL_Sales,  
 isnull(round(sum(IPDSLAM_Click_Sales), 0), 0) as Online_IPDSL_Sales,  
 isnull(round(sum(Local_Call_Sales), 0), 0) as Call_Access_Sales,  
 isnull(round(sum(Local_Click_Sales), 0), 0) as Online_Access_Sales,  
 isnull(round(sum(UVERSE_TV_Click_Sales),0),0) as Online_TV_Sales,  
 isnull(round(sum(HSIA_Call_Sales),0),0) as Call_HSIA_Sales,  
 isnull(round(sum(HSIA_Click_Sales),0),0) as Online_HSIA_Sales,  
 isnull(round(sum(VOIP_Call_Sales),0),0) as Call_VOIP_Sales,  
 isnull(round(sum(VOIP_Click_Sales),0),0) as Online_VOIP_Sales  

FROM Results.UVAQ_LB_2014_Response_Sales_Volume_Budget_Apprtnd as A  
 LEFT JOIN Forecasting.Touch_Type as B on A.Touch_Type_FK=B.Touch_Type_ID  
 LEFT JOIN Forecasting.Media_Type as C on B.Media_Type_FK=C.Media_Type_ID  
 LEFT JOIN Forecasting.Program_Owners as D on B.Program_Owner_FK=D.Program_Owner_ID  
 LEFT JOIN Forecasting.Audience as E on B.Audience_FK=E.Audience_ID  
 INNer JOIN (select MediaMonth_Long, ISO_Week from dim.Media_Calendar_Daily where MediaMonth_Year=2014 group by MediaMonth_Long, ISO_Week) 
	as F on A.report_week=f.ISO_Week

----------------------------------------------------------------------------------------------------------------  
WHERE A.Report_Year=2014   
 and A.Report_Week <= (select [ISO_Week]-1 from DIM.Media_Calendar_Daily   
     where CONVERT(VARCHAR(10),DIM.Media_Calendar_Daily.[Date],111)=CONVERT(VARCHAR(10),GETDATE(),111))  
GROUP BY A.touch_type_fk,  
 E.Audience_Type_Name,  
 Case When touch_type_fk=0 then ('2013 Unaccounted Overflow' + ' ' + A.Media_Type)  
  ELSE isnull((Touch_Name + ' ' + Touch_Name_2),'Unplanned')  
  END,  
 COALESCE(C.Media_Type,A.Media_Type),  
 isnull(Program_Owner,'2013 Flowover'),  
 A.Report_Week,  
  Mediamonth_long,
 A.[Start_Date]) as actual
  
 UNPIVOT
 
 (value for metric in (Budget, Volume, Calls, Clicks, Call_TV_Sales,  
 Online_TV_Sales,  
 Call_HSIA_Sales,  
 Online_HSIA_Sales,  
 Call_VOIP_Sales,  
 Online_VOIP_Sales,  
   
 Call_DSL_Reg_Sales,  
 Call_DSL_Dry_Sales,  
 Call_Access_Sales,  
 Call_Wrls_Voice_Sales,  
 Call_Dish_Sales,  
 Call_WRLS_Family_Sales,  
 Call_WRLS_Data_Sales,  
 Call_IPDSL_Sales,  
   
 Online_DSL_Reg_Sales,  
 Online_DSL_Dry_Sales,  
 Online_Access_Sales,  
 Online_Wrls_Voice_Sales,  
 Online_Dish_Sales,  
 Online_WRLS_Family_Sales,  
 Online_WRLS_Data_Sales,  
 Online_IPDSL_Sales)) as unpvt
