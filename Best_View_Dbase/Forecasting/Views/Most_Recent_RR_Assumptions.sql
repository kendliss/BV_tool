﻿
create view Forecasting.Most_Recent_RR_Assumptions WITH SCHEMABINDING
 AS 
 SELECT A.Touch_Type_FK, A.Response_Rate, A.Response_Channel_FK, B.Entry_Date 
	FROM
	Forecasting.Response_Rates as A INNER JOIN
	Forecasting.Entry_Metadata as B 
	ON A.Entry_Metadata_FK=B.Entry_Metadata_ID
	INNER JOIN 
	Forecasting.Most_Recent_RR_Temp as C
	ON A.Touch_Type_FK=C.Touch_Type_FK and B.Entry_Date=C.Entry_Date and A.Response_Channel_FK=C.Response_Channel_FK
GROUP BY  A.Touch_Type_FK, A.Response_Rate, A.Response_Channel_FK, B.Entry_Date 
