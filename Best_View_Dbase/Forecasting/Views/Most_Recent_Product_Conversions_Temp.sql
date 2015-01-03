
CREATE VIEW Forecasting.Most_Recent_Product_Conversions_Temp WITH SCHEMABINDING

AS SELECT      MAX(Forecasting.Entry_Metadata.Entry_Date) AS Entry_Date, Forecasting.Product_Conversion_Rates.Touch_Type_FK, Forecasting.Product_Conversion_Rates.Response_Channel_FK
			
                       
FROM          Forecasting.Product_Conversion_Rates INNER JOIN
                        Forecasting.Entry_Metadata ON Forecasting.Product_Conversion_Rates.Entry_Metadata_FK = Forecasting.Entry_Metadata.Entry_Metadata_ID
GROUP BY Forecasting.Product_Conversion_Rates.Touch_Type_FK, Forecasting.Product_Conversion_Rates.Response_Channel_FK
