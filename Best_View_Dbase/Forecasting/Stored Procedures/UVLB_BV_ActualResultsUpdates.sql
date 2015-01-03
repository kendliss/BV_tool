









----Updates the ParentID Listing for Current UVAQ LB Campaigns
----Run Stored Proc Weekly After Main Table Updates

CREATE PROCEDURE [Forecasting].[UVLB_BV_ActualResultsUpdates]
as
---Insert New ParentID and Campaign Information
INSERT INTO Results.UVAQ_LB_2012_Active_Campaigns
(ParentID, Campaign_Name, [Start_Date], Media_Scorecard, Vendor)
SELECT DISTINCT ParentID, Campaign_Name, [Start_Date], a.Media_Code, Vendor
	FROM JAVDB.IREPORT.dbo.IR_Campaign_Data_Latest_MAIN_2012 as a join JAVDB.IREPORT.dbo.ir_a_ownertypetactic_matrix as b
      on a.tactic_id=b.id
     where b.Scorecard_Top_Tab = 'Direct Marketing'
and  b.Scorecard_LOB_Tab = 'U-verse'
and  b.Scorecard_tab = 'Uverse Base Acq'

AND ([Start_Date]<= '28-DEC-2014' and End_Date_Traditional>='29-DEC-2012') 
	and a.Media_Code <> 'DR'
	and ParentID > 1334
	and ParentID not in (SELECT ParentID from Results.UVAQ_LB_2012_Active_Campaigns)
	and campaign_name not like '%Commitment View%'
	and campaign_name not like '%Remaining data%'


---Insert New ParentID and Touch_Type_Links
INSERT INTO Results.ParentID_Touch_Type_Link
(ParentID, Touch_Type_FK)
SELECT ParentID,
CASE 

--catalog
WHEN media_scorecard = 'CA' AND Campaign_Name LIKE '%over%' THEN 172
WHEN media_scorecard = 'CA' AND (Campaign_Name LIKE '%FRESH%' OR Campaign_Name LIKE '%NEW GREEN%') AND Campaign_Name NOT LIKE '%TOUCH%' AND Campaign_Name NOT LIKE '%T3%' THEN 71
WHEN media_scorecard = 'CA' AND Campaign_Name NOT LIKE '%TOUCH%' AND Campaign_Name NOT LIKE '%T3%' and Campaign_Name  like '%Non-IRU%' and Campaign_Name like '%(WLN)%'  THEN 70
WHEN media_scorecard = 'CA' AND Campaign_Name NOT LIKE '%TOUCH%' AND Campaign_Name NOT LIKE '%T3%' and Campaign_Name  like '%Non-IRU%' and  Campaign_Name  like '%(WLS)%' THEN 68
WHEN media_scorecard = 'CA' AND Campaign_Name NOT LIKE '%TOUCH%' AND Campaign_Name NOT LIKE '%T3%' and Campaign_Name like '%IRU%'and Campaign_Name not like '%Fresh%' THEN 163
WHEN media_scorecard = 'CA' AND (Campaign_Name LIKE '%TOUCH%' OR Campaign_Name LIKE '%T3%') THEN 41
WHEN media_scorecard = 'CA' AND Campaign_Name LIKE '%TV%' THEN 43

--tv upsell dm
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%TV UPSELL%' or Campaign_Name LIKE '%TV UP%') and ((campaign_name like ('%never%') or campaign_name like ('% NH %') or campaign_name like ('% NH%')or campaign_name like ('%NH%')))and (campaign_name not like '%mid%' Or campaign_name not like '%early%' OR campaign_name not like '%late%') then 176
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%TV UPSELL%' or Campaign_Name LIKE '%TV UP%') and ((campaign_name like ('%win%') or campaign_name like ('% WB %')or campaign_name like ('% WB%')or campaign_name like ('%WB%')))and (campaign_name not like '%mid%' Or campaign_name not like '%early%' OR campaign_name not like '%late%') then 175
WHEN media_scorecard = 'DM' AND campaign_name not like '%Mid TV upsell champ%' and (Campaign_Name LIKE '%TV UPSELL%' or Campaign_Name LIKE '%TV UP%') and (campaign_name not like '%mid%' Or campaign_name not like '%early%' OR campaign_name not like '%late%')   THEN 30

--DTR
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%DRIVE%' OR Campaign_Name LIKE '%DTR%' THEN 29

--Trigger DM
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%CONNECT%' AND Campaign_Name NOT LIKE '%IRU%'THEN 94
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%CONNECT%' AND Campaign_Name LIKE '%IRU%%' THEN 93
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%contact%' AND Campaign_Name NOT LIKE '%IRU%' THEN 102
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%contact%' AND Campaign_Name  LIKE '%IRU%' THEN 101
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%WINBACK%' AND Campaign_Name NOT LIKE '%IRU%' AND Campaign_Name NOT LIKE '%Wireless%'THEN 105
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%WINBACK%' AND Campaign_Name NOT LIKE '%IRU%' AND Campaign_Name NOT LIKE '%wireline%'THEN 103
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%WINBACK%' AND Campaign_Name  LIKE '%IRU%' THEN 104
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%Click RESPONDER%' THEN 340
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%RESPONDER%' THEN 63
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%DATA%'  THEN 48
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%CREDIT%' THEN 96
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%ONLINE%' or campaign_name like '%oec%') AND Campaign_Name NOT LIKE '%IRU%' THEN 92
WHEN media_scorecard = 'DM' and (Campaign_Name LIKE '%ONLINE%' or campaign_name like '%oec%') AND Campaign_Name LIKE '%IRU%' THEN 91
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%SMART%' OR Campaign_Name LIKE '%SP%') AND Campaign_Name NOT LIKE '%IRU%' THEN 99
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%SMART%' OR Campaign_Name LIKE '%SP%') AND Campaign_Name NOT LIKE '%IRU%' and campaign_name like '%WLS Only%' THEN 97
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%SMART%' OR Campaign_Name LIKE '%SP%') AND Campaign_Name LIKE '%IRU%' THEN 98
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%landline defect%' THEN 178
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%tabletuser%' THEN 64
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%TRIG%' or Campaign_Name LIKE '%GO LOCAL EMERGENCY%') AND Campaign_Name LIKE '%Gig%' THEN 310
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%CANCEL BEFORE%'or Campaign_Name LIKE '%CANCEL B4%' or campaign_name like '%xcell B4%') AND (Campaign_name LIKE '%w/o wls%' or Campaign_name LIKE '%BAU%' or Campaign_name LIKE '%CT%')AND Campaign_Name NOT LIKE '%IRU%' THEN 302
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%CANCEL BEFORE%' or Campaign_Name LIKE '%CANCEL B4%'or campaign_name like '%xcell B4%')AND Campaign_name LIKE '%wls%' AND Campaign_Name NOT LIKE '%IRU%' THEN 300
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%CANCEL BEFORE%' or Campaign_Name LIKE '%CANCEL B4%'or campaign_name like '%xcell B4%')AND Campaign_Name LIKE '%IRU%' THEN 301
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%BUYERS REMORSE%' AND Campaign_Name NOT LIKE '%IRU%' THEN 300
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%BUYERS REMORSE%' AND Campaign_Name  LIKE '%IRU%' THEN 301
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%INSTALLATION ISSUES%' AND Campaign_Name NOT LIKE '%IRU%' THEN 300
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%INSTALLATION ISSUES%' AND Campaign_Name  LIKE '%IRU%' THEN 301


--trig engagement email
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%engage%' THEN 132
WHEN media_scorecard = 'EM' AND Campaign_Name NOT LIKE '%re-eng%'and (Campaign_Name LIKE '%ENGAGE%' OR Campaign_Name LIKE '%ENG%' OR Campaign_Name LIKE '%ENG%')  AND Campaign_Name NOT LIKE '%TV Upsell%' AND Campaign_Name NOT LIKE '%TV UP%' AND Campaign_Name NOT LIKE '%TRIG%'  and Campaign_Name NOT LIKE '%IRU%'and Campaign_Name NOT LIKE '%IRU%' and Campaign_Name NOT LIKE '%re-eng%'  THEN 111
WHEN media_scorecard = 'EM' AND Campaign_Name NOT LIKE '%re-eng%'and(Campaign_Name LIKE '%ENGAGE%' OR Campaign_Name LIKE '%ENG%' OR Campaign_Name LIKE '%ENG%') AND Campaign_Name NOT LIKE '%TV Upsell%'  AND Campaign_Name NOT LIKE '%TV UP%' AND Campaign_Name NOT LIKE '%TRIG%'  AND Campaign_Name LIKE '%IRU%' and Campaign_Name NOT LIKE '%re-eng%'THEN 112


--Core DM
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%EARLY%' or Campaign_name like '%EM DM%' or Campaign_Name LIKE '%2014 April INC%')AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name LIKE '%IRU%'AND Campaign_Name NOT LIKE '%GIG%' THEN 73
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%EARLY%' or Campaign_name like '%EM DM%' or Campaign_Name LIKE '%2014 April INC%') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%SPANISH%' and Campaign_Name like '%Fresh%' AND Campaign_Name NOT LIKE '%GIG%' THEN 75
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%EARLY%' or Campaign_name like '%EM DM%' or Campaign_Name LIKE '%2014 April INC%') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%SPANISH%' and Campaign_Name not like '%WLN w/%' and Campaign_Name not like '%WLS+%'and Campaign_Name not like '%non wls%' and Campaign_Name like '%WLS%'  THEN 72
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%EARLY%' or Campaign_name like '%EM DM%' or Campaign_Name LIKE '%2014 April INC%')AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%SPANISH%'  THEN 74
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%EARLY%' OR Campaign_Name LIKE '%GO LOCAL EMERGENCY%'or Campaign_name like '%EM DM%') AND Campaign_Name LIKE '%SPANISH%'  THEN 179

WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%2014 April UVLB DM Austin Go Local Emergency%' AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name LIKE '%IRU%' THEN 73
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%2014 April UVLB DM Austin Go Local Emergency%' AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%SPANISH%' and Campaign_Name like '%Fresh%'  THEN 75
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%2014 April UVLB DM Austin Go Local Emergency%' AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%SPANISH%' and Campaign_Name not like '%WLN w/ WLS%' and Campaign_Name not like '%WLS+O%'and Campaign_Name not like '%non wls%' and Campaign_Name like '%WLS%' AND Campaign_Name NOT LIKE '%GIG%' THEN 72
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%2014 April UVLB DM Austin Go Local Emergency%' AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%SPANISH%' AND Campaign_Name NOT LIKE '%GIG%' THEN 74

WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%LATE%' OR Campaign_Name LIKE '%3RD%' OR Campaign_Name like 'LM') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name LIKE '%IRU%' AND Campaign_Name NOT LIKE '%GIG%'THEN 77
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%LATE%' OR Campaign_Name LIKE '%3RD%' OR Campaign_Name like 'LM') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%IRU%' and Campaign_Name like '%fresh%'AND Campaign_Name NOT LIKE '%GIG%' THEN 79
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%LATE%' OR Campaign_Name LIKE '%3RD%' OR Campaign_Name like 'LM') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%IRU%' and Campaign_Name not like '%WLN w/ WLS%' and Campaign_Name not like '%WLS+O%'  and Campaign_Name not like '%non wls%' and Campaign_Name like '%WLS%'AND Campaign_Name NOT LIKE '%GIG%' THEN 76
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%LATE%' OR Campaign_Name LIKE '%3RD%' OR Campaign_Name like 'LM') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%IRU%'AND Campaign_Name NOT LIKE '%GIG%' THEN 78
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%LATE%' AND Campaign_Name LIKE '%SPANISH TAG%'  THEN 180

WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%MID%' OR Campaign_Name LIKE '%MM%') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name LIKE '%IRU%'  AND Campaign_Name NOT LIKE '%GIG%' THEN 81
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%MID%' OR Campaign_Name LIKE '%MM%') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name Not LIKE '%IRU%' and Campaign_Name like '%fresh%' AND Campaign_Name NOT LIKE '%GIG%' THEN 83
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%MID%' OR Campaign_Name LIKE '%MM%') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name Not LIKE '%IRU%' and Campaign_Name not like '%WLN w/ WLS%' and Campaign_Name not like '%WLS+O%' and Campaign_Name not like '%WLS+%' and Campaign_Name not like '%non wls%' and Campaign_Name like '%WLS%' AND Campaign_Name NOT LIKE '%GIG%' and campaign_name not like '%Spanish Tag%' THEN 80
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%MID%' OR Campaign_Name LIKE '%MM%') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%IRU%' AND Campaign_Name NOT LIKE '%GIG%' and Campaign_Name not like '%Spanish Tag%' THEN 82
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%MID%' OR Campaign_Name LIKE '%MM%') AND Campaign_Name LIKE '%SPANISH TAG%'  THEN 181

WHEN media_scorecard = 'DM' AND (campaign_name like '%Nov13 LightGig WLN%' OR campaign_name like '%Nov13 LightGig WLS+O%' or campaign_name like '%WLN w/ or w/o WLS%') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%IRU%' THEN 82
WHEN media_scorecard = 'DM' AND (campaign_name like '%Nov13 LightGig WLS%' or campaign_name like '%WLS Only Records%') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name Not LIKE '%IRU%' and Campaign_Name not like '%WLN w/ WLS%' and Campaign_Name not like '%WLS+O%' and Campaign_Name not like '%non wls%' and Campaign_Name like '%WLS%'  THEN 80

WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%Gig%' AND (Campaign_Name LIKE '%IPTV%' OR Campaign_name like '%Light%' AND Campaign_Name NOT LIKE '%WLS ONLY%' AND Campaign_Name NOT LIKE '%(WLS)%') AND Campaign_Name Not LIKE '%IRU%'THEN 305
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%Gig%' AND (Campaign_Name LIKE '%WLS +%' OR Campaign_name LIKE '%(WLS+O)%'OR Campaign_name LIKE '%(WLN)%'OR Campaign_name LIKE '%SUBS%' or Campaign_Name like '%NWLS%') AND Campaign_Name Not LIKE '%IRU%'  THEN 305
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%Gig%' AND (Campaign_Name LIKE '%WLS Only%' OR Campaign_name LIKE '%WLS%') AND Campaign_Name Not LIKE '%IRU%' THEN 307
WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%Gig%' AND Campaign_Name  LIKE '%IRU%' THEN 306

WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%Phone Card%'  THEN 59

WHEN media_scorecard = 'DM' AND Campaign_Name LIKE '%TWC%'  THEN 311

--new green dm hispanic
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%T1%' OR Campaign_Name LIKE '%TOUCH 1%') AND (Campaign_Name LIKE '%BILINGUAL%' OR Campaign_Name LIKE '%HISPANIC%' OR Vendor='Dieste') THEN 7
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%T2%' OR Campaign_Name LIKE '%TOUCH 2%') AND (Campaign_Name LIKE '%BILINGUAL%' OR Campaign_Name LIKE '%HISPANIC%'OR Vendor='Dieste') THEN 8
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%BILINGUAL%' OR Campaign_Name LIKE '%HISPANIC%' OR Campaign_Name LIKE '%SPANISH%' OR Vendor='Dieste') and campaign_name not like '%spanish%' and campaign_name not like '%bilingual bucket test%' and campaign_name not like '%phone card%'THEN 84

--DTV cross sell DM
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%DTV%' OR Campaign_Name LIKE '%CROSS%' OR Campaign_Name LIKE '%cross-sell%' OR Campaign_Name LIKE '%cross sell%') THEN 140

--new green dm
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%TOUCH 1%'OR Campaign_Name LIKE '%T1%' OR Campaign_Name LIKE '%employee%')  AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%trig%' and campaign_name not like '%sp%' and campaign_name not like '%responder%' AND Campaign_Name NOT LIKE '%IRU%' and (Campaign_Name NOT LIKE '%Wireless%' or campaign_name not like '%wls%')THEN 87
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%TOUCH 1%'OR Campaign_Name LIKE '%T1%' OR Campaign_Name LIKE '%employee%')  AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%trig%' AND Campaign_Name NOT LIKE '%IRU%' AND Campaign_Name NOT LIKE '%WIRELINE%' and campaign_name like '%wls%' THEN 85
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%TOUCH 1%'OR Campaign_Name LIKE '%T1%' OR Campaign_Name LIKE '%employee%')  AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' and campaign_name not like '%sp%' and campaign_name not like '%responder%' AND Campaign_Name NOT LIKE '%trig%' AND Campaign_Name LIKE '%IRU%' THEN 86

WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%TOUCH 2%' OR Campaign_Name LIKE '%T2%')  AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%trig%' AND Campaign_Name NOT LIKE '%IRU%' and (Campaign_Name LIKE '%Wireless%' or campaign_name like '%wls%')THEN 88
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%TOUCH 2%' OR Campaign_Name LIKE '%T2%')  AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%trig%' AND campaign_name not like 'sp%' and campaign_name not like '%responder%' and Campaign_Name NOT LIKE '%IRU%' and (Campaign_Name NOT LIKE '%Wireless%' or campaign_name not like '%wls%') THEN 90
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%TOUCH 2%'OR Campaign_Name LIKE '%T2%' OR Campaign_Name LIKE '%employee%')  AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%trig%' AND Campaign_Name NOT LIKE '%IRU%' AND Campaign_Name NOT LIKE '%WIRELINE%' THEN 80
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%TOUCH 2%' OR Campaign_Name LIKE '%T2%')  AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%trig%' and campaign_name not like '%sp%' and campaign_name not like '%responder%'AND Campaign_Name LIKE '%IRU%' THEN 89

WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%TOUCH 3%' OR Campaign_Name LIKE '%T3%')  AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%trig%' AND Campaign_Name NOT LIKE '%IRU%' and Campaign_Name NOT LIKE '%Wireless%' THEN 139
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%TOUCH 3%'OR Campaign_Name LIKE '%T3%' OR Campaign_Name LIKE '%employee%')  AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%trig%' AND Campaign_Name NOT LIKE '%IRU%' AND Campaign_Name NOT LIKE '%WIRELINE%' THEN 137
WHEN media_scorecard = 'DM' AND (Campaign_Name LIKE '%TOUCH 3%' OR Campaign_Name LIKE '%T3%')  AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%trig%' and campaign_name not like '%sp%' and campaign_name not like '%responder%'AND Campaign_Name LIKE '%IRU%' THEN 138


--new green email
WHEN media_scorecard = 'EM' AND (Campaign_Name LIKE '%touch 1%' OR Campaign_Name LIKE '%t1%' OR Campaign_Name LIKE '%follow%') AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '%TV Upsell%' AND Campaign_Name NOT LIKE '%TV UP%'AND Campaign_Name NOT LIKE '%Trig%' THEN 117
WHEN media_scorecard = 'EM' AND (Campaign_Name LIKE '%touch 1%' OR Campaign_Name LIKE '%t1%')AND Campaign_Name LIKE '%BLAST%' AND Campaign_Name NOT LIKE '%winback%'AND Campaign_Name NOT LIKE '%TV UP%' THEN 119
WHEN media_scorecard = 'EM' AND (Campaign_Name LIKE '%touch 2%' OR Campaign_Name LIKE '%t2%')AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '%TV UPSELL%' AND Campaign_Name NOT LIKE '%TV UP%' AND Campaign_Name NOT LIKE '%winback%' THEN 121
WHEN media_scorecard = 'EM' AND (Campaign_Name LIKE '%touch 2%' OR Campaign_Name LIKE '%t2%')AND Campaign_Name LIKE '%BLAST%' and Campaign_Name NOT LIKE '%winback%' and campaign_name not like '%tv upsell%' THEN 123
WHEN media_scorecard = 'EM' AND (Campaign_Name LIKE '%touch 3%' OR Campaign_Name LIKE '%t3%')AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '%TV UPSELL%' AND Campaign_Name NOT LIKE '%TV UP%' AND Campaign_Name NOT LIKE '%winback%' THEN 121
WHEN media_scorecard = 'EM' AND (Campaign_Name LIKE '%touch 3%' OR Campaign_Name LIKE '%t3%')AND Campaign_Name LIKE '%BLAST%' and Campaign_Name NOT LIKE '%winback%' THEN 123

--core email
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%EARLY%' AND (Campaign_Name NOT LIKE '%BLAST%' or Campaign_Name NOT LIKE '%RB%') AND Campaign_Name NOT LIKE '%REDEPLOY%' and Campaign_Name NOT LIKE '%IRU%'THEN 107
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%EARLY%' AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '%REDEPLOY%' and Campaign_Name LIKE '%IRU%'THEN 106
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%EARLY%' AND (Campaign_Name  LIKE '%BLAST%' or Campaign_Name  LIKE '%REDEPLOY%' or Campaign_Name  LIKE '%redploy%'or Campaign_Name  LIKE '%RB%') AND Campaign_Name NOT LIKE '%IRU%' THEN 109
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%EARLY%' AND (Campaign_Name  LIKE '%BLAST%' or Campaign_Name  LIKE '%REDEPLOY%' or Campaign_Name  LIKE '%redploy%') AND Campaign_Name LIKE '%IRU%' THEN 110
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%MID%' AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '%deploy%'  AND Campaign_Name NOT LIKE '%GigaPower%'THEN 113
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%MID%' AND (Campaign_Name  LIKE '%BLAST%' or Campaign_Name LIKE '%deploy%')  THEN 115
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%Late%' AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '%deploy%'  THEN 113
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%Late%' AND (Campaign_Name  LIKE '%BLAST%' or Campaign_Name LIKE '%deploy%')  THEN 115
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%cyber mon%' AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '%deploy%'  THEN 113
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%cyber mon%' AND (Campaign_Name  LIKE '%BLAST%' or Campaign_Name LIKE '%deploy%')  THEN 115
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%black fri%' AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '%deploy%'  THEN 113
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%black fri%' AND (Campaign_Name  LIKE '%BLAST%' or Campaign_Name LIKE '%deploy%')  THEN 115
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%GIG%' AND Campaign_Name NOT LIKE '%TRIGGER%' and Campaign_Name NOT LIKE '%TV Upsell%'THEN 113

--bill media
WHEN media_scorecard = 'BI' AND Campaign_Name LIKE '%TV%' AND Campaign_Name NOT LIKE '%ebill%' AND Campaign_Name NOT LIKE '%e-bill%' THEN 61
WHEN media_scorecard = 'BI' AND Campaign_Name NOT LIKE '%WIRELESS%' AND Campaign_Name NOT LIKE '%ebill%' AND Campaign_Name NOT LIKE '%e-bill%' AND Campaign_Name NOT LIKE '%WLS%' AND Campaign_Name NOT LIKE '%all records%'THEN 22
WHEN media_scorecard = 'BI' AND Campaign_Name LIKE '%ebill%' AND Campaign_Name NOT LIKE '%TV%' THEN 58
WHEN media_scorecard = 'BI' AND (Campaign_Name LIKE '%WIRELESS%' OR Campaign_Name LIKE '%WLS%' OR Campaign_Name LIKE '%all records%') THEN 26
WHEN media_scorecard = 'BI' AND Campaign_Name LIKE '%TV%' AND (Campaign_Name LIKE '%ebill%' OR Campaign_Name LIKE '%e-bill%'OR Campaign_Name LIKE '%E-bill%') THEN 164

WHEN media_scorecard = 'FYI' AND Campaign_Name LIKE '%FPC%' THEN 308
WHEN media_scorecard = 'FYI' AND Campaign_Name  LIKE '%ONSERT%' AND Campaign_Name  LIKE '%TV%'  THEN 125
WHEN media_scorecard = 'FYI' AND Campaign_Name  LIKE '%ONSERT%' AND (Campaign_Name  LIKE '%wireless%' OR Campaign_Name  LIKE '%WRLS%')  THEN 165
WHEN media_scorecard = 'FYI' AND Campaign_Name NOT LIKE '%WIRELESS%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%SPANISH%' AND Campaign_Name NOT LIKE '%SP%' and Campaign_Name NOT LIKE '%TV Upsell%' THEN 24
WHEN media_scorecard = 'FYI' AND Campaign_Name NOT LIKE '%WIRELESS%' AND (Campaign_Name LIKE '%HISPANIC%' OR Campaign_Name LIKE '%SPANISH%' or Campaign_Name like '%SP%') THEN 25
WHEN media_scorecard = 'FYI' AND Campaign_Name LIKE '%WIRELESS%' AND (Campaign_Name LIKE '%HISPANIC%' OR Campaign_Name LIKE '%SPANISH%' OR Campaign_Name LIKE '%Wireless SP%') THEN 144
WHEN media_scorecard = 'FYI' AND Campaign_Name LIKE '%WIRELESS%' THEN 27
WHEN media_scorecard = 'FYI' AND Campaign_Name LIKE '%TV Upsell%' THEN 170

WHEN media_scorecard = 'FPC' AND Campaign_Name LIKE '%FPC%' THEN 308

WHEN media_scorecard = 'SMS' THEN 28

--shared mail
WHEN media_scorecard = 'VAS' THEN 38
WHEN media_scorecard = 'VAP' AND Campaign_Name LIKE '%Money%' THEN 145
WHEN media_scorecard = 'VAP' AND Campaign_Name NOT LIKE '%Money%' THEN 39
WHEN media_scorecard = 'FSI' THEN 40



--triggers email
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%CREDIT%' THEN 49
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%ONLINE%' AND (Campaign_Name NOT LIKE '%reblast%' and Campaign_Name NOT LIKE '%rbt%') THEN 50
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%RESPONDER%' AND (Campaign_Name NOT LIKE '%reblast%' and Campaign_Name NOT LIKE '%rbt%') THEN 126
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%TRIG%' AND (Campaign_Name LIKE '%SMART%' OR Campaign_Name LIKE '%SP%') AND Campaign_Name NOT LIKE '%reblast%' AND Campaign_Name NOT LIKE '%rbt%' AND Campaign_Name NOT LIKE '%data%' THEN 51
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%CONNECT%' AND Campaign_Name NOT LIKE '%reblast%' AND Campaign_Name NOT LIKE '%rbt%' THEN 52
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%TRIG%' AND (Campaign_Name LIKE '%REC%' or campaign_name like '%recontact%') AND (Campaign_Name NOT LIKE '%reblast%' and Campaign_Name NOT LIKE '%rbt%') THEN 53
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%WINBACK%' AND (Campaign_Name NOT LIKE '%reblast%' and Campaign_Name NOT LIKE '%rbt%') THEN 54
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%data buster%'  THEN 167
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%data buster%' AND (Campaign_Name LIKE '%reblast%' OR Campaign_Name LIKE '%rbt%') THEN 168
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%giga%' THEN 299
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%Dec 2013 trigger EM%' THEN 299

WHEN media_scorecard = 'EM' AND (Campaign_Name LIKE '%TV UPSELL%' or Campaign_Name LIKE '%TV UP%') AND Campaign_NAME NOT LIKE '%ENGAGE%' AND Campaign_Name not LIKE '%ENG%' THEN 44
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%TV%'  AND (Campaign_NAME LIKE '%ENGAGE%' OR Campaign_Name LIKE '%ENG%') THEN 45
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%onboarding%'  THEN 5
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%ONLINE%' AND (Campaign_Name LIKE '%reblast%' or Campaign_Name LIKE '%rbt%' or Campaign_Name LIKE '%re-blast%') THEN 127
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%RESPONDER%' AND (Campaign_Name LIKE '%reblast%' or Campaign_Name LIKE '%rbt%') THEN 133
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%TRIG%' AND (Campaign_Name LIKE '%SMART%' OR Campaign_Name LIKE '%SP%') AND (Campaign_Name LIKE '%reblast%' or Campaign_Name LIKE '%rbt%') AND Campaign_Name NOT LIKE '%data%'THEN 129
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%REC%' AND (Campaign_Name LIKE '%reblast%' or Campaign_Name LIKE '%rbt%') THEN 130
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%WINBACK%' AND (Campaign_Name LIKE '%reblast%' or Campaign_Name LIKE '%rbt%') THEN 131
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%CONNECT%' AND (Campaign_Name LIKE '%reblast%' or Campaign_Name LIKE '%rbt%') THEN 141
WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%COMP%'  THEN 341

WHEN media_scorecard = 'EM' AND Campaign_Name LIKE '%Cancel before%'  THEN 303



--door hanger dm
WHEN media_scorecard = 'DH'  THEN 62


ELSE 0 END AS Touch_Type_FK
FROM Results.UVAQ_LB_2012_Active_Campaigns
WHERE ParentID not in (SELECT ParentID from Results.ParentID_Touch_Type_Link)
and ParentID > 1334









