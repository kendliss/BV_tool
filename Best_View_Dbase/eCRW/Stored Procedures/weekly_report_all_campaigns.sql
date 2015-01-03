


CREATE PROCEDURE [eCRW].[weekly_report_all_campaigns]
as 
if object_id('tempdb..#eCRW_data') is not null drop table #eCRW_data
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
, a.Media_code as 'Channel'
, Vendor as 'Agency'
, Date_CRW_Created as 'eCRW Created Date'
, crw_call_resp_rate as 'Call RR'
, crw_click_resp_rate as 'Click RR'
, Toll_Free_Numbers as 'TFN'
, d.tfn_type_name as 'TFN Type'
      ,case when a.Campaign_Name like ('%IRU%') and a.Campaign_Name not like ('%non%') then 'IRU'
			when a.Campaign_Name NOT LIKE '%IRU%' and a.campaign_name not like '%WLN w/ WLS%' 
				and a.campaign_name not like '%WLS+O%'  and a.campaign_name not like '%non wls%' 
				and a.campaign_name not like '%WLS/WLN%' and a.campaign_name not like '%WLN/WLS%' 
				and a.campaign_name not like '%WRLS/WLN%' and a.campaign_name not like '%WLN/WRLS%' 
				and a.campaign_name not like '%(WLN w/ or w/o WLS)%' and a.campaign_name not like '%+ WLS%' 
				and a.campaign_name not like '%WLS +%' and a.campaign_name not like '%nonwls%' 
				and a.campaign_name not like '%nonwrls%' and a.campaign_name not like '%Non-wireless%' 
				and a.campaign_name not like '%WLNwWLS%' 
				and a.campaign_name not like '%w/o wireless%' and a.campaign_name not like '%wlsw/%' 
				and (a.campaign_name like '%WLS%' or a.campaign_name like '%WRLS%' or a.campaign_name like '%smartphone%'
					or a.campaign_name like '%wireless only%'or a.campaign_name like '%wireless%') then 'Wls Only'
			when a.Campaign_Name like ('%green%') or a.Campaign_Name like ('%- NG -%') or a.Campaign_Name like ('%FRESH%') or a.Campaign_Name like ('%FSH%') then 'NewGreen'
			when a.Campaign_Name like ('%hisp%') and a.Media_code like '%CA%' then 'BL'
		    when a.Campaign_Parent_Name like ('%tv upsell%') and (a.Campaign_Parent_Name like ('%never%') or a.Campaign_Parent_Name like ('% NH %') or a.Campaign_Parent_Name like ('% NH%')or a.Campaign_Parent_Name like ('%NH%')) then 'Neverhad'
			when a.Campaign_Parent_Name like ('%tv upsell%') and (a.Campaign_Parent_Name like ('%win%') or a.Campaign_Parent_Name like ('% WB %')or a.Campaign_Parent_Name like ('% WB%')or a.Campaign_Parent_Name like ('%WB%')) then 'Winback'
			else ''
			end as Audience --need to try using TFN audience from the view instead of creating
, URL_List as 'URL'
, max(CTD_Quantity) as 'Quantity'
, max(CTD_Budget) as 'Budget'
into #eCRW_data
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
	and b.Scorecard_tab = 'Uverse'
and b.Scorecard_Program_Channel not like '%Drag%'
and b.Scorecard_Program_Channel not like '%social%'
and a.Campaign_Name not like 'Remaining data'
and a.report_year in ('2014', '2015')
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
, a.Media_code
, Vendor
, Date_CRW_Created
, crw_call_resp_rate
, crw_click_resp_rate
, Toll_Free_Numbers
, d.tfn_type_name
, URL_List

update #eCRW_data 
set URL='email'
where (URL='' or URL is null)
and ([Channel] like '%EM%')

update #eCRW_data 
set URL='No URL tracking requested'
where (URL='' or URL is null)
and not ([Channel] like '%EM%')

update #eCRW_data 
set [TFN Type]='LT/CCC'
where ([TFN Type]='22-state')

--export data tab
if object_id('eCRW.weekly_report_data') is not null drop table eCRW.weekly_report_data
select #eCRW_data.*
, 'TFN Audience' = [TFN Type]+' '+Audience
into eCRW.weekly_report_data
from #eCRW_data 
select * from eCRW.weekly_report_data




