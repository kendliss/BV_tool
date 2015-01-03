
CREATE VIEW Forecasting.Most_Recent_Curves_Temp WITH SCHEMABINDING

AS SELECT      MAX(Forecasting.Entry_Metadata.Entry_Date) AS Entry_Date, Forecasting.Response_Curves.Touch_Type_FK, Forecasting.Response_Curves.Response_Channel_FK, Forecasting.Response_Curves.Curve_Week 
			
                       
FROM          Forecasting.Response_Curves INNER JOIN
                        Forecasting.Entry_Metadata ON Forecasting.Response_Curves.Entry_Metadata_FK = Forecasting.Entry_Metadata.Entry_Metadata_ID
GROUP BY Forecasting.Response_Curves.Touch_Type_FK, Forecasting.Response_Curves.Response_Channel_FK, Forecasting.Response_Curves.Curve_Week
