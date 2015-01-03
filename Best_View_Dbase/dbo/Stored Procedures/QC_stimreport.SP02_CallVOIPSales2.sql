create procedure [QC_stimreport.SP02_CallVOIPSales2] as 
--Call VOIP sales
if object_id('tempdb..#pidWOWcall_VOIP') is not null drop table #pidWOWcall_VOIP
select [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description] as [Cell Title]
,[ParentID]
,a.[TFN]
,[ytd_ts_uvrs_VOIP]
,Share#
into #pidWOWcall_VOIP
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] as a 
	left join (select [TFN], count(parentid)as Share# from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] where TFN is not null group by [TFN]) as b
	on a.tfn=b.tfn
where [ytd_ts_uvrs_VOIP]<0
group by [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description]
,[ParentID]
,a.[TFN]
,[ytd_ts_uvrs_VOIP]
,Share#

--Checks if the TFNs that had declines at the parentid level increased in clicks overall
--if no TFNs are in the output, then there were not any declines in calls at the TFN level
select [Scorecard_TypeC]
,[TFN]
, SUM(isnull([ytd_ts_uvrs_VOIP],0)) as [Overall Call VOIP Sales Declines?]
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW]
where [TFN] in (select [TFN] from #pidWOWcall_VOIP)
group by [Scorecard_TypeC]
,[TFN]
having SUM(isnull([ytd_ts_uvrs_VOIP],0))<0