CREATE VIEW Forecasting.Most_Recent_Volume_Temp WITH SCHEMABINDING

AS SELECT      MAX(Forecasting.Entry_Metadata.Entry_Date) AS Expr1, Forecasting.VOLUME_ASSUMPTIONS.Touch_Type_FK
FROM          Forecasting.VOLUME_ASSUMPTIONS INNER JOIN
                        Forecasting.Entry_Metadata ON Forecasting.VOLUME_ASSUMPTIONS.Entry_Metadata_FK = Forecasting.Entry_Metadata.Entry_Metadata_ID
GROUP BY Forecasting.VOLUME_ASSUMPTIONS.Touch_Type_FK