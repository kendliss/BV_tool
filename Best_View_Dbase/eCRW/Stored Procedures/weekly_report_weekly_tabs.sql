create PROCEDURE eCRW.weekly_report_weekly_tabs
as

if object_id('eCRW.weekly_tabs0') is not null drop table eCRW.weekly_tabs0
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
into eCRW.weekly_tabs0
from eCRW.weekly_report_data
where [Week In-home]=ReportCycle_YYYYWW
select * from eCRW.weekly_tabs0

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

if object_id('eCRW.weekly_tabs2') is not null drop table eCRW.weekly_tabs2
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
into eCRW.weekly_tabs2
from eCRW.weekly_report_data
where [Week In-home]=(ReportCycle_YYYYWW+2)
select * from eCRW.weekly_tabs2

if object_id('eCRW.weekly_tabs3') is not null drop table eCRW.weekly_tabs3
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
into eCRW.weekly_tabs3
from eCRW.weekly_report_data
where [Week In-home]=(ReportCycle_YYYYWW+3)
select * from eCRW.weekly_tabs3

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
where [Week In-home]=(ReportCycle_YYYYWW+4)
select * from eCRW.weekly_tabs4

if object_id('eCRW.weekly_tabs5') is not null drop table eCRW.weekly_tabs5
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
into eCRW.weekly_tabs5
from eCRW.weekly_report_data
where [Week In-home]=(ReportCycle_YYYYWW+5)
select * from eCRW.weekly_tabs5

if object_id('eCRW.weekly_tabs6') is not null drop table eCRW.weekly_tabs6
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
into eCRW.weekly_tabs6
from eCRW.weekly_report_data
where [Week In-home]=(ReportCycle_YYYYWW+6)
select * from eCRW.weekly_tabs6

if object_id('eCRW.weekly_tabs7') is not null drop table eCRW.weekly_tabs7
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
into eCRW.weekly_tabs7
from eCRW.weekly_report_data
where [Week In-home]=(ReportCycle_YYYYWW+7)
select * from eCRW.weekly_tabs7