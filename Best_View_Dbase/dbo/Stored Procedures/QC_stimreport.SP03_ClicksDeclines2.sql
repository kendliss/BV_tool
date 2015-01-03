
CREATE procedure [dbo].[QC_stimreport.SP03_ClicksDeclines2] as 
if object_id('tempdb..#pidWOWclicks') is not null drop table #pidWOWclicks
select [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description] as [Cell Title]
,[ParentID]
,a.[PlacementName] as [URL]
,[ytd_clicks]
,Share#
into #pidWOWclicks
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] as a 
	left join (select [PlacementName], count(parentid)as Share# from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] where [PlacementName] is not null group by [PlacementName]) as b
	on a.[PlacementName]=b.[PlacementName]
where [ytd_clicks]<0
group by [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description]
,[ParentID]
,a.[PlacementName]
,[ytd_clicks]
,Share#
--Checks if the URLs that had declines at the parentid level increased in clicks overall
--if no URLs are in the output, then there were not any declines in clicks at the URL level
select [Scorecard_TypeC]
,[PlacementName] as [URL]
, SUM(isnull(ytd_clicks,0)) as [Overall Clicks Declines?]
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW]
where [PlacementName] in (select [PlacementName] from #pidWOWclicks)
and placementname not like '%No URL tracking requested%'
group by [Scorecard_TypeC]
,[PlacementName]
having SUM(isnull(ytd_clicks,0))<0
