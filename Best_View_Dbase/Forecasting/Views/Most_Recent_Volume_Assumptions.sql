
create view Forecasting.Most_Recent_Volume_Assumptions WITH SCHEMABINDING
 AS 
 SELECT A.Touch_Type_FK, A.Volume_Assumption, B.Entry_Date 
	FROM
	Forecasting.VOLUME_ASSUMPTIONS as A INNER JOIN
	Forecasting.Entry_Metadata as B 
	ON A.Entry_Metadata_FK=B.Entry_Metadata_ID
	INNER JOIN 
	Forecasting.Most_Recent_Volume_Temp as C
	ON A.Touch_Type_FK=C.Touch_Type_FK and B.Entry_Date=C.Expr1
GROUP BY A.Touch_Type_FK, A.Volume_Assumption, B.Entry_Date 
