
create view Forecasting.Most_Recent_Sales_Percents_View WITH SCHEMABINDING
 AS 
 SELECT A.Touch_Type_FK, A.Call_Percent_of_Sales, A.Click_Percent_of_Sales, A.Product_FK, B.Entry_Date 
	FROM
	Forecasting.Sales_Percents as A INNER JOIN
	Forecasting.Entry_Metadata as B 
	ON A.Entry_Metadata_FK=B.Entry_Metadata_ID
	INNER JOIN 
	Forecasting.Most_Recent_SalesPerc_Temp as C
	ON A.Touch_Type_FK=C.Touch_Type_FK and B.Entry_Date=C.Entry_Date and A.Product_FK=C.Product_FK
GROUP BY A.Touch_Type_FK, A.Call_Percent_of_Sales, A.Click_Percent_of_Sales, A.Product_FK, B.Entry_Date 
