CREATE VIEW [bvt_prod].[Drag_Method_Start_End_VW]
	AS WITH T1 AS
(SELECT Row_Number() OVER(ORDER BY
[idProgram_LU_TBL_FK],
[drag_start_date]
) N, 
	
[idProgram_LU_TBL_FK],
[idDrag_Method_LU_TBL_FK],
[Metric],
[drag_start_date],


----Build a unique compound ID for lagging-------------
cast([idProgram_LU_TBL_FK] AS varchar)
as unqid
--------------------------------------------	
	
FROM [bvt_prod].[Drag_Method] s
GROUP BY [idProgram_LU_TBL_FK],
[idDrag_Method_LU_TBL_FK],
[Metric],
[drag_start_date])


SELECT 
----------Selecting the Base Data----------------
[idProgram_LU_TBL_FK],
[idDrag_Method_LU_TBL_FK],
[Metric],
[drag_start_date],

	
-----------Creating the End Date------------------
cast(case when (CASE when N%2=1 then MAX(CASE WHEN N%2=0 THEN unqid END) OVER (Partition BY (N+1)/2) 
	ELSE MAX(CASE WHEN N%2=1 THEN unqid END) OVER (Partition BY N/2) END) = unqid then
	
(CASE WHEN N%2=1 THEN MAX(CASE WHEN N%2=0 THEN dateadd(day,-1,[drag_start_date]) END) OVER (Partition BY (N+1)/2) 
	ELSE MAX(CASE WHEN N%2=1 THEN dateadd(day,-1,[drag_start_date]) END) OVER (Partition BY N/2) END)
	
	ELSE '2200-01-01' end as datetime) as END_DATE


FROM T1