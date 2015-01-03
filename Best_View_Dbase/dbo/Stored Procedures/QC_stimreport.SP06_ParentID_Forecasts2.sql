
create procedure [QC_stimreport.SP06_ParentID_Forecasts2] as 
--if forecasts decline and qty does not, check new/changed for a date change
select a.[Scorecard_TypeC]
,b.start_date
,b.days_in_home
,b.weeks_in_home
,a.[Campaign_Name]
,a.[TFN_Description] as [Cell Title]
,a.[ParentID]
, sum(isnull(a.total_quantity,0)) as total_quantity
, sum(isnull(a.goal_calls,0)) as goal_calls
, sum(isnull(a.goal_clicks,0)) as goal_clicks
, sum(isnull(a.goal_tv_telesales,0)) as goal_tv_telesales
, sum(isnull(a.goal_tv_onlinesales,0)) as goal_tv_onlinesales
, sum(isnull(a.goal_telesales,0)) as goal_telesales
, sum(isnull(a.goal_onlinesales,0)) as goal_onlinesales
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] as a left join 
	[javdb].[IREPORT_2014].[dbo].WB_07_Stim_report as b
	on a.[ParentID]=b.[ParentID]
where b.days_in_home is not null
group by a.[Scorecard_TypeC]
,a.[TFN_Description]
,a.[ParentID]
,b.start_date
,b.days_in_home
,b.weeks_in_home
,a.[Campaign_Name]
having (sum(isnull(a.goal_calls,0))<0
or sum(isnull(a.goal_clicks,0))<0
or sum(isnull(a.goal_telesales,0))<0
or sum(isnull(a.goal_onlinesales,0))<0
or sum(isnull(a.goal_tv_telesales,0))<0
or sum(isnull(a.goal_tv_onlinesales,0))<0)
and (sum(isnull(a.total_quantity,0))>0)
order by a.[Scorecard_TypeC] desc
,sum(isnull(a.total_quantity,0))desc
,b.days_in_home
,b.weeks_in_home
,a.[Campaign_Name]
