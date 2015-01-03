CREATE PROCEDURE eCRW.weekly_report_campaigns_due1
as
if object_id('ecrw.weekly_report_campaigns') is not null drop table ecrw.weekly_report_campaigns
select [Program Name]
,[Channel]
,[AT&T Program Manager] 
,[First Drop Date/ Track Start]
,[In-Home Date]
,[Campaign Name]
into ecrw.weekly_report_campaigns
from eCRW.weekly_report_data
group by [Program Name]
,[Channel]
,[AT&T Program Manager] 
,[First Drop Date/ Track Start]
,[In-Home Date]
,[Campaign Name]
order by [Program Name]
,[Channel]
,[AT&T Program Manager] 
,[First Drop Date/ Track Start]
,[In-Home Date]
,[Campaign Name]
select * from ecrw.weekly_report_campaigns