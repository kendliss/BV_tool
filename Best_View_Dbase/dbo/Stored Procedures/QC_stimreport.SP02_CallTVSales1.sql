CREATE procedure [dbo].[QC_stimreport.SP02_CallTVSales1] as 
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
--Looks at calls declines and checks for sharing
select [Scorecard_TypeC]
,a.[Campaign_Name]
,a.[TFN_Description] as [Cell Title]
,a.[ParentID]
,a.[TFN]
,a.[total_quantity]
,a.[ytd_ts_uvrs_tv]
,case when [ParentID] IN (select [ParentID] from #pidWOWcall_tv group by [ParentID]) then 'Y'
	else 'N'
	end as [Sales decline?]
,b.Share#
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] as a 
	left join (select [TFN], count(parentid)as Share# from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] where TFN is not null group by [TFN]) as b
	on a.tfn=b.tfn
where a.[TFN] in (select [TFN] from #pidWOWcall_tv)
group by [Scorecard_TypeC]
,a.[TFN]
,a.[Campaign_Name]
,a.[TFN_Description]
,a.[ParentID]
,a.[total_quantity]
,a.[ytd_ts_uvrs_tv]
,b.Share#
