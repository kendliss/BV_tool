create procedure [QC_stimreport.SP01_version_WB_07_Stim_Report_WOW] as 
if object_id('#WB_07_Stim_Report_WOW') is not null drop table #WB_07_Stim_Report_WOW
select wkcurrent, vercurrent, wkprior, verprior
into #WB_07_Stim_Report_WOW
from [javdb].ireport_2014.dbo.WB_07_Stim_Report_WOW
where wkcurrent <>0 and vercurrent <>0 and wkprior <>0 and verprior <>0
group by wkcurrent, vercurrent, wkprior, verprior
select * from #WB_07_Stim_Report_WOW