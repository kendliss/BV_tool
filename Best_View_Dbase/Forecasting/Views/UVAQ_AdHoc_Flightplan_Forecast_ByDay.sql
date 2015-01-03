

CREATE VIEW [Forecasting].[UVAQ_AdHoc_Flightplan_Forecast_ByDay] WITH SCHEMABINDING
AS 
Select b.Ad_Hoc_flightplan_ID,
	   b.Forecast_Week_Date,
   	   b.Forecast_DayDate,
	   b.Wk_Call_Forecast,
	   b.Wk_Click_Forecast,
	   b.Wk_Call_Forecast*Call_Curve_Daily.Day_Percent as Day_Call_Forecast,
   	   b.Wk_Click_Forecast*Click_Curve_Daily.Day_Percent as Day_Click_Forecast

From 
(SELECT a.Ad_Hoc_flightplan_ID,
	   a.Touch_Type_FK, 
	   a.Forecast_Week_Date,
	   DATEADD(day,Forecasting.Most_Recent_Response_Curve_Daily_View.Curve_Day_ID-1,a.Forecast_Week_Date) as Forecast_DayDate,
	   DAY_ID = Case Datepart(weekday,(DATEADD(day,Forecasting.Most_Recent_Response_Curve_Daily_View.Curve_Day_ID-1,a.Forecast_Week_Date))) 
	   When 1 then 7
	   When 2 then 1
	   When 3 then 2
	   When 4 then 3
	   When 5 then 4
	   When 6 then 5
	   When 7 then 6
	   END,
	   a.Wk_Call_Forecast,
	   a.Wk_Click_Forecast
FROM
(SELECT Forecasting.UVAQ_ad_hoc_Flightplan_Forecast_View.Ad_Hoc_flightplan_ID,
		Forecasting.UVAQ_ad_hoc_Flightplan_Forecast_View.Touch_Type_FK, 
---Calculate the date for this week's forecast
	DATEADD(week,Call_Curve.Curve_Week,Drop_date) as Forecast_Week_Date,
	Forecasting.UVAQ_ad_hoc_Flightplan_Forecast_View.Call_Forecast*Call_Curve.Week_Percent as Wk_Call_Forecast, 
	Forecasting.UVAQ_ad_hoc_Flightplan_Forecast_View.click_Forecast*click_Curve.Week_Percent as Wk_Click_Forecast

FROM Forecasting.UVAQ_ad_hoc_Flightplan_Forecast_View LEFT JOIN 
	 Forecasting.Most_Recent_Response_Curve_View as Call_Curve
	 ON Forecasting.UVAQ_ad_hoc_Flightplan_Forecast_View.Touch_Type_FK=Call_Curve.Touch_Type_FK and Call_Curve.Response_Channel_FK=1
	 LEFT JOIN 
	 Forecasting.Most_Recent_Response_Curve_View as Click_Curve
	 ON Forecasting.UVAQ_ad_hoc_Flightplan_Forecast_View.Touch_Type_FK=Click_Curve.Touch_Type_FK and Click_Curve.Response_Channel_FK=2 
		and Call_Curve.Curve_Week=Click_Curve.Curve_Week ) as a
	left join
	Forecasting.Most_Recent_Response_Curve_Daily_View
	on a.Touch_Type_FK = Forecasting.Most_Recent_Response_Curve_Daily_View.Touch_Type_FK
	where Forecasting.Most_Recent_Response_Curve_Daily_View.Response_Channel_FK = 1
--order by a.Flight_Plan_Record_ID, a.Touch_Type_FK,Forecast_Week_Date, Forecast_DayDate
) as B

left join

     Forecasting.Most_Recent_Response_Curve_Daily_View as Call_Curve_Daily
	 ON B.Touch_Type_FK=Call_Curve_Daily.Touch_Type_FK and Call_Curve_Daily.Response_Channel_FK=1 and b.DAY_ID = Call_Curve_Daily.Curve_Day_ID
	 LEFT JOIN 
	 Forecasting.Most_Recent_Response_Curve_Daily_View as Click_Curve_Daily
	 ON B.Touch_Type_FK=Click_Curve_Daily.Touch_Type_FK and Click_Curve_Daily.Response_Channel_FK=2 and b.DAY_ID = Click_Curve_Daily.Curve_Day_ID







