
CREATE VIEW Forecasting.Most_Recent_Curves_Daily_Temp WITH SCHEMABINDING

AS SELECT      MAX(Forecasting.Entry_Metadata.Entry_Date) AS Entry_Date, Forecasting.Response_Curves_Daily.Touch_Type_FK, Forecasting.Response_Curves_Daily.Response_Channel_FK, Forecasting.Response_Curves_Daily.Curve_Day_ID 
			
                       
FROM          Forecasting.Response_Curves_Daily INNER JOIN
                        Forecasting.Entry_Metadata ON Forecasting.Response_Curves_Daily.Entry_Metadata_FK = Forecasting.Entry_Metadata.Entry_Metadata_ID
GROUP BY Forecasting.Response_Curves_Daily.Touch_Type_FK, Forecasting.Response_Curves_Daily.Response_Channel_FK, Forecasting.Response_Curves_Daily.Curve_Day_ID
