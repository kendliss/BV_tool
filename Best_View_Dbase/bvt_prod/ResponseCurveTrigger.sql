CREATE TRIGGER [ResponseCurveTrigger]
	ON [bvt_prod].[Response_Curve]
	AFTER DELETE, INSERT, UPDATE
	AS
	BEGIN
		SET NOCOUNT ON
		
	---Get Changed IDs------------
	select [idProgram_Touch_Definitions_TBL_FK] into #ids from
	((select [idProgram_Touch_Definitions_TBL_FK] from INSERTED)
	UNION
	(select [idProgram_Touch_Definitions_TBL_FK] from deleted)) A;

	---Remove those ids from the Start/End Table---
	delete from [bvt_processed].[Response_Curve_Start_End]
	where [idProgram_Touch_Definitions_TBL_FK] 
		in (select [idProgram_Touch_Definitions_TBL_FK] from #ids);

	---Recalculate Start/End for the ids Altered----
	WITH T1 AS
(SELECT Row_Number() OVER(ORDER BY
idProgram_Touch_Definitions_TBL_FK,
idkpi_type_FK,
Week_ID,
Curve_Start_Date
) N, 
	
idProgram_Touch_Definitions_TBL_FK,
idkpi_type_FK,
Week_ID,
week_percent,
Curve_Start_Date,


----Build a unique compound ID for lagging-------------
cast(idProgram_Touch_Definitions_TBL_FK AS varchar)+
cast(idkpi_type_FK AS varchar)+
CAST(Week_ID AS varchar)
as unqid
--------------------------------------------	
	
FROM bvt_prod.Response_Curve s
	where idProgram_Touch_Definitions_TBL_FK in (SELECT * from #ids)
GROUP BY idProgram_Touch_Definitions_TBL_FK,
idkpi_type_FK,
Week_ID,
week_percent,
Curve_Start_Date)

SELECT 
----------Selecting the Base Data----------------
idProgram_Touch_Definitions_TBL_FK,
idkpi_type_FK,
Week_ID,
week_percent,
Curve_Start_Date,
	
-----------Creating the End Date------------------
cast(case when (CASE when N%2=1 then MAX(CASE WHEN N%2=0 THEN unqid END) OVER (Partition BY (N+1)/2) 
	ELSE MAX(CASE WHEN N%2=1 THEN unqid END) OVER (Partition BY N/2) END) = unqid then
	
(CASE WHEN N%2=1 THEN MAX(CASE WHEN N%2=0 THEN dateadd(day,-1,Curve_Start_Date) END) OVER (Partition BY (N+1)/2) 
	ELSE MAX(CASE WHEN N%2=1 THEN dateadd(day,-1,Curve_Start_Date) END) OVER (Partition BY N/2) END)
	
	ELSE '2200-01-01' end as datetime) as END_DATE

INTO #responsecurve
FROM T1;

---------------Insert into the Start End Table----------
INSERT INTO [bvt_processed].[Response_Curve_Start_End]
([idProgram_Touch_Definitions_TBL_FK], [idkpi_type_FK], [Week_ID], [week_percent], [Curve_Start_Date], [END_DATE])
Select * from #responsecurve
--------------------------------------------------------
END
