USE [UVAQ_STAGING]
GO

/****** Object:  StoredProcedure [bvt_staging].[UCLM_ParentID_FlightRecord_Link_PR]    Script Date: 01/27/2016 15:14:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*removed gigapower to put in seperate program. KL 10/2/15
Added the tables for CLM_Revenue. Left in same query to since they cannot be easily split in eCRW. KL 3/10/16
Added GP back in since the other two programs are functioning as one. This allows the process to only be ran for all of UCLM once a week. KL 3/10/16
Moved all GP into UVLB and X-Sell Programs. Removing 2016 from Active Campsigns table KL 4/13/16
Only needs to run for Revenue now. delete all retention. 9/19/16
*/

ALTER PROC [bvt_staging].[UCLM_ParentID_FlightRecord_Link_PR]

AS
BEGIN
	SET NOCOUNT ON;


IF Object_ID('bvt_staging.UCLM_pID_FlightPlan_Clean') IS NOT NULL
TRUNCATE TABLE bvt_staging.UCLM_pID_FlightPlan_Clean

IF Object_ID('bvt_staging.UCLM_pID_FlightPlan_other') IS NOT NULL
TRUNCATE TABLE bvt_staging.UCLM_pID_FlightPlan_other

IF Object_ID('bvt_staging.UCLM_pID_FlightPlan_NoMatch') IS NOT NULL
TRUNCATE TABLE bvt_staging.UCLM_pID_FlightPlan_NoMatch

IF Object_ID('bvt_staging.UCLM_pID_FlightPlan_Dups') IS NOT NULL
TRUNCATE TABLE bvt_staging.UCLM_pID_FlightPlan_Dups


INSERT INTO UVAQ.bvt_processed.UCLM_ActiveCampaigns
SELECT DISTINCT a.ParentID, a.Campaign_Name, a.start_date AS [In_Home_Date], a.Media_Code,  a.eCRW_Project_Name, GETDATE()
	FROM JAVDB.IREPORT_2015.dbo.WB_01_Campaign_list_WB_2016 AS a 
	JOIN JAVDB.IREPORT_2015.dbo.WB_00_Reporting_Hierarchy_2016 AS b
      ON a.tactic_id=b.id
WHERE b.Scorecard_lob_Tab in ('Revenue Enhancement')--,'Retention')
	AND a.End_Date_Traditional>='28-DEC-2015'
	AND a.Media_Code <> 'DR'
	AND a.parentID  NOT IN (SELECT parentID FROM UVAQ.bvt_processed.UCLM_ActiveCampaigns)
	AND a.campaign_name NOT LIKE '%Commitment View%'
	AND a.campaign_name NOT LIKE '%best View Objectives%'


SELECT ParentID,
CASE 

--Bill Media -- Bill Inserts
/*still missing 209, 210, 567, 630, 631, 795, 796, 1280, 1309, 1316, 1317, 1412*/

WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%EPIX%' THEN 206 --EPiX BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Free%On%Demand%' THEN 207 --Free On Demand BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%HBO%' THEN 208 -- HBO BI 
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%HD%' AND Campaign_Name NOT LIKE '%Premium%' THEN 211 -- HD BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%HD%' AND Campaign_Name LIKE '%Premium%' THEN 213 --HD Premium Upgrade BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%HSIA%Upgrade%' THEN 215 --HSIA Upgrade BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Live%TV%' THEN 217 --Live TV BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%R4R%' THEN 224 --R$R BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Screen Pack%' THEN 225 -- Screen Pack BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Upgrade%' AND Campaign_Name LIKE '%U200%' THEN 227 -- IPTV Upgrade BI U200
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Upgrade%' AND Campaign_Name LIKE '%U300%' THEN 228 -- IPTV Upgrade BI U300
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Upgrade%' AND Campaign_Name LIKE '%U450%' THEN 229 -- IPTV Upgrade BI U450
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Wireless Receiver%' THEN 239 --Wireless Receiver BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Digital%Life%' THEN 547 --Digital Life BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Hallmark%' THEN 556 --Hallkmark BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%NBA%' THEN 579 --NBA League Pass BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%TV%Upgrade%' AND Campaign_Name LIKE '%3 Months%' THEN 590 -- IPTV Upgrade 3 Months Free BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%TV%Upgrade%' AND Campaign_Name LIKE '%Reward Card%' THEN 591 -- IPTV Upgrade Reward Card BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%TV%Upgrade%' THEN 586 --TV Upgrade BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%DTV%' THEN 737 --DTV Cross Sell BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Anime%' THEN 789 --Anime Network On Demand BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Verse%Game%' THEN 790 --U-Verse Games BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Karaoke%' THEN 791 --Karaoke TV App BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%ConnecTech%' THEN 792 --ConnecTech BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Disney%Story%' THEN 793 --Disney Story Central BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Verse%Movie%' THEN 794 --U-verse Movies BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Disney%' THEN 1175 --Disney Family Movies BI


--First Page Communicators
/*still missing */

WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%ConnecTech%' THEN 241 --ConnecTech FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%Football%' THEN 245 --Football FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%HBO%' THEN 250 --HBO FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%HD%' THEN 252 --HD FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%HSIA%' AND eCRW_Project_Name NOT LIKE '%Upsell%' AND eCRW_Project_Name NOT LIKE '%HSIA%Only%' THEN 331 --HSIA Upgrade FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%Tumblebooks%' THEN 352 --Tumblebooks FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%TV%Upgrade%' THEN 354 --IPTV Upgrade FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%verse%Games%' THEN 357
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%Voice%' THEN 409 -- Voice Cross Sell FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE 'Epix%' THEN 549 --EPiX FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%HSIA%Only%' AND eCRW_Project_Name LIKE '%Upgrade%' THEN 566 --HSIA Only Upgrade FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%DTV%' THEN 736 --DTV Cross Sell FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%Disney%Story%' THEN 798 -- Disney Story Central FPC

--WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%Gigapower%' THEN 247 --Gigapower FPC


--FYI
/*Still missing */

WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%ConnecTech%' THEN 240 --ConnecTech FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Epix%' THEN 243 --Epix FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%HBO%' THEN 249 --HBO Upgrade FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name NOT LIKE '% OE%' AND eCRW_Project_Name LIKE '%HSIA%Upgrade%' AND eCRW_Project_Name NOT LIKE '%Non-HSIA%' AND eCRW_Project_Name NOT LIKE '%Cross%Sell%' THEN 330 --HSIA Upgrade FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%International%' THEN 332 --International FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Karaoke%' THEN 334 --Karaoke FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%R4R%' THEN 344 --R4R FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Screen%Pack%' THEN 345 --Screen Pack FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Sport%' THEN 349 --Sports package FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Tumblebooks%' THEN 351 --Tumblebooks FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%TV%Upgrade%' THEN 353 --IPTV Upgrade FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Verse%Game%' THEN 356 --U-verse Games FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Verse%Movie%' THEN 358 --U-Verse Movies FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Hot%spot%' THEN 359 --Wifi Hotspots FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Wireless%Receiver%' THEN 360 --Wireless Receiver FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Disney Family%' THEN 548 --Disney Family Movies FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Home Wiring%' THEN 561 --Home Wiring Protection FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND (eCRW_Project_Name LIKE '%Generic Upgrade%' OR eCRW_Project_Name LIKE '%Special Offer%') THEN 1409 --Generic Upgrade/Special Offer FYI

--Outer Envelope
When Media_Code = 'OE' AND eCRW_Project_Name LIKE '%HSIA%' THEN 563 --HSIA Messaging OE

--Remit Envelope
/*still missing 1176*/

--Onserts
/*still missing 242*/

WHEN (Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' OR Media_Code = 'Onsert') AND eCRW_Project_Name LIKE '%Football%' THEN 244 --Football Onsert
WHEN (Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' OR Media_Code = 'Onsert') AND eCRW_Project_Name LIKE '%HD%' THEN 251 --HD Onsert
WHEN (Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' OR Media_Code = 'Onsert') AND eCRW_Project_Name LIKE '%Screen%Pack%' THEN 346 --Screen Pack Onsert
WHEN (Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' OR Media_Code = 'Onsert') AND eCRW_Project_Name LIKE '%ConnecTech%' THEN 546 --ConnecTech Onsert
WHEN (Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' OR Media_Code = 'Onsert') AND eCRW_Project_Name LIKE '%HBO%' THEN 559 --HBO Onsert
WHEN (Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' OR Media_Code = 'Onsert') AND eCRW_Project_Name LIKE '%HSIA%Upgrade%' AND eCRW_Project_Name NOT LIKE '%HSIA%Only%' THEN 564 --HSIA Upgrade Onsert
WHEN (Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' OR Media_Code = 'Onsert') AND eCRW_Project_Name LIKE '%Karaoke%' THEN 569 --Karaoke Onsert
WHEN (Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' OR Media_Code = 'Onsert') AND eCRW_Project_Name LIKE '%Live%TV%' THEN 570 --Live TV Onsert
WHEN (Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' OR Media_Code = 'Onsert') AND eCRW_Project_Name LIKE '%TV%Upgrade%' THEN 587 --IPTV Upgrade Onsert
WHEN (Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' OR Media_Code = 'Onsert') AND eCRW_Project_Name LIKE '%HSIA%Upgrade%' AND eCRW_Project_Name LIKE '%HSIA%Only%' THEN 596 --HSIA ONly Updrage Onsert
WHEN (Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' OR Media_Code = 'Onsert') AND eCRW_Project_Name LIKE '%Movers%' AND eCRW_Project_Name LIKE '%HSIA%Only%' THEN 694 --HSIA Only Movers Onsert
WHEN (Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' OR Media_Code = 'Onsert') AND eCRW_Project_Name LIKE '%Wiresless%Receiver%' THEN 797 --Wireless Receiver Onsery
WHEN (Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' OR Media_Code = 'Onsert') AND eCRW_Project_Name LIKE '%League%Pass%' THEN 806 --NBA League Pass Onsert


--Direct Mail
/*still missing */


WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%HBO%Upgrade%' AND (Campaign_Name LIKE '%GC%' OR Campaign_Name LIKE '%Greeting Card%') THEN 369 --HBO Greeting Card DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%HBO%Upgrage%' AND (Campaign_Name LIKE '%SP%' OR Campaign_Name LIKE '%Poster%') THEN 370 -- HBO SP DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%HBO%Upgrade%' AND (Campaign_Name LIKE '%PC%' OR Campaign_Name LIKE '%Postcard%' OR Campaign_Name LIKE '%Post Card%') THEN 371 --HBO Post Card DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%HSIA%Upgrade%' AND Campaign_Name NOT LIKE '%Non-HSIA%' AND Campaign_Name NOT LIKE '%Cross%Sell%' THEN 372 --HSIA Letter Kit DM
WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%HSIA%Upgrade%' OR eCRW_Project_Name LIKE '%HSIA_STAR%') AND (Campaign_Name LIKE '%Non-HSIA%' OR Campaign_Name LIKE '%Cross%Sell%' OR Campaign_Name LIKE '%x-sell%') THEN 376 --HSIA Upsell Letter Kit DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%TV%Upgrade%' AND (Campaign_Name LIKE '%SM%' OR Campaign_Name LIKE '%SelfMailer%' OR Campaign_Name LIKE '%Self Mailer%' OR [In_Home_Date] in('11-12-14','4-7-16')) THEN 381 --IPTV Self Mailer DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%TV%Upgrade%' AND (Campaign_Name LIKE '%PC%' OR Campaign_Name LIKE '%Postcard%' OR Campaign_Name LIKE '%Post Card%') THEN 382 --IPTV Post Card DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%Disney%' THEN 1331 --Disney Family Movies DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%ESPN%' THEN 1427 -- ESPN DM

--EMail
/*still missing 901, 1330*/

WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%HBO%' AND (Campaign_Name LIKE '%Follow%Up%' OR Campaign_Name LIKE '%FU%') THEN 390 --HBO Follow Up EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%HBO%' AND Campaign_Name LIKE '%Initial%' THEN 391 --HBO Initial EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%HBO%' THEN 389 -- HBO EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%HSIA%Upgrade%' AND Campaign_Name NOT LIKE '%Non-HSIA%' AND Campaign_Name NOT LIKE '%Cross%Sell%' THEN 394 --HSIA Upgrade/Cross Sell EM
WHEN Media_Code = 'EM' AND (eCRW_Project_Name LIKE '%HSIA%Upgrade%' OR eCRW_Project_Name LIKE '%HSIA_Star%') AND (Campaign_Name LIKE '%Non-HSIA%' OR Campaign_Name LIKE '%Cross%Sell%' OR Campaign_Name LIKE '%x-Sell%') THEN 399 --Non-HSIA EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%TV%Upgrade%' THEN 403 --IPTV Upgrade EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Weekly%' AND eCRW_Project_Name LIKE '%Movies%' THEN 404 --Movies weekly EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Hallmark%' THEN 557 --Hallmark EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%TV_Upgrade%' AND Campaign_Name  LIKE '%Initial%' THEN 588 --IPTV Upgrade Initial EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%TV_Upgrade%' AND Campaign_Name LIKE '%Follow%Up%' THEN 589 --IPTV Upgrade Follow Up EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%VOICE%' THEN 595 --Voice Cross Sell EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%NFL%' THEN 696 --NFL Sunday Ticket EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%DTV%' THEN 739 --DTV Cross Sell EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%DNC%' THEN 1318 --Democratic National Convention EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%RNC%' THEN 1319 --Republican National Convention EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Disney%' THEN 1329 --Disney Family Movies EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%ESPN%' THEN 1426 -- ESPN EM


ELSE 0 END AS idProgram_Touch_Definitions,

'' AS idFlight_Plan_Records

INTO #ParentID_ID_Link

FROM UVAQ.bvt_processed.UCLM_ActiveCampaigns

	
SELECT a.[ParentID], a.idProgram_Touch_Definitions, c.idFlight_Plan_Records
INTO #ParentID_ID_Link2

FROM #ParentID_ID_Link a
JOIN UVAQ.bvt_processed.UCLM_ActiveCampaigns b ON a.parentID = b.ParentID
LEFT JOIN (SELECT Distinct 
       [idFlight_Plan_Records]
      ,idProgram_Touch_Definitions_TBL_FK 
      ,[InHome_Date]
		FROM UVAQ.bvt_prod.CLM_Revenue_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' 
		) c
ON (a.idprogram_Touch_Definitions = c.idProgram_Touch_Definitions_TBL_FK  AND
(c.InHome_Date BETWEEN Dateadd(D, -5,b.In_Home_Date) AND  Dateadd(D, 5, b.In_Home_Date)))
ORDER BY a.idProgram_Touch_Definitions



--for QC purposes adds information about touch type and campaign instead of only having ID numbers and puts it into the different category tables.

--Clean = flight plan has exact in home date match.
INSERT INTO bvt_staging.UCLM_pID_FlightPlan_Clean
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.In_Home_Date, 
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.UCLM_ActiveCampaigns b ON a.parentID = b.ParentID
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
		FROM UVAQ.bvt_prod.CLM_Revenue_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume'
		) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where b.In_Home_Date = d.InHome_Date
AND a.ParentID not in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate =Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


--Flight plan has record within +/- 5 days of eCRW in home date but does not match exactly.
INSERT INTO bvt_staging.UCLM_pID_FlightPlan_Other
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.In_Home_Date, 
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.UCLM_ActiveCampaigns b ON a.parentID = b.ParentID
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
		FROM UVAQ.bvt_prod.CLM_Revenue_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume'
		) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where b.In_Home_Date <> d.InHome_Date and d.InHome_Date is not null
AND a.ParentID not in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate =Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


--eCRW information does not have matching flight plan within +/- 5 days.
INSERT INTO bvt_staging.UCLM_pID_FlightPlan_NoMatch
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.In_Home_Date, 
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], Coalesce(d.Touch_Name, e.Touch_Name) as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], Coalesce(d.Media, e.Media) as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.UCLM_ActiveCampaigns b ON a.parentID = b.ParentID
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
		FROM UVAQ.bvt_prod.CLM_Revenue_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume'
		) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
JOIN (select a.idProgram_Touch_Definitions_TBL, a.Touch_Name, b.Media from UVAQ.bvt_prod.Program_Touch_Definitions_TBL a
		JOIN  UVAQ.bvt_prod.Media_LU_TBL b
		ON a.idMedia_LU_TBL_FK = b.idMedia_LU_TBL) e
on a.idProgram_Touch_Definitions = e.idProgram_Touch_Definitions_TBL
Where d.InHome_Date is null
AND b.AssignDate =Convert(date, getdate())
AND a.ParentID not in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
ORDER BY a.idProgram_Touch_Definitions



--There are multiple matches within +/- days. Should not occur going forward often. 
INSERT INTO bvt_staging.UCLM_pID_FlightPlan_Dups
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.In_Home_Date, 
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.UCLM_ActiveCampaigns b ON a.parentID = b.ParentID
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
		FROM UVAQ.bvt_prod.CLM_Revenue_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume'
		) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where a.ParentID in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate =Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions

END







GO


