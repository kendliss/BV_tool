CREATE procedure [dbo].[QC_stimreport.SP03_ClicksDeclines3] as 
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
if object_id('tempdb..#URLclicksdeclines') is not null drop table #URLclicksdeclines
select [Scorecard_TypeC]
,[PlacementName] as [URL]
, SUM(isnull(ytd_clicks,0)) as [Overall Clicks Declines?]
into #URLclicksdeclines
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW]
where [PlacementName] in (select [PlacementName] from #pidWOWclicks)
and placementname not like '%No URL tracking requested%'
group by [Scorecard_TypeC]
,[PlacementName]
having SUM(isnull(ytd_clicks,0))<0


if object_id('tempdb..#URLdeclines_share') is not null drop table #URLdeclines_share
select [Scorecard_TypeC]
,[Track_Start_Date]
,[Track_End_Date]
,[parentid]
,b.[Campaign_Name]
,[Source]
,a.URL
into #URLdeclines_share
from #URLclicksdeclines as a join [javdb].[IREPORT_2014].[dbo].[WB_01_URL_List_WB] as b
on a.URL=b.URL

select * from #URLdeclines_share