﻿ALTER TRIGGER bvt_prod.[KPIRatesTrigger]
ON bvt_prod.KPI_Rates
AFTER Insert, Update, Delete
AS
BEGIN
	SET NOCOUNT ON
	
	---Get Changed IDs------------
	select [idProgram_Touch_Definitions_TBL_FK] into #ids from
	((select [idProgram_Touch_Definitions_TBL_FK] from INSERTED)
	UNION
	(select [idProgram_Touch_Definitions_TBL_FK] from deleted)) A;

	---Remove those ids from the Start/End Table---
	delete from [bvt_processed].[KPI_Rate_Start_End]
	where [idProgram_Touch_Definitions_TBL_FK] 
		in (select [idProgram_Touch_Definitions_TBL_FK] from #ids);

	---Recalculate Start/End for the ids Altered----
WITH T1 AS
(SELECT Row_Number() OVER(ORDER BY
idProgram_Touch_Definitions_TBL_FK,
idkpi_types_FK,
Rate_Start_Date
) N, 
	
idProgram_Touch_Definitions_TBL_FK,
idkpi_types_FK,
KPI_Rate,
Rate_Start_Date,
----Build a unique compound ID for lagging-------------
cast(idProgram_Touch_Definitions_TBL_FK AS varchar)+
cast(idkpi_types_FK AS varchar)
as unqid
--------------------------------------------	
	
FROM bvt_prod.KPI_Rates s
	where idProgram_Touch_Definitions_TBL_FK in (SELECT * FROM #ids)
GROUP BY idProgram_Touch_Definitions_TBL_FK,
idkpi_types_FK,
KPI_Rate,
Rate_Start_Date)


SELECT 
----------Selecting the Base Data----------------
idProgram_Touch_Definitions_TBL_FK,
idkpi_types_FK,
KPI_Rate,
Rate_Start_Date,
	
-----------Creating the End Date------------------
cast(case when (CASE when N%2=1 then MAX(CASE WHEN N%2=0 THEN unqid END) OVER (Partition BY (N+1)/2) 
	ELSE MAX(CASE WHEN N%2=1 THEN unqid END) OVER (Partition BY N/2) END) = unqid then
	
(CASE WHEN N%2=1 THEN MAX(CASE WHEN N%2=0 THEN dateadd(day,-1,Rate_Start_Date) END) OVER (Partition BY (N+1)/2) 
	ELSE MAX(CASE WHEN N%2=1 THEN dateadd(day,-1,Rate_Start_Date) END) OVER (Partition BY N/2) END)
	
	ELSE '2200-01-01' end as datetime) as END_DATE
INTO #kpistartend
FROM T1;

---------------Insert into the Start End Table----------
INSERT INTO [bvt_processed].[KPI_Rate_Start_End]
([idProgram_Touch_Definitions_TBL_FK], [idkpi_types_FK], [KPI_Rate], [Rate_Start_Date], [END_DATE])
SELECT * from #kpistartend;

--------------Reorg the index on the table-------------
ALTER INDEX [IDX_NC_KPIRATE_STRT_END] ON [bvt_processed].[KPI_Rate_Start_End] Reorganize;

END
