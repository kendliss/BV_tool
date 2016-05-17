USE [UVAQ_STAGING]
GO

/****** Object:  StoredProcedure [bvt_staging].[UVLB_ParentID_FlightRecord_Link_PR]    Script Date: 02/12/2016 09:20:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [bvt_staging].[UVLB_ParentID_FlightRecord_Link_PR]

AS
BEGIN
	SET NOCOUNT ON;



IF Object_ID('bvt_staging.UVLB_pID_FlightPlan_Clean') IS NOT NULL
TRUNCATE TABLE bvt_staging.UVLB_pID_FlightPlan_Clean

IF Object_ID('bvt_staging.UVLB_pID_FlightPlan_other') IS NOT NULL
TRUNCATE TABLE bvt_staging.UVLB_pID_FlightPlan_other

IF Object_ID('bvt_staging.UVLB_pID_FlightPlan_NoMatch') IS NOT NULL
TRUNCATE TABLE bvt_staging.UVLB_pID_FlightPlan_NoMatch

IF Object_ID('bvt_staging.UVLB_pID_FlightPlan_Dups') IS NOT NULL
TRUNCATE TABLE bvt_staging.UVLB_pID_FlightPlan_Dups


Select Source_System_ID
into #TempXSellPID
from  bvt_prod.External_ID_linkage_TBL a
JOIN bvt_prod.External_ID_linkage_TBL_has_Flight_Plan_Records b
on a.idExternal_ID_linkage_TBL = b.idExternal_ID_linkage_TBL_FK
JOIN bvt_prod.Flight_Plan_Records c
on b.idFlight_Plan_Records_FK = c.idFlight_Plan_Records
JOIN bvt_Prod.Touch_Definition_VW d
on d.idProgram_Touch_Definitions_TBL = c.idProgram_Touch_Definitions_TBL_FK
where PROGRAM_NAME = 'X-Sell'


Insert INTO bvt_processed.XSell_ActiveCampaigns
SELECT DISTINCT a.ParentID, a.Project_ID, a.eCRW_Project_Name, a.Campaign_Name, a.Start_Date, b.Scorecard_Program_Channel, a.Media_Code, a.Vendor, a.CallStrat_ID,
a.Cell_Description, GETDATE() as AssignDate

	FROM JAVDB.IREPORT_2015.dbo.WB_01_Campaign_list_WB_2016 AS a 
	JOIN JAVDB.IREPORT_2015.dbo.WB_00_Reporting_Hierarchy_2016 AS b
      ON a.tactic_id=b.id
     WHERE b.Scorecard_lob_Tab = 'Cross-Sell'
    AND a.End_Date_Traditional>='12/28/15'
	AND a.Media_Code <> 'DR'
	AND a.campaign_name NOT LIKE '%Commitment View%'
	AND a.campaign_name NOT LIKE '%Remaining data%'
	AND a.campaign_name NOT LIKE '%best View Objectives%'
	AND a.ParentID not in (Select ParentID from bvt_processed.XSell_ActiveCampaigns)





Select ParentID,
CASE 

--Bill Media -- Bill Inserts
WHEN Media_Code = 'BI' AND(Campaign_Name LIKE '%WLS%' OR Campaign_Name LIKE '%Wireless%') AND Campaign_Name NOT LIKE '%E-Bill%' AND Campaign_Name NOT LIKE '%EBill%' AND Campaign_Name NOT LIKE '%TV%' THEN 187
WHEN Media_Code = 'BI' AND eCRW_Project_Name LIKE '%UNAT_UVBillIns2015%' THEN 188 --Wireline Bill Insert
WHEN Media_Code = 'BI' AND (Campaign_Name LIKE '%EBill%' OR Campaign_Name like '%E-Bill%') AND Campaign_Name NOT LIKE '%TV%' THEN 185
WHEN Media_Code = 'BI' AND eCRW_Project_Name LIKE '%BI_DTV_CROSS_SELL%' THEN 189 --TV Cross Sell Bill Insert
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%TV%' AND (Campaign_Name LIKE '%EBill%' OR Campaign_Name LIKE '%E-Bill%') THEN 186 


--Catalog
WHEN Media_Code = 'CA' AND Campaign_Name LIKE '%overrun%' THEN 171
WHEN Media_Code = 'CA' AND (Campaign_Name LIKE '%FRESH%' OR Campaign_Name LIKE '%NEW GREEN%') AND Campaign_Name NOT LIKE '%TOUCH%' AND Campaign_Name NOT LIKE '%T3%' THEN 170
WHEN Media_Code = 'CA' AND Campaign_Name NOT LIKE '%TOUCH%' AND Campaign_Name NOT LIKE '%T3%' AND Campaign_Name LIKE '%(WLN)%' THEN 169
WHEN Media_Code = 'CA' AND Campaign_Name NOT LIKE '%TOUCH%' AND Campaign_Name NOT LIKE '%T3%' AND  Campaign_Name  LIKE '%(WLS)%'  THEN 167
WHEN Media_Code = 'CA' AND Campaign_Name NOT LIKE '%TOUCH%' AND Campaign_Name NOT LIKE '%T3%' AND (Campaign_Name  LIKE '%Non-IRU%' OR Campaign_Name NOT LIKE '%IRU%') THEN 169

--Door Danger DM 
WHEN Media_Code = 'DH' THEN 203

--Shared Mail
WHEN Media_Code = 'VAS' THEN 173

--GoLocal DM
WHEN Media_Code = 'DM' AND (ecrw_project_name LIKE '%Local%' OR eCRW_Project_Name LIKE '%PreGreen%') THEN 60

WHEN Media_Code = 'DM' AND eCRW_Project_Name like '%Chicago%' THEN 640

--Direct Mail TV Upsell
WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%TV UP%' OR eCRW_Project_Name LIKE '%HSIAONLY%' OR eCRW_Project_Name LIKE '%TV%UP%') AND ((Campaign_Name LIKE ('%never%') OR Campaign_Name LIKE ('% NH %') OR Campaign_Name LIKE ('% NH%')OR Campaign_Name LIKE ('%NH%'))) AND (Campaign_Name NOT LIKE '%mid%' OR Campaign_Name NOT LIKE '%early%' OR Campaign_Name NOT LIKE '%late%') THEN 75
WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%TV UP%' OR eCRW_Project_Name LIKE '%HSIAONLY%' OR eCRW_Project_Name LIKE '%TV%UP%') AND ((Campaign_Name LIKE ('%win%') or Campaign_Name LIKE ('% WB %')or Campaign_Name LIKE ('% WB%')or Campaign_Name LIKE ('%WB%'))) AND (Campaign_Name NOT LIKE '%mid%' OR Campaign_Name NOT LIKE '%early%' OR Campaign_Name NOT LIKE '%late%') THEN 74
WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%TV UP%' OR eCRW_Project_Name LIKE '%HSIAONLY%' OR eCRW_Project_Name LIKE '%TV%UP%') AND (Campaign_Name NOT LIKE '%mid%' OR Campaign_Name NOT LIKE '%early%' OR Campaign_Name NOT LIKE '%late%') THEN 75

--Trigger DM
WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%CONNECT%' OR eCRW_Project_Name LIKE '%Connect%') THEN 103
WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%contact%' OR eCRW_Project_Name LIKE '%contact%') THEN 112
WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%WINBACK%' OR eCRW_Project_Name LIKE '%winback%') THEN 117
WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%Click Responder%' OR eCRW_Project_Name LIKE '%clickresponder%') THEN 95
WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%RESPONDER%' OR eCRW_Project_Name LIKE '%responder%') THEN 113
WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%DATA%' OR eCRW_Project_Name LIKE '%databust%') THEN 98
WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%Eligibility%' OR campaign_name LIKE '%oec%' OR eCRW_Project_Name LIKE '%online%' OR eCRW_Project_Name LIKE '%oec%' OR eCRW_Project_Name LIKE '%EligibilityConfirmed%') THEN 94
WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%SMART%' OR Campaign_Name LIKE '%SP%' OR eCRW_Project_Name LIKE '%smart%') AND Campaign_Name NOT LIKE '%Prospect%' AND Campaign_Name NOT LIKE '%USPS%' AND Campaign_Name NOT LIKE '%HISP%' AND Campaign_Name NOT LIKE '%SP TAG%' AND Campaign_Name NOT LIKE '%Spanish%' AND eCRW_Project_Name NOT LIKE '%HISP%' and eCRW_Project_Name NOT LIKE '%GIG%' THEN 106 --Trigger Purchased Smartphone WLS DM
WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%TRIG%' OR Campaign_Name LIKE '%GO LOCAL EMERGENCY%') AND (Campaign_Name LIKE '%Gig%' OR eCRW_Project_Name LIKE '%giga%') THEN 99
WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%CANCEL BEFORE%'OR Campaign_Name LIKE '%CANCEL B4%' OR campaign_name LIKE '%xcell B4%' OR Campaign_Name LIKE '%BUYERS REMORSE%' OR Campaign_Name LIKE '%INSTALLATION ISSUES%' OR eCRW_Project_Name LIKE '%Cancelbefore%') THEN 91
WHEN Media_Code = 'DM' AND Campaign_Name LIKE '%New%IRU%' AND Campaign_Name NOT LIKE '%New Green%' THEN 104



--Core Direct Mail
WHEN Media_Code = 'DM' AND Campaign_Name LIKE '%Phone Card%'  THEN 68
--WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%HISP%CROSS%' THEN 192 --LOOK AT!!! Most go into a different touch!

/*
WHEN Media_Code = 'DM' AND (eCRW_Project_Name NOT LIKE '%GIG%' OR (eCRW_Project_Name LIKE '%Gig%' AND Vendor = 'Aspen')) AND (Campaign_Name LIKE '%EARLY%' OR Campaign_name LIKE '% EM %') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISP%' AND Campaign_Name NOT LIKE '%SPANISH%' AND Campaign_Name NOT LIKE '%SP Tag%' AND (Campaign_Name LIKE '%fresh%' OR Campaign_Name LIKE '% FR %') THEN 47
WHEN Media_Code = 'DM' AND (eCRW_Project_Name NOT LIKE '%GIG%' OR (eCRW_Project_Name LIKE '%Gig%' AND Vendor = 'Aspen')) AND (Campaign_Name LIKE '%EARLY%' OR Campaign_name LIKE '% EM %') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISP%' AND Campaign_Name NOT LIKE '%SPANISH%' AND Campaign_Name NOT LIKE '%SP Tag%' AND Campaign_Name NOT LIKE '%WLN w/%' AND Campaign_Name NOT LIKE '%WLS+%' AND Campaign_Name NOT LIKE '%WLS +%' AND Campaign_Name NOT LIKE '%non wls%' AND Campaign_Name NOT LIKE '%WLSO%' AND Campaign_Name NOT LIKE '%NWLS%' AND Campaign_Name LIKE '%WLS%'  THEN 44
WHEN Media_Code = 'DM' AND (eCRW_Project_Name NOT LIKE '%GIG%' OR (eCRW_Project_Name LIKE '%Gig%' AND Vendor = 'Aspen')) AND (Campaign_Name LIKE '%EARLY%' OR Campaign_name LIKE '% EM %')AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISP%' AND Campaign_Name NOT LIKE '%SPANISH%' AND Campaign_Name NOT LIKE '%SP Tag%' THEN 46
WHEN Media_Code = 'DM' AND (eCRW_Project_Name NOT LIKE '%GIG%' OR (eCRW_Project_Name LIKE '%Gig%' AND Vendor = 'Aspen')) AND (Campaign_Name LIKE '%EARLY%' OR Campaign_Name LIKE '%GO LOCAL EMERGENCY%' OR Campaign_name LIKE '% EM %') AND (Campaign_Name LIKE '%SPANISH TAG%' OR Campaign_Name LIKE '%SP TAG%')  THEN 48


WHEN Media_Code = 'DM' AND (eCRW_Project_Name NOT LIKE '%GIG%' OR (eCRW_Project_Name LIKE '%Gig%' AND Vendor = 'Aspen')) AND (Campaign_Name LIKE '%LATE%' OR Campaign_Name LIKE '%3RD%' OR Campaign_Name LIKE '% LM %') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISP%' AND Campaign_Name NOT LIKE '%SPANISH%' AND Campaign_Name NOT LIKE '%SP Tag%' AND (Campaign_Name LIKE '%fresh%' OR Campaign_Name LIKE '% FR %') THEN 57
WHEN Media_Code = 'DM' AND (eCRW_Project_Name NOT LIKE '%GIG%' OR (eCRW_Project_Name LIKE '%Gig%' AND Vendor = 'Aspen')) AND (Campaign_Name LIKE '%LATE%' OR Campaign_Name LIKE '%3RD%' OR Campaign_Name LIKE '% LM %') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISP%' AND Campaign_Name NOT LIKE '%SPANISH%' AND Campaign_Name NOT LIKE '%SP Tag%' AND Campaign_Name NOT LIKE '%WLN w/%' AND Campaign_Name NOT LIKE '%WLS+%' AND Campaign_Name NOT LIKE '%WLS +%' AND Campaign_Name NOT LIKE '%non wls%' AND Campaign_Name NOT LIKE '%WLSO%' AND Campaign_Name NOT LIKE '%NWLS%' AND Campaign_Name LIKE '%WLS%' THEN 54
WHEN Media_Code = 'DM' AND (eCRW_Project_Name NOT LIKE '%GIG%' OR (eCRW_Project_Name LIKE '%Gig%' AND Vendor = 'Aspen')) AND (Campaign_Name LIKE '%LATE%' OR Campaign_Name LIKE '%3RD%' OR Campaign_Name LIKE '% LM %') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISP%' AND Campaign_Name NOT LIKE '%SPANISH%' AND Campaign_Name NOT LIKE '%SP Tag%' THEN 56
WHEN Media_Code = 'DM' AND (eCRW_Project_Name NOT LIKE '%GIG%' OR (eCRW_Project_Name LIKE '%Gig%' AND Vendor = 'Aspen')) AND (Campaign_Name LIKE '%LATE%' OR Campaign_Name LIKE '%3RD%' OR Campaign_Name LIKE '% LM %') AND (Campaign_Name LIKE '%SPANISH TAG%' OR Campaign_Name LIKE '%SP TAG%')  THEN 58


WHEN Media_Code = 'DM' AND (eCRW_Project_Name NOT LIKE '%GIG%' OR (eCRW_Project_Name LIKE '%Gig%' AND Vendor = 'Aspen')) AND (Campaign_Name LIKE '%MID%' OR Campaign_Name LIKE '% MM %' OR Campaign_Name LIKE '%INC%') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISP%' AND Campaign_Name NOT LIKE '%SPANISH%' AND Campaign_Name NOT LIKE '%SP Tag%' AND (Campaign_Name LIKE '%fresh%' OR Campaign_Name LIKE '% FR %') THEN 64
WHEN Media_Code = 'DM' AND (eCRW_Project_Name NOT LIKE '%GIG%' OR (eCRW_Project_Name LIKE '%Gig%' AND Vendor = 'Aspen')) AND (Campaign_Name LIKE '%MID%' OR Campaign_Name LIKE '% MM %' OR Campaign_Name LIKE '%INC%') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISP%' AND Campaign_Name NOT LIKE '%SPANISH%' AND Campaign_Name NOT LIKE '%SP Tag%' AND Campaign_Name NOT LIKE '%WLN w/%' AND Campaign_Name NOT LIKE '%WLS+%' AND Campaign_Name NOT LIKE '%WLS +%' AND Campaign_Name NOT LIKE '%non wls%' AND Campaign_Name NOT LIKE '%WLSO%' AND Campaign_Name NOT LIKE '%NWLS%' AND Campaign_Name LIKE '%WLS%' THEN 61
WHEN Media_Code = 'DM' AND (eCRW_Project_Name NOT LIKE '%GIG%' OR (eCRW_Project_Name LIKE '%Gig%' AND Vendor = 'Aspen')) AND (Campaign_Name LIKE '%MID%' OR Campaign_Name LIKE '% MM %' OR Campaign_Name LIKE '%INC%') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISP%' AND Campaign_Name NOT LIKE '%SPANISH%' AND Campaign_Name NOT LIKE '%SP Tag%' THEN 63
WHEN Media_Code = 'DM' AND (eCRW_Project_Name NOT LIKE '%GIG%' OR (eCRW_Project_Name LIKE '%Gig%' AND Vendor = 'Aspen')) AND (Campaign_Name LIKE '%MID%' OR Campaign_Name LIKE '% MM %' OR Campaign_Name LIKE '%INC%') AND (Campaign_Name LIKE '%SPANISH TAG%' OR Campaign_Name LIKE '%SP TAG%') THEN 65
*/
--Updated Core DM
WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%Early%' OR eCRW_Project_Name LIKE '%Mid%' OR eCRW_Project_Name LIKE '%Late%') AND eCRW_Project_Name LIKE '%BAU%' AND Cell_Description LIKE '%DTV%' AND Cell_Description NOT LIKE '%DTV El%' THEN 732 --Core DTV DM
WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%Early%' OR eCRW_Project_Name LIKE '%Mid%' OR eCRW_Project_Name LIKE '%Late%') AND eCRW_Project_Name LIKE '%BAU%' AND Cell_Description LIKE '%Wireless Only%' THEN 1048 --735 --Core WLS DM Temp moved to DTV Call Center Touch
WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%Early%' OR eCRW_Project_Name LIKE '%Mid%' OR eCRW_Project_Name LIKE '%Late%') AND eCRW_Project_Name LIKE '%BAU%' THEN 734 --Core WLN DM


WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%Early%' OR eCRW_Project_Name LIKE '%Mid%' OR eCRW_Project_Name LIKE '%Late%') AND eCRW_Project_Name LIKE '%DSL%' THEN 731 --Core BBMig DM

WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%UCLM%' AND eCRW_Project_Name LIKE '%GIG%' AND eCRW_Project_Name LIKE '%Monthly%' THEN 1258 --Gigapower Monthly HP CLM DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%UCLM%' AND eCRW_Project_Name LIKE '%GIG%' AND eCRW_Project_Name LIKE '%Announcement 1%' THEN 1259 --Gigapower Announcement 1 CLM DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%UCLM%' AND eCRW_Project_Name LIKE '%GIG%' AND eCRW_Project_Name LIKE '%Announcement 2%' THEN 1260 --Gigapower Announcement 2 CLM DM 
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%GIG%' AND eCRW_Project_Name LIKE '%ONGO%' AND eCRW_project_name NOT LIKE '%PRO%' AND Campaign_Name LIKE '%DTV%' AND Campaign_Name NOT LIKE '%NON%DTV%' THEN 641 --Gigapower Core DTV DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%GIG%' AND eCRW_Project_Name LIKE '%ONGO%' AND eCRW_Project_Name LIKE '%PRO%' THEN 1018 --Gigapower Core Prospect DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%GIG%' AND eCRW_Project_Name LIKE '%ONGO%' THEN 52 --Gigapower Core WLN DM


WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%GIG%' AND (eCRW_Project_Name LIKE '%LAUNCH%' OR Campaign_Name LIKE '%LNCH%') AND (Campaign_Name LIKE '%TOUCH 1%' OR Campaign_Name LIKE '%T1%') AND Campaign_Name NOT LIKE '%OCT1%' AND eCRW_project_name NOT LIKE '%PRO%' AND Campaign_Name LIKE '%DTV%' AND Campaign_Name NOT LIKE '%NON%DTV%' THEN 642 --Gigapower Touch 1 DTV DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%GIG%' AND (eCRW_Project_Name LIKE '%LAUNCH%' OR Campaign_Name LIKE '%LNCH%') AND (Campaign_Name LIKE '%TOUCH 1%' OR Campaign_Name LIKE '%T1%') AND Campaign_Name NOT LIKE '%OCT1%' AND eCRW_Project_Name LIKE '%PRO%' THEN 1019 --Gigapower Touch 1 Prospect DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%GIG%' AND (eCRW_Project_Name LIKE '%LAUNCH%' OR Campaign_Name LIKE '%LNCH%') AND (Campaign_Name LIKE '%TOUCH 1%' OR Campaign_Name LIKE '%T1%') AND Campaign_Name NOT LIKE '%OCT1%' THEN 40 --Gigapower Touch 1 WRLN DM


WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%GIG%' AND (eCRW_Project_Name LIKE '%LAUNCH%' OR Campaign_Name LIKE '%LNCH%') AND (Campaign_Name LIKE '%TOUCH 2%' OR Campaign_Name LIKE '%T2%' OR Campaign_Name LIKE '%T3%' OR Campaign_Name LIKE '%T4%') THEN 43 --Gigapower Touch 2 WRLN DM

WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%GIG%' AND (eCRW_Project_Name LIKE '%LAUNCH%' OR Campaign_Name LIKE '%LNCH%') AND eCRW_project_name NOT LIKE '%PRO%' AND Campaign_Name LIKE '%DTV%' AND Campaign_Name NOT LIKE '%NON%DTV%' THEN 642 --Gigapower Touch 1 DTV DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%GIG%' AND (eCRW_Project_Name LIKE '%LAUNCH%' OR Campaign_Name LIKE '%LNCH%') AND eCRW_Project_Name LIKE '%PRO%' THEN 1019 --Gigapower Touch 1 Prospect DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%GIG%' AND (eCRW_Project_Name LIKE '%LAUNCH%' OR Campaign_Name LIKE '%LNCH%') THEN 40 --Gigapower Touch 1 WRLN DM



WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%IPTVSubsHSIA%' THEN 996 --Core IPTV DM (HSIA Cross Sell from CLM)
--new green dm hispanic
WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%T1%' OR Campaign_Name LIKE '%TOUCH 1%') AND (Campaign_Name LIKE '%BILINGUAL%' OR Campaign_Name LIKE '%HISPANIC%' OR Vendor='Dieste') THEN 71
WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%BILINGUAL%' OR Campaign_Name LIKE '%HISPANIC%' OR Campaign_Name LIKE '%SPANISH%' OR Vendor='Dieste') AND campaign_name NOT LIKE '%spanish%' AND campaign_name NOT LIKE '%bilingual bucket test%' AND campaign_name NOT LIKE '%phone card%' AND Campaign_Name NOT LIKE '%HISPANIC%LT%'THEN 69
WHEN Media_Code = 'DM' AND Campaign_Name LIKE '%HISPANIC%LT%' THEN 71


--DTV cross sell DM
WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%DTV%' AND Campaign_Name LIKE '%CROSS%') THEN 73

WHEN Media_code = 'DM' AND eCRW_Project_Name LIKE '%FCC%' THEN 191
WHEN Media_code = 'EM' AND eCRW_Project_Name LIKE '%FCC%' THEN 202

--new green dm

WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%TOUCH 1%'OR Campaign_Name LIKE '%T1%') AND (Campaign_Name LIKE '%New Green%' OR Campaign_Name LIKE '%employee%') AND Campaign_Name NOT LIKE '%WIRELINE%' and Campaign_Name NOT LIKE '%WLS+%' AND Campaign_Name NOT LIKE '%WLN%' AND (campaign_name like '%wls%' OR Campaign_Name LIKE '%Wireless%') THEN 77
WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%TOUCH 1%'OR Campaign_Name LIKE '%T1%') AND (Campaign_Name LIKE '%New Green%' OR Campaign_Name LIKE '%employee%') THEN 79


WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%TOUCH 2%' OR Campaign_Name LIKE '%T2%') AND (Campaign_Name LIKE '%New Green%' OR Campaign_Name LIKE '%employee%') AND Campaign_Name NOT LIKE '%WIRELINE%' and Campaign_Name NOT LIKE '%WLS+%' AND Campaign_Name NOT LIKE '%WLN%' AND (campaign_name like '%wls%' OR Campaign_Name LIKE '%Wireless%') THEN 81
WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%TOUCH 2%' OR Campaign_Name LIKE '%T2%') AND (Campaign_Name LIKE '%New Green%' OR Campaign_Name LIKE '%employee%') THEN 83


WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%TOUCH 3%' OR Campaign_Name LIKE '%T3%') AND (Campaign_Name LIKE '%New Green%' OR Campaign_Name LIKE '%employee%') AND Campaign_Name NOT LIKE '%WIRELINE%' and Campaign_Name NOT LIKE '%WLS+%' AND Campaign_Name NOT LIKE '%WLN%' AND (campaign_name like '%wls%' OR Campaign_Name LIKE '%Wireless%') THEN 86 
WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%TOUCH 3%' OR Campaign_Name LIKE '%T3%') AND (Campaign_Name LIKE '%New Green%' OR Campaign_Name LIKE '%employee%') THEN 88


WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%New Green%' OR Campaign_Name LIKE '%employee%') AND Campaign_Name NOT LIKE '%WIRELINE%' and Campaign_Name NOT LIKE '%WLS+%' AND Campaign_Name NOT LIKE '%WLN%' AND (campaign_name like '%wls%' OR Campaign_Name LIKE '%Wireless%') THEN 77
WHEN Media_Code = 'DM' AND (Campaign_Name LIKE '%New Green%' OR Campaign_Name LIKE '%employee%') THEN 79



--OOF Email
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%OOF%' and (eCRW_Project_Name LIKE '%Redeploy%' OR eCRW_Project_Name LIKE '%Reblast%' OR eCRW_Project_Name LIKE '%RBT%') THEN 938 --OOF Engagement
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%OOF%' THEN 937 --OOF Initial EM

--triggers email

WHEN Media_Code = 'EM' AND (Campaign_Name LIKE '%TV UP%' OR eCRW_Project_Name LIKE '%HSIAONLY%') AND (Campaign_Name NOT LIKE '%reblast%' AND Campaign_Name NOT LIKE '% rb%' AND Campaign_Name NOT LIKE '%Re-Blast%' AND Campaign_Name NOT LIKE '%ENG%') THEN 193
WHEN Media_Code = 'EM' AND (Campaign_Name LIKE '%TV UP%' OR eCRW_Project_Name LIKE '%HSIAONLY%') AND (Campaign_Name LIKE '%reblast%' OR Campaign_Name LIKE '% rb%' OR Campaign_Name LIKE '%Re-Blast%' OR Campaign_Name LIKE '%ENG%') THEN 194
WHEN Media_Code = 'EM' AND (Campaign_Name LIKE '%eligibility%' OR eCRW_Project_Name LIKE '%eligibility%') AND (Campaign_Name NOT LIKE '%reblast%' AND Campaign_Name NOT LIKE '%rbt%' AND Campaign_Name NOT LIKE '%Re-Blast%') THEN 149 
WHEN Media_Code = 'EM' AND (Campaign_Name LIKE '%RESPONDER%' OR eCRW_Project_Name LIKE '%Responder%') AND (Campaign_Name NOT LIKE '%reblast%' AND Campaign_Name NOT LIKE '%rbt%') AND Campaign_Name NOT LIKE '%NON%Respond%'THEN 162
WHEN Media_Code = 'EM' AND eCRW_Project_Name NOT LIKE '%GIG%' AND (Campaign_Name LIKE '%SMART%' OR Campaign_Name LIKE '% SP %' OR eCRW_Project_Name LIKE '%Smart%') AND Campaign_Name NOT LIKE '%reblast%' AND Campaign_Name NOT LIKE '%rbt%' AND Campaign_Name NOT LIKE '%ENG%' AND Campaign_Name NOT LIKE '%data%' THEN 158
WHEN Media_Code = 'EM' AND (Campaign_Name LIKE '%CONNECT%' OR eCRW_Project_Name LIKE '%Connect%') AND Campaign_Name NOT LIKE '%reblast%' AND Campaign_Name NOT LIKE '%rbt%' THEN 156
WHEN Media_Code = 'EM' AND (Campaign_Name LIKE '%data buster%' OR eCRW_Project_Name LIKE '%databust%') AND (Campaign_Name NOT LIKE '%reblast%' AND Campaign_Name NOT LIKE '%rbt%') THEN 153 
WHEN Media_Code = 'EM' AND (Campaign_Name LIKE '%data buster%' OR eCRW_Project_Name LIKE '%databust%') AND (Campaign_Name LIKE '%reblast%' OR Campaign_Name LIKE '%rbt%') THEN 154 
WHEN Media_Code = 'EM' AND (campaign_name LIKE '%recontact%' OR eCRW_Project_Name LIKE '%recontact%') AND (Campaign_Name NOT LIKE '%reblast%' AND Campaign_Name NOT LIKE '%rbt%') THEN 160
WHEN Media_Code = 'EM' AND (Campaign_Name LIKE '%WINBACK%'  OR eCRW_Project_Name LIKE '%WINBACK%') AND (Campaign_Name NOT LIKE '%reblast%' AND Campaign_Name NOT LIKE '%rbt%') THEN 164 
WHEN Media_Code = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%giga%' THEN 122
WHEN Media_Code = 'EM' AND (Campaign_Name LIKE '%COMP%Resp%' OR eCRW_Project_Name LIKE '%Comp%Resp%') AND (Campaign_Name NOT LIKE '%reblast%' and Campaign_Name NOT LIKE '%rbt%') THEN 151
WHEN Media_Code = 'EM' AND (Campaign_Name LIKE '%Cancel before%' OR Campaign_Name LIKE '%Cancel B4%' OR eCRW_Project_Name LIKE '%cancelbefore%') AND (Campaign_Name NOT LIKE '%reblast%' and Campaign_Name NOT LIKE '%rbt%')  THEN 147

WHEN Media_Code = 'EM' AND (Campaign_Name LIKE '%eligibility%' OR eCRW_Project_Name LIKE '%eligibility%') AND (Campaign_Name LIKE '%reblast%' OR Campaign_Name LIKE '%rbt%' OR Campaign_Name LIKE '%Re-Blast%') THEN 150
WHEN Media_Code = 'EM' AND (Campaign_Name LIKE '%RESPONDER%' OR eCRW_Project_Name LIKE '%responder%') AND (Campaign_Name LIKE '%reblast%' OR Campaign_Name LIKE '%rbt%' OR Campaign_Name LIKE '%Re-Blast%') AND Campaign_Name NOT LIKE '%NON%Respond%'THEN 163 
WHEN Media_Code = 'EM' AND eCRW_Project_Name NOT LIKE '%GIG%' AND (Campaign_Name LIKE '%SMART%' OR Campaign_Name LIKE '% SP %'  OR eCRW_Project_Name LIKE '%smart%') AND (Campaign_Name LIKE '%reblast%' or Campaign_Name LIKE '%rbt%' OR Campaign_Name LIKE '%Re-Blast%') AND Campaign_Name NOT LIKE '%data%'THEN 159
WHEN Media_Code = 'EM' AND (campaign_name like '%recontact%' OR eCRW_Project_Name LIKE '%recontact%') AND (Campaign_Name LIKE '%reblast%' OR Campaign_Name LIKE '%rbt%' OR Campaign_Name LIKE '%Re-Blast%') THEN 161
WHEN Media_Code = 'EM' AND (Campaign_Name LIKE '%WINBACK%' OR eCRW_Project_Name LIKE '%winback%') AND (Campaign_Name LIKE '%reblast%' OR Campaign_Name LIKE '%rbt%' OR Campaign_Name LIKE '%Re-Blast%') THEN 165
WHEN Media_Code = 'EM' AND (Campaign_Name LIKE '%CONNECT%' OR eCRW_Project_Name LIKE '%connect%') AND (Campaign_Name LIKE '%reblast%' OR Campaign_Name LIKE '%rbt%' OR Campaign_Name LIKE '%Re-Blast%') THEN 157
WHEN MEdia_Code = 'EM' AND (Campaign_Name LIKE '%COMP%Resp%'  OR eCRW_Project_Name LIKE '%Comp%Resp%') AND (Campaign_Name LIKE '%reblast%' OR Campaign_Name LIKE '%rbt%') THEN 152
WHEN Media_Code = 'EM' AND (Campaign_Name LIKE '%Cancel before%' OR Campaign_Name LIKE '%Cancel B4%' OR eCRW_Project_Name LIKE '%cancelbefore%') AND (Campaign_Name LIKE '%reblast%' OR Campaign_Name LIKE '%rbt%') THEN 148

WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Engage%' THEN 155

--new green email 
WHEN Media_code = 'EM' AND eCRW_Project_Name NOT LIKE '%GIG%' AND eCRW_Project_Name NOT LIKE '%Pregreen%' AND (Campaign_Name LIKE '%touch 1%' OR Campaign_Name LIKE '%t1%' OR Campaign_Name LIKE '%follow%') AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '% RB%' AND Campaign_Name NOT LIKE '%ENG%' AND Campaign_Name NOT LIKE '%TV Upsell%' AND Campaign_Name NOT LIKE '%TV UP%'AND Campaign_Name NOT LIKE '%Trig%' THEN 118
WHEN Media_code = 'EM' AND eCRW_Project_Name NOT LIKE '%GIG%' AND eCRW_Project_Name NOT LIKE '%Pregreen%' AND (Campaign_Name LIKE '%touch 1%' OR Campaign_Name LIKE '%t1%')AND (Campaign_Name LIKE '%BLAST%' OR Campaign_Name LIKE '% RB%' OR Campaign_Name lIKE '%ENG%') AND Campaign_Name NOT LIKE '%winback%'AND Campaign_Name NOT LIKE '%TV UP%'THEN 119
WHEN Media_Code = 'EM' AND eCRW_Project_Name NOT LIKE '%GIG%' AND eCRW_Project_Name NOT LIKE '%Pregreen%' AND (Campaign_Name LIKE '%touch 2%' OR Campaign_Name LIKE '%t2%' OR Campaign_Name LIKE '%touch 3%' OR Campaign_Name LIKE '%t3%')AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '% RB%' AND Campaign_Name NOT LIKE '%ENG%' AND Campaign_Name NOT LIKE '%TV UPSELL%' AND Campaign_Name NOT LIKE '%TV UP%' AND Campaign_Name NOT LIKE '%winback%' THEN 120
WHEN Media_Code = 'EM' AND eCRW_Project_Name NOT LIKE '%GIG%' AND eCRW_Project_Name NOT LIKE '%Pregreen%' AND (Campaign_Name LIKE '%touch 2%' OR Campaign_Name LIKE '%t2%' OR Campaign_Name LIKE '%touch 3%' OR Campaign_Name LIKE '%t3%')AND (Campaign_Name LIKE '%BLAST%' OR Campaign_Name LIKE '% RB%' OR Campaign_Name lIKE '%ENG%') and Campaign_Name NOT LIKE '%winback%' AND campaign_name NOT LIKE '%tv upsell%' THEN 121


/*--engagement email

WHEN Media_Code = 'EM' AND Campaign_Name NOT LIKE '%re-eng%' AND Campaign_Name LIKE '%ENG%' AND(Campaign_Name LIKE '%EARLY%' OR Campaign_Name LIKE '%Mid%' OR Campaign_Name LIKE '%Late%' OR eCRW_Project_Name LIKE '%PostLaunchWeek1and2%' OR eCRW_Project_Name LIKE '%PostLaunchWeek3and4%' OR eCRW_Project_Name LIKE '%PostWeek5%' OR eCRW_Project_Name LIKE '%CoreEarly%') AND Campaign_Name NOT LIKE '%TRIG%' THEN 128

--core email
WHEN Media_Code = 'EM' AND eCRW_Project_Name NOT LIKE '%GIG%' AND (Campaign_Name LIKE '%EARLY%' OR eCRW_Project_Name LIKE '%PostLaunchWeek1and2%' OR eCRW_Project_Name LIKE '%Early%') AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '% RB%' AND Campaign_Name NOT LIKE '%REDEPLOY%' THEN 124
WHEN Media_Code = 'EM' AND eCRW_Project_Name NOT LIKE '%GIG%' AND (Campaign_Name LIKE '%EARLY%' OR eCRW_Project_Name LIKE '%PostLaunchWeek1and2%' OR eCRW_Project_Name LIKE '%Early%') AND (Campaign_Name  LIKE '%BLAST%' OR Campaign_Name  LIKE '%REDEPLOY%' OR Campaign_Name  LIKE '% RB%') THEN 126


WHEN Media_Code = 'EM' AND eCRW_Project_Name NOT LIKE '%GIG%' AND (Campaign_Name LIKE '%MID%' OR eCRW_Project_Name LIKE '%PostLaunchWeek3and4%' OR eCRW_Project_Name LIKE '%Mid%') AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '% RB%' AND Campaign_Name NOT LIKE '%REDEPLOY%' THEN 130
WHEN Media_Code = 'EM' AND eCRW_Project_Name NOT LIKE '%GIG%' AND (Campaign_Name LIKE '%MID%' OR eCRW_Project_Name LIKE '%PostLaunchWeek3and4%' OR eCRW_Project_Name LIKE '%Mid%') AND (Campaign_Name  LIKE '%BLAST%' OR Campaign_Name  LIKE '%REDEPLOY%' OR Campaign_Name  LIKE '% RB%') THEN 132

WHEN Media_Code = 'EM' AND eCRW_Project_Name NOT LIKE '%GIG%' AND (Campaign_Name LIKE '%LATE%' OR eCRW_Project_Name LIKE '%PostWeek5%') AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '% RB%' AND Campaign_Name NOT LIKE '%REDEPLOY%'THEN 130
WHEN Media_Code = 'EM' AND eCRW_Project_Name NOT LIKE '%GIG%' AND (Campaign_Name LIKE '%LATE%' OR eCRW_Project_Name LIKE '%PostWeek5%') AND (Campaign_Name  LIKE '%BLAST%' OR Campaign_Name  LIKE '%REDEPLOY%' OR Campaign_Name  LIKE '% RB%') THEN 132


WHEN Media_Code = 'EM' AND eCRW_Project_Name NOT LIKE '%GIG%' AND Campaign_Name LIKE '%cyber mon%' AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '%deploy%'  THEN 130
WHEN Media_Code = 'EM' AND eCRW_Project_Name NOT LIKE '%GIG%' AND Campaign_Name LIKE '%cyber mon%' AND (Campaign_Name  LIKE '%BLAST%' OR Campaign_Name LIKE '%deploy%')  THEN 132
WHEN Media_Code = 'EM' AND eCRW_Project_Name NOT LIKE '%GIG%' AND Campaign_Name LIKE '%black fri%' AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '%deploy%'  THEN 130
WHEN Media_Code = 'EM' AND eCRW_Project_Name NOT LIKE '%GIG%' AND Campaign_Name LIKE '%black fri%' AND (Campaign_Name  LIKE '%BLAST%' OR Campaign_Name LIKE '%deploy%')  THEN 132
WHEN Media_Code = 'EM' AND eCRW_Project_Name NOT LIKE '%GIG%' AND Campaign_Name LIKE '%GIG%' AND Campaign_Name NOT LIKE '%TRIGGER%' and Campaign_Name NOT LIKE '%TV Upsell%'THEN 130
*/
--Core Email per new naming structure

WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Core%Early%' AND Campaign_Name LIKE '%Has DSL%' AND Campaign_Name NOT LIKE '%Engagement%' THEN 538 --Core Early BBMig EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Core%Early%' AND Campaign_Name LIKE '%Has DTV%' AND Campaign_Name NOT LIKE '%Engagement%' THEN 656 --Core Early DTV EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Core%Early%' AND Campaign_Name NOT LIKE '%Engagement%' THEN 124 --Core Early WRLN EM

WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Core%Early%' AND Campaign_Name LIKE '%Has DSL%' AND Campaign_Name LIKE '%Engagement%' THEN 726 --Core Engagement BBMig EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Core%Early%' AND Campaign_Name LIKE '%Has DTV%' AND Campaign_Name LIKE '%Engagement%' THEN 658 --Core Engagement DTV EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Core%Early%' AND Campaign_Name LIKE '%Engagement%' THEN 128 --Core Engagement WRLN EM

WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Core%Mid%' AND Campaign_Name LIKE '%Has DSL%' AND Campaign_Name NOT LIKE '%Engagement%' THEN 540 --Core Mid BBMig EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Core%Mid%' AND Campaign_Name LIKE '%Has DTV%' AND Campaign_Name NOT LIKE '%Engagement%' THEN 662 --Core Mid DTV EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Core%Mid%' AND Campaign_Name NOT LIKE '%Engagement%' THEN 130 --Core Mid WRLN EM

WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Core%Mid%' AND Campaign_Name LIKE '%Has DSL%' AND Campaign_Name LIKE '%Engagement%' THEN 726 --Core Engagement BBMig EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Core%Mid%' AND Campaign_Name LIKE '%Has DTV%' AND Campaign_Name LIKE '%Engagement%' THEN 658 --Core Engagement DTV EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Core%Mid%' AND Campaign_Name LIKE '%Engagement%' THEN 128 --Core Engagement WRLN EM

WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Core%Late%' AND Campaign_Name LIKE '%Has DSL%' AND Campaign_Name NOT LIKE '%Engagement%' THEN 540 --Core Late BBMig EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Core%Late%' AND Campaign_Name LIKE '%Has DTV%' AND Campaign_Name NOT LIKE '%Engagement%' THEN 662 --Core Late DTV EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Core%Late%' AND Campaign_Name NOT LIKE '%Engagement%' THEN 130 --Core Late WRLN EM

WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Core%Late%' AND Campaign_Name LIKE '%Has DSL%' AND Campaign_Name LIKE '%Engagement%' THEN 728 --Core Engagement BBMig EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Core%Late%' AND Campaign_Name LIKE '%Has DTV%' AND Campaign_Name LIKE '%Engagement%' THEN 729 --Core Engagement DTV EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Core%Late%' AND Campaign_Name LIKE '%Engagement%' THEN 727 --Core Engagement WRLN EM

--Gigapower Core Email
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%UCLM%' AND eCRW_Project_Name LIKE '%GIG%' AND eCRW_Project_Name LIKE '%Monthly%' THEN 1262 --Gigapower Monthly HP CLM EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%UCLM%' AND eCRW_Project_Name LIKE '%GIG%' AND eCRW_Project_Name LIKE '%Announcement 1%' THEN 1264 --Gigapower Announcement 1 CLM EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%UCLM%' AND eCRW_Project_Name LIKE '%GIG%' AND eCRW_Project_Name LIKE '%Announcement 2%' THEN 1265 --Gigapower Announcement 2 CLM EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%GIG%' AND eCRW_Project_Name LIKE '%ONGO%' AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '% RB%' AND Campaign_Name NOT LIKE '%REDEPLOY%' AND Campaign_Name NOT LIKE '%RBT%' THEN  503
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%GIG%' AND eCRW_Project_Name LIKE '%ONGO%'  AND (Campaign_Name LIKE '%BLAST%' OR Campaign_Name LIKE '% RB%' OR Campaign_Name LIKE '%REDEPLOY%' OR Campaign_Name LIKE '%RBT%') THEN 504
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%GIG%' AND (eCRW_Project_Name LIKE '%LAUNCH%' OR Campaign_Name LIKE '%Launch%' OR Campaign_Name LIKE '%LNCH%') AND (Campaign_Name LIKE '%Touch1%' OR Campaign_Name LIKE '%T1%') AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '% RB%' AND Campaign_Name NOT LIKE '%REDEPLOY%' AND Campaign_Name NOT LIKE '%RBT%' THEN  196
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%GIG%' AND (eCRW_Project_Name LIKE '%LAUNCH%' OR Campaign_Name LIKE '%Launch%' OR Campaign_Name LIKE '%LNCH%') AND (Campaign_Name LIKE '%Touch1%' OR Campaign_Name LIKE '%T1%') AND (Campaign_Name LIKE '%BLAST%' OR Campaign_Name LIKE '% RB%' OR Campaign_Name LIKE '%REDEPLOY%' OR Campaign_Name LIKE '%RBT%') THEN 197
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%GIG%' AND (eCRW_Project_Name LIKE '%LAUNCH%' OR Campaign_Name LIKE '%Launch%' OR Campaign_Name LIKE '%LNCH%') AND (Campaign_Name LIKE '%Touch2%' OR Campaign_Name LIKE '%T2%' OR Campaign_Name LIKE '%T3%' OR Campaign_Name LIKE '%T4%') AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '% RB%' AND Campaign_Name NOT LIKE '%REDEPLOY%' AND Campaign_Name NOT LIKE '%RBT%' THEN  199
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%GIG%' AND (eCRW_Project_Name LIKE '%LAUNCH%' OR Campaign_Name LIKE '%Launch%' OR Campaign_Name LIKE '%LNCH%') AND (Campaign_Name LIKE '%Touch2%' OR Campaign_Name LIKE '%T2%' OR Campaign_Name LIKE '%T3%' OR Campaign_Name LIKE '%T4%') AND (Campaign_Name LIKE '%BLAST%' OR Campaign_Name LIKE '% RB%' OR Campaign_Name LIKE '%REDEPLOY%' OR Campaign_Name LIKE '%RBT%') THEN 201
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%GIG%' AND (eCRW_Project_Name LIKE '%LAUNCH%' OR Campaign_Name LIKE '%Launch%' OR Campaign_Name LIKE '%LNCH%') AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '% RB%' AND Campaign_Name NOT LIKE '%REDEPLOY%' AND Campaign_Name NOT LIKE '%RBT%' THEN  196
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%GIG%' AND (eCRW_Project_Name LIKE '%LAUNCH%' OR Campaign_Name LIKE '%Launch%' OR Campaign_Name LIKE '%LNCH%') AND (Campaign_Name LIKE '%BLAST%' OR Campaign_Name LIKE '% RB%' OR Campaign_Name LIKE '%REDEPLOY%' OR Campaign_Name LIKE '%RBT%') THEN 197


WHEN Media_Code = 'FYI' AND Campaign_Name LIKE '%ONSERT%' AND Campaign_Name  LIKE '%SP%'  THEN 177
WHEN Media_Code = 'FYI' AND Campaign_Name LIKE '%ONSERT%' AND Campaign_Name  LIKE '%TV%'  THEN 178
WHEN Media_Code = 'FYI' AND Campaign_Name LIKE '%ONSERT%' AND (Campaign_Name  LIKE '%wireless%' OR Campaign_Name  LIKE '%WRLS%')  THEN 179
WHEN Media_Code = 'FYI' AND Campaign_Name LIKE '%ONSERT%' AND eCRW_Project_Name LIKE '%HSIA%Sell%' THEN 1279 --HSIA Cross Sell Bill Onsert
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%UNAT_BillMsg%' AND Campaign_Name LIKE '%DTV Eligible%' THEN 181
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%UNAT_BillMsg%' AND Campaign_Name LIKE '%DTV Subs%' THEN 691
WHEN Media_Code = 'FYI' AND Campaign_Name NOT LIKE '%WIRELESS%' AND (Campaign_Name LIKE '%HISPANIC%' OR Campaign_Name LIKE '%SPANISH%' OR Campaign_Name LIKE '%SP%') AND Campaign_Name NOT LIKE '%TV%Upsell%' THEN 174
WHEN Media_Code = 'FYI' AND Campaign_Name LIKE '%WIRELESS%' AND (Campaign_Name LIKE '%HISPANIC%' OR Campaign_Name LIKE '%SPANISH%' OR Campaign_Name LIKE '%SP%') AND Campaign_Name NOT LIKE '%TV%Upsell%' THEN 175
WHEN Media_Code = 'FYI' AND (Campaign_Name LIKE '%HISPANIC%' OR Campaign_Name LIKE '%SPANISH%' OR Campaign_Name LIKE '%SP%') AND Campaign_Name LIKE '%TV%Upsell%' THEN 508
WHEN Media_Code = 'FYI' AND Campaign_Name LIKE '%WIRELESS%' THEN 180
WHEN Media_Code = 'FYI' AND Campaign_Name LIKE '%TV Upsell%' THEN 184
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%HSIA%Sell%' THEN 1278 --HSIA Cross Sell Bill Message

WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%NancyFPCAllIPTVGreen%' AND Campaign_Name LIKE '%Non DSL DTV cross sell HSIA Cross Sell%' THEN 689 --DTV FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%NancyFPCAllIPTVGreen%' AND Campaign_Name LIKE '%Non DSL DTV cross sell DTV Cross Sell%' THEN 182 --Wireline FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%NancyFPCDSLCust%' AND Campaign_Name LIKE '%DSL Subscriber cross sell DTV Cross Sell%' THEN 801 --Wireline Migrator BBMig FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%NancyFPCDSLCust%' AND Campaign_Name LIKE '%DSL Subscriber cross sell HSIA Cross Sell%' THEN 799 --Wireline Migrator DTV FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%DTVCrossSellUVBill%' THEN 183 --TV Cross Sell FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%HSIA%Sell%' THEN 1248 --HSIA Cross Sell FPC

WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Uverse OE%' THEN 1026 --TV Cross Sell OE


WHEN Media_Code = 'LP' THEN 506

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


