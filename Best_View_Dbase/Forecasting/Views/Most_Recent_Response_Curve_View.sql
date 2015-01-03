
create view Forecasting.Most_Recent_Response_Curve_View WITH SCHEMABINDING
 AS 
 SELECT A.Touch_Type_FK, A.Week_Percent, A.Response_Channel_FK, A.Curve_Week, B.Entry_Date 
	FROM
	Forecasting.Response_Curves as A INNER JOIN
	Forecasting.Entry_Metadata as B 
	ON A.Entry_Metadata_FK=B.Entry_Metadata_ID
	INNER JOIN 
	Forecasting.Most_Recent_Curves_Temp as C
	ON A.Touch_Type_FK=C.Touch_Type_FK and B.Entry_Date=C.Entry_Date and A.Response_Channel_FK=C.Response_Channel_FK and A.Curve_Week=C.Curve_Week
GROUP BY A.Touch_Type_FK, A.Week_Percent, A.Response_Channel_FK, A.Curve_Week, B.Entry_Date
