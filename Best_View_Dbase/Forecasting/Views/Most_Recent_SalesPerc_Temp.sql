
CREATE VIEW Forecasting.Most_Recent_SalesPerc_Temp WITH SCHEMABINDING

AS SELECT      MAX(Forecasting.Entry_Metadata.Entry_Date) AS Entry_Date, Forecasting.Sales_Percents.Touch_Type_FK, Forecasting.Sales_Percents.Product_FK 
			
                       
FROM          Forecasting.Sales_Percents INNER JOIN
                        Forecasting.Entry_Metadata ON Forecasting.Sales_Percents.Entry_Metadata_FK = Forecasting.Entry_Metadata.Entry_Metadata_ID
GROUP BY Forecasting.Sales_Percents.Touch_Type_FK, Forecasting.Sales_Percents.Product_FK 
