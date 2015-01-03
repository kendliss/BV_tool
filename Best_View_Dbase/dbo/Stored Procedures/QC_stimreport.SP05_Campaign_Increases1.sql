create procedure [QC_stimreport.SP05_Campaign_Increases1] as 
--campaign level increases
select a.[Scorecard_TypeC]
,b.start_date
,b.days_in_home
,b.weeks_in_home
,a.[Campaign_Name]
, sum(isnull(a.total_budget,0)) as total_budget
, sum(isnull(a.total_quantity,0)) as total_quantity
, sum(isnull(a.ytd_calls,0)) as ytd_calls
, sum(isnull(a.ytd_clicks,0)) as ytd_clicks
, sum(isnull(a.ytd_ts_local_accl,0)) as ytd_ts_local_accl
, sum(isnull(a.ytd_ts_ld,0)) as ytd_ts_ld
, sum(isnull(a.ytd_ts_dsl_reg,0)) as ytd_ts_dsl_reg
, sum(isnull(a.ytd_ts_uvrs_tv,0)) as ytd_ts_uvrs_tv
, sum(isnull(a.ytd_ts_cing,0)) as ytd_ts_cing
, sum(isnull(a.ytd_ts_uvrs_voip,0)) as ytd_ts_uvrs_voip
, sum(isnull(a.ytd_ts_uvrs_hsia,0)) as ytd_ts_uvrs_hsia
, sum(isnull(a.ytd_ts_dsl_dry,0)) as ytd_ts_dsl_dry
, sum(isnull(a.ytd_ts_dsl_ip,0)) as ytd_ts_dsl_ip
, sum(isnull(a.ytd_ts_dish,0)) as ytd_ts_dish
, sum(isnull(a.ytd_TS_DLIFE,0)) as ytd_TS_DLIFE
, sum(isnull(a.ytd_qrscans,0)) as ytd_qrscans
, sum(isnull(a.ytd_on_local_accl,0)) as ytd_on_local_accl
, sum(isnull(a.ytd_on_ld,0)) as ytd_on_ld
, sum(isnull(a.ytd_on_dsl_reg,0)) as ytd_on_dsl_reg
, sum(isnull(a.ytd_on_dsl_ip,0)) as ytd_on_dsl_ip
, sum(isnull(a.ytd_on_uvrs_tv,0)) as ytd_on_uvrs_tv
, sum(isnull(a.ytd_on_cing,0)) as ytd_on_cing
, sum(isnull(a.ytd_on_uvrs_voip,0)) as ytd_on_uvrs_voip
, sum(isnull(a.ytd_on_uvrs_hsia,0)) as ytd_on_uvrs_hsia
, sum(isnull(a.ytd_on_dsl_dry,0)) as ytd_on_dsl_dry
, sum(isnull(a.ytd_on_dish,0)) as ytd_on_dish
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
		or sum(isnull(a.ytd_ts_dish,0))>0	or sum(isnull(a.ytd_TS_DLIFE,0))>0 or sum(isnull(a.ytd_calls,0))>0)
order by a.[Scorecard_TypeC] desc
,b.days_in_home
,b.weeks_in_home
,a.[Campaign_Name]
,sum(isnull(a.total_quantity,0))desc