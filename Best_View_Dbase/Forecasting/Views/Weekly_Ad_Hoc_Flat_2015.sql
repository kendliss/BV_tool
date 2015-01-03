

create view [Forecasting].[Weekly_Ad_Hoc_Flat_2015]
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
(select Ad_Hoc_flightplan_ID, Media_Week, MediaMonth_Long, 'Ad_Hoc' as Source_Data, Metric, Value

from 

(select Ad_Hoc_flightplan_ID, sum(Day_Call_Forecast) as Calls, sum(Day_Click_Forecast) as Clicks, [ISO_Week] as Media_Week, MediaMonth_Long   
 from Forecasting.[UVAQ_AdHoc_Flightplan_Forecast_ByDay] LEFT JOIN  
  DIM.Media_Calendar_Daily  
 ON Forecasting.[UVAQ_AdHoc_Flightplan_Forecast_ByDay].Forecast_DayDate=DIM.Media_Calendar_Daily.[Date]  
 where MediaMonth_Year=2015  
 Group by Ad_Hoc_flightplan_ID,[ISO_Week], MediaMonth_Long) as response_query
 UNPIVOT
 (value for Metric in (Calls, Clicks))as unpvt
 
 -----------------------------------------------------
 union
 -----------Forecasted sales unpivoted----------------
 select Ad_Hoc_flightplan_ID, Media_Week, MediaMonth_Long, 'Ad_Hoc' as Source_Data, Metric, Value
 
 from 
 
 (SELECT Ad_Hoc_flightplan_ID, [ISO_Week] as Media_Week, MediaMonth_Long,  
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
 Forecasting.[UVAQ_Ad_Hoc_Forecast_Sales_ByDay]   
 LEFT JOIN DIM.Media_Calendar_Daily  
 ON Forecast_DayDate=DIM.Media_Calendar_Daily.[Date]
 where MediaMonth_Year=2015  
GROUP BY Ad_Hoc_flightplan_ID, [ISO_Week], MediaMonth_Long) as subquery_sales  

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
 select Ad_Hoc_flightplan_ID,  [ISO_Week] as Media_Week, MediaMonth_Long, 'Ad_Hoc' as Source_Data, 
		'Volume' as metric, Volume_Forecast AS VALUE 
 from Forecasting.UVAQ_ad_hoc_Flightplan_Forecast_View
  left join DIM.Media_Calendar_Daily  
 ON Drop_Date=DIM.Media_Calendar_Daily.[Date]  
 where MediaMonth_Year=2015
 ---------------------------------------------------------------------------------------
 UNION ALL
 ------------------Project Budget Query-------------------------------------------------
 select Ad_Hoc_flightplan_ID, [ISO_Week] as Media_Week, MediaMonth_Long, 'Ad_Hoc' as Source_Data, 
		'Budget' as metric, Budget_Forecast AS VALUE 
 from Forecasting.UVAQ_ad_hoc_Flightplan_Forecast_View 
  INNER JOIN DIM.Media_Calendar_Daily ON InHome_Date=DIM.Media_Calendar_Daily.[Date]  
  where ISO_Week_Year=2015 ) as forecast_query 
 ---------------------------------------------------------------------------------------
 inner join 
 ---Subquery to pull in the necessary information about the touch type----------------------------------  
  (SELECT Ad_Hoc_flightplan_ID, Media_Type, Touch_Type_FK, Touch_Name, Touch_Name_2, Audience_Type_Name as Audience, Program_Owner, InHome_Date   
    from Forecasting.Ad_Hoc_Flightplan AS A, Forecasting.Touch_Type as B, Forecasting.Media_Type as C, Forecasting.Audience as D,   
     Forecasting.Program_Owners as E  
    Where A.Touch_Type_FK=B.Touch_Type_ID and B.Media_Type_FK=C.Media_Type_ID and B.Audience_FK=D.Audience_ID   
     and B.Program_Owner_FK=E.Program_Owner_ID) as flight_plan_record  
  
ON forecast_query.Ad_Hoc_flightplan_ID=flight_plan_record.Ad_Hoc_flightplan_ID  

 /*End of the Forecast portion of the data pull*/


