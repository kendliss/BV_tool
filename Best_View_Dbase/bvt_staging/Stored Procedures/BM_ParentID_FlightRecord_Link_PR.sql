USE [UVAQ_STAGING]
GO

/****** Object:  StoredProcedure [bvt_staging].[BM_ParentID_FlightRecord_Link_PR]    Script Date: 02/12/2016 09:20:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [bvt_staging].[BM_ParentID_FlightRecord_Link_PR]

AS
BEGIN
	SET NOCOUNT ON;



IF Object_ID('bvt_staging.BM_pID_FlightPlan_Clean') IS NOT NULL
TRUNCATE TABLE bvt_staging.BM_pID_FlightPlan_Clean

IF Object_ID('bvt_staging.BM_pID_FlightPlan_other') IS NOT NULL
TRUNCATE TABLE bvt_staging.BM_pID_FlightPlan_other

IF Object_ID('bvt_staging.BM_pID_FlightPlan_NoMatch') IS NOT NULL
TRUNCATE TABLE bvt_staging.BM_pID_FlightPlan_NoMatch

IF Object_ID('bvt_staging.BM_pID_FlightPlan_Dups') IS NOT NULL
TRUNCATE TABLE bvt_staging.BM_pID_FlightPlan_Dups


INSERT INTO UVAQ.bvt_processed.BM_ActiveCampaigns
SELECT DISTINCT a.ParentID, eCRW_Project_Name, Campaign_Name, Cell_Description, eCRW_Classification_Name, a.Media_Code,
	Start_Date, a.Cell_DTV_Flag, Vendor, GETDATE() AS AssignDate

	FROM JAVDB.IREPORT_2015.dbo.WB_01_Campaign_list_WB_2016 AS a 
	JOIN JAVDB.IREPORT_2015.dbo.WB_00_Reporting_Hierarchy_2016 AS b
      ON a.tactic_id=b.id
     WHERE b.scorecard_lob_tab = 'Bill Media/Movers'
    AND b.scorecard_type_major = 'Bill Media'
	AND a.parentID  NOT IN (SELECT parentID FROM UVAQ.bvt_processed.BM_ActiveCampaigns)
	AND a.campaign_name NOT LIKE '%Commitment View%'
	AND a.campaign_name NOT LIKE '%Remaining data%'
	AND a.campaign_name NOT LIKE '%best View Objectives%'






Select ParentID,
CASE 





ELSE 0 END AS idProgram_Touch_Definitions,

'' AS idFlight_Plan_Records

INTO #ParentID_ID_Link

FROM UVAQ.bvt_processed.UVLB_ActiveCampaigns

	
SELECT a.[ParentID], a.idProgram_Touch_Definitions, c.idFlight_Plan_Records
INTO #ParentID_ID_Link2

FROM #ParentID_ID_Link a
JOIN UVAQ.bvt_processed.UVLB_ActiveCampaigns b ON a.parentID = b.ParentID
LEFT JOIN (SELECT Distinct 
       [idFlight_Plan_Records]
      ,idProgram_Touch_Definitions_TBL_FK 
      ,[InHome_Date]
		FROM UVAQ.bvt_prod.UVLB_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0) c
ON (a.idprogram_Touch_Definitions = c.idProgram_Touch_Definitions_TBL_FK  AND
(c.InHome_Date BETWEEN Dateadd(D, -5,b.[In_Home_Date]) AND  Dateadd(D, 5, b.[In_Home_Date])))
ORDER BY a.idProgram_Touch_Definitions




--for QC purposes adds information about touch type and campaign instead of only having ID numbers and puts it into the different category tables.

--Clean = flight plan has exact in home date match.

INSERT INTO bvt_staging.UVLB_pID_FlightPlan_Clean
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Cell_Description, b.In_Home_Date, b.Vendor,
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.UVLB_ActiveCampaigns b ON a.parentID = b.ParentID
LEFT JOIN (SELECT DISTINCT 
       [idFlight_Plan_Records]
      ,idProgram_Touch_Definitions_TBL_FK 
      ,[Campaign_Name]
      ,[InHome_Date]
      ,[Touch_Name]
      ,[Program_Name]
      ,[Tactic]
      ,[Media]
      ,[Campaign_Type]
      ,[Audience]
      ,[Creative_Name]
      ,[Offer]
		FROM UVAQ.bvt_prod.UVLB_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where b.In_Home_Date = d.InHome_Date
AND a.ParentID not in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate =Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


--Flight plan has record within +/- 5 days of eCRW in home date but does not match exactly.
INSERT INTO bvt_staging.UVLB_pID_FlightPlan_Other
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Cell_Description, b.In_Home_Date, b.Vendor,
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.UVLB_ActiveCampaigns b ON a.parentID = b.ParentID
LEFT JOIN (SELECT DISTINCT 
       [idFlight_Plan_Records]
      ,idProgram_Touch_Definitions_TBL_FK 
      ,[Campaign_Name]
      ,[InHome_Date]
      ,[Touch_Name]
      ,[Program_Name]
      ,[Tactic]
      ,[Media]
      ,[Campaign_Type]
      ,[Audience]
      ,[Creative_Name]
      ,[Offer]
		FROM UVAQ.bvt_prod.UVLB_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where b.In_Home_Date <> d.InHome_Date and d.InHome_Date is not null
AND a.ParentID not in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate = Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


--eCRW information does not have matching flight plan within +/- 5 days.

INSERT INTO bvt_staging.UVLB_pID_FlightPlan_NoMatch
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Cell_Description, b.In_Home_Date, b.Vendor,
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], Coalesce(d.Touch_Name, e.Touch_Name) as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], Coalesce(d.Media, e.Media) as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.UVLB_ActiveCampaigns b ON a.parentID = b.ParentID
LEFT JOIN (SELECT DISTINCT 
       [idFlight_Plan_Records]
      ,idProgram_Touch_Definitions_TBL_FK 
      ,[Campaign_Name]
      ,[InHome_Date]
      ,[Touch_Name]
      ,[Program_Name]
      ,[Tactic]
      ,[Media]
      ,[Campaign_Type]
      ,[Audience]
      ,[Creative_Name]
      ,[Offer]
		FROM UVAQ.bvt_prod.UVLB_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
JOIN (select a.idProgram_Touch_Definitions_TBL, a.Touch_Name, b.Media from UVAQ.bvt_prod.Program_Touch_Definitions_TBL a
		JOIN  UVAQ.bvt_prod.Media_LU_TBL b
		ON a.idMedia_LU_TBL_FK = b.idMedia_LU_TBL) e
on a.idProgram_Touch_Definitions = e.idProgram_Touch_Definitions_TBL
Where d.InHome_Date is null
AND b.AssignDate = Convert(date, getdate())
ORDER BY In_Home_Date, a.idProgram_Touch_Definitions



--There are multiple matches within +/- days. Should not occur going forward often. 
INSERT INTO bvt_staging.UVLB_pID_FlightPlan_Dups
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Cell_Description, b.In_Home_Date, b.Vendor,
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.UVLB_ActiveCampaigns b ON a.parentID = b.ParentID
LEFT JOIN (SELECT DISTINCT 
       [idFlight_Plan_Records]
      ,idProgram_Touch_Definitions_TBL_FK 
      ,[Campaign_Name]
      ,[InHome_Date]
      ,[Touch_Name]
      ,[Program_Name]
      ,[Tactic]
      ,[Media]
      ,[Campaign_Type]
      ,[Audience]
      ,[Creative_Name]
      ,[Offer]
		FROM UVAQ.bvt_prod.UVLB_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where a.ParentID in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate = Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


END






GO


