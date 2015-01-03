


CREATE VIEW [Forecasting].[Current_UVAQ_Flightplan_Sales_ByProduct] WITH SCHEMABINDING

AS SELECT Forecasting.Current_UVAQ_Flightplan_Forecast_View.Flight_Plan_Record_ID, drop_date, Product_FK, 
	Call_Sales_Forecast*Call_Percent_of_Sales as Call_Sales, Click_Sales_Forecast*Click_Percent_of_Sales as Click_Sales
	
FROM Forecasting.Current_UVAQ_Flightplan_Forecast_View LEFT OUTER JOIN
	Forecasting.Most_Recent_Sales_Percents_View 
	ON Forecasting.Current_UVAQ_Flightplan_Forecast_View.Touch_Type_FK=Forecasting.Most_Recent_Sales_Percents_View.Touch_Type_FK







