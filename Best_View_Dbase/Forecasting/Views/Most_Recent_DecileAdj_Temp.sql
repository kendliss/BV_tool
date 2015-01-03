
CREATE VIEW Forecasting.Most_Recent_DecileAdj_Temp WITH SCHEMABINDING

AS SELECT      MAX(Forecasting.Entry_Metadata.Entry_Date) AS Entry_Date, Forecasting.Decile_Response_Adjustments.Touch_Type_FK, Forecasting.Decile_Response_Adjustments.Percent_Target
                       
FROM          Forecasting.Decile_Response_Adjustments INNER JOIN
                        Forecasting.Entry_Metadata ON Forecasting.Decile_Response_Adjustments.Entry_Metadata_FK = Forecasting.Entry_Metadata.Entry_Metadata_ID
GROUP BY Forecasting.Decile_Response_Adjustments.Touch_Type_FK, Forecasting.Decile_Response_Adjustments.Percent_Target