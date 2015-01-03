


CREATE VIEW [Forecasting].[Current_UVAQ_Flightplan_Forecast_ByWeek] WITH SCHEMABINDING

AS SELECT Forecasting.Current_UVAQ_Flightplan_Forecast_View.Flight_Plan_Record_ID, 
---Calculate the date for this week's forecast
	DATEADD(week,Call_Curve.Curve_Week,Drop_Date) as Forecast_Date,
	Forecasting.Current_UVAQ_Flightplan_Forecast_View.Call_Forecast*Call_Curve.Week_Percent as Wk_Call_Forecast, 
	Forecasting.Current_UVAQ_Flightplan_Forecast_View.click_Forecast*click_Curve.Week_Percent as Wk_Click_Forecast
FROM Forecasting.Current_UVAQ_Flightplan_Forecast_View LEFT JOIN 
	 Forecasting.Most_Recent_Response_Curve_View as Call_Curve
	 ON Forecasting.Current_UVAQ_Flightplan_Forecast_View.Touch_Type_FK=Call_Curve.Touch_Type_FK and Call_Curve.Response_Channel_FK=1
	 LEFT JOIN 
	 Forecasting.Most_Recent_Response_Curve_View as Click_Curve
	 ON Forecasting.Current_UVAQ_Flightplan_Forecast_View.Touch_Type_FK=Click_Curve.Touch_Type_FK and Click_Curve.Response_Channel_FK=2 
		and Call_Curve.Curve_Week=Click_Curve.Curve_Week







