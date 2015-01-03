
create procedure [QC_stimreport.SP03_ClicksDSLREG1] as 
--Click DSL REG sales
if object_id('tempdb..#pidWOWClick_DSLREG') is not null drop table #pidWOWClick_DSLREG
select [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description] as [Cell Title]
,[ParentID]
,a.[PlacementName]
,[ytd_on_dsl_reg]
,Share#
into #pidWOWClick_DSLREG
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] as a 
	left join (select [PlacementName], count(parentid)as Share# from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] where [PlacementName] is not null group by [PlacementName]) as b
	on a.[PlacementName]=b.[PlacementName]
where [ytd_on_dsl_reg]<0
group by [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description]
,[ParentID]
,a.[PlacementName]
,[ytd_on_dsl_reg]
,Share#

--Looks at Clicks declines and checks for sharing
select [Scorecard_TypeC]
,a.[Campaign_Name]
,a.[TFN_Description] as [Cell Title]
,a.[ParentID]
,a.[PlacementName]
,a.[total_quantity]
,a.[ytd_on_dsl_reg]
,case when [ParentID] IN (select [ParentID] from #pidWOWClick_DSLREG group by [ParentID]) then 'Y'
	else 'N'
	end as [Clicks decline?]
,b.Share#
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] as a 
	left join (select [PlacementName], count(parentid)as Share# from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] where [PlacementName] is not null group by [PlacementName]) as b
	on a.[PlacementName]=b.[PlacementName]
where a.[PlacementName] in (select [PlacementName] from #pidWOWClick_DSLREG)
group by [Scorecard_TypeC]
,a.[PlacementName]
,a.[Campaign_Name]
,a.[TFN_Description]
,a.[ParentID]
,a.[total_quantity]
,a.[ytd_on_dsl_reg]
,b.Share#