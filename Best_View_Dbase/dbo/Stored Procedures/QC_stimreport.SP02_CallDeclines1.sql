CREATE procedure [dbo].[QC_stimreport.SP02_CallDeclines1] as 
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

--Looks at calls declines and checks for sharing
select a.[Scorecard_TypeC]
,a.[Campaign_Name]
,a.[TFN_Description] as [Cell Title]
,c.start_date
,a.[ParentID]
,a.[TFN]
,a.[total_quantity]
,a.[ytd_calls]
,case when a.[ParentID] IN (select [ParentID] from #pidWOWcalls group by [ParentID]) then 'Y'
	else 'N'
	end as [Calls decline?]
,b.Share#
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] as a 
	left join (select [TFN], count(parentid)as Share# from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] where TFN is not null group by [TFN]) as b
	on a.tfn=b.tfn
	left join [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report] as c
	on a.parentid=c.parentid
where a.[TFN] in (select [TFN] from #pidWOWcalls)
group by a.[Scorecard_TypeC]
,a.[TFN]
,a.[Campaign_Name]
,c.start_date
,a.[TFN_Description]
,a.[ParentID]
,a.[total_quantity]
,a.[ytd_calls]
,b.Share#