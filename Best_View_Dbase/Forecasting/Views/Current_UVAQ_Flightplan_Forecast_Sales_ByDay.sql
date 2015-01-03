create view Forecasting.Current_UVAQ_Flightplan_Forecast_Sales_ByDay
 as select Flight_Plan_Record_ID,
	   Forecast_Week_Date,
   	   Forecast_DayDate,
   	   Product_FK,
   	   Day_Call_Forecast*call_conversion*Call_Percent_of_Sales as day_call_sales,
   	   Day_Click_Forecast*click_conversion*Click_Percent_of_Sales as day_click_sales
   
  from 
  
  (select A.Flight_Plan_Record_ID,
	   A.Forecast_Week_Date,
   	   A.Forecast_DayDate,
   	   Day_Call_Forecast,
   	   Day_Click_Forecast,
   	   Touch_Type_FK
   	   
   from Forecasting.Current_UVAQ_Flightplan_Forecast_ByDay as A
  
  INNER JOIN
  
  ---Subquery to pull in the necessary information about the touch type----------------------------------  
  (SELECT Flight_Plan_Record_ID, Media_Type, 
			Case when Touch_Type_FK = 72 and InHome_Date >= '2013-03-20' then 74  ----- CORE DM EM DMDR to LT 
			     when Touch_Type_FK = 76 and InHome_Date >= '2013-03-20' then 78  ----- CORE DM LM DMDR to LT 
			     when Touch_Type_FK = 80 and InHome_Date >= '2013-03-20' then 82  ----- CORE DM MM DMDR to LT 
			     
			     when Touch_Type_FK = 68 and InHome_Date >= '2013-06-01' then 70  ----- CORE CA MM DMDR to LT
			     
			     --when Touch_Type_FK = 27 and InHome_Date >= '2013-04-01' then 24  ----- WLS FYI DMDR to LT (WLN)  
			     --when Touch_Type_FK = 26 and InHome_Date >= '2013-04-01' then 22  ----- WLS BI DMDR to LT (WLN)
			     
			     --when Touch_Type_FK = 97 and InHome_Date >= '2013-03-01' then 99  ----- TRIG DM DMDR to LT
			     --when Touch_Type_FK = 100 and InHome_Date >= '2013-03-01' then 102  ----- TRIG DM DMDR to LT
			     --when Touch_Type_FK = 103 and InHome_Date >= '2013-03-01' then 105  ----- TRIG DM DMDR to LT
			     
			     --when Touch_Type_FK = 85 and InHome_Date >= '2013-03-01' then 87  ----- Launch T1 DM DMDR to LT
			     --when Touch_Type_FK = 88 and InHome_Date >= '2013-03-01' then 90  ----- Launch T2 DM DMDR to LT
			     --when Touch_Type_FK = 137 and InHome_Date >= '2013-03-01' then 139  ----- Launch T3 DM DMDR to LT
			     else Touch_Type_FK
			     end as Touch_Type_FK, 
			     
			     Touch_Name, Touch_Name_2, Audience_Type_Name as Audience, Program_Owner, InHome_Date   
    from Forecasting.Flight_Plan_Records AS A, Forecasting.Touch_Type as B, Forecasting.Media_Type as C, Forecasting.Audience as D,   
     Forecasting.Program_Owners as E  
    Where A.Touch_Type_FK=B.Touch_Type_ID and B.Media_Type_FK=C.Media_Type_ID and B.Audience_FK=D.Audience_ID   
     and B.Program_Owner_FK=E.Program_Owner_ID) as flight_plan_record 
     
     ON A.Flight_Plan_Record_ID=flight_plan_record.Flight_Plan_Record_ID) as response_daily
     
  inner join  
  ---pull strategic conversion rate-------------------------------------------------------------
  (select call_conversions.touch_type_fk, call_conversions.conversion_rate as call_conversion, click_conversions.conversion_rate as click_conversion
	 from Forecasting.Most_Recent_Conversions_View as call_conversions 
	 inner join Forecasting.Most_Recent_Conversions_View as click_conversions
	 on call_conversions.touch_type_fk=click_conversions.touch_type_fk
	 where call_conversions.response_channel_fk=1 and click_conversions.response_channel_fk=2) as conversions
  
  ON response_daily.touch_type_fk=conversions.touch_type_fk
  
  inner join
  
  ----------------------pull sales percents by product------------------------------------------------------
  Forecasting.Most_Recent_Sales_Percents_View
  
  ON response_daily.touch_type_fk=Most_Recent_Sales_Percents_View.Touch_Type_FK