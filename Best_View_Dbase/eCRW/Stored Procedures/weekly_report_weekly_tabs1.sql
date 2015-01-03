
create PROCEDURE eCRW.weekly_report_weekly_tabs1
as
if object_id('eCRW.weekly_tabs1') is not null drop table eCRW.weekly_tabs1
select [Week In-home]
, [AT&T Program Manager]
, [Agency]
, [Channel]
, [Aprimo ID]
, [Campaign ID]
, [Campaign Name]
, [In-home Date]
, [First Drop Date/ Track Start]
, [ParentID]
, [Cell Title]
, [TFN]
, [TFN Type]
, [URL]
, [Quantity]
, [Budget]
, [Call RR]
, [Click RR] 
into eCRW.weekly_tabs1
from eCRW.weekly_report_data
where [Week In-home]=(ReportCycle_YYYYWW+1)
select * from eCRW.weekly_tabs1