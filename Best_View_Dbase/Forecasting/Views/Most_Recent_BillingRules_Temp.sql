
CREATE VIEW Forecasting.Most_Recent_BillingRules_Temp WITH SCHEMABINDING

AS SELECT      MAX(Forecasting.Entry_Metadata.Entry_Date) AS Entry_Date, Forecasting.Billing_Rules.Touch_Type_FK
	
			
                       
FROM          Forecasting.Billing_Rules INNER JOIN
                        Forecasting.Entry_Metadata ON Forecasting.Billing_Rules.Entry_Metadata_FK = Forecasting.Entry_Metadata.Entry_Metadata_ID
GROUP BY Forecasting.Billing_Rules.Touch_Type_FK
