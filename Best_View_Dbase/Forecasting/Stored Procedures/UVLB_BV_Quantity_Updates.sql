CREATE PROCEDURE [Forecasting].[UVLB_BV_Quantity_Updates]
as 
if object_id('temp..#UVLB_BV_quantity') is not null drop table #UVLB_BV_quantity
select --Report_year
 ReportCycle_YYYYWW
, c.CalendarMonth_YYYYMM as 'In-home Month'
, c.ReportWeek_YYYYWW as 'Week In-home'
, case when (b.id = 255 or b.id = 49) then 'U-verse Base Acq - DM - Hisp'
	        when (b.id = 51 and a.Campaign_Parent_Name like '%HISP%') then 'U-verse Base Acq - Catalog - Hisp'
	else b.Scorecard_Program_Channel
	end as 'Scorecard Program Channel'
, JobNumber as 'Program Name'
, Tactic_id as 'Tactic ID'
, e.att_contact_name as 'AT&T Program Manager' 
, f.aprimo_id as 'Aprimo ID'
, a.Project_ID as 'Campaign ID'
, eCRW_Project_Name as 'Campaign Name'
, a.In_Home_Date as 'In-home Date'
, Start_Date as 'First Drop Date/ Track Start'
, End_Date_Traditional as 'Tracking End Date'
, ParentID
, a.Campaign_Name as 'Cell Title' 
, a.media_code as 'Channel'
, Vendor as 'Agency'
, Date_CRW_Created as 'eCRW Created Date'
, crw_call_resp_rate as 'Call RR'
, crw_click_resp_rate as 'Click RR'
, Toll_Free_Numbers as 'TFN'
, d.tfn_type_name as 'TFN Type'
--catalog
, case
WHEN a.media_code = 'CA' AND Campaign_Name LIKE '%over%' THEN 172
WHEN a.media_code = 'CA' AND Campaign_Name NOT LIKE '%TOUCH%' AND Campaign_Name NOT LIKE '%T3%' and Campaign_Name not like '%IRU%' THEN 70
WHEN a.media_code = 'CA' AND Campaign_Name NOT LIKE '%TOUCH%' AND Campaign_Name NOT LIKE '%T3%' and Campaign_Name  like '%IRU%' THEN 68
WHEN a.media_code = 'CA' AND (Campaign_Name LIKE '%TOUCH%' OR Campaign_Name LIKE '%T3%') THEN 41
WHEN a.media_code = 'CA' AND Campaign_Name LIKE '%TV%' THEN 43


--tv upsell dm
WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%TV UPSELL%' or Campaign_Name LIKE '%TV UP%') and ((campaign_name like ('%never%') or campaign_name like ('% NH %') or campaign_name like ('% NH%')or campaign_name like ('%NH%')))and (campaign_name not like '%mid%' Or campaign_name not like '%early%' OR campaign_name not like '%late%') then 176
WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%TV UPSELL%' or Campaign_Name LIKE '%TV UP%') and ((campaign_name like ('%win%') or campaign_name like ('% WB %')or campaign_name like ('% WB%')or campaign_name like ('%WB%')))and (campaign_name not like '%mid%' Or campaign_name not like '%early%' OR campaign_name not like '%late%') then 175
WHEN a.media_code = 'DM' AND campaign_name not like '%Mid TV upsell champ%' and (Campaign_Name LIKE '%TV UPSELL%' or Campaign_Name LIKE '%TV UP%') and (campaign_name not like '%mid%' Or campaign_name not like '%early%' OR campaign_name not like '%late%')   THEN 30

--DTR
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%DRIVE%' OR Campaign_Name LIKE '%DTR%' THEN 29

--Trigger DM
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%CONNECT%' AND Campaign_Name NOT LIKE '%IRU%'THEN 94
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%CONNECT%' AND Campaign_Name LIKE '%IRU%%' THEN 93
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%contact%' AND Campaign_Name NOT LIKE '%IRU%' THEN 102
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%contact%' AND Campaign_Name  LIKE '%IRU%' THEN 101
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%WINBACK%' AND Campaign_Name NOT LIKE '%IRU%' THEN 105
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%WINBACK%' AND Campaign_Name  LIKE '%IRU%' THEN 104
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%RESPONDER%' THEN 63
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%DATA%'  THEN 48
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%CREDIT%' THEN 96
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%ONLINE%' AND Campaign_Name NOT LIKE '%IRU%' THEN 92
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%ONLINE%' AND Campaign_Name LIKE '%IRU%' THEN 91
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%CONNECT%' THEN 94
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%TRIG%' AND (Campaign_Name LIKE '%SMART%' OR Campaign_Name LIKE '%SP%') AND Campaign_Name NOT LIKE '%IRU%' THEN 99
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%TRIG%' AND (Campaign_Name LIKE '%SMART%' OR Campaign_Name LIKE '%SP%') AND Campaign_Name LIKE '%IRU%' THEN 98
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%landline defect%' THEN 178
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%tabletuser%' THEN 64
--trig engagement email
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%engage%' THEN 132
WHEN a.media_code = 'EM' AND Campaign_Name NOT LIKE '%re-eng%'and (Campaign_Name LIKE '%ENGAGE%' OR Campaign_Name LIKE '%ENG%' OR Campaign_Name LIKE '%ENG%')  AND Campaign_Name NOT LIKE '%TV Upsell%' AND Campaign_Name NOT LIKE '%TV UP%' AND Campaign_Name NOT LIKE '%TRIG%'  and Campaign_Name NOT LIKE '%IRU%'and Campaign_Name NOT LIKE '%IRU%' and Campaign_Name NOT LIKE '%re-eng%'  THEN 111
WHEN a.media_code = 'EM' AND Campaign_Name NOT LIKE '%re-eng%'and(Campaign_Name LIKE '%ENGAGE%' OR Campaign_Name LIKE '%ENG%' OR Campaign_Name LIKE '%ENG%') AND Campaign_Name NOT LIKE '%TV Upsell%'  AND Campaign_Name NOT LIKE '%TV UP%' AND Campaign_Name NOT LIKE '%TRIG%'  AND Campaign_Name LIKE '%IRU%' and Campaign_Name NOT LIKE '%re-eng%'THEN 112


--Core DM
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%EARLY%' AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name LIKE '%IRU%' THEN 73
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%EARLY%' AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%SPANISH%' and Campaign_Name like '%Fresh%'  THEN 75
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%EARLY%' AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%SPANISH%' and Campaign_Name not like '%WLN w/ WLS%' and Campaign_Name not like '%WLS+O%'and Campaign_Name not like '%non wls%' and Campaign_Name like '%WLS%'  THEN 72
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%EARLY%' AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%SPANISH%'  THEN 74

WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%2014 April UVLB DM Austin Go Local Emergency%' AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name LIKE '%IRU%' THEN 73
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%2014 April UVLB DM Austin Go Local Emergency%' AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%SPANISH%' and Campaign_Name like '%Fresh%'  THEN 75
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%2014 April UVLB DM Austin Go Local Emergency%' AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%SPANISH%' and Campaign_Name not like '%WLN w/ WLS%' and Campaign_Name not like '%WLS+O%'and Campaign_Name not like '%non wls%' and Campaign_Name like '%WLS%'  THEN 72
WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%2014 April UVLB DM Austin Go Local Emergency%' AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%SPANISH%'  THEN 74

WHEN a.media_code = 'DM' AND Campaign_Name LIKE '%LATE%' AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name LIKE '%IRU%' THEN 77
WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%LATE%' OR Campaign_Name LIKE '%3RD%') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%IRU%' and Campaign_Name like '%fresh%' THEN 79
WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%LATE%' OR Campaign_Name LIKE '%3RD%') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%IRU%' and Campaign_Name not like '%WLN w/ WLS%' and Campaign_Name not like '%WLS+O%'  and Campaign_Name not like '%non wls%' and Campaign_Name like '%WLS%' THEN 76
WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%LATE%' OR Campaign_Name LIKE '%3RD%') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%IRU%' THEN 78

WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%MID%' OR Campaign_Name LIKE '%MM%') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name LIKE '%IRU%'  THEN 81
WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%MID%' OR Campaign_Name LIKE '%MM%') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name Not LIKE '%IRU%' and Campaign_Name like '%fresh%'  THEN 83
WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%MID%' OR Campaign_Name LIKE '%MM%') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name Not LIKE '%IRU%' and Campaign_Name not like '%WLN w/ WLS%' and Campaign_Name not like '%WLS+O%' and Campaign_Name not like '%non wls%' and Campaign_Name like '%WLS%'  THEN 80
WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%MID%' OR Campaign_Name LIKE '%MM%') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%IRU%' THEN 82
WHEN a.media_code = 'DM' AND (campaign_name like '%Nov13 LightGig WLN%' OR campaign_name like '%Nov13 LightGig WLS+O%') AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%IRU%' THEN 82
WHEN a.media_code = 'DM' AND campaign_name like '%Nov13 LightGig WLS%' AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name Not LIKE '%IRU%' and Campaign_Name not like '%WLN w/ WLS%' and Campaign_Name not like '%WLS+O%' and Campaign_Name not like '%non wls%' and Campaign_Name like '%WLS%'  THEN 80
--new green dm hispanic
WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%T1%' OR Campaign_Name LIKE '%TOUCH 1%') AND (Campaign_Name LIKE '%BILINGUAL%' OR Campaign_Name LIKE '%HISPANIC%' OR Vendor='Dieste') THEN 7
WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%T2%' OR Campaign_Name LIKE '%TOUCH 2%') AND (Campaign_Name LIKE '%BILINGUAL%' OR Campaign_Name LIKE '%HISPANIC%'OR Vendor='Dieste') THEN 8
WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%BILINGUAL%' OR Campaign_Name LIKE '%HISPANIC%' OR Campaign_Name LIKE '%SPANISH%' OR Vendor='Dieste') and campaign_name not like '%spanish tag%' and campaign_name not like '%bilingual bucket test%' THEN 84

--DTV cross sell DM
WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%DTV%' OR Campaign_Name LIKE '%CROSS%' OR Campaign_Name LIKE '%cross-sell%' OR Campaign_Name LIKE '%cross sell%') THEN 140

--new green dm
WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%TOUCH 1%'OR Campaign_Name LIKE '%T1%' OR Campaign_Name LIKE '%employee%')  AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%trig%' AND Campaign_Name NOT LIKE '%IRU%' THEN 87
WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%TOUCH 1%'OR Campaign_Name LIKE '%T1%' OR Campaign_Name LIKE '%employee%')  AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%trig%' AND Campaign_Name NOT LIKE '%IRU%' AND Campaign_Name NOT LIKE '%WIRELINE%' THEN 85
WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%TOUCH 1%'OR Campaign_Name LIKE '%T1%' OR Campaign_Name LIKE '%employee%')  AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%trig%' AND Campaign_Name LIKE '%IRU%' THEN 86

WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%TOUCH 2%' OR Campaign_Name LIKE '%T2%')  AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%trig%' AND Campaign_Name NOT LIKE '%IRU%' THEN 90
WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%TOUCH 2%'OR Campaign_Name LIKE '%T2%' OR Campaign_Name LIKE '%employee%')  AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%trig%' AND Campaign_Name NOT LIKE '%IRU%' AND Campaign_Name NOT LIKE '%WIRELINE%' THEN 80
WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%TOUCH 2%' OR Campaign_Name LIKE '%T2%')  AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%trig%' AND Campaign_Name LIKE '%IRU%' THEN 89

WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%TOUCH 3%' OR Campaign_Name LIKE '%T3%')  AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%trig%' AND Campaign_Name NOT LIKE '%IRU%' THEN 139
WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%TOUCH 3%'OR Campaign_Name LIKE '%T3%' OR Campaign_Name LIKE '%employee%')  AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%trig%' AND Campaign_Name NOT LIKE '%IRU%' AND Campaign_Name NOT LIKE '%WIRELINE%' THEN 137
WHEN a.media_code = 'DM' AND (Campaign_Name LIKE '%TOUCH 3%' OR Campaign_Name LIKE '%T3%')  AND Campaign_Name NOT LIKE '%BILINGUAL%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%trig%' AND Campaign_Name LIKE '%IRU%' THEN 138


--new green email
WHEN a.media_code = 'EM' AND (Campaign_Name LIKE '%touch 1%' OR Campaign_Name LIKE '%t1%' OR Campaign_Name LIKE '%follow%') AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '%TV Upsell%' AND Campaign_Name NOT LIKE '%TV UP%'AND Campaign_Name NOT LIKE '%Trig%' THEN 117
WHEN a.media_code = 'EM' AND (Campaign_Name LIKE '%touch 1%' OR Campaign_Name LIKE '%t1%')AND Campaign_Name LIKE '%BLAST%' AND Campaign_Name NOT LIKE '%winback%'AND Campaign_Name NOT LIKE '%TV UP%' THEN 119
WHEN a.media_code = 'EM' AND (Campaign_Name LIKE '%touch 2%' OR Campaign_Name LIKE '%t2%')AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '%TV UPSELL%' AND Campaign_Name NOT LIKE '%TV UP%' AND Campaign_Name NOT LIKE '%winback%' THEN 121
WHEN a.media_code = 'EM' AND (Campaign_Name LIKE '%touch 2%' OR Campaign_Name LIKE '%t2%')AND Campaign_Name LIKE '%BLAST%' and Campaign_Name NOT LIKE '%winback%' THEN 123
WHEN a.media_code = 'EM' AND (Campaign_Name LIKE '%touch 3%' OR Campaign_Name LIKE '%t3%')AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '%TV UPSELL%' AND Campaign_Name NOT LIKE '%TV UP%' AND Campaign_Name NOT LIKE '%winback%' THEN 121
WHEN a.media_code = 'EM' AND (Campaign_Name LIKE '%touch 3%' OR Campaign_Name LIKE '%t3%')AND Campaign_Name LIKE '%BLAST%' and Campaign_Name NOT LIKE '%winback%' THEN 123

--core email
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%EARLY%' AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '%REDEPLOY%' THEN 107
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%EARLY%' AND (Campaign_Name  LIKE '%BLAST%' or Campaign_Name  LIKE '%REDEPLOY%' or Campaign_Name  LIKE '%redploy%') AND Campaign_Name NOT LIKE '%IRU%' THEN 109
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%EARLY%' AND (Campaign_Name  LIKE '%BLAST%' or Campaign_Name  LIKE '%REDEPLOY%' or Campaign_Name  LIKE '%redploy%') AND Campaign_Name LIKE '%IRU%' THEN 110
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%MID%' AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '%deploy%'  THEN 113
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%MID%' AND (Campaign_Name  LIKE '%BLAST%' or Campaign_Name LIKE '%deploy%')  THEN 115
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%Late%' AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '%deploy%'  THEN 113
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%Late%' AND (Campaign_Name  LIKE '%BLAST%' or Campaign_Name LIKE '%deploy%')  THEN 115
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%cyber mon%' AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '%deploy%'  THEN 113
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%cyber mon%' AND (Campaign_Name  LIKE '%BLAST%' or Campaign_Name LIKE '%deploy%')  THEN 115
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%black fri%' AND Campaign_Name NOT LIKE '%BLAST%' AND Campaign_Name NOT LIKE '%deploy%'  THEN 113
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%black fri%' AND (Campaign_Name  LIKE '%BLAST%' or Campaign_Name LIKE '%deploy%')  THEN 115
--bill media
WHEN a.media_code = 'BI' AND Campaign_Name LIKE '%TV%' AND Campaign_Name NOT LIKE '%ebill%' AND Campaign_Name NOT LIKE '%e-bill%' THEN 61
WHEN a.media_code = 'BI' AND Campaign_Name NOT LIKE '%WIRELESS%' AND Campaign_Name NOT LIKE '%ebill%' AND Campaign_Name NOT LIKE '%e-bill%' AND Campaign_Name NOT LIKE '%WLS%' AND Campaign_Name NOT LIKE '%all records%'THEN 22
WHEN a.media_code = 'BI' AND Campaign_Name LIKE '%ebill%' AND Campaign_Name NOT LIKE '%TV%' THEN 58
WHEN a.media_code = 'BI' AND (Campaign_Name LIKE '%WIRELESS%' OR Campaign_Name LIKE '%WLS%' OR Campaign_Name LIKE '%all records%') THEN 26
WHEN a.media_code = 'BI' AND Campaign_Name LIKE '%TV%' AND (Campaign_Name LIKE '%ebill%' OR Campaign_Name LIKE '%e-bill%'OR Campaign_Name LIKE '%E-bill%') THEN 164


WHEN a.media_code = 'FYI' AND Campaign_Name  LIKE '%ONSERT%' AND Campaign_Name  LIKE '%TV%'  THEN 125
WHEN a.media_code = 'FYI' AND Campaign_Name  LIKE '%ONSERT%' AND (Campaign_Name  LIKE '%wireless%' OR Campaign_Name  LIKE '%WRLS%')  THEN 165
WHEN a.media_code = 'FYI' AND Campaign_Name NOT LIKE '%WIRELESS%' AND Campaign_Name NOT LIKE '%HISPANIC%' AND Campaign_Name NOT LIKE '%SPANISH%' AND Campaign_Name NOT LIKE '%TV Upsell%' THEN 24
WHEN a.media_code = 'FYI' AND Campaign_Name NOT LIKE '%WIRELESS%' AND (Campaign_Name LIKE '%HISPANIC%' OR Campaign_Name LIKE '%SPANISH%') THEN 25
WHEN a.media_code = 'FYI' AND Campaign_Name LIKE '%WIRELESS%' AND (Campaign_Name LIKE '%HISPANIC%' OR Campaign_Name LIKE '%SPANISH%' OR Campaign_Name LIKE '%Wireless SP%') THEN 144
WHEN a.media_code = 'FYI' AND Campaign_Name LIKE '%WIRELESS%' THEN 27
WHEN a.media_code = 'FYI' AND Campaign_Name LIKE '%TV Upsell%' THEN 170

WHEN a.media_code = 'SMS' THEN 28

--shared mail
WHEN a.media_code = 'VAS' THEN 38
WHEN a.media_code = 'VAP' AND Campaign_Name LIKE '%Money%' THEN 145
WHEN a.media_code = 'VAP' AND Campaign_Name NOT LIKE '%Money%' THEN 39
WHEN a.media_code = 'FSI' THEN 40



--triggers email
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%CREDIT%' THEN 49
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%ONLINE%' AND (Campaign_Name NOT LIKE '%reblast%' and Campaign_Name NOT LIKE '%rbt%') THEN 50
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%RESPONDER%' AND (Campaign_Name NOT LIKE '%reblast%' and Campaign_Name NOT LIKE '%rbt%') THEN 126
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%TRIG%' AND (Campaign_Name LIKE '%SMART%' OR Campaign_Name LIKE '%SP%') AND Campaign_Name NOT LIKE '%reblast%' AND Campaign_Name NOT LIKE '%rbt%' AND Campaign_Name NOT LIKE '%data%' THEN 51
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%CONNECT%' AND Campaign_Name NOT LIKE '%reblast%' AND Campaign_Name NOT LIKE '%rbt%' THEN 52
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%TRIG%' AND (Campaign_Name LIKE '%REC%' or campaign_name like '%recontact%') AND (Campaign_Name NOT LIKE '%reblast%' and Campaign_Name NOT LIKE '%rbt%') THEN 53
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%WINBACK%' AND (Campaign_Name NOT LIKE '%reblast%' and Campaign_Name NOT LIKE '%rbt%') THEN 54
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%data buster%' AND (Campaign_Name LIKE '%initial%' OR Campaign_Name LIKE '%int%') THEN 167
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%data buster%' AND (Campaign_Name LIKE '%reblast%' OR Campaign_Name LIKE '%rbt%') THEN 168

WHEN a.media_code = 'EM' AND (Campaign_Name LIKE '%TV UPSELL%' or Campaign_Name LIKE '%TV UP%') AND Campaign_NAME NOT LIKE '%ENGAGE%' AND Campaign_Name not LIKE '%ENG%' THEN 44
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%TV%'  AND (Campaign_NAME LIKE '%ENGAGE%' OR Campaign_Name LIKE '%ENG%') THEN 45
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%onboarding%'  THEN 5
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%ONLINE%' AND (Campaign_Name LIKE '%reblast%' or Campaign_Name LIKE '%rbt%') THEN 127
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%RESPONDER%' AND (Campaign_Name LIKE '%reblast%' or Campaign_Name LIKE '%rbt%') THEN 133
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%TRIG%' AND (Campaign_Name LIKE '%SMART%' OR Campaign_Name LIKE '%SP%') AND (Campaign_Name LIKE '%reblast%' or Campaign_Name LIKE '%rbt%') AND Campaign_Name NOT LIKE '%data%'THEN 129
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%REC%' AND (Campaign_Name LIKE '%reblast%' or Campaign_Name LIKE '%rbt%') THEN 130
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%WINBACK%' AND (Campaign_Name LIKE '%reblast%' or Campaign_Name LIKE '%rbt%') THEN 131
WHEN a.media_code = 'EM' AND Campaign_Name LIKE '%TRIG%' AND Campaign_Name LIKE '%CONNECT%' AND (Campaign_Name LIKE '%reblast%' or Campaign_Name LIKE '%rbt%') THEN 141


--door hanger dm
WHEN a.Media_Code = 'DH'  THEN 62

ELSE 0 END AS Touch_Type_FK



, URL_List as 'URL'
, max(CTD_Quantity) as 'Quantity'
, max(CTD_Budget) as 'Budget'

into #UVLB_BV_quantity

from javdb.ireport_2014.dbo.WB_01_campaign_list_wb as a 
		join javdb.ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
			on a.tactic_id=b.id
		left join javdb.ireport_2014.dbo.WB_00_Media_Calendar_Daily c
			on a.in_home_date=c.date
		left join (select ecrw_campaign_id,ecrw_cell_title, cell_tfn, tfn_type_name, tfn_audience_name 
					from javdb.ireport.dbo.eCRW_Final_Cells_view																	
					group by ecrw_campaign_id,ecrw_cell_title, cell_tfn, tfn_type_name, tfn_audience_name ) as d 
					on (a.project_id = d.ecrw_campaign_id and a.campaign_name=d.ecrw_cell_title)
						
		left join (select ecrw_campaign_id,att_contact_name,status_name 
					from javdb.ireport.dbo.eCRW_Final_Program_campaign_view														
					group by ecrw_campaign_id,att_contact_name,status_name) as e
					on (a.project_id = e.ecrw_campaign_id)
									
		left join (select ecrw_campaign_id,aprimo_id 
					from javdb.ireport.dbo.eCRW_Final_Program_campaign_view														
					group by ecrw_campaign_id,aprimo_id ) as f 
					on (a.project_id = f.ecrw_campaign_id)
									
where a.in_home_date >= '2013-07-01'   
	and b.Scorecard_Top_Tab = 'Direct Marketing'
	and b.Scorecard_LOB_Tab = 'U-verse'
	and b.Scorecard_tab = 'Uverse Base Acq'
and b.Scorecard_Program_Channel not like '%Drag%'
and b.Scorecard_Program_Channel not like '%social%'
and a.Campaign_Name not like 'Remaining data'
and a.report_year in ('2014')
group by ReportCycle_YYYYWW
, c.CalendarMonth_YYYYMM
, c.ReportWeek_YYYYWW
, b.Scorecard_Program_Channel
, b.id
, JobNumber
, Tactic_id
, e.att_contact_name 
, f.aprimo_id
, a.Project_ID
, eCRW_Project_Name
, a.In_Home_Date
, Start_Date
, End_Date_Traditional
, ParentID
, a.Campaign_Name
, a.Campaign_Parent_Name
, a.media_code
, Vendor
, Date_CRW_Created
, crw_call_resp_rate
, crw_click_resp_rate
, Toll_Free_Numbers
, d.tfn_type_name
, URL_List

update #UVLB_BV_quantity
set URL='email'
where (URL='' or URL is null)
and ([Channel] like '%EM%')

update #UVLB_BV_quantity
set URL='No URL tracking requested'
where (URL='' or URL is null)
and not ([Channel] like '%EM%')

update #UVLB_BV_quantity 
set [TFN Type]='LT/CCC'
where ([TFN Type]='22-state')

if object_id('forecasting.UVLB_BV_quantity') is not null drop table forecasting.UVLB_BV_quantity
select a.* 
,b.Media_Type
,b.Touch_Name
,b.Touch_Name_2
,b.Audience_Type_Name
,b.Program_Owner
,project = b.touch_name_2+ ' ' +b.Touch_Name
into forecasting.UVLB_BV_quantity
from #UVLB_BV_quantity as a
left join dbo.[Touch Type Human View] as b
	  on a.Touch_Type_FK=b.Touch_Type_id

select * from forecasting.UVLB_BV_quantity

