
CREATE procedure [dbo].[QC_stimreport.SP03_ClicksVOIP1] as 
--Click VOIP sales
if object_id('tempdb..#pidWOWClick_VOIP') is not null drop table #pidWOWClick_VOIP
select [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description] as [Cell Title]
,[ParentID]
,a.[PlacementName]
,[ytd_on_uvrs_VOIP]
,Share#
into #pidWOWClick_VOIP
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] as a 
	left join (select [PlacementName], count(parentid)as Share# from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] where [PlacementName] is not null group by [PlacementName]) as b
	on a.[PlacementName]=b.[PlacementName]
where [ytd_on_uvrs_VOIP]<0
group by [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description]
,[ParentID]
,a.[PlacementName]
,[ytd_on_uvrs_VOIP]
,Share#

--Looks at Clicks declines and checks for sharing
select [Scorecard_TypeC]
,a.[Campaign_Name]
,a.[TFN_Description] as [Cell Title]
,a.[ParentID]
,a.[PlacementName]
,a.[total_quantity]
,a.[ytd_on_uvrs_VOIP]
,case when [ParentID] IN (select [ParentID] from #pidWOWClick_VOIP group by [ParentID]) then 'Y'
	else 'N'
	end as [Clicks VOIP decline?]
,b.Share#
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] as a 
	left join (select [PlacementName], count(parentid)as Share# from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] where [PlacementName] is not null group by [PlacementName]) as b
	on a.[PlacementName]=b.[PlacementName]
where a.[PlacementName] in (select [PlacementName] from #pidWOWClick_VOIP)
group by [Scorecard_TypeC]
,a.[PlacementName]
,a.[Campaign_Name]
,a.[TFN_Description]
,a.[ParentID]
,a.[total_quantity]
,a.[ytd_on_uvrs_VOIP]
,b.Share#
