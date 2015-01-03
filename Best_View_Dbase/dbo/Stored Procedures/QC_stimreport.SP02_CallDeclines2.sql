
create procedure [QC_stimreport.SP02_CallDeclines2] as 
--Checks if the TFNs that had declines at the parentid level increased in clicks overall
--if no TFNs are in the output, then there were not any declines in calls at the TFN level
if object_id('tempdb..#pidWOWcalls') is not null drop table #pidWOWcalls
select [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description] as [Cell Title]
,[ParentID]
,a.[TFN]
,[ytd_calls]
,Share#
into #pidWOWcalls
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] as a 
	left join (select [TFN], count(parentid)as Share# from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] where TFN is not null group by [TFN]) as b
	on a.tfn=b.tfn
where [ytd_calls]<0
group by [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description]
,[ParentID]
,a.[TFN]
,[ytd_calls]
,Share#
select [Scorecard_TypeC]
,[TFN]
, SUM(isnull([ytd_calls],0)) as [Overall Calls Declines?]
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW]
where [TFN] in (select [TFN] from #pidWOWcalls)
group by [Scorecard_TypeC]
,[TFN]
having SUM(isnull([ytd_calls],0))<0