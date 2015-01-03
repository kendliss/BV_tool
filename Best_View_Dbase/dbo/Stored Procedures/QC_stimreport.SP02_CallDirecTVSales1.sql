CREATE procedure [dbo].[QC_stimreport.SP02_CallDirecTVSales1] as
--Call DISH or DIRECTV sales
if object_id('tempdb..#pidWOWcall_DISH') is not null drop table #pidWOWcall_DISH
select [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description] as [Cell Title]
,[ParentID]
,a.[TFN]
,[ytd_ts_dish]
,Share#
into #pidWOWcall_DISH
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] as a 
	left join (select [TFN], count(parentid)as Share# from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] where TFN is not null group by [TFN]) as b
	on a.tfn=b.tfn
where [ytd_ts_dish]<0
group by [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description]
,[ParentID]
,a.[TFN]
,[ytd_ts_dish]
,Share#

--Looks at calls declines and checks for sharing
select [Scorecard_TypeC]
,a.[Campaign_Name]
,a.[TFN_Description] as [Cell Title]
,a.[ParentID]
,a.[TFN]
,a.[total_quantity]
,a.[ytd_ts_dish]
,case when [ParentID] IN (select [ParentID] from #pidWOWcall_DISH group by [ParentID]) then 'Y'
	else 'N'
	end as [Sales decline?]
,b.Share#
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] as a 
	left join (select [TFN], count(parentid)as Share# from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] where TFN is not null group by [TFN]) as b
	on a.tfn=b.tfn
where a.[TFN] in (select [TFN] from #pidWOWcall_DISH)
group by [Scorecard_TypeC]
,a.[TFN]
,a.[Campaign_Name]
,a.[TFN_Description]
,a.[ParentID]
,a.[total_quantity]
,a.[ytd_ts_dish]
,b.Share#