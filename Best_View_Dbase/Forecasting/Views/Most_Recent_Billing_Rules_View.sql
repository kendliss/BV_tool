
create view Forecasting.Most_Recent_Billing_Rules_View WITH SCHEMABINDING
 AS 
 SELECT A.Touch_Type_FK, A.Billing_Percent, A.Month_Difference, B.Entry_Date 
	FROM
	Forecasting.Billing_Rules as A INNER JOIN
	Forecasting.Entry_Metadata as B 
	ON A.Entry_Metadata_FK=B.Entry_Metadata_ID
	INNER JOIN 
	Forecasting.Most_Recent_BillingRules_Temp as C
	ON A.Touch_Type_FK=C.Touch_Type_FK and B.Entry_Date=C.Entry_Date 
GROUP BY A.Touch_Type_FK, A.Billing_Percent, A.Month_Difference, B.Entry_Date
