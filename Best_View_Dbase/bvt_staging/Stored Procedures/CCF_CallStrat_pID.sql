USE [UVAQ_STAGING]
GO

/****** Object:  StoredProcedure [bvt_staging].[CCF_CallStrat_pID_SP]    Script Date: 09/20/2016 10:29:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER PROC [bvt_staging].[CCF_CallStrat_pID_SP]

AS
BEGIN
	SET NOCOUNT ON;

IF Object_ID('bvt_staging.CCF_CallStrat_pID') IS NOT NULL
TRUNCATE TABLE bvt_staging.CCF_CallStrat_pID

INSERT INTO bvt_staging.CCF_CallStrat_pID

SELECT b.idFlight_Plan_Records_FK, Source_System_ID, e.TOLLFREE_NUMBER, Coalesce(e.cat_ID, f.CallStrat_ID) AS CallStrat_ID, CTD_Quantity, ISNULL(CTD_Quantity,0)/FlightVolume AS PIDPercent

FROM  UVAQ.bvt_prod.External_ID_linkage_TBL a
JOIN UVAQ.bvt_prod.External_ID_linkage_TBL_has_Flight_Plan_Records b
	ON a.idExternal_ID_linkage_TBL = b.idExternal_ID_linkage_TBL_FK
LEFT JOIN JAVDB.IREPORT_2015.dbo.WB_01_Campaign_List_WB_2016 c
	ON a.Source_System_ID = c.parentID
LEFT JOIN JAVDB.IREPORT_2015.dbo.WB_01_TFN_List_WB f
on c.parentID = f.ParentID and f.Source = 'eCRW_TFN'
LEFT JOIN (SELECT Tollfree_number,
			CASE WHEN category LIKE '%Z%' THEN 100
				 WHEN CATEGORY LIKE '[A-Z][0-9][0-9][A-Z]%' AND CAST(SUBSTRING(category,2,2) AS INT) = 10 AND category LIKE '%Green%' THEN 10.1
				 WHEN CATEGORY LIKE '[A-Z][0-9][0-9][A-Z]%' AND CAST(SUBSTRING(category,2,2) AS INT) = 10 AND category LIKE '%Organic%' THEN 10.2
				 WHEN CATEGORY LIKE '[A-Z][0-9][0-9][A-Z]%' AND CAST(SUBSTRING(category,2,2) AS INT) = 16 AND category LIKE '%ACQ%' THEN 16.1
				 WHEN CATEGORY LIKE '[A-Z][0-9][0-9][A-Z]%' AND CAST(SUBSTRING(category,2,2) AS INT) = 16 AND category LIKE '%XSell%' THEN 16.2
				 WHEN CATEGORY LIKE '[A-Z][0-9][0-9][A-Z]%' AND CAST(SUBSTRING(category,2,2) AS INT) = 16 AND category LIKE '%Universal%' THEN 16.3		 
				 WHEN CATEGORY LIKE '[A-Z][0-9][0-9][A-Z]%' THEN CAST(SUBSTRING(category,2,2) AS INT) 
				 ELSE 0
				 END AS cat_ID
		FROM SCAMP.dbo.TFN_CATEGORY_WEEKLY 
		WHERE  ReportWeek_YYYYWW = (select ReportCycle_YYYYWW from [JAVDB].[ireport_2015].[dbo].[wb_00_reporting_cycle])
		GROUP BY Tollfree_number,
		CASE WHEN category LIKE '%Z%' THEN 100
				 WHEN CATEGORY LIKE '[A-Z][0-9][0-9][A-Z]%' AND CAST(SUBSTRING(category,2,2) AS INT) = 10 AND category LIKE '%Green%' THEN 10.1
				 WHEN CATEGORY LIKE '[A-Z][0-9][0-9][A-Z]%' AND CAST(SUBSTRING(category,2,2) AS INT) = 10 AND category LIKE '%Organic%' THEN 10.2
				 WHEN CATEGORY LIKE '[A-Z][0-9][0-9][A-Z]%' AND CAST(SUBSTRING(category,2,2) AS INT) = 16 AND category LIKE '%ACQ%' THEN 16.1
				 WHEN CATEGORY LIKE '[A-Z][0-9][0-9][A-Z]%' AND CAST(SUBSTRING(category,2,2) AS INT) = 16 AND category LIKE '%XSell%' THEN 16.2
				 WHEN CATEGORY LIKE '[A-Z][0-9][0-9][A-Z]%' AND CAST(SUBSTRING(category,2,2) AS INT) = 16 AND category LIKE '%Universal%' THEN 16.3		 
				 WHEN CATEGORY LIKE '[A-Z][0-9][0-9][A-Z]%' THEN CAST(SUBSTRING(category,2,2) AS INT) 
				 ELSE 0
				 END) e
	ON f.TFN = e.TOLLFREE_NUMBER
JOIN (SELECT idFlight_Plan_Records_FK, SUM(ISNULL(CTD_Quantity,0)) AS FlightVolume
		FROM UVAQ.bvt_prod.External_ID_linkage_TBL a
		JOIN UVAQ.bvt_prod.External_ID_linkage_TBL_has_Flight_Plan_Records b
			ON a.idExternal_ID_linkage_TBL = b.idExternal_ID_linkage_TBL_FK
		LEFT JOIN JAVDB.IREPORT_2015.dbo.WB_01_Campaign_List_WB_2016 c
			ON Source_System_ID = c.parentID
		GROUP BY idFlight_Plan_Records_FK
		HAVING SUM(ISNULL(CTD_Quantity,0)) <> 0) d
	ON b.idFlight_Plan_Records_FK = d.idFlight_Plan_Records_FK
ORDER BY b.idFlight_Plan_Records_FK, Source_System_ID

END






GO


