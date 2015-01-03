CREATE procedure [QC_stimreport.SP02_CallDigitalLifeSales2] as 
--Call Digital Life sales
if object_id('tempdb..#pidWOWcall_digitallife') is not null drop table #pidWOWcall_digitallife
select [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description] as [Cell Title]
,[ParentID]
,a.[TFN]
,ytd_TS_DLIFE
,Share#
into #pidWOWcall_digitallife
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] as a 
	left join (select [TFN], count(parentid)as Share# from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] where TFN is not null group by [TFN]) as b
	on a.tfn=b.tfn
where ytd_TS_DLIFE<0
group by [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description]
,[ParentID]
,a.[TFN]
,ytd_TS_DLIFE
,Share#

--Checks if the TFNs that had declines at the parentid level increased in clicks overall
--if no TFNs are in the output, then there were not any declines in calls at the TFN level
select [Scorecard_TypeC]
,[TFN]
, SUM(isnull([ytd_ts_dish],0)) as [Overall Call DISH Sales Declines?]
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW]
where [TFN] in (select [TFN] from #pidWOWcall_digitallife)
group by [Scorecard_TypeC]
,[TFN]
having SUM(isnull([ytd_ts_dish],0))<0