CREATE procedure [QC_stimreport.SP01_version_WB_07_Stim_report] as 
if object_id('#WB_07_Stim_report') is not null drop table #WB_07_Stim_report
select reportweek_YYYYWW, version
into #WB_07_Stim_report
from [javdb].ireport_2014.dbo.WB_07_Stim_report
group by reportweek_YYYYWW, version
select * from #WB_07_Stim_report