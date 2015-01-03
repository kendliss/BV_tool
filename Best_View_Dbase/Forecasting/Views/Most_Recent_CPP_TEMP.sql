
Create View Forecasting.Most_Recent_CPP_TEMP WITH SCHEMABINDING

AS SELECT      MAX(Forecasting.Entry_Metadata.Entry_Date) AS Entry_Date, Forecasting.CPP.Touch_Type_FK
FROM          Forecasting.CPP INNER JOIN
                        Forecasting.Entry_Metadata ON Forecasting.CPP.Entry_Metadata_FK = Forecasting.Entry_Metadata.Entry_Metadata_ID
GROUP BY Forecasting.CPP.Touch_Type_FK
