drop view [bvt_prod].[Drag_Conversion_Start_End_VW]
GO

CREATE VIEW [bvt_prod].[Drag_Conversion_Start_End_VW]
AS WITH T1 AS
(SELECT Row_Number() OVER(ORDER BY
idProgram_Touch_Definitions_TBL_FK,
[idProduct_LU_TBL_FK],
[Conv_Rate_Start_Date],
[idKPI_Type_FK]
) N, 
	
idProgram_Touch_Definitions_TBL_FK,
[idProduct_LU_TBL_FK],
[Conversion_Rate],
[Conv_Rate_Start_Date],
[idKPI_Type_FK],



----Build a unique compound ID for lagging-------------
cast(idProgram_Touch_Definitions_TBL_FK AS varchar)+
cast([idProduct_LU_TBL_FK] AS varchar) +
cast(idKPI_Type_FK as varchar) 
as unqid
--------------------------------------------	
	
FROM [bvt_prod].[Drag_Conversion_Rates] s
GROUP BY idProgram_Touch_Definitions_TBL_FK,
[idProduct_LU_TBL_FK],
[Conversion_Rate],
[Conv_Rate_Start_Date],
[idKPI_Type_FK])


SELECT 
----------Selecting the Base Data----------------
idProgram_Touch_Definitions_TBL_FK,
[idProduct_LU_TBL_FK],
[Conversion_Rate],
[Conv_Rate_Start_Date],
[idKPI_Type_FK],
	
-----------Creating the End Date------------------
cast(case when (CASE when N%2=1 then MAX(CASE WHEN N%2=0 THEN unqid END) OVER (Partition BY (N+1)/2) 
	ELSE MAX(CASE WHEN N%2=1 THEN unqid END) OVER (Partition BY N/2) END) = unqid then
	
(CASE WHEN N%2=1 THEN MAX(CASE WHEN N%2=0 THEN dateadd(day,-1,[Conv_Rate_Start_Date]) END) OVER (Partition BY (N+1)/2) 
	ELSE MAX(CASE WHEN N%2=1 THEN dateadd(day,-1,[Conv_Rate_Start_Date]) END) OVER (Partition BY N/2) END)
	
	ELSE '2200-01-01' end as datetime) as END_DATE


FROM T1
