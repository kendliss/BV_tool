CREATE VIEW Forecasting.Most_Recent_RR_Temp WITH SCHEMABINDING
AS SELECT      MAX(Forecasting.Entry_Metadata.Entry_Date) AS Entry_Date, Forecasting.Response_Rates.Touch_Type_FK, 
                        Forecasting.Response_Rates.Response_Channel_FK
FROM          Forecasting.Response_Rates INNER JOIN
                        Forecasting.Entry_Metadata ON Forecasting.Response_Rates.Entry_Metadata_FK = Forecasting.Entry_Metadata.Entry_Metadata_ID
GROUP BY Forecasting.Response_Rates.Touch_Type_FK, Forecasting.Response_Rates.Response_Channel_FK