
create PROCEDURE eCRW.weekly_report_email_links
as
if object_id('eCRW.missing_email_links') is not null drop table eCRW.missing_email_links
select c.in_home_date as 'Blast Date'
,c.aprimo_id as 'Aprimo ID'
,a.ecrw_campaign_id as 'Campaign ID'
,c.ecrw_campaign_title as 'Campaign Name'
into eCRW.missing_email_links
from javdb.IREPORT.[dbo].eCRW_Final_Cells_view as a 
	left join javdb.IREPORT.[dbo].eCRW_Final_Email_links_view as b
		on a.[ecrw_cell_id]=b.[ecrw_cell_id]
	left join javdb.IREPORT.dbo.eCRW_Final_Program_campaign_view as c
	on a.[ecrw_campaign_id]=c.[ecrw_campaign_id]
where a.[ecrw_campaign_id] in 
	(SELECT [ecrw_campaign_id]
	FROM javdb.IREPORT.dbo.eCRW_Final_Program_campaign_view
		where [att_program_code] = 'UVLB'
		and [channel_name] = 'Email'
		and [track_start_date] > '2012-12-25'
		group by [ecrw_campaign_id])
and [ecrw_email_id] is NULL
and c.in_home_date is not null
group by c.in_home_date
,c.aprimo_id
,a.ecrw_campaign_id
,c.ecrw_campaign_title
order by c.in_home_date
,c.aprimo_id
,a.ecrw_campaign_id
,c.ecrw_campaign_title 
select * from eCRW.missing_email_links
