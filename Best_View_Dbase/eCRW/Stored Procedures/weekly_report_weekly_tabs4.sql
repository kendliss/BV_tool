

CREATE PROCEDURE [eCRW].[weekly_report_weekly_tabs4]
as
if object_id('eCRW.weekly_tabs4') is not null drop table eCRW.weekly_tabs4
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
into eCRW.weekly_tabs4
from eCRW.weekly_report_data
where (ReportCycle_YYYYWW <= 201452 and [Week In-home] =  (ReportCycle_YYYYWW+4-201452+201500))
      or (ReportCycle_YYYYWW >201452 and [Week In-home]=(ReportCycle_YYYYWW+4))
--[Week In-home]=(ReportCycle_YYYYWW+4)
select * from eCRW.weekly_tabs4
