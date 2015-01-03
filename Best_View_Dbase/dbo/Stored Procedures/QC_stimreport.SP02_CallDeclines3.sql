CREATE procedure [dbo].[QC_stimreport.SP02_CallDeclines3] as 
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

if object_id('tempdb..#TFNcallsdeclines') is not null drop table #TFNcallsdeclines
select [Scorecard_TypeC]
,[TFN]
, SUM(isnull([ytd_calls],0)) as [Overall Calls Declines?]
into #TFNcallsdeclines
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW]
where [TFN] in (select [TFN] from #pidWOWcalls)
group by [Scorecard_TypeC]
,[TFN]
having SUM(isnull([ytd_calls],0))<0

if object_id('tempdb..#TFNdeclines_share') is not null drop table #TFNdeclines_share
select [Scorecard_TypeC]
,[Track_Start_Date]
,[Track_End_Date]
,[parentid]
,b.[Campaign_Name]
,[Source]
,a.[TFN]
into #TFNdeclines_share
from #TFNcallsdeclines as a join [javdb].[IREPORT_2014].[dbo].[WB_01_TFN_List_WB] as b
on a.tfn=b.tfn
where b.source not like '%movers%'

select * from #TFNdeclines_share