
CREATE procedure [dbo].[QC_stimreport.SP03_ClicksHSIA1] as 
--Click HSIA sales
if object_id('tempdb..#pidWOWClick_HSIA') is not null drop table #pidWOWClick_HSIA
select [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description] as [Cell Title]
,[ParentID]
,a.[PlacementName]
,[ytd_on_uvrs_HSIA]
,Share#
into #pidWOWClick_HSIA
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] as a 
	left join (select [PlacementName], count(parentid)as Share# from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] where [PlacementName] is not null group by [PlacementName]) as b
	on a.[PlacementName]=b.[PlacementName]
where [ytd_on_uvrs_HSIA]<0
group by [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description]
,[ParentID]
,a.[PlacementName]
,[ytd_on_uvrs_HSIA]
,Share#

--Looks at Clicks declines and checks for sharing
select [Scorecard_TypeC]
,a.[Campaign_Name]
,a.[TFN_Description] as [Cell Title]
,a.[ParentID]
,a.[PlacementName]
,a.[total_quantity]
,a.[ytd_on_uvrs_HSIA]
,case when [ParentID] IN (select [ParentID] from #pidWOWClick_HSIA group by [ParentID]) then 'Y'
	else 'N'
	end as [Clicks HSIA decline?]
,b.Share#
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] as a 
	left join (select [PlacementName], count(parentid)as Share# from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] where [PlacementName] is not null group by [PlacementName]) as b
	on a.[PlacementName]=b.[PlacementName]
where a.[PlacementName] in (select [PlacementName] from #pidWOWClick_HSIA)
group by [Scorecard_TypeC]
,a.[PlacementName]
,a.[Campaign_Name]
,a.[TFN_Description]
,a.[ParentID]
,a.[total_quantity]
,a.[ytd_on_uvrs_HSIA]
,b.Share#