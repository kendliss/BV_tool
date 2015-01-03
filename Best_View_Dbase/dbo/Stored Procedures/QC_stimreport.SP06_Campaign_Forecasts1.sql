create procedure [QC_stimreport.SP06_Campaign_Forecasts1] as 
--campaign level increases in forecasts and actuals
select a.[Scorecard_TypeC]
,b.start_date
,b.days_in_home
,b.weeks_in_home
,a.[Campaign_Name]
, sum(isnull(a.total_quantity,0)) as total_quantity
, sum(isnull(a.goal_calls,0)) as goal_calls
, sum(isnull(a.ytd_calls,0)) as ytd_calls
, sum(isnull(a.goal_clicks,0)) as goal_clicks
, sum(isnull(a.ytd_clicks,0)) as ytd_clicks
, sum(isnull(a.goal_tv_telesales,0)) as goal_tv_telesales
, sum(isnull(a.ytd_ts_uvrs_tv,0)) as ytd_ts_uvrs_tv
, sum(isnull(a.goal_tv_onlinesales,0)) as goal_tv_onlinesales
, sum(isnull(a.ytd_on_uvrs_tv,0)) as ytd_on_uvrs_tv
, sum(isnull(a.goal_telesales,0)) as goal_telesales
, sum(isnull(a.ytd_ts_local_accl,0)
		+ isnull(a.ytd_ts_dsl_reg,0)
		+ isnull(a.ytd_ts_uvrs_tv,0)
		+ isnull(a.ytd_ts_cing,0)
		+ isnull(a.ytd_ts_uvrs_voip,0)
		+ isnull(a.ytd_ts_uvrs_hsia,0)
		+ isnull(a.ytd_ts_dsl_dry,0)
		+ isnull(a.ytd_ts_dsl_ip,0)
		+ isnull(a.ytd_ts_dish,0)
		+ isnull(a.ytd_TS_DLIFE,0)) as ytd_ts_strategic
, sum(isnull(a.goal_onlinesales,0)) as goal_onlinesales
, sum(isnull(a.ytd_on_local_accl,0)
		+ isnull(a.ytd_on_dsl_reg,0)
		+ isnull(a.ytd_on_dsl_ip,0)
		+ isnull(a.ytd_on_uvrs_tv,0)
		+ isnull(a.ytd_on_cing,0)
		+ isnull(a.ytd_on_uvrs_voip,0)
		+ isnull(a.ytd_on_uvrs_hsia,0)
		+ isnull(a.ytd_on_dsl_dry,0)
		+ isnull(a.ytd_on_dish,0)) as ytd_on_strategic
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] as a left join 
	[javdb].[IREPORT_2014].[dbo].WB_07_Stim_report as b
	on a.[ParentID]=b.[ParentID]
where b.days_in_home is not null
group by a.[Scorecard_TypeC]
,b.start_date
,b.days_in_home
,b.weeks_in_home
,a.[Campaign_Name]
having (sum(isnull(a.ytd_clicks,0))>0	or sum(isnull(a.ytd_qrscans,0))>0	or sum(isnull(a.ytd_on_local_accl,0))>0	
		or sum(isnull(a.ytd_on_ld,0))>0	or sum(isnull(a.ytd_on_dsl_reg,0))>0	or sum(isnull(a.ytd_on_dsl_ip,0))>0	
		or sum(isnull(a.ytd_on_uvrs_tv,0))>0	or sum(isnull(a.ytd_on_cing,0))>0	or sum(isnull(a.ytd_on_uvrs_voip,0))>0	
		or sum(isnull(a.ytd_on_uvrs_hsia,0))>0	or sum(isnull(a.ytd_on_dsl_dry,0))>0	or sum(isnull(a.ytd_on_dish,0))>0	
		or sum(isnull(a.ytd_ts_local_accl,0))>0	or sum(isnull(a.ytd_ts_ld,0))>0	or sum(isnull(a.ytd_ts_dsl_reg,0))>0	
		or sum(isnull(a.ytd_ts_uvrs_tv,0))>0	or sum(isnull(a.ytd_ts_cing,0))>0	or sum(isnull(a.ytd_ts_uvrs_voip,0))>0	
		or sum(isnull(a.ytd_ts_uvrs_hsia,0))>0	or sum(isnull(a.ytd_ts_dsl_dry,0))>0	or sum(isnull(a.ytd_ts_dsl_ip,0))>0	
		or sum(isnull(a.ytd_ts_dish,0))>0	or sum(isnull(a.ytd_calls,0))>0 or sum(isnull(a.ytd_TS_DLIFE,0))>0)
order by a.[Scorecard_TypeC] desc
,sum(isnull(a.total_quantity,0))desc
,b.days_in_home
,b.weeks_in_home
,a.[Campaign_Name]