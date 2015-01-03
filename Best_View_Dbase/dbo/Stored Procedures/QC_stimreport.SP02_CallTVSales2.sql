create procedure [QC_stimreport.SP02_CallTVSales2] as 
--Checks if the TFNs that had declines at the parentid level increased in clicks overall
--if no TFNs are in the output, then there were not any declines in calls at the TFN level
--Call TV Sales
if object_id('tempdb..#pidWOWcall_tv') is not null drop table #pidWOWcall_tv
select [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description] as [Cell Title]
,[ParentID]
,a.[TFN]
,[ytd_ts_uvrs_tv]
,Share#
into #pidWOWcall_tv
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] as a 
	left join (select [TFN], count(parentid)as Share# from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] where TFN is not null group by [TFN]) as b
	on a.tfn=b.tfn
where [ytd_ts_uvrs_tv]<0
group by [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description]
,[ParentID]
,a.[TFN]
,[ytd_ts_uvrs_tv]
,Share#

select [Scorecard_TypeC]
,[TFN]
, SUM(isnull([ytd_ts_uvrs_tv],0)) as [Overall Call TV Sales Declines?]
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW]
where [TFN] in (select [TFN] from #pidWOWcall_tv)
group by [Scorecard_TypeC]
,[TFN]
having SUM(isnull([ytd_ts_uvrs_tv],0))<0