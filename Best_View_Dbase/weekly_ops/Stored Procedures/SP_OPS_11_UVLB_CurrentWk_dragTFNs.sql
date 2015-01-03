CREATE PROCEDURE weekly_ops.SP_OPS_11_UVLB_CurrentWk_dragTFNs
as 
if object_id('weekly_ops.OPS_11_UVLB_CurrentWk_dragTFNs') is not null 
drop table weekly_ops.OPS_11_UVLB_CurrentWk_dragTFNs

select ReportWeek_YYYYWW
,parentid
,tfn
,sum(calls) as calls
into weekly_ops.OPS_11_UVLB_CurrentWk_dragTFNs
from javdb.ireport_2014.dbo.WB_03_Data_Calls_SCAMP as a 
	left join javdb.ireport_2014.dbo.WB_00_Media_Calendar_Daily as b
	on a.date=b.date
where parentid in ('82172','82173')
and ReportWeek_YYYYWW =(select (ReportCycle_YYYYWW) from javdb.[IREPORT_2014].[dbo].[wb_00_reporting_cycle] group by ReportCycle_YYYYWW)
group by ReportWeek_YYYYWW
,parentid
,tfn
order by calls desc

select * from weekly_ops.OPS_11_UVLB_CurrentWk_dragTFNs

