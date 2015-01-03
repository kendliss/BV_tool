
create view Forecasting.Most_Recent_Decile_Adjustments WITH SCHEMABINDING
 AS 
 SELECT A.Touch_Type_FK, A.Adjustment_Factor, A.Percent_Target, B.Entry_Date 
	FROM
	Forecasting.Decile_Response_Adjustments as A INNER JOIN
	Forecasting.Entry_Metadata as B 
	ON A.Entry_Metadata_FK=B.Entry_Metadata_ID
	INNER JOIN 
	Forecasting.Most_Recent_DecileAdj_Temp as C
	ON A.Touch_Type_FK=C.Touch_Type_FK and B.Entry_Date=C.Entry_Date and A.Percent_Target=C.Percent_Target
GROUP BY A.Touch_Type_FK, A.Adjustment_Factor, A.Percent_Target, B.Entry_Date
