USE [UVAQ_STAGING]
GO

/****** Object:  StoredProcedure [bvt_staging].[Movers_ParentID_FlightRecord_Link_PR]    Script Date: 03/24/2016 17:44:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER PROC [bvt_staging].[Movers_ParentID_FlightRecord_Link_PR]

AS
BEGIN
	SET NOCOUNT ON;



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
from UVAQ.bvt_processed.Movers_ActiveCampaigns




INSERT INTO UVAQ.bvt_processed.Movers_ActiveCampaigns
SELECT distinct [eCRW_Project_Name], [Project_Id], a.[ParentID], [Campaign_Name], [Media_Code], [Start_Date], [In_Home_Date], CONVERT(date,GETDATE())

      FROM javdb.IREPORT_2015.dbo.WB_01_Campaign_List_WB a
      LEFT JOIN #MoversParentIDs b
      on a.parentID = b.parentID
      where  
      program='Movers' 
	  AND [End_Date_Traditional] > '2014-12-28'
      AND Campaign_Name NOT LIKE '%best view objectives%'
      AND Campaign_Name NOT LIKE '%commitment view objectives%'
      AND eCRW_Project_Name NOT LIKE '%YP%'
      AND Campaign_Name NOT LIKE '%remaining data%'
	  AND b.parentID IS NULL








Select ParentID,
CASE 

--MoveATT
WHEN Media_Code = 'MoveATT' THEN 33 --MoveATT

--Shared Mail
WHEN Media_Code = 'Shared Mail' THEN 491 --U-verse Welcome Home Post Move Shared Mail

--USPS
WHEN Media_Code = 'USPS' AND eCRW_Project_Name LIKE '%Movers Guide Shared Market%' THEN 762 --Livebase DTV Pre Move Movers Guide
WHEN Media_Code = 'USPS' AND eCRW_Project_Name LIKE '%Movers Guide ATT Market%' THEN 763 --Livebase UVTV Pre Move Movers Guide
WHEN Media_Code = 'USPS' AND eCRW_Project_Name LIKE '%Mover Advantage Shared Market%' THEN 764 --Livebase DTV Pre Move Movers Guide Online
WHEN Media_Code = 'USPS' AND eCRW_Project_Name LIKE '%Mover Advantage ATT Market%' THEN 765 --Livebase UVTV Pre Move Movers Guide Online
WHEN Media_Code = 'USPS' AND eCRW_Project_Name LIKE '%MVL Shared Market%' AND In_Home_Date <= '3/31/16' THEN 766 --Livebase DTV Pre Move Mover Validation Letter DTV CC
WHEN Media_Code = 'USPS' AND eCRW_Project_Name LIKE '%MVL Shared Market%' AND In_Home_Date >= '4/1/16' THEN 989 --Livebase DTV Pre Move Mover Validation Letter
WHEN Media_Code = 'USPS' AND eCRW_Project_Name LIKE '%Welcome Kit Shared Market%' THEN 768 --Livebase DTV Post Move Welcome Kit
WHEN Media_Code = 'USPS' AND eCRW_Project_Name LIKE '%Welcome Kit ATT Market%' THEN 769 --Livebase UVTV Post Move Welcome Kit
WHEN Media_Code = 'USPS' AND eCRW_Project_Name LIKE '%CNL ATT Market%' THEN 771 --Livebase UVTV Post Move Customer Notification Letter
WHEN Media_Code = 'USPS' AND eCRW_Project_Name LIKE '%CNL Shared Market%' THEN 770 --Livebase DTV Post Move Customer Notification Letter

--SpotTV
WHEN Media_Code = 'NAI' THEN 36 --U-Verse Live Base Pre Move Spot TV

--FPC
WHEN Media_Code = 'FPC' THEN 772 --Livebase Pre Move FPC

--DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%WirelessCOA%' THEN 537 --U-verse Wireless Only Triggers Post Move DM

WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%HomesForSaleLiveTouch1%' OR eCRW_Project_Name LIKE '%FirstTimeBuyerT1%' OR eCRW_Project_Name LIKE '%EpsilonPropensityToMove%'
	OR eCRW_Project_Name LIKE '%MoversHomeSold%' OR eCRW_Project_Name LIKE '%RecLiveRenterTouch1%' OR (eCRW_Project_Name LIKE '%RecLiveRenter%' AND eCRW_Project_Name NOT LIKE '%RecLiveRenterTouch2%'))
	AND Campaign_Name LIKE '% Live %' AND (Campaign_Name LIKE '%Non TV%' OR Campaign_Name LIKE '%IPDSL%' OR Campaign_Name LIKE '%Remainder%') THEN 746 --Livebase Pre Move Non TV T1 DM

WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%HomesForSaleLiveTouch1%' OR eCRW_Project_Name LIKE '%FirstTimeBuyerT1%' OR eCRW_Project_Name LIKE '%EpsilonPropensityToMove%'
	OR eCRW_Project_Name LIKE '%MoversHomeSold%' OR (eCRW_Project_Name LIKE '%RecLiveRenter%' AND eCRW_Project_Name NOT LIKE '%RecLiveRenterTouch2%')) AND Campaign_Name LIKE '% Live %' AND 
	Campaign_Name LIKE '%Promo%' THEN 747 --Livebase Pre Move UV Promo T1 DM

WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%HomesForSaleLiveTouch1%' OR eCRW_Project_Name LIKE '%FirstTimeBuyerT1%' OR eCRW_Project_Name LIKE '%EpsilonPropensityToMove%'
	OR eCRW_Project_Name LIKE '%MoversHomeSold%' OR (eCRW_Project_Name LIKE '%RecLiveRenter%' AND eCRW_Project_Name NOT LIKE '%RecLiveRenterTouch2%')) AND Campaign_Name LIKE '% Live %' AND 
	Campaign_Name LIKE '%Rack Rate%' THEN 748 --Livebase Pre Move UV Rack Rate T1 DM

WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%FirstTimeBuyerT2Live%' OR eCRW_Project_Name LIKE '%HomesForSaleTouch2%' OR eCRW_Project_Name LIKE '%RecLiveRenterTouch2%')
	AND Campaign_Name LIKE '% Live %' AND (Campaign_Name LIKE '%Non TV%' OR Campaign_Name LIKE '%IPDSL%' OR Campaign_Name LIKE '%Remainder%') THEN 750 --Livebase Pre Move Non TV T2 DM

WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%FirstTimeBuyerT2Live%' OR eCRW_Project_Name LIKE '%HomesForSaleTouch2%' OR eCRW_Project_Name LIKE '%RecLiveRenterTouch2%')
	AND Campaign_Name LIKE '% Live %' AND Campaign_Name LIKE '%Promo%' THEN 751 --Livebase Pre Move UV Promo T2 DM

WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%FirstTimeBuyerT2Live%' OR eCRW_Project_Name LIKE '%HomesForSaleTouch2%' OR eCRW_Project_Name LIKE '%RecLiveRenterTouch2%')
	AND Campaign_Name LIKE '% Live %' AND Campaign_Name LIKE '%Rack Rate%' THEN 752 --Livebase Pre Move UV Rack Rate T2 DM

WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%HomesForSaleLiveTouch1%' OR eCRW_Project_Name LIKE '%FirstTimeBuyerT1%' OR eCRW_Project_Name LIKE '%EpsilonPropensityToMove%'
	OR eCRW_Project_Name LIKE '%MoversHomeSold%' OR (eCRW_Project_Name LIKE '%RecLiveRenter%' AND eCRW_Project_Name NOT LIKE '%RecLiveRenterTouch2%')) AND Campaign_Name LIKE '% Live %' AND 
	Campaign_Name LIKE '%Wireless Only%' THEN 754 --Wireless Pre Move T1 DM

WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%FirstTimeBuyerT2Live%' OR eCRW_Project_Name LIKE '%HomesForSaleTouch2%' OR eCRW_Project_Name LIKE '%RecLiveRenterTouch2%')
	AND Campaign_Name LIKE '% Live %' AND Campaign_Name LIKE '%Wireless Only%' THEN 755 --Wireless Pre Move T2 DM

WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%ProspectPropensityToMove%' OR eCRW_Project_Name LIKE '%RentersProspect%' OR eCRW_Project_Name LIKE '%FirstTimeBuyer%'
	OR eCRW_Project_Name LIKE '%HFSProspectWeekly%' OR eCRW_Project_Name LIKE '%ProspectMoversHomeSold%' OR eCRW_Project_Name LIKE '%ProspectMoversHomeSold%') AND Campaign_Name LIKE '% Prospect %' THEN 756 --Prospect Pre Move T1 DM

WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%PostMovers%' AND Campaign_Name LIKE '%Wireless%' THEN 758 --Wireless Post Move DM

WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%PostMovers%' AND Campaign_Name LIKE '%Live%' THEN 759 --Livebase Post Move DM

WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%PostMovers%' AND Campaign_Name LIKE '%Prospect%' THEN 761 --Prospect Post Move DM
 
ELSE 0 END AS idProgram_Touch_Definitions,

'' AS idFlight_Plan_Records

INTO #ParentID_ID_Link

FROM UVAQ.bvt_processed.Movers_ActiveCampaigns

	
SELECT a.[ParentID], a.idProgram_Touch_Definitions, c.idFlight_Plan_Records
INTO #ParentID_ID_Link2

FROM #ParentID_ID_Link a
JOIN UVAQ.bvt_processed.Movers_ActiveCampaigns b ON a.parentID = b.ParentID
LEFT JOIN (SELECT Distinct 
       [idFlight_Plan_Records]
      ,idProgram_Touch_Definitions_TBL_FK 
      ,[InHome_Date]
		FROM UVAQ.bvt_prod.Movers_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume') c
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
JOIN UVAQ.bvt_processed.Movers_ActiveCampaigns b ON a.parentID = b.ParentID
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
		FROM UVAQ.bvt_prod.Movers_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume') d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where b.In_Home_Date = d.InHome_Date
AND a.ParentID not in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate =Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


--Flight plan has record within +/- 5 days of eCRW in home date but does not match exactly.
INSERT INTO bvt_staging.Movers_pID_FlightPlan_Other
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name,  b.Start_Date,
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.Movers_ActiveCampaigns b ON a.parentID = b.ParentID
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
		FROM UVAQ.bvt_prod.Movers_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume') d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where b.In_Home_Date <> d.InHome_Date and d.InHome_Date is not null
AND a.ParentID not in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate = Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


--eCRW information does not have matching flight plan within +/- 5 days.

INSERT INTO bvt_staging.Movers_pID_FlightPlan_NoMatch
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Start_Date,
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], Coalesce(d.Touch_Name, e.Touch_Name) as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], Coalesce(d.Media, e.Media) as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.Movers_ActiveCampaigns b ON a.parentID = b.ParentID
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
		FROM UVAQ.bvt_prod.Movers_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume') d
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
JOIN UVAQ.bvt_processed.Movers_ActiveCampaigns b ON a.parentID = b.ParentID
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
		FROM UVAQ.bvt_prod.Movers_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume') d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where a.ParentID in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate = Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


END








GO


