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
	Start_Date, a.Cell_DTV_Flag, Vendor, GETDATE() AS AssignDate, b.Scorecard_Program_Channel, a.CallStrat_ID, a.Aprimo_ID

	FROM JAVDB.IREPORT_2015.dbo.WB_01_Campaign_list_WB_2017 AS a 
	JOIN JAVDB.IREPORT_2015.dbo.WB_00_Reporting_Hierarchy_2017 AS b
      ON a.tactic_id=b.id
     WHERE b.att_program_code = 'CSBM'
	AND a.parentID  NOT IN (SELECT parentID FROM UVAQ.bvt_processed.BM_ActiveCampaigns)
	AND a.campaign_name NOT LIKE '%Commitment View%'
	AND a.campaign_name NOT LIKE '%Remaining data%'
	AND a.campaign_name NOT LIKE '%best View Objectives%'
	AND a.Media_Code <> 'Drag'


Select ParentID,
CASE 

--Bill Media -- BAM
--Still Missing: 

WHEN Media_Code = 'BAM' THEN 1493 --Wireline BAM


--Bill Media -- Bill Inserts
--Still Missing: 1436, 1439

WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Insert' AND (Campaign_Name LIKE '%EBill%' OR Campaign_Name like '%E-Bill%') AND Campaign_Name NOT LIKE '%TV%' THEN 1429 --Wireline TV Cross Sell eBill Insert
WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'Enabler Bill - Bill Insert' AND Campaign_Name LIKE '%TV%' AND (Campaign_Name LIKE '%EBill%' OR Campaign_Name LIKE '%E-Bill%') THEN 1430 --Enabler TV Cross Sell eBill Insert
WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'Wireless Bill - Bill Insert' AND eCRW_Project_Name LIKE '%TV%sell%' THEN 1431 --Wireless TV Cross Sell Bill Insert 
--WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Insert' AND eCRW_Project_Name LIKE '%TV%sell%' THEN 1432 --Wireline TV Cross Sell Bill Insert (OLD Enabler)
WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'Enabler Bill - Bill Insert' AND eCRW_Project_Name LIKE '%BI_DTV_CROSS_SELL%' THEN 1433 --Enabler TV Cross Sell Bill Insert
WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Insert' AND eCRW_Project_Name LIKE '%Bundles%' THEN 1434 --Wireline Bundles Bill Insert
--WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Insert' AND eCRW_Project_Name LIKE '%IPBBMonthly%' AND eCRW_Project_Name LIKE '%WRLN%' THEN 1435 --Wireline DSL Cross Sell Bill Insert
WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'Wireless Bill - Bill Insert' AND (eCRW_Project_Name LIKE '%IPBB%' OR eCRW_Project_Name LIKE '%Broadband%') THEN 1437 --Wireless IPBB Cross Sell Bill Insert
WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Insert' AND eCRW_Project_Name LIKE '%TV%sell%' THEN 1438 --Wireline DTV Cross Sell Bill Insert
WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'Enabler Bill - Bill Insert' AND eCRW_Project_Name LIKE '%IPBB%' THEN 1440 --Enabler IPBB Cross Sell Bill Insert
WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Insert' AND eCRW_Project_Name LIKE '%IPBBMonthly%' THEN 1531 --Wireline IPBB Cross Sell Bill Insert
WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Insert' AND eCRW_Project_Name LIKE '%Wireless%' THEN 1532 --Wireline WRLS Cross Sell Bill Insert
WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Insert' AND eCRW_Project_Name LIKE '%VOIP%' THEN 1533 --Wireline VoIP Cross Sell Bill Insert
WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'DIRECTV Bill - Bill Insert' AND eCRW_Project_Name LIKE '%IPBB%' THEN 1541 --DTV INFA HSIA Cross Sell Bill Insert
WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'DIRECTV Bill - Bill Insert' AND eCRW_Project_Name LIKE '%Wireless%' THEN 1542 --DTV OOF Wireless Bill Insert
WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'Enabler Bill - Bill Insert' AND eCRW_Project_Name LIKE '%Welcome%' THEN 1551 --Enabler Welcome Bill Insert
WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Insert' AND eCRW_Project_Name LIKE '%Mover%' THEN 1560 --Wireline Movers Bill Insert
WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'Enabler Bill - Bill Insert' AND eCRW_Project_Name LIKE '%ThankYou%' THEN 1561 --Enabler Thank you Bill Insert
WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Insert' AND eCRW_Project_Name LIKE '%Mandatory%' THEN 1572 --Wireline Mandatory Bill Insert
WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'Enabler Bill - Bill Insert' AND eCRW_Project_Name LIKE '%WLS%' THEN 1616 --Enabler WRLS Cross Sell Bill Insert
WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'Wireless Bill - Bill Insert' AND eCRW_Project_Name LIKE '%Add-a-line%' THEN 1618 --Wireless WRLS AAL Bill Insert
WHEN Media_Code = 'BI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Insert' AND eCRW_Project_Name LIKE '%Thankyou%' THEN 1619 --Wireline Thank You Bill Insert

--Bill Media -- FPC
--Still Missing: 1445, 1534

WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Wireline Bill - FPC' AND eCRW_Project_Name LIKE '%NancyFPCAllIPTVGreen%' AND Campaign_Name LIKE '%Remaining%' THEN 1441 --Wireline Non-DSL HSIA Cross Sell FPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Enabler Bill - FPC' AND eCRW_Project_Name LIKE '%DTVCrossSellUVBill%' THEN 1442 --Enabler TV Cross Sell FPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Wireline Bill - FPC' AND eCRW_Project_Name LIKE '%FPC_T21_IPDSL%' AND Campaign_Name LIKE '%TDM%' AND Campaign_Name NOT LIKE '%TDM+WLS%' THEN 1443 --Wireline TDM IPBB/DTV Cross Sell FPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Wireline Bill - FPC' AND eCRW_Project_Name LIKE '%Migration%' THEN 1444 --Wireline Migration FPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Wireline Bill - FPC' AND eCRW_Project_Name LIKE '%NancyFPCAllIPTVGreen%' AND Campaign_Name LIKE '%Has DTV%' THEN 1446 --Wireline Non-DSL TV Cross Sell FPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Wireline Bill - FPC' AND eCRW_Project_Name LIKE '%NancyFPCDSLCust%' AND Campaign_Name LIKE '%Has DTV%' THEN 1447 --Wireline DSL HSIA Cross Sell FPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Wireline Bill - FPC' AND eCRW_Project_Name LIKE '%NancyFPCDSLCust%' AND Campaign_Name LIKE '%All Remaining%' THEN 1448 --Wireline DSL TV Cross Sell FPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Wireline Bill - FPC' AND eCRW_Project_Name LIKE '%FPC_T21_DSL%' THEN 1449 --Wireline DSL Cross Sell FPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Wireline Bill - FPC' AND eCRW_Project_Name LIKE '%FPC_T21_IPDSL%' THEN 1450 --Wireline TDM IPBB Cross Sell FPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Wireline Bill - FPC' AND eCRW_Project_Name LIKE '%FPC_T21_IPDSL%' AND Campaign_Name LIKE '%TDM+DTV%' AND Campaign_Name NOT LIKE '%TDM+DTV+WLS%' THEN 1451 --Wireline TDM/DTV IPBB Cross Sell FPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Wireline Bill - FPC' AND eCRW_Project_Name LIKE '%FPC_T21_IPDSL%' AND Campaign_Name LIKE '%TDM+DTV+WLS%' THEN 1452 --Wireline TDM/DTV/WRLS IPBB Cross Sell FPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Wireline Bill - FPC' AND eCRW_Project_Name LIKE '%FPC_T21_Bundles%' THEN 1453 --Wireline Bundles FPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Enabler Bill - FPC' AND eCRW_Project_Name LIKE '%Welcome%Uverse%' AND Campaign_Name LIKE '%Welcome%' THEN 1454 --Enabler Welcome FPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Enabler Bill - FPC' AND eCRW_Project_Name LIKE '%VOI%' THEN 1455 --Enabler VoIP Cross Sell FPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Wireline Bill - FPC' AND eCRW_Project_Name LIKE '%FPC_T21_CLM_WLN_Welcome%' THEN 1456 --Wireline Welcome FPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Enabler Bill - FPC' AND eCRW_Project_Name LIKE '%Welcome%Uverse%' AND Campaign_Name LIKE '%Upgrade%' THEN 1457 --Enabler IPDSL Upgrade FPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Wireline Bill - FPC' AND eCRW_Project_Name LIKE '%DTV%' THEN 1458 --Wireline DTV Cross Sell FPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Enabler Bill - FPC' AND eCRW_Project_Name LIKE '%IPBB%Sell%' THEN 1459 --Enabler HSIA Cross Sell FPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Enabler Bill - FPC' AND eCRW_Project_Name LIKE '%Gigapower%' THEN 1460 --Enabler Gigapower Cross Sell FPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Wireline Bill - FPC' AND eCRW_Project_Name LIKE '%IPBB%' THEN 1535 --Wireline IPBB Cross Sell FPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'DIRECTV Bill - FPC' AND eCRW_Project_Name LIKE '%Wireless%' THEN 1553 --DIRECTV WRLS Cross Sell TPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Wireline Bill - FPC' AND eCRW_Project_Name LIKE '%Wireless%' THEN 1562 --Wireline WRLS Cross Sell FPC
WHEN Media_Code = 'FPC' AND Scorecard_Program_Channel = 'Enabler Bill - FPC' AND eCRW_Project_Name LIKE '%Wireless%' THEN 1563 --Enabler WRLS Cross Sell FPC

--Bill Media -- FYI
-- Still Missing: 1485

WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Message' AND eCRW_Project_Name LIKE '%Wireline%' AND eCRW_Project_Name LIKE '%TV%' AND eCRW_Project_Name LIKE '%Spanish%' THEN 1471 --Wireline TV Cross Sell Spanish Bill Message
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Wireless Bill - Bill Message' AND eCRW_Project_Name LIKE '%Wireless%' AND eCRW_Project_Name LIKE '%TV%' AND eCRW_Project_Name LIKE '%Spanish%' THEN 1472 --Wireless DTV Cross Sell Spanish Bill Message
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Wireless Bill - Bill Message' AND eCRW_Project_Name LIKE '%Wireless%' AND eCRW_Project_Name LIKE '%TV%' AND eCRW_Project_Name NOT LIKE '%Spanish%' THEN 1473 --Wireless DTV Cross Sell Bill Message
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Message' AND eCRW_Project_Name LIKE '%CSBM_BillMsg%' AND (Campaign_Name LIKE '%DTV Eligible%' OR Campaign_Name LIKE '%IPTV Eligible%') THEN 1474 --Wireline TV Cross Sell Bill Message
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Enabler Bill - Bill Message' AND eCRW_Project_Name LIKE '%U%Verse%' AND eCRW_Project_Name LIKE '%TV%' AND eCRW_Project_Name NOT LIKE '%Spanish%' THEN 1475 --Enabler DTV Cross Sell Bill Message
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Message' AND eCRW_Project_Name LIKE '%Migration%' AND Campaign_Name LIKE '%Bundles%' THEN 1476 --Wireline Bundles Bill Message
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Message' AND eCRW_Project_Name LIKE '%Migration%' AND Campaign_Name LIKE '%IPDSL%' THEN 1477 --Wireline IPBB Cross Sell Bill Message
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Message' AND eCRW_Project_Name LIKE '%Migration%' AND Campaign_Name LIKE '%DSL%' THEN 1478 --Wireline DSL Cross Sell Bill Message
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Message' AND eCRW_Project_Name LIKE '%Migration%' AND Campaign_Name LIKE '%Live Base%' THEN 1479 --Wireline Opportunity Bill Message
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Message' AND eCRW_Project_Name LIKE '%Migration%' AND Campaign_Name LIKE '%Migration%' THEN 1480 --Wireline Migration Bill Message
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Message' AND eCRW_Project_Name LIKE '%Migration%' AND Campaign_Name LIKE '%Welcome%' THEN 1481 --Wireline Welcome Bill Message 
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Enabler Bill - Bill Message' AND eCRW_Project_Name LIKE '%U%Verse%' AND eCRW_Project_Name LIKE '%TV%' AND eCRW_Project_Name LIKE '%Spanish%' THEN 1482 --Enabler DTV Cross Sell Spanish Bill Message
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Enabler Bill - Bill Message' AND eCRW_Project_Name LIKE '%U%verse%' AND eCRW_Project_Name LIKE '%Welcome%' AND eCRW_Project_Name NOT LIKE '%Giga%' THEN 1483 --Enabler Welcome Bill Message
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Message' AND eCRW_Project_Name LIKE '%UNAT_BillMsg%' AND Campaign_Name LIKE '%DTV Subs%' THEN 1484 --Wireline DTV Cross Sell Bill Message
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Enabler Bill - Bill Message' AND eCRW_Project_Name LIKE '%U%verse%' AND eCRW_Project_Name LIKE '%HSIA%' THEN 1486 --Enabler HSIA Cross Sell Bill Message
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Wireless Bill - Bill Message' AND eCRW_Project_Name LIKE '%Wireless%' AND eCRW_Project_Name LIKE '%Broadband%' THEN 1487 --Wireless IPBB Cross Sell Bill Message
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Message' AND (eCRW_Project_Name LIKE '%_ALL_%' OR eCRW_Project_Name LIKE '%Generic%') AND eCRW_Project_Name LIKE '%Spanish%' THEN 1567 --Wireline Spanish Thank you Bill Message
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Wireline Bill - Bill Message' AND (eCRW_Project_Name LIKE '%_ALL_%' OR eCRW_Project_Name LIKE '%Generic%') THEN 1557 --Wireline Thank you Bill Message
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Wireless Bill - Bill Message' AND (eCRW_Project_Name LIKE '%_ALL_%' OR eCRW_Project_Name LIKE '%Generic%') AND eCRW_Project_Name LIKE '%Spanish%' THEN 1568 --Wireless Spanish Thank you Bill Message
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Wireless Bill - Bill Message' AND (eCRW_Project_Name LIKE '%_ALL_%' OR eCRW_Project_Name LIKE '%Generic%') THEN 1559 --Wireless Thank you Bill Message
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Enabler Bill - Bill Message' AND (eCRW_Project_Name LIKE '%_ALL_%' OR eCRW_Project_Name LIKE '%Generic%') AND eCRW_Project_Name LIKE '%Spanish%' THEN 1569 --Enabler Spanish Thank you Bill Message
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Enabler Bill - Bill Message' AND (eCRW_Project_Name LIKE '%_ALL_%' OR eCRW_Project_Name LIKE '%Generic%') THEN 1558 --Enabler Thank you Bill Message
WHEN Media_Code = 'FYI' AND Scorecard_Program_Channel = 'Wireless Bill - Bill Message' AND eCRW_Project_Name LIKE '%Add-a-line%' THEN 1625 --Wireless WRLS AAL Bill Message

-- Bill Media -- OE
-- Still Missing:

WHEN Media_Code = 'OE' AND Scorecard_Program_Channel = 'Enabler Bill - OE/RE' AND eCRW_Project_Name LIKE '%Bundles%' THEN 1489 --Enabler TV Cross Sell OE
WHEN Media_Code = 'OE' AND Scorecard_Program_Channel = 'Wireline Bill - OE/RE' AND eCRW_Project_Name LIKE '%Bundles%' THEN 1488 --Wireline OE
WHEN Media_Code = 'OE' AND Scorecard_Program_Channel = 'Wireless Bill - OE/RE' AND eCRW_Project_Name LIKE '%TV%' THEN 1626 --Wireless TV Cross Sell OE
WHEN Media_Code = 'OE' AND Scorecard_Program_Channel = 'DIRECTV Bill - OE/RE' AND eCRW_Project_Name LIKE '%Wireless%' THEN 1684 --DIRECTV WLS Cross Sell OE
WHEN Media_Code = 'OE' AND Scorecard_Program_Channel = 'Enabler Bill - OE/RE' AND eCRW_Project_Name LIKE '%IPBB%' THEN 1685 --Enabler IPBB Cross Sell OE



--Bill Media -- Onsert
-- Still Missing: 1467, 1537, 1538

WHEN Media_Code = 'Onsert' AND Scorecard_Program_Channel = 'Wireless Bill - Bill Onsert' AND eCRW_Project_Name LIKE '%Wireless%' AND eCRW_Project_Name LIKE '%TV%' AND eCRW_Project_Name LIKE '%Spanish%' THEN 1461 --Wireless DTV Cross Sell Onsert
WHEN Media_Code = 'Onsert' AND Scorecard_Program_Channel = 'Enabler Bill - Bill Onsert' AND eCRW_Project_Name LIKE '%U%verse%' AND eCRW_Project_Name LIKE '%TV%' THEN 1462 --Enabler DTV Cross Sell Onsert
WHEN Media_Code = 'Onsert' AND Scorecard_Program_Channel = 'Wireless Bill - Bill Onsert' AND (Campaign_Name LIKE '%TV%') THEN 1463 --Wireless TV Cross Sell Bill Onsert
WHEN Media_Code = 'Onsert' AND Scorecard_Program_Channel = 'Enabler Bill - Bill Onsert' AND eCRW_Project_Name LIKE '%U%verse%' AND eCRW_Project_Name LIKE '%Upgrade%' THEN 1464 --Enabler Internet Update Onsert
WHEN Media_Code = 'Onsert' AND Scorecard_Program_Channel = 'Enabler Bill - Bill Onsert' AND eCRW_Project_Name LIKE '%U%verse%' AND eCRW_Project_Name LIKE '%Voice%' THEN 1465 -- Enabler Voice Onsert
WHEN Media_Code = 'Onsert' AND Scorecard_Program_Channel = 'Enabler Bill - Bill Onsert' AND eCRW_Project_Name LIKE '%U%verse%' AND eCRW_Project_Name LIKE '%Welcome%' And eCRW_Project_Name NOT LIKE '%GIGA%' THEN 1466 --Enabler Welcome Onsert
WHEN Media_Code = 'Onsert' AND Scorecard_Program_Channel = 'Enabler Bill - Bill Onsert' AND eCRW_Project_Name LIKE '%U%Verse%' AND eCRW_Project_Name LIKE '%Giga%' THEN 1468 --Enabler Gigapower Welcome Onsert
WHEN Media_Code = 'Onsert' AND Scorecard_Program_Channel = 'Enabler Bill - Bill Onsert' AND eCRW_Project_Name LIKE '%U%verse%' AND eCRW_Project_Name LIKE '%HSIA%' THEN 1469 --Enabler HSIA Cross Sell Onsert
--WHEN Media_Code = 'Onsert' AND Scorecard_Program_Channel = 'DIRECTV Bill - Bill Onsert' AND eCRW_Project_Name LIKE '%HSIA Cross%' AND eCRW_Project_Name LIKE '%D%TV%' THEN 1470 --DTV HSIA Cross Sell Bill Onsert
WHEN Media_Code = 'Onsert' AND Scorecard_Program_Channel = 'DIRECTV Bill - Bill Onsert' AND eCRW_Project_Name LIKE '%HSIA%' AND eCRW_Project_Name LIKE '%Spanish%' THEN 1538 -- DIRECTV INF IPBB Cross Sell Spanish
WHEN Media_Code = 'Onsert' AND Scorecard_Program_Channel = 'DIRECTV Bill - Bill Onsert' AND eCRW_Project_Name LIKE '%HSIA%' THEN 1537 -- DIRECTV INF IPBB Cross Sell English
WHEN Media_Code = 'Onsert' AND Scorecard_Program_Channel = 'DIRECTV Bill - Bill Onsert' AND eCRW_Project_Name LIKE '%Wireless%' AND eCRW_Project_Name LIKE '%Spanish%' THEN 1540 --DIRECTV OOF WRLS Spanish Onsert
WHEN Media_Code = 'Onsert' AND Scorecard_Program_Channel = 'DIRECTV Bill - Bill Onsert' AND eCRW_Project_Name LIKE '%Wireless%' THEN 1539 --DIRECTV OOF WRLS Onsert
WHEN Media_Code = 'Onsert' AND Scorecard_Program_Channel = 'Enabler Bill - Bill Onsert' AND eCRW_Project_Name LIKE '%Wireless%' THEN 1554 --Titan WRLS Cross Sell Onsert
WHEN Media_Code = 'Onsert' AND Scorecard_Program_Channel = 'Wireless Bill - Bill Onsert' AND eCRW_Project_Name LIKE '%HSIA%' THEN 1627 --Wireless IPBB Cross Sell Onsert

--Bill Media -- RE
--Still Missing:

WHEN Media_Code = 'Remit' AND Scorecard_Program_Channel = 'Wireline Bill - OE/RE' AND eCRW_Project_Name LIKE '%Wireline RE%' THEN 1491
WHEN Media_Code = 'Remit' AND Scorecard_Program_Channel = 'Enabler Bill - OE/RE' THEN 1571

--Bill Media -- TPC
--Still Missing: 1553

ELSE 0 END AS idProgram_Touch_Definitions,

'' AS idFlight_Plan_Records

INTO #ParentID_ID_Link

FROM UVAQ.bvt_processed.BM_ActiveCampaigns

	
SELECT a.[ParentID], a.idProgram_Touch_Definitions, c.idFlight_Plan_Records
INTO #ParentID_ID_Link2

FROM #ParentID_ID_Link a
JOIN UVAQ.bvt_processed.BM_ActiveCampaigns b ON a.parentID = b.ParentID
LEFT JOIN (SELECT Distinct 
       [idFlight_Plan_Records]
      ,idProgram_Touch_Definitions_TBL_FK 
      ,[InHome_Date]
		FROM UVAQ.bvt_prod.BM_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0) c
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
		FROM UVAQ.bvt_prod.BM_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0) d
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
		FROM UVAQ.bvt_prod.BM_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where b.Start_Date <> d.InHome_Date and d.InHome_Date is not null
AND a.ParentID not in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate = Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


--eCRW information does not have matching flight plan within +/- 5 days.

INSERT INTO bvt_staging.BM_pID_FlightPlan_NoMatch
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Cell_Description, b.Start_Date, b.Vendor,
 Scorecard_Program_Channel, CallStrat_ID ,d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], Coalesce(d.Touch_Name, e.Touch_Name) as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], Coalesce(d.Media, e.Media) as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.BM_ActiveCampaigns b ON a.parentID = b.ParentID
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
		FROM UVAQ.bvt_prod.BM_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0) d
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
		FROM UVAQ.bvt_prod.BM_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0) d
		ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where a.ParentID in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate = Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


END






GO


