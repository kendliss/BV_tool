
CREATE VIEW Forecasting.Most_Recent_Conversions_Temp WITH SCHEMABINDING

AS SELECT      MAX(Forecasting.Entry_Metadata.Entry_Date) AS Entry_Date, Forecasting.Conversion_Rates.Touch_Type_FK, Forecasting.Conversion_Rates.Response_Channel_FK
			
                       
FROM          Forecasting.Conversion_Rates INNER JOIN
                        Forecasting.Entry_Metadata ON Forecasting.Conversion_Rates.Entry_Metadata_FK = Forecasting.Entry_Metadata.Entry_Metadata_ID
GROUP BY Forecasting.Conversion_Rates.Touch_Type_FK, Forecasting.Conversion_Rates.Response_Channel_FK
