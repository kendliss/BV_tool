create procedure [QC_stimreport.SP03_ClicksDSLDRY2] as 
--Click DSL DRY sales
if object_id('tempdb..#pidWOWClick_DSLDRY') is not null drop table #pidWOWClick_DSLDRY
select [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description] as [Cell Title]
,[ParentID]
,a.[PlacementName]
,[ytd_on_dsl_dry]
,Share#
into #pidWOWClick_DSLDRY
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] as a 
	left join (select [PlacementName], count(parentid)as Share# from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] where [PlacementName] is not null group by [PlacementName]) as b
	on a.[PlacementName]=b.[PlacementName]
where [ytd_on_dsl_dry]<0
group by [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description]
,[ParentID]
,a.[PlacementName]
,[ytd_on_dsl_dry]
,Share#
--Checks if the TFNs that had declines at the parentid level increased in clicks overall
--if no TFNs are in the output, then there were not any declines in Clicks at the TFN level
select [Scorecard_TypeC]
,[PlacementName]
, SUM(isnull([ytd_on_dsl_dry],0)) as [Overall Click DSL DRY Sales Declines?]
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW]
where [PlacementName] in (select [PlacementName] from #pidWOWClick_DSLDRY)
group by [Scorecard_TypeC]
,[PlacementName]
having SUM(isnull([ytd_on_dsl_dry],0))<0