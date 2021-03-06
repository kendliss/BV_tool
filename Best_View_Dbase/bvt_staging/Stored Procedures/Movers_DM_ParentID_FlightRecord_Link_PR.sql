USE [UVAQ_STAGING]
GO
/****** Object:  StoredProcedure [bvt_staging].[Movers_DM_ParentID_FlightRecord_Link_PR]    Script Date: 06/13/2016 15:26:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [bvt_staging].[Movers_DM_ParentID_FlightRecord_Link_PR]

AS
BEGIN
	SET NOCOUNT ON;

/*Moved Movers DM to X-Sell Program for 2017*/

IF Object_ID('bvt_staging.Movers_pID_FlightPlan_Clean') IS NOT NULL
TRUNCATE TABLE bvt_staging.Movers_pID_FlightPlan_Clean

IF Object_ID('bvt_staging.Movers_pID_FlightPlan_other') IS NOT NULL
TRUNCATE TABLE bvt_staging.Movers_pID_FlightPlan_other

IF Object_ID('bvt_staging.Movers_pID_FlightPlan_NoMatch') IS NOT NULL
TRUNCATE TABLE bvt_staging.Movers_pID_FlightPlan_NoMatch

IF Object_ID('bvt_staging.Movers_pID_FlightPlan_Dups') IS NOT NULL
TRUNCATE TABLE bvt_staging.Movers_pID_FlightPlan_Dups

IF Object_ID('#MoversParentIDs') IS NOT NULL
DROP TABLE #MoversParentIDs


select ParentID
INTO #MoversParentIDs
from UVAQ.bvt_processed.Movers_DM_ActiveCampaigns





INSERT INTO UVAQ.bvt_processed.Movers_DM_ActiveCampaigns
SELECT distinct [eCRW_Project_Name], [Project_Id], a.[ParentID], [Campaign_Name], a.[Media_Code], [Start_Date], [In_Home_Date], CONVERT(date,GETDATE())

      FROM javdb.IREPORT_2015.dbo.WB_01_Campaign_list_WB_2017 a
      JOIN JAVDB.IREPORT_2015.dbo.WB_00_Reporting_Hierarchy_2017 c
      on a.tactic_id = c.id
      LEFT JOIN #MoversParentIDs b
      on a.parentID = b.parentID
	  where ATT_program_Code in ('MODM')
	  AND [End_Date_Traditional] > '2014-12-28'
      AND Campaign_Name NOT LIKE '%best view objectives%'
      AND Campaign_Name NOT LIKE '%commitment view objectives%'
      AND eCRW_Project_Name NOT LIKE '%YP%'
      AND Campaign_Name NOT LIKE '%remaining data%'
	  AND b.parentID IS NULL
	  AND a.Media_Code <> 'Drag'
	  AND a.ExcludefromScorecard = 'N'


Select ParentID,
CASE 
--DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%WirelessCOA%' THEN 537 --U-verse Wireless Only Triggers Post Move DM

WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%HomesForSaleLiveTouch1%' OR eCRW_Project_Name LIKE '%FirstTimeBuyerT1%'
	OR eCRW_Project_Name LIKE '%MoversHomeSold%' OR eCRW_Project_Name LIKE '%PreMoverCombinedT1LiveANDProspect%' OR 
	(eCRW_Project_Name LIKE '%RecLiveRenter%' AND eCRW_Project_Name NOT LIKE '%RecLiveRenterTouch2%')) AND 
	(Campaign_Name LIKE '%Wireless%' OR Campaign_Name LIKE '%WLS%') AND Campaign_Name NOT LIKE '%WLN%' AND Campaign_Name NOT LIKE '%Prospect%' THEN 754 --Wireless Pre Move T1 DM

WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%FirstTimeBuyerT2Live%' OR eCRW_Project_Name LIKE '%HomesForSaleTouch2%' OR eCRW_Project_Name LIKE '%RecLiveRenterTouch2%' 
OR eCRW_Project_Name LIKE '%PreMoverCombinedT2LiveANDProspect%') AND
	(Campaign_Name LIKE '%Wireless%' OR Campaign_Name LIKE '%WLS%') AND Campaign_Name NOT LIKE '%WLN%' AND Campaign_Name NOT LIKE '%Prospect%' THEN 755 --Wireless Pre Move T2 DM

WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%HomesForSaleLiveTouch1%' OR eCRW_Project_Name LIKE '%FirstTimeBuyerT1%'
	OR eCRW_Project_Name LIKE '%MoversHomeSold%' OR eCRW_Project_Name LIKE '%RecLiveRenterTouch1%' OR (eCRW_Project_Name LIKE '%RecLiveRenter%' 
	AND eCRW_Project_Name NOT LIKE '%RecLiveRenterTouch2%'))
	AND Campaign_Name LIKE '% Live %' AND (Campaign_Name LIKE '%Non TV%' OR Campaign_Name LIKE '%IPDSL%' OR Campaign_Name LIKE '%Remainder%' OR Campaign_Name LIKE '%NonTV%') 
	AND Campaign_Name NOT LIKE '%Prospect%'  THEN 746 --Livebase Pre Move Non TV T1 DM

WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%HomesForSaleLiveTouch1%' OR eCRW_Project_Name LIKE '%FirstTimeBuyerT1%'
	OR eCRW_Project_Name LIKE '%MoversHomeSold%' OR (eCRW_Project_Name LIKE '%RecLiveRenter%' AND eCRW_Project_Name NOT LIKE '%RecLiveRenterTouch2%')) AND Campaign_Name LIKE '% Live %' AND 
	Campaign_Name LIKE '%Promo%' AND Campaign_Name NOT LIKE '%Prospect%' THEN 747 --Livebase Pre Move UV Promo T1 DM

WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%HomesForSaleLiveTouch1%' OR eCRW_Project_Name LIKE '%FirstTimeBuyerT1%'
	OR eCRW_Project_Name LIKE '%MoversHomeSold%' OR (eCRW_Project_Name LIKE '%RecLiveRenter%' AND eCRW_Project_Name NOT LIKE '%RecLiveRenterTouch2%')) AND Campaign_Name LIKE '% Live %' AND 
	Campaign_Name LIKE '%Rack Rate%' AND Campaign_Name NOT LIKE '%Prospect%' THEN 748 --Livebase Pre Move UV Rack Rate T1 DM

WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%FirstTimeBuyerT2Live%' OR eCRW_Project_Name LIKE '%HomesForSaleTouch2%' OR eCRW_Project_Name LIKE '%RecLiveRenterTouch2%')
	AND Campaign_Name LIKE '% Live %' AND (Campaign_Name LIKE '%Non TV%' OR Campaign_Name LIKE '%IPDSL%' OR Campaign_Name LIKE '%Remainder%' OR Campaign_Name LIKE '%NonTV%') AND Campaign_Name NOT LIKE '%Prospect%' THEN 750 --Livebase Pre Move Non TV T2 DM

WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%FirstTimeBuyerT2Live%' OR eCRW_Project_Name LIKE '%HomesForSaleTouch2%' OR eCRW_Project_Name LIKE '%RecLiveRenterTouch2%')
	AND Campaign_Name LIKE '% Live %' AND Campaign_Name LIKE '%Promo%' AND Campaign_Name NOT LIKE '%Prospect%' THEN 751 --Livebase Pre Move UV Promo T2 DM

WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%FirstTimeBuyerT2Live%' OR eCRW_Project_Name LIKE '%HomesForSaleTouch2%' OR eCRW_Project_Name LIKE '%RecLiveRenterTouch2%')
	AND Campaign_Name LIKE '% Live %' AND Campaign_Name LIKE '%Rack Rate%' AND Campaign_Name NOT LIKE '%Prospect%' THEN 752 --Livebase Pre Move UV Rack Rate T2 DM

WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%ProspectEpsilonPropensityToMove%' OR eCRW_Project_Name LIKE '%RentersProspect%' OR eCRW_Project_Name LIKE '%FirstTimeBuyer%'
	OR eCRW_Project_Name LIKE '%HFSProspectWeekly%' OR eCRW_Project_Name LIKE '%ProspectMoversHomeSold%' OR eCRW_Project_Name LIKE '%ProspectMoversHomeSold%') AND Campaign_Name LIKE '% Prospect %' THEN 756 --Prospect Pre Move T1 DM

WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%PostMovers%' AND Campaign_Name LIKE '%Wireless%' THEN 758 --Wireless Post Move DM

WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%PostMovers%' AND Campaign_Name LIKE '%Live%' THEN 759 --Livebase Post Move DM

WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%PostMovers%' AND Campaign_Name LIKE '%Prospect%' THEN 761 --Prospect Post Move DM

WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%PreMover%T1%' AND eCRW_Project_Name LIKE '%Live%' AND Campaign_Name LIKE '%Promo%' AND Campaign_Name NOT LIKE '%Prospect%' THEN 747 --Livebase Pre Move UV Promo T1 DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%Premover%T1%' AND eCRW_Project_Name LIKE '%Live%' AND Campaign_Name LIKE '%Rack Rate%' AND Campaign_Name NOT LIKE '%Prospect%' THEN 748 --Livebase Pre Move UV Rack Rate T1 DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%PreMover%T1%' AND eCRW_Project_Name LIKE '%Live%' AND (Campaign_Name LIKE '%WLS%' OR Campaign_Name LIKE '%Wireless%') AND Campaign_Name NOT LIKE '%Prospect%' THEN 754 --Wireless Pre Move T1 DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%PreMover%T1%' AND eCRW_Project_Name LIKE '%Live%' AND Campaign_Name NOT LIKE '%Prospect%' THEN 746 --Livebase Pre Move Non TV T1 DM

WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%PreMover%T1%' AND Campaign_Name LIKE '%Prospect%' THEN 756 --Prospect Pre Move T1 DM

WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%PreMover%T2%' AND eCRW_Project_Name LIKE '%Live%' AND Campaign_Name LIKE '%Promo%' AND Campaign_Name NOT LIKE '%Prospect%' THEN 751 --Livebase Pre Move UV Promo T2 DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%Premover%T2%' AND eCRW_Project_Name LIKE '%Live%' AND Campaign_Name LIKE '%Rack Rate%' AND Campaign_Name NOT LIKE '%Prospect%' THEN 752 --Livebase Pre Move UV Rack Rate T2 DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%PreMover%T2%' AND eCRW_Project_Name LIKE '%Live%' AND (Campaign_Name LIKE '%WLS%' OR Campaign_Name LIKE '%Wireless%') AND Campaign_Name NOT LIKE '%Prospect%' THEN 755 --Wireless Pre Move T2 DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%PreMover%T2%' AND eCRW_Project_Name LIKE '%Live%' AND Campaign_Name NOT LIKE '%Prospect%' THEN 750 --Livebase Pre Move Non TV T2 DM

WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%PreMover%T2%' AND Campaign_Name LIKE '%Prospect%' THEN 757 --Prospect Pre Move T1 DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%PropensityToMove%' THEN 17 --PTM

 
ELSE 0 END AS idProgram_Touch_Definitions,

'' AS idFlight_Plan_Records

INTO #ParentID_ID_Link

FROM UVAQ.bvt_processed.Movers_DM_ActiveCampaigns


	
SELECT a.[ParentID], a.idProgram_Touch_Definitions, c.idFlight_Plan_Records
INTO #ParentID_ID_Link2

FROM #ParentID_ID_Link a
JOIN UVAQ.bvt_processed.Movers_DM_ActiveCampaigns b ON a.parentID = b.ParentID
LEFT JOIN (SELECT Distinct 
       [idFlight_Plan_Records]
      ,idProgram_Touch_Definitions_TBL_FK 
      ,[InHome_Date]
		FROM UVAQ.bvt_prod.XSell_Best_View_Forecast_VW
		where KPI_Type = 'Volume'
		AND idProgram_Touch_Definitions_TBL_FK in (759,746,750,747,751,748,752,761,756,757,537,17,754,758)) c
ON (a.idprogram_Touch_Definitions = c.idProgram_Touch_Definitions_TBL_FK  AND
(c.InHome_Date BETWEEN Dateadd(D, -5,b.[Start_Date]) AND  Dateadd(D, 5, b.[Start_Date])))
ORDER BY a.idProgram_Touch_Definitions



--for QC purposes adds information about touch type and campaign instead of only having ID numbers and puts it into the different category tables.

--Clean = flight plan has exact in home date match.

INSERT INTO bvt_staging.Movers_pID_FlightPlan_Clean
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Start_Date,
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.Movers_DM_ActiveCampaigns b ON a.parentID = b.ParentID
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
		FROM UVAQ.bvt_prod.XSell_Best_View_Forecast_VW
		where KPI_Type = 'Volume'
		AND idProgram_Touch_Definitions_TBL_FK in (759,746,750,747,751,748,752,761,756,757,537,17,754,758)) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where b.Start_Date = d.InHome_Date
AND a.ParentID not in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate =Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


--Flight plan has record within +/- 5 days of eCRW in home date but does not match exactly.
INSERT INTO bvt_staging.Movers_pID_FlightPlan_Other
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name,  b.Start_Date,
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.Movers_DM_ActiveCampaigns b ON a.parentID = b.ParentID
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
		FROM UVAQ.bvt_prod.XSell_Best_View_Forecast_VW
		where KPI_Type = 'Volume'
		AND idProgram_Touch_Definitions_TBL_FK in (759,746,750,747,751,748,752,761,756,757,537,17,754,758)) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where b.Start_Date <> d.InHome_Date and d.InHome_Date is not null
AND a.ParentID not in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate = Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


--eCRW information does not have matching flight plan within +/- 5 days.

INSERT INTO bvt_staging.Movers_pID_FlightPlan_NoMatch
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Start_Date,
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], Coalesce(d.Touch_Name, e.Touch_Name) as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], Coalesce(d.Media, e.Media) as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.Movers_DM_ActiveCampaigns b ON a.parentID = b.ParentID
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
		FROM UVAQ.bvt_prod.XSell_Best_View_Forecast_VW
		where KPI_Type = 'Volume'
		AND idProgram_Touch_Definitions_TBL_FK in (759,746,750,747,751,748,752,761,756,757,537,17,754,758)) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
JOIN (select a.idProgram_Touch_Definitions_TBL, a.Touch_Name, b.Media from UVAQ.bvt_prod.Program_Touch_Definitions_TBL a
		JOIN  UVAQ.bvt_prod.Media_LU_TBL b
		ON a.idMedia_LU_TBL_FK = b.idMedia_LU_TBL) e
on a.idProgram_Touch_Definitions = e.idProgram_Touch_Definitions_TBL
Where d.InHome_Date is null
AND b.AssignDate = Convert(date, getdate())
ORDER BY Start_Date, a.idProgram_Touch_Definitions



--There are multiple matches within +/- days. Should not occur going forward often. 
INSERT INTO bvt_staging.Movers_pID_FlightPlan_Dups
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Start_Date,
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.Movers_DM_ActiveCampaigns b ON a.parentID = b.ParentID
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
		FROM UVAQ.bvt_prod.XSell_Best_View_Forecast_VW
		where KPI_Type = 'Volume'
		AND idProgram_Touch_Definitions_TBL_FK in (759,746,750,747,751,748,752,761,756,757,537,17,754,758)) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where a.ParentID in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate = Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions




END








