USE [UVAQ_STAGING]
GO

/****** Object:  StoredProcedure [bvt_staging].[BM_ParentID_FlightRecord_Link_PR]    Script Date: 02/12/2016 09:20:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [bvt_staging].[BM_ParentID_FlightRecord_Link_PR]

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
	Start_Date, a.Cell_DTV_Flag, Vendor, GETDATE() AS AssignDate, b.Scorecard_Program_Channel, a.CallStrat_ID

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

--Bill Media -- Bill Inserts
WHEN Media_Code = 'BI' AND eCRW_Project_Name LIKE '%Bundles%' THEN 452 -- Bill Insert - Bundles
WHEN Media_Code = 'BI' AND eCRW_Project_Name LIKE '%Broadband%' AND eCRW_Project_Name NOT LIKE '%WLS%' THEN 453 -- Bill Insert - DSL
--WHEN Media_Code = 'BI' AND eCRW_Classification_Name LIKE '%Wireless%' THEN 454 -- Bill Insert - WRLS
WHEN Media_Code = 'BI' AND (eCRW_Project_Name LIKE '%DSL in WLS%' OR eCRW_Project_Name LIKE '%BroadbandinWLS%') THEN 461 --Bill Insert - DSL in WRLS
WHEN Media_Code = 'BI' AND eCRW_Project_Name LIKE '%DIRECTV%' THEN 603 -- Bill Insert - DTV
--WHEN Media_Code = 'BI' AND eCRW_Classification_Name LIKE '%IP Migration%' THEN 606 -- Bill Insert - Migration

--Bill Media -- BAM
WHEN Media_Code = 'BAM' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' THEN 809
WHEN Media_Code = 'BAM' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 810

--Bill Media -- OE/RE
--WHEN Media_Code = 'OE' THEN 628
--WHEN Media_Code = 'Remit' THEN 629

--Bill Media -- FYI
--WHEN Media_Code = 'FYI' AND eCRW_Classification_Name LIKE  '%Bundles Legacy%' THEN 465
--WHEN Media_Code = 'FYI' AND eCRW_Classification_Name LIKE  '%Broadband IPDSL%' THEN 466
--WHEN Media_Code = 'FYI' AND eCRW_Classification_Name LIKE  '%Broadband Legacy%' THEN 467
--WHEN Media_Code = 'FYI' AND eCRW_Classification_Name LIKE  '%Opportunity Legacy%' THEN 468
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Migration%' AND Campaign_Name LIKE '%Bundles%' THEN 465 -- FYI - Bundles Monthly
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Migration%' AND Campaign_Name LIKE '%Live Base%' THEN 468 -- FYI - Opportunity
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Migration%' AND Campaign_Name LIKE '%IPDSL%' THEN 466 -- FYI - Broadband IP
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Migration%' AND Campaign_Name LIKE '%DSL%' THEN 467 -- FYI - Broadband Legacy
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Migration%' AND Campaign_Name LIKE '%Migration%' THEN 470 -- FYI - Migration
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Migration%' AND Campaign_Name LIKE '%Welcome%' THEN 471 -- FYI - Welcome
--WHEN Media_Code = 'FYI' AND eCRW_Classification_Name LIKE  '%Welcome Legacy%' THEN 471
--WHEN Media_Code = 'FYI' AND eCRW_Classification_Name LIKE  '%Bundles IPDSL%' AND (eCRW_Project_Name LIKE '%UVSWelcome%' OR eCRW_Project_Name LIKE '%UvsWelcome%') THEN 627

--Bill Media -- Onsert
WHEN Media_Code = 'Onsert' AND eCRW_Project_Name LIKE '%Welcome%' THEN 610 -- Onserts - Welcome
WHEN Media_Code = 'Onsert' AND eCRW_Project_Name LIKE '%Upgrade%' THEN 607 -- Onserts - Speed Upgrade
WHEN Media_Code = 'Onsert' AND eCRW_Project_Name LIKE '%Voice%' THEN 608 -- Onserts - UVV

--Bill Media -- FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE  '%DTV%' THEN 992 --FPC - DTV

WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%FPC_T21_IPDSL%' AND Campaign_Name LIKE '%TDM%' AND Campaign_Name NOT LIKE '%TDM+WLS%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' THEN 462 -- FPC IP - DTV - TDM
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%FPC_T21_IPDSL%' AND Campaign_Name LIKE '%TDM+WLS%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%'  THEN 872 -- FPC IP - DTV - TDM+WLS
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%FPC_T21_IPDSL%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%'  THEN 462 -- FPC IP - DTV - TDM
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%FPC_T21_IPDSL%' AND Campaign_Name LIKE '%TDM+DTV%' AND Campaign_Name NOT LIKE '%TDM+DTV+WLS%' AND Cell_DTV_Flag LIKE '%NON_DTV%'  THEN 875 -- FPC IP - Non_DTV - TDM+DTV
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%FPC_T21_IPDSL%' AND Campaign_Name LIKE '%TDM+WLS%' AND Cell_DTV_Flag LIKE '%NON_DTV%'  THEN 874 -- FPC IP - Non_DTV - TDM+WLS
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%FPC_T21_IPDSL%' AND Campaign_Name LIKE '%TDM+DTV+WLS%' AND Cell_DTV_Flag LIKE '%NON_DTV%'  THEN 876 -- FPC IP - Non_DTV - TDM+WLS+DTV
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%FPC_T21_IPDSL%' THEN 873 -- FPC IP - Non_DTV - TDM

--WHEN Media_Code = 'FPC' AND eCRW_Classification_Name LIKE  '%Bundles Legacy%' AND eCRW_Project_Name LIKE '%FPC_T21_Bundles%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_FLAG NOT LIKE '%NON_DTV%' THEN 622
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%FPC_T21_Bundles%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 877 --FPC - Bundles Monthly - Non-DTV

--WHEN Media_Code = 'FPC' AND eCRW_Classification_Name LIKE  '%Bundles Legacy%' AND eCRW_Project_Name LIKE '%FPC_T21_CLM_WLN_Welcome%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' THEN 626
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%FPC_T21_CLM_WLN_Welcome%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 899 --FPC - Wireline Welcome - Non-DTV

--WHEN Media_Code = 'FPC' AND eCRW_Classification_Name LIKE  '%Upgrade IPDSL%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' THEN 935
--WHEN Media_Code = 'FPC' AND eCRW_Classification_Name LIKE  '%Upgrade IPDSL%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 936

--WHEN Media_Code = 'FPC' AND eCRW_Classification_Name LIKE  '%Welcome IPDSL%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' THEN 624
--WHEN Media_Code = 'FPC' AND eCRW_Classification_Name LIKE  '%Welcome IPDSL%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 897

--WHEN Media_Code = 'FPC' AND eCRW_Classification_Name LIKE  '%DSL%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' THEN 463
--WHEN Media_Code = 'FPC' AND eCRW_Classification_Name LIKE  '%DSL%' AND Campaign_Name LIKE '%DTV%' THEN 871
--WHEN Media_Code = 'FPC' AND eCRW_Classification_Name LIKE  '%DSL%' THEN 463

--WHEN Media_Code = 'FPC' AND eCRW_Classification_Name LIKE  '%UVV%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' THEN 625
--WHEN Media_Code = 'FPC' AND eCRW_Classification_Name LIKE  '%UVV%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 898

WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%Migration%' THEN 464 -- FPC - Migration
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%Gigapower%' THEN 1266 -- Gigapower FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%HSIA%Sell%' THEN 1248 --HSIA Cross Sell FPC


--Bill Media -- Bill Inserts
WHEN Media_Code = 'BI' AND(Campaign_Name LIKE '%WLS%' OR Campaign_Name LIKE '%Wireless%') AND Campaign_Name NOT LIKE '%E-Bill%' AND Campaign_Name NOT LIKE '%EBill%' AND Campaign_Name NOT LIKE '%TV%' THEN 187
WHEN Media_Code = 'BI' AND eCRW_Project_Name LIKE '%UNAT_UVBillIns2015%' THEN 188 --Wireline Bill Insert
WHEN Media_Code = 'BI' AND (Campaign_Name LIKE '%EBill%' OR Campaign_Name like '%E-Bill%') AND Campaign_Name NOT LIKE '%TV%' THEN 185
WHEN Media_Code = 'BI' AND eCRW_Project_Name LIKE '%BI_DTV_CROSS_SELL%' THEN 189 --TV Cross Sell Bill Insert
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%TV%' AND (Campaign_Name LIKE '%EBill%' OR Campaign_Name LIKE '%E-Bill%') THEN 186 


WHEN Media_Code = 'FYI' AND Campaign_Name LIKE '%ONSERT%' AND Campaign_Name  LIKE '%SP%'  THEN 177
WHEN Media_Code = 'FYI' AND Campaign_Name LIKE '%ONSERT%' AND Campaign_Name  LIKE '%TV%'  THEN 178
WHEN Media_Code = 'FYI' AND Campaign_Name LIKE '%ONSERT%' AND (Campaign_Name  LIKE '%wireless%' OR Campaign_Name  LIKE '%WRLS%')  THEN 179
WHEN Media_Code = 'FYI' AND Campaign_Name LIKE '%ONSERT%' AND eCRW_Project_Name LIKE '%HSIA%Sell%' THEN 1279 --HSIA Cross Sell Bill Onsert
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%UNAT_BillMsg%' AND (Campaign_Name LIKE '%DTV Eligible%' OR Campaign_Name LIKE '%IPTV Eligible%') THEN 181
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%UNAT_BillMsg%' AND Campaign_Name LIKE '%DTV Subs%' THEN 691
WHEN Media_Code = 'FYI' AND Campaign_Name NOT LIKE '%WIRELESS%' AND (Campaign_Name LIKE '%HISPANIC%' OR Campaign_Name LIKE '%SPANISH%' OR Campaign_Name LIKE '%SP%') AND Campaign_Name NOT LIKE '%TV%Upsell%' THEN 174
WHEN Media_Code = 'FYI' AND Campaign_Name LIKE '%WIRELESS%' AND (Campaign_Name LIKE '%HISPANIC%' OR Campaign_Name LIKE '%SPANISH%' OR Campaign_Name LIKE '%SP%') AND Campaign_Name NOT LIKE '%TV%Upsell%' THEN 175
WHEN Media_Code = 'FYI' AND (Campaign_Name LIKE '%HISPANIC%' OR Campaign_Name LIKE '%SPANISH%' OR Campaign_Name LIKE '%SP%') AND Campaign_Name LIKE '%TV%Upsell%' THEN 508
WHEN Media_Code = 'FYI' AND Campaign_Name LIKE '%WIRELESS%' THEN 180
WHEN Media_Code = 'FYI' AND Campaign_Name LIKE '%TV Upsell%' THEN 184
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%HSIA%Sell%' THEN 1278 --HSIA Cross Sell Bill Message

WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%NancyFPCAllIPTVGreen%' AND Campaign_Name LIKE '%Has DTV%' THEN 689 --DTV FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%NancyFPCAllIPTVGreen%' AND Campaign_Name LIKE '%Remaining%' THEN 182 --Wireline FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%NancyFPCDSLCust%' AND Campaign_Name LIKE '%All Remaining%' THEN 801 --Wireline Migrator BBMig FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%NancyFPCDSLCust%' AND Campaign_Name LIKE '%Has DTV%' THEN 799 --Wireline Migrator DTV FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%DTVCrossSellUVBill%' THEN 183 --TV Cross Sell FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%HSIA%Sell%' THEN 1248 --HSIA Cross Sell FPC

WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Uverse OE%' THEN 1026 --TV Cross Sell OE
WHEN Media_Code = 'OE' AND eCRW_Project_Name LIKE '%Wireline OE%' THEN 1307 --OE - Wireline OE Message
WHEN Media_Code = 'Onsert' AND eCRW_Project_Name LIKE '%HSIA Cross%' AND eCRW_Project_Name LIKE '%D%TV%' THEN 1367 --HSIA Cross Sell Bill Onsert DTV Bill





ELSE 0 END AS idProgram_Touch_Definitions,

'' AS idFlight_Plan_Records

INTO #ParentID_ID_Link

FROM UVAQ.bvt_processed.BM_ActiveCampaigns

	
SELECT a.[ParentID], a.idProgram_Touch_Definitions, c.idFlight_Plan_Records
INTO #ParentID_ID_Link2

FROM #ParentID_ID_Link a
JOIN UVAQ.bvt_processed.BM_ActiveCampaigns b ON a.parentID = b.ParentID
LEFT JOIN ((SELECT Distinct 
       [idFlight_Plan_Records]
      ,idProgram_Touch_Definitions_TBL_FK 
      ,[InHome_Date]
		FROM UVAQ.bvt_prod.UVLB_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0)
		UNION (SELECT Distinct 
       [idFlight_Plan_Records]
      ,idProgram_Touch_Definitions_TBL_FK 
      ,[InHome_Date]
		FROM UVAQ.bvt_prod.VALB_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0)	) c
ON (a.idprogram_Touch_Definitions = c.idProgram_Touch_Definitions_TBL_FK  AND
(c.InHome_Date BETWEEN Dateadd(D, -5,b.[Start_Date]) AND  Dateadd(D, 5, b.[Start_Date])))
ORDER BY a.idProgram_Touch_Definitions




--for QC purposes adds information about touch type and campaign instead of only having ID numbers and puts it into the different category tables.

--Clean = flight plan has exact in home date match.

INSERT INTO bvt_staging.BM_pID_FlightPlan_Clean
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Cell_Description, b.Start_Date, b.Vendor,
 Scorecard_Program_Channel, CallStrat_ID ,d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.BM_ActiveCampaigns b ON a.parentID = b.ParentID
LEFT JOIN ((SELECT DISTINCT 
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
		where KPI_Type = 'Volume' And Forecast <> 0
		AND Media in ('BAM','BI','FYI','FPC','RE','OE','Onsert'))
		UNION (SELECT DISTINCT 
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
		FROM UVAQ.bvt_prod.VALB_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0
		AND Media in ('BAM','BI','FYI','FPC','RE','OE','Onsert')) ) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where b.Start_Date = d.InHome_Date
AND a.ParentID not in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate =Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


--Flight plan has record within +/- 5 days of eCRW in home date but does not match exactly.
INSERT INTO bvt_staging.BM_pID_FlightPlan_Other
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Cell_Description, b.Start_Date, b.Vendor,
 Scorecard_Program_Channel, CallStrat_ID ,d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.BM_ActiveCampaigns b ON a.parentID = b.ParentID
LEFT JOIN ((SELECT DISTINCT 
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
		where KPI_Type = 'Volume' And Forecast <> 0
		AND Media in ('BAM','BI','FYI','FPC','RE','OE','Onsert'))
		UNION (SELECT DISTINCT 
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
		FROM UVAQ.bvt_prod.VALB_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0
		AND Media in ('BAM','BI','FYI','FPC','RE','OE','Onsert')) ) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where b.Start_Date <> d.InHome_Date and d.InHome_Date is not null
AND a.ParentID not in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate = Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


--eCRW information does not have matching flight plan within +/- 5 days.

INSERT INTO bvt_staging.BM_pID_FlightPlan_NoMatch
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Cell_Description, b.Start_Date, b.Vendor,
 Scorecard_Program_Channel, CallStrat_ID ,d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.BM_ActiveCampaigns b ON a.parentID = b.ParentID
LEFT JOIN ((SELECT DISTINCT 
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
		where KPI_Type = 'Volume' And Forecast <> 0
		AND Media in ('BAM','BI','FYI','FPC','RE','OE','Onsert'))
		UNION (SELECT DISTINCT 
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
		FROM UVAQ.bvt_prod.VALB_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0
		AND Media in ('BAM','BI','FYI','FPC','RE','OE','Onsert')) ) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
JOIN (select a.idProgram_Touch_Definitions_TBL, a.Touch_Name, b.Media from UVAQ.bvt_prod.Program_Touch_Definitions_TBL a
		JOIN  UVAQ.bvt_prod.Media_LU_TBL b
		ON a.idMedia_LU_TBL_FK = b.idMedia_LU_TBL) e
on a.idProgram_Touch_Definitions = e.idProgram_Touch_Definitions_TBL
Where d.InHome_Date is null
AND b.AssignDate = Convert(date, getdate())
ORDER BY Start_Date, a.idProgram_Touch_Definitions



--There are multiple matches within +/- days. Should not occur going forward often. 
INSERT INTO bvt_staging.BM_pID_FlightPlan_Dups
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Cell_Description, b.Start_Date, b.Vendor,
 Scorecard_Program_Channel, CallStrat_ID ,d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.BM_ActiveCampaigns b ON a.parentID = b.ParentID
LEFT JOIN ((SELECT DISTINCT 
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
		where KPI_Type = 'Volume' And Forecast <> 0
		AND Media in ('BAM','BI','FYI','FPC','RE','OE','Onsert'))
		UNION (SELECT DISTINCT 
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
		FROM UVAQ.bvt_prod.VALB_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0
		AND Media in ('BAM','BI','FYI','FPC','RE','OE','Onsert')) ) d
		ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where a.ParentID in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate = Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


END






GO


