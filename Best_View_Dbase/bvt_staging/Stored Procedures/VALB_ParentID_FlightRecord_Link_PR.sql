USE [UVAQ_STAGING]
GO

/****** Object:  StoredProcedure [bvt_staging].[VALB_ParentID_FlightRecord_Link_PR]    Script Date: 02/18/2016 17:05:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









ALTER PROC [bvt_staging].[VALB_ParentID_FlightRecord_Link_PR]

AS
BEGIN
	SET NOCOUNT ON;



IF Object_ID('bvt_staging.VALB_pID_FlightPlan_Clean') IS NOT NULL
TRUNCATE TABLE bvt_staging.VALB_pID_FlightPlan_Clean

IF Object_ID('bvt_staging.VALB_pID_FlightPlan_other') IS NOT NULL
TRUNCATE TABLE bvt_staging.VALB_pID_FlightPlan_other

IF Object_ID('bvt_staging.VALB_pID_FlightPlan_NoMatch') IS NOT NULL
TRUNCATE TABLE bvt_staging.VALB_pID_FlightPlan_NoMatch

IF Object_ID('bvt_staging.VALB_pID_FlightPlan_Dups') IS NOT NULL
TRUNCATE TABLE bvt_staging.VALB_pID_FlightPlan_Dups


INSERT INTO UVAQ.bvt_processed.VALB_ActiveCampaigns
SELECT DISTINCT a.ParentID, a.Campaign_Name, a.eCRW_Project_Name, a.eCRW_Classification_Name, d.Cell_DTV_FLAG, a.Start_Date, a.Media_Code, a.Vendor, GETDATE()
	FROM JAVDB.IREPORT_2015.dbo.WB_01_Campaign_List AS a JOIN JAVDB.IREPORT_2015.dbo.WB_00_Reporting_Hierarchy AS b
      ON a.tactic_id=b.id
    LEFT JOIN JAVDB.IREPORT_2015.dbo.WB_01_Campaign_List d
	ON a.ParentID = d.ParentID
     WHERE b.Scorecard_Top_Tab = 'Direct Marketing'
AND  b.Scorecard_LOB_Tab = 'Value'
AND  b.Scorecard_tab = 'Value'
AND  d.business_unit_name LIKE '%Value Live Base%'

AND a.End_Date_Traditional>='28-DEC-2015'
	AND a.Media_Code <> 'DR'
	AND a.parentID  NOT IN (SELECT parentID FROM UVAQ.bvt_processed.VALB_ActiveCampaigns)
	AND a.campaign_name NOT LIKE '%Commitment View%'
	AND a.campaign_name NOT LIKE '%Remaining data%'
	AND a.campaign_name NOT LIKE '%best View Objectives%'



SELECT ParentID,

CASE 

--Bill Media -- Bill Inserts
WHEN Media_Code = 'BI' AND (ecrw_classification_name LIKE  '%Bundles IPDSL%' OR ecrw_classification_name LIKE  '%Bundles Legacy%') AND Campaign_Name LIKE '%Bundles%' THEN 452
WHEN Media_Code = 'BI' AND ecrw_classification_name LIKE  '%DSL%' THEN 453
WHEN Media_Code = 'BI' AND ecrw_classification_name LIKE  '%Wireless%' THEN 454
WHEN Media_Code = 'BI' AND ecrw_classification_name LIKE  '%DSL in WLS%' THEN 461
WHEN Media_Code = 'BI' AND ecrw_classification_name LIKE  '%DIRECTV%' THEN 603
WHEN Media_Code = 'BI' AND ecrw_classification_name LIKE  '%IP Migration%' THEN 606

--Bill Media -- BAM
WHEN Media_Code = 'BAM' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' THEN 809
WHEN Media_Code = 'BAM' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 810

--Bill Media -- OE/RE
WHEN Media_Code = 'OE' THEN 628
WHEN Media_Code = 'Remit' THEN 629

--Bill Media -- FYI
WHEN Media_Code = 'FYI' AND ecrw_classification_name LIKE  '%Bundles Legacy%' THEN 465
WHEN Media_Code = 'FYI' AND ecrw_classification_name LIKE  '%Broadband IPDSL%' THEN 466
WHEN Media_Code = 'FYI' AND ecrw_classification_name LIKE  '%Broadband Legacy%' THEN 467
WHEN Media_Code = 'FYI' AND ecrw_classification_name LIKE  '%Opportunity Legacy%' THEN 468
WHEN Media_Code = 'FYI' AND ecrw_classification_name LIKE  '%IP Migration%' THEN 470
WHEN Media_Code = 'FYI' AND ecrw_classification_name LIKE  '%Welcome Legacy%' THEN 471
WHEN Media_Code = 'FYI' AND ecrw_classification_name LIKE  '%Bundles IPDSL%' AND (eCRW_Project_Name LIKE '%UVSWelcome%' OR eCRW_Project_Name LIKE '%UvsWelcome%') THEN 627

--Bill Media -- Onsert
WHEN Media_Code = 'FYI' AND ecrw_classification_name LIKE  '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%ONSERT_Welcome%' THEN 610
WHEN Media_Code = 'FYI' AND ecrw_classification_name LIKE  '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%ONSERT_Upgrade%' THEN 607
WHEN Media_Code = 'FYI' AND ecrw_classification_name LIKE  '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%ONSERT_Voice%' THEN 608

--Bill Media -- FPC
WHEN Media_Code = 'FPC' AND ecrw_classification_name LIKE  '%DIRECTV%' THEN 992

WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%FPC_T21_IPDSL%' AND Campaign_Name LIKE '%TDM%' AND Campaign_Name NOT LIKE '%TDM+WLS%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' THEN 462 -- FPC IP - DTV - TDM
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%FPC_T21_IPDSL%' AND Campaign_Name LIKE '%TDM+WLS%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%'  THEN 872 -- FPC IP - DTV - TDM+WLS
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%FPC_T21_IPDSL%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%'  THEN 462 -- FPC IP - DTV - TDM
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%FPC_T21_IPDSL%' AND Campaign_Name LIKE '%TDM+DTV%' AND Campaign_Name NOT LIKE '%TDM+DTV+WLS%' AND Cell_DTV_Flag LIKE '%NON_DTV%'  THEN 875 -- FPC IP - Non_DTV - TDM+DTV
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%FPC_T21_IPDSL%' AND Campaign_Name LIKE '%TDM+WLS%' AND Cell_DTV_Flag LIKE '%NON_DTV%'  THEN 874 -- FPC IP - Non_DTV - TDM+WLS
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%FPC_T21_IPDSL%' AND Campaign_Name LIKE '%TDM+DTV+WLS%' AND Cell_DTV_Flag LIKE '%NON_DTV%'  THEN 876 -- FPC IP - Non_DTV - TDM+WLS+DTV
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%FPC_T21_IPDSL%' THEN 873 -- FPC IP - Non_DTV - TDM

WHEN Media_Code = 'FPC' AND ecrw_classification_name LIKE  '%Bundles Legacy%' AND eCRW_Project_Name LIKE '%FPC_T21_Bundles%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_FLAG NOT LIKE '%NON_DTV%' THEN 622
WHEN Media_Code = 'FPC' AND ecrw_classification_name LIKE  '%Bundles Legacy%' AND eCRW_Project_Name LIKE '%FPC_T21_Bundles%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 877

WHEN Media_Code = 'FPC' AND ecrw_classification_name LIKE  '%Bundles Legacy%' AND eCRW_Project_Name LIKE '%FPC_T21_CLM_WLN_Welcome%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' THEN 626
WHEN Media_Code = 'FPC' AND ecrw_classification_name LIKE  '%Bundles Legacy%' AND eCRW_Project_Name LIKE '%FPC_T21_CLM_WLN_Welcome%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 899

WHEN Media_Code = 'FPC' AND ecrw_classification_name LIKE  '%Upgrade IPDSL%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' THEN 935
WHEN Media_Code = 'FPC' AND ecrw_classification_name LIKE  '%Upgrade IPDSL%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 936

WHEN Media_Code = 'FPC' AND ecrw_classification_name LIKE  '%Welcome IPDSL%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' THEN 624
WHEN Media_Code = 'FPC' AND ecrw_classification_name LIKE  '%Welcome IPDSL%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 897

WHEN Media_Code = 'FPC' AND ecrw_classification_name LIKE  '%DSL%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' THEN 463
WHEN Media_Code = 'FPC' AND ecrw_classification_name LIKE  '%DSL%' AND Campaign_Name LIKE '%DTV%' THEN 871
WHEN Media_Code = 'FPC' AND ecrw_classification_name LIKE  '%DSL%' THEN 463

WHEN Media_Code = 'FPC' AND ecrw_classification_name LIKE  '%UVV%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' THEN 625
WHEN Media_Code = 'FPC' AND ecrw_classification_name LIKE  '%UVV%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 898

WHEN Media_Code = 'FPC' AND ecrw_classification_name LIKE  '%IP Migration%' THEN 464

--Direct Mail -- New Connect
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%New Connect IPDSL%' AND eCRW_Project_Name LIKE '%NewConnect_T3%' AND Campaign_Name LIKE '%DTV elig%'  THEN 436 -- DM Magalog NC T3 - DTV
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%New Connect IPDSL%' AND eCRW_Project_Name LIKE '%NewConnect_T3%' AND Cell_DTV_Flag LIKE '%Non_DTV%'  THEN 435 -- DM Magalog NC T3 - Non_DTV
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%New Connect IPDSL%' AND eCRW_Project_Name LIKE '%NewConnect_T3%' AND Cell_DTV_Flag LIKE '%DTV%'  THEN 436 -- DM Magalog NC T3 - DTV

WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%New Connect IPDSL%' AND eCRW_Project_Name LIKE '%NewConnect_T2%' AND Campaign_Name LIKE '%DTV elig%'  THEN 867 -- DM New Connect T2 - DTV
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%New Connect IPDSL%' AND eCRW_Project_Name LIKE '%NewConnect_T2%' AND Cell_DTV_Flag LIKE '%Non_DTV%'  THEN 868 -- DM New Connect T2 - Non_DTV
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%New Connect IPDSL%' AND eCRW_Project_Name LIKE '%NewConnect_T2%' AND Cell_DTV_Flag LIKE '%DTV%'  THEN 867 -- DM New Connect T2 - DTV

WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%New Connect IPDSL%' AND eCRW_Project_Name LIKE '%NewConnect_T1%' AND Campaign_Name LIKE '%DTV elig%'  THEN 447 -- DM New Connect T1 - DTV
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%New Connect IPDSL%' AND eCRW_Project_Name LIKE '%NewConnect_T1%' AND Cell_DTV_Flag LIKE '%Non_DTV%'  THEN 448 -- DM New Connect T1 - Non_DTV
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%New Connect IPDSL%' AND eCRW_Project_Name LIKE '%NewConnect_T1%' AND Cell_DTV_Flag LIKE '%DTV%'  THEN 447 -- DM New Connect T1 - DTV

--Direct Mail -- Migration
WHEN Media_Code = 'DM' AND  ecrw_classification_name LIKE '%IP Migration%' AND (eCRW_Project_Name LIKE '%DM_Migration_T1%' OR eCRW_Project_Name LIKE '%DM_Migration_T3%') THEN 440 -- DM Migration T1 & T3
WHEN Media_Code = 'DM' AND  ecrw_classification_name LIKE '%IP Migration%' AND (eCRW_Project_Name LIKE '%DM_Migration_T2%' OR eCRW_Project_Name LIKE '%DM_Migration_T4%') THEN 615 -- DM Migration T2 & T4

--Direct Mail -- Bundles

WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchA%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' AND (Campaign_Name LIKE '%TDM+WLS%' OR Campaign_Name LIKE '%+WLS%') THEN 813 -- DM Bundles A IP - DTV - TDM+WLS
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchA%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' AND Campaign_Name NOT LIKE '%DTV%' THEN 437 --DM Bundles A IP - DTV - TDM
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchA%' AND Cell_DTV_Flag LIKE '%Non-DTV%' AND Campaign_Name LIKE '%TDM+WLS%' AND Campaign_Name NOT LIKE '%DTV%' THEN 817 -- DM Bundles A IP - Non_DTV - TDM+WLS
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchA%' AND Campaign_Name NOT LIKE '%DTV%' AND Campaign_Name LIKE '%+WLS%' THEN 813 --DM Bundles A IP - DTV - TDM+WLS
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchA%' AND Campaign_Name NOT LIKE '%DTV%' AND Campaign_Name NOT LIKE '%MDU%' THEN 437 --DM Bundles A IP - DTV - TDM
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchA%' AND (Campaign_Name LIKE '%TDM+DTV+WLS%' OR Campaign_Name LIKE '%+DTV+WLS%' OR Campaign_Name LIKE '%+WLS+DTV%') THEN 819 -- DM Bundles A IP - Non_DTV - TDM+WLS+DTV
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchA%' AND (Campaign_Name LIKE '%TDM+DTV%' OR Campaign_Name LIKE '%+DTV%') THEN 818 -- DM Bundles A IP - Non_DTV - TDM+DTV
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchA%' AND (Campaign_Name LIKE '%TDM+WLS%' OR Campaign_Name LIKE '%+WLS%') THEN 817 -- DM Bundles A IP - Non_DTV - TDM+WLS
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchA%' THEN 815 -- DM Bundles A IP - Non_DTV - TDM

WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchB%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' AND (Campaign_Name LIKE '%TDM+WLS%' OR Campaign_Name LIKE '%+WLS%') THEN 821 -- DM Bundles B IP - DTV - TDM+WLS
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchB%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' AND Campaign_Name NOT LIKE '%DTV%' THEN 820 --DM Bundles B IP - DTV - TDM
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchB%' AND Cell_DTV_Flag LIKE '%Non-DTV%' AND Campaign_Name LIKE '%TDM+WLS%' AND Campaign_Name NOT LIKE '%DTV%' THEN 825 -- DM Bundles B IP - Non_DTV - TDM+WLS
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchB%' AND Campaign_Name NOT LIKE '%DTV%' AND Campaign_Name LIKE '%+WLS%' THEN 821 --DM Bundles B IP - DTV - TDM+WLS
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchB%' AND Campaign_Name NOT LIKE '%DTV%' AND Campaign_Name NOT LIKE '%MDU%' THEN 820 --DM Bundles B IP - DTV - TDM
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchB%' AND (Campaign_Name LIKE '%TDM+DTV+WLS%' OR Campaign_Name LIKE '%+DTV+WLS%' OR Campaign_Name LIKE '%+WLS+DTV%') THEN 827 -- DM Bundles B IP - Non_DTV - TDM+WLS+DTV
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchB%' AND (Campaign_Name LIKE '%TDM+DTV%' OR Campaign_Name LIKE '%+DTV%') THEN 826 -- DM Bundles B IP - Non_DTV - TDM+DTV
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchB%' AND (Campaign_Name LIKE '%TDM+WLS%' OR Campaign_Name LIKE '%+WLS%') THEN 825 -- DM Bundles B IP - Non_DTV - TDM+WLS
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchB%' THEN 822 -- DM Bundles B IP - Non_DTV - TDM

WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchC%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' AND (Campaign_Name LIKE '%TDM+WLS%' OR Campaign_Name LIKE '%+WLS%') THEN 829 -- DM Bundles C IP - DTV - TDM+WLS
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchC%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' AND Campaign_Name NOT LIKE '%DTV%' THEN 828 --DM Bundles C IP - DTV - TDM
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchC%' AND Cell_DTV_Flag LIKE '%Non-DTV%' AND Campaign_Name LIKE '%TDM+WLS%' AND Campaign_Name NOT LIKE '%DTV%' THEN 831 -- DM Bundles C IP - Non_DTV - TDM+WLS
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchC%' AND Campaign_Name NOT LIKE '%DTV%' AND Campaign_Name LIKE '%+WLS%' THEN 829 --DM Bundles C IP - DTV - TDM+WLS
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchC%' AND Campaign_Name NOT LIKE '%DTV%' AND Campaign_Name NOT LIKE '%MDU%' THEN 828 --DM Bundles C IP - DTV - TDM
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchC%' AND (Campaign_Name LIKE '%TDM+DTV+WLS%' OR Campaign_Name LIKE '%+DTV+WLS%' OR Campaign_Name LIKE '%+WLS+DTV%') THEN 833 -- DM Bundles C IP - Non_DTV - TDM+WLS+DTV
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchC%' AND (Campaign_Name LIKE '%TDM+DTV%' OR Campaign_Name LIKE '%+DTV%') THEN 832 -- DM Bundles C IP - Non_DTV - TDM+DTV
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchC%' AND (Campaign_Name LIKE '%TDM+WLS%' OR Campaign_Name LIKE '%+WLS%') THEN 831 -- DM Bundles C IP - Non_DTV - TDM+WLS
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%TouchC%' THEN 830 -- DM Bundles C IP - Non_DTV - TDM

WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE  '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%BBX_Monthly%' THEN 836 --BBX put all in TDM Non_DTV Opp due to lack of info
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE  '%Bundles Legacy%' AND eCRW_Project_Name LIKE '%BBX_Monthly%' THEN 836 --BBX put all in TDM Non_DTV Opp due to lack of info

--Direct Mail Anniversary/Loyalty
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%ANNIVERSARY%' AND (Campaign_Name LIKE '%DM_DTV%' OR Campaign_Name LIKE '%DM_DTIV%') THEN 878
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%ANNIVERSARY%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 879
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%ANNIVERSARY%' THEN 878

WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%6_Month%' AND Campaign_Name LIKE '%DM_DTV%' THEN 449
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%6_Month%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 880
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%6_Month%' THEN 449

--Direct Mail Recontact/Responder
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Recontact IPDSL%' AND eCRW_Project_Name LIKE '%Responder%' AND eCRW_Project_Name NOT LIKE '%ResponderTouch2%' THEN 858
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Recontact IPDSL%' AND eCRW_Project_Name LIKE '%ResponderTouch2%' THEN 863
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Recontact IPDSL%' AND eCRW_Project_Name LIKE '%Recontact%' AND eCRW_Project_Name NOT LIKE '%RecontactTouch2%' THEN 848
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Recontact IPDSL%' AND eCRW_Project_Name LIKE '%RecontactTouch2%' THEN 853
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Recontact Legacy%' AND eCRW_Project_Name LIKE '%Responder%' AND eCRW_Project_Name NOT LIKE '%ResponderTouch2%' THEN 858
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Recontact Legacy%' AND eCRW_Project_Name LIKE '%ResponderTouch2%' THEN 863
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Recontact Legacy%' AND eCRW_Project_Name LIKE '%Recontact%' AND eCRW_Project_Name NOT LIKE '%RecontactTouch2%' THEN 848
WHEN Media_Code = 'DM' AND ecrw_classification_name LIKE '%Recontact Legacy%' AND eCRW_Project_Name LIKE '%RecontactTouch2%' THEN 853

--Email Hispanic
WHEN Media_Code = 'EM' AND (eCRW_Project_Name LIKE '%Hispanic%' OR eCRW_Project_Name LIKE '%HSVA%') AND Campaign_Name LIKE '%DTV%' THEN 881 --EM Hispanic - Non_DTV
WHEN Media_Code = 'EM' AND (eCRW_Project_Name LIKE '%Hispanic%' OR eCRW_Project_Name LIKE '%HSVA%') THEN 432 --EM Hispanic - DTV

--Email IP Migration
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%IP Migration%' AND eCRW_Project_Name LIKE '%EM_Migration%' THEN 487 --EM Migration

--Email Upgrade
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%Upgrade IPDSL%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 884
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%Upgrade IPDSL%' THEN 485

--Email Welcome Stream
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%New Connect IPDSL%' AND eCRW_Project_Name LIKE '%Welcome_Stream%' AND Campaign_Name LIKE '%T1%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' THEN 924
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%New Connect IPDSL%' AND eCRW_Project_Name LIKE '%Welcome_Stream%' AND Campaign_Name LIKE '%T1%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 926
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%New Connect IPDSL%' AND eCRW_Project_Name LIKE '%Welcome_Stream%' AND Campaign_Name LIKE '%T2%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' THEN 927
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%New Connect IPDSL%' AND eCRW_Project_Name LIKE '%Welcome_Stream%' AND Campaign_Name LIKE '%T2%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 928
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%New Connect IPDSL%' AND eCRW_Project_Name LIKE '%Welcome_Stream%' AND Campaign_Name LIKE '%T3%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' THEN 929
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%New Connect IPDSL%' AND eCRW_Project_Name LIKE '%Welcome_Stream%' AND Campaign_Name LIKE '%T3%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 930
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%New Connect IPDSL%' AND eCRW_Project_Name LIKE '%Welcome_Stream%' AND Campaign_Name LIKE '%T4%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' THEN 931
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%New Connect IPDSL%' AND eCRW_Project_Name LIKE '%Welcome_Stream%' AND Campaign_Name LIKE '%T4%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 932
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%New Connect IPDSL%' AND eCRW_Project_Name LIKE '%Welcome_Stream%' AND Campaign_Name LIKE '%T5%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' THEN 933
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%New Connect IPDSL%' AND eCRW_Project_Name LIKE '%Welcome_Stream%' AND Campaign_Name LIKE '%T5%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 934

--Email Sign up Cancel
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%IPDSL%' AND eCRW_Project_Name LIKE '%Email_Sign_Up_and_Cancel%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 883
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%IPDSL%' AND eCRW_Project_Name LIKE '%Email_Sign_Up_and_Cancel%' THEN 486

--Email -- Bundles
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%Email_Monthly%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' AND (Campaign_Name LIKE '%TDM+WLS%' OR Campaign_Name LIKE '%+WLS%') THEN 474 -- EM Bundles IP - DTV - TDM+WLS
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%Email_Monthly%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%NON_DTV%' AND Campaign_Name NOT LIKE '%DTV%' THEN 885 --EM Bundles IP - DTV - TDM
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%Email_Monthly%' AND Cell_DTV_Flag LIKE '%Non-DTV%' AND Campaign_Name LIKE '%TDM+WLS%' AND Campaign_Name NOT LIKE '%DTV%' THEN 888 -- EM Bundles IP - Non_DTV - TDM+WLS
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%Email_Monthly%' AND Campaign_Name NOT LIKE '%DTV%' AND Campaign_Name LIKE '%+WLS%' THEN 474 --EM Bundles IP - DTV - TDM+WLS
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%Email_Monthly%' AND Campaign_Name NOT LIKE '%DTV%' AND Campaign_Name NOT LIKE '%MDU%' THEN 885 --EM Bundles IP - DTV - TDM
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%Email_Monthly%' AND (Campaign_Name LIKE '%TDM+DTV+WLS%' OR Campaign_Name LIKE '%+DTV+WLS%' OR Campaign_Name LIKE '%+WLS+DTV%') THEN 887 -- EM Bundles IP - Non_DTV - TDM+WLS+DTV
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%Email_Monthly%' AND (Campaign_Name LIKE '%TDM+DTV%' OR Campaign_Name LIKE '%+DTV%') THEN 886 -- EM Bundles IP - Non_DTV - TDM+DTV
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%Email_Monthly%' AND (Campaign_Name LIKE '%TDM+WLS%' OR Campaign_Name LIKE '%+WLS%') THEN 888 -- EM Bundles IP - Non_DTV - TDM+WLS
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%Bundles IPDSL%' AND eCRW_Project_Name LIKE '%Email_Monthly%' THEN 889 -- EM Bundles IP - Non_DTV - TDM

WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%Bundles Legacy%' AND Campaign_Name LIKE '%DTV Elig%' THEN 472
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%Bundles Legacy%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 890
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%Bundles Legacy%' THEN 472

WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%IPDSL%' AND eCRW_Project_Name LIKE '%Email_Sign_Up_and_Cancel%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 883 --EM Sign up Cancel - Non_DTV
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%IPDSL%' AND eCRW_Project_Name LIKE '%Email_Sign_Up_and_Cancel%' THEN 486 --EM Sign up Cancel - DTV

--Email New Connect
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%New Connect Legacy%' AND Campaign_Name LIKE '%DTV%' THEN 478
WHEN Media_Code = 'EM' AND ecrw_classification_name LIKE '%New Connect Legacy%' THEN 479

--Email Trigger
WHEN Media_Code = 'EM' AND (ecrw_classification_name LIKE '%Online Trigger IPDSL%' OR ecrw_classification_name LIKE '%Online Trigger Legacy%') AND Campaign_Name LIKE '%DTV Elig%' THEN 475
WHEN Media_Code = 'EM' AND (ecrw_classification_name LIKE '%Online Trigger IPDSL%' OR ecrw_classification_name LIKE '%Online Trigger Legacy%') AND Campaign_Name LIKE '%DTV%' THEN 480
WHEN Media_Code = 'EM' AND (ecrw_classification_name LIKE '%Online Trigger IPDSL%' OR ecrw_classification_name LIKE '%Online Trigger Legacy%') THEN 475

--Email Recontact/Responder
WHEN Media_Code = 'EM' AND (ecrw_classification_name LIKE '%Recontact IPDSL%' OR ecrw_classification_name LIKE '%Recontact Legacy%') AND eCRW_Project_Name LIKE '%Recontact%' AND Campaign_Name LIKE '%DTV Elig%' THEN 476
WHEN Media_Code = 'EM' AND (ecrw_classification_name LIKE '%Recontact IPDSL%' OR ecrw_classification_name LIKE '%Recontact Legacy%') AND eCRW_Project_Name LIKE '%Recontact%' AND Campaign_Name LIKE '%DTV%' THEN 620
WHEN Media_Code = 'EM' AND (ecrw_classification_name LIKE '%Recontact IPDSL%' OR ecrw_classification_name LIKE '%Recontact Legacy%') AND eCRW_Project_Name LIKE '%Recontact%' THEN 476

WHEN Media_Code = 'EM' AND (ecrw_classification_name LIKE '%Recontact IPDSL%' OR ecrw_classification_name LIKE '%Recontact Legacy%') AND eCRW_Project_Name LIKE '%Responder%' AND Campaign_Name LIKE '%DTV Elig%' THEN 477
WHEN Media_Code = 'EM' AND (ecrw_classification_name LIKE '%Recontact IPDSL%' OR ecrw_classification_name LIKE '%Recontact Legacy%') AND eCRW_Project_Name LIKE '%Responder%' AND Campaign_Name LIKE '%DTV%' THEN 882
WHEN Media_Code = 'EM' AND (ecrw_classification_name LIKE '%Recontact IPDSL%' OR ecrw_classification_name LIKE '%Recontact Legacy%') AND eCRW_Project_Name LIKE '%Responder%' THEN 477

WHEN Media_Code = 'EM' AND (ecrw_classification_name LIKE '%Recontact IPDSL%' OR ecrw_classification_name LIKE '%Recontact Legacy%') AND eCRW_Project_Name LIKE '%Responder%' AND Campaign_Name LIKE '%DTV Elig%' THEN 477
WHEN Media_Code = 'EM' AND (ecrw_classification_name LIKE '%Recontact IPDSL%' OR ecrw_classification_name LIKE '%Recontact Legacy%') AND eCRW_Project_Name LIKE '%Responder%' AND Cell_DTV_Flag LIKE '%DTV%' AND Cell_DTV_Flag NOT LIKE '%Non_DTV%' THEN 477
WHEN Media_Code = 'EM' AND (ecrw_classification_name LIKE '%Recontact IPDSL%' OR ecrw_classification_name LIKE '%Recontact Legacy%') AND eCRW_Project_Name LIKE '%Responder%' AND Cell_DTV_Flag LIKE '%Non_DTV%' THEN 882
WHEN Media_Code = 'EM' AND (ecrw_classification_name LIKE '%Recontact IPDSL%' OR ecrw_classification_name LIKE '%Recontact Legacy%') AND eCRW_Project_Name LIKE '%Responder%' THEN 477



ELSE 0 END AS idProgram_Touch_Definitions,

'' AS idFlight_Plan_Records

INTO #ParentID_ID_Link

FROM UVAQ.bvt_processed.VALB_ActiveCampaigns

	
SELECT a.[ParentID], a.idProgram_Touch_Definitions, c.idFlight_Plan_Records
INTO #ParentID_ID_Link2

FROM #ParentID_ID_Link a
JOIN UVAQ.bvt_processed.VALB_ActiveCampaigns b ON a.parentID = b.ParentID
LEFT JOIN (SELECT Distinct 
       [idFlight_Plan_Records]
      ,idProgram_Touch_Definitions_TBL_FK 
      ,[InHome_Date]
		FROM UVAQ.bvt_prod.VALB_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0) c
ON (a.idprogram_Touch_Definitions = c.idProgram_Touch_Definitions_TBL_FK  AND
(c.InHome_Date BETWEEN Dateadd(D, -5,b.[Start_Date]) AND  Dateadd(D, 5, b.[Start_Date])))
ORDER BY a.idProgram_Touch_Definitions




--for QC purposes adds information about touch type and campaign instead of only having ID numbers and puts it into the different category tables.

--Clean = flight plan has exact in home date match.

INSERT INTO bvt_staging.VALB_pID_FlightPlan_Clean
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Start_Date, b.Vendor,
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.VALB_ActiveCampaigns b ON a.parentID = b.ParentID
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
		FROM UVAQ.bvt_prod.VALB_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where b.Start_Date = d.InHome_Date
AND a.ParentID not in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate =Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


--Flight plan has record within +/- 5 days of eCRW in home date but does not match exactly.
INSERT INTO bvt_staging.VALB_pID_FlightPlan_Other
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Start_Date, b.Vendor,
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.VALB_ActiveCampaigns b ON a.parentID = b.ParentID
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
		FROM UVAQ.bvt_prod.VALB_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where b.Start_Date <> d.InHome_Date and d.InHome_Date is not null
AND a.ParentID not in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate = Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


--eCRW information does not have matching flight plan within +/- 5 days.

INSERT INTO bvt_staging.VALB_pID_FlightPlan_NoMatch
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Start_Date, b.Vendor,
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], Coalesce(d.Touch_Name, e.Touch_Name) as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], Coalesce(d.Media, e.Media) as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.VALB_ActiveCampaigns b ON a.parentID = b.ParentID
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
		FROM UVAQ.bvt_prod.VALB_Best_View_Forecast_VW_FOR_LINK
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
INSERT INTO bvt_staging.VALB_pID_FlightPlan_Dups
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Start_Date, b.Vendor,
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.VALB_ActiveCampaigns b ON a.parentID = b.ParentID
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
		FROM UVAQ.bvt_prod.VALB_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where a.ParentID in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate = Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


END












GO


