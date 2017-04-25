drop view bvt_prod.Sales_Curve_Start_End_VW
GO

create view
bvt_prod.Sales_Curve_Start_End_VW
as 	
WITH T1 AS
(SELECT Row_Number() OVER(ORDER BY
idProgram_Touch_Definitions_TBL_FK,
idkpi_type_FK,
Week_ID,
Curve_Start_Date,
idProduct_LU_TBL_FK
) N, 
	
idProgram_Touch_Definitions_TBL_FK,
idkpi_type_FK,
Week_ID,
week_percent,
Curve_Start_Date,
idProduct_LU_TBL_FK,


----Build a unique compound ID for lagging-------------
cast(idProgram_Touch_Definitions_TBL_FK AS varchar)+
cast(idkpi_type_FK AS varchar)+
cast(Week_ID as varchar)+
cast(idProduct_LU_TBL_FK as varchar)
as unqid
--------------------------------------------	
	
FROM bvt_prod.Sales_Curve s
GROUP BY idProgram_Touch_Definitions_TBL_FK,
idkpi_type_FK,
Week_ID,
week_percent,
Curve_Start_Date,
idProduct_LU_TBL_FK)


SELECT 
----------Selecting the Base Data----------------
idProgram_Touch_Definitions_TBL_FK,
idkpi_type_FK,
idProduct_LU_TBL_FK,
Week_ID,
week_percent,
Curve_Start_Date,
	
-----------Creating the End Date------------------
cast(case when (CASE when N%2=1 then MAX(CASE WHEN N%2=0 THEN unqid END) OVER (Partition BY (N+1)/2) 
	ELSE MAX(CASE WHEN N%2=1 THEN unqid END) OVER (Partition BY N/2) END) = unqid then
	
(CASE WHEN N%2=1 THEN MAX(CASE WHEN N%2=0 THEN dateadd(day,-1,Curve_Start_Date) END) OVER (Partition BY (N+1)/2) 
	ELSE MAX(CASE WHEN N%2=1 THEN dateadd(day,-1,Curve_Start_Date) END) OVER (Partition BY N/2) END)
	
	ELSE '2200-01-01' end as datetime) as END_DATE


FROM T1


