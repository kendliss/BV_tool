
create view Forecasting.Most_Recent_Product_Conversions_View WITH SCHEMABINDING
 AS 
 SELECT A.Touch_Type_FK, A.Product_Conversion_Rate , A.Product_FK, A.Response_Channel_FK, B.Entry_Date, A.Product_Conversion_Rate_ID 
	FROM
	Forecasting.Product_Conversion_Rates as A INNER JOIN
	Forecasting.Entry_Metadata as B 
	ON A.Entry_Metadata_FK=B.Entry_Metadata_ID
	INNER JOIN 
	Forecasting.Most_Recent_Product_Conversions_Temp as C
	ON A.Touch_Type_FK=C.Touch_Type_FK and B.Entry_Date=C.Entry_Date and A.Response_Channel_FK=C.Response_Channel_FK
GROUP BY A.Touch_Type_FK, A.Product_Conversion_Rate, A.Product_FK, A.Response_Channel_FK, B.Entry_Date, A.Product_Conversion_Rate_ID
