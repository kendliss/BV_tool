drop view bvt_prod.Dropdate_Start_End_VW
GO

create view 
bvt_prod.Dropdate_Start_End_VW
as 	
WITH T1 AS
(SELECT Row_Number() OVER(ORDER BY
idProgram_Touch_Definitions_TBL_FK,
drop_start_date
) N, 
	
idProgram_Touch_Definitions_TBL_FK,
Days_Before_Inhome,
drop_start_date,


----Build a unique compound ID for lagging-------------
cast(idProgram_Touch_Definitions_TBL_FK AS varchar)
as unqid
--------------------------------------------	
	
FROM bvt_prod.Drop_Date_Calc_Rules s
GROUP BY idProgram_Touch_Definitions_TBL_FK,
Days_Before_Inhome,
drop_start_date)


SELECT 
----------Selecting the Base Data----------------
idProgram_Touch_Definitions_TBL_FK,
Days_Before_Inhome,
drop_start_date,

	
-----------Creating the End Date------------------
cast(case when (CASE when N%2=1 then MAX(CASE WHEN N%2=0 THEN unqid END) OVER (Partition BY (N+1)/2) 
	ELSE MAX(CASE WHEN N%2=1 THEN unqid END) OVER (Partition BY N/2) END) = unqid then
	
(CASE WHEN N%2=1 THEN MAX(CASE WHEN N%2=0 THEN dateadd(day,-1,drop_start_date) END) OVER (Partition BY (N+1)/2) 
	ELSE MAX(CASE WHEN N%2=1 THEN dateadd(day,-1,drop_start_date) END) OVER (Partition BY N/2) END)
	
	ELSE '2200-01-01' end as datetime) as END_DATE


FROM T1


