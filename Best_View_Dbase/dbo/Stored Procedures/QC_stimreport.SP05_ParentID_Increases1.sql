
CREATE procedure [dbo].[QC_stimreport.SP05_ParentID_Increases1] as 
--parentid level increases
select a.[Scorecard_TypeC]
,b.start_date
,b.days_in_home
,b.weeks_in_home
,a.[Campaign_Name]
,a.[TFN_Description] as [Cell Title]
,a.[ParentID]
,a.total_quantity
,a.total_budget
,a.ytd_calls
,a.ytd_ts_uvrs_tv
,a.ytd_ts_local_accl
,a.ytd_ts_ld
,a.ytd_ts_dsl_reg
,a.ytd_ts_cing
,a.ytd_ts_uvrs_voip
,a.ytd_ts_uvrs_hsia
,a.ytd_ts_dsl_dry
,a.ytd_ts_dsl_ip
,a.ytd_ts_dish
,a.ytd_TS_DLIFE
,a.ytd_clicks
,a.ytd_qrscans
,a.ytd_on_local_accl
,a.ytd_on_ld
,a.ytd_on_dsl_reg
,a.ytd_on_dsl_ip
,a.ytd_on_uvrs_tv
,a.ytd_on_cing
,a.ytd_on_uvrs_voip
,a.ytd_on_uvrs_hsia
,a.ytd_on_dsl_dry
,a.ytd_on_dish
,b.tfn
,b.placementname
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] as a left join 
	[javdb].[IREPORT_2014].[dbo].WB_07_Stim_report as b
	on a.[ParentID]=b.[ParentID]
where (a.ytd_clicks>0 or 	a.ytd_qrscans>0 or 	a.ytd_on_local_accl>0 or 	
		a.ytd_on_ld>0 or 	a.ytd_on_dsl_reg>0 or 	a.ytd_on_dsl_ip>0 or 	a.ytd_on_uvrs_tv>0 or 	
		a.ytd_on_cing>0 or 	a.ytd_on_uvrs_voip>0 or 	a.ytd_on_uvrs_hsia>0 or 	a.ytd_on_dsl_dry>0 or 	
		a.ytd_on_dish>0 or 	a.ytd_ts_local_accl>0 or 	a.ytd_ts_ld>0 or 	a.ytd_ts_dsl_reg>0 or 	
		a.ytd_ts_uvrs_tv>0 or 	a.ytd_ts_cing>0 or 	a.ytd_ts_uvrs_voip>0 or 	a.ytd_ts_uvrs_hsia>0 or 	
		a.ytd_ts_dsl_dry>0 or 	a.ytd_ts_dsl_ip>0 or 	a.ytd_ts_dish>0 or a.ytd_TS_DLIFE>0 or 	a.ytd_calls>0)
		and b.days_in_home is not null
group by a.[Scorecard_TypeC]
,b.start_date
,b.days_in_home
,b.weeks_in_home
,a.[Campaign_Name]
,a.[TFN_Description]
,a.[ParentID]
,a.total_quantity
,a.total_budget
,a.ytd_calls
,a.ytd_ts_uvrs_tv
,a.ytd_ts_local_accl
,a.ytd_ts_ld
,a.ytd_ts_dsl_reg
,a.ytd_ts_cing
,a.ytd_ts_uvrs_voip
,a.ytd_ts_uvrs_hsia
,a.ytd_ts_dsl_dry
,a.ytd_ts_dsl_ip
,a.ytd_ts_dish
,a.ytd_TS_DLIFE
,a.ytd_clicks
,a.ytd_qrscans
,a.ytd_on_local_accl
,a.ytd_on_ld
,a.ytd_on_dsl_reg
,a.ytd_on_dsl_ip
,a.ytd_on_uvrs_tv
,a.ytd_on_cing
,a.ytd_on_uvrs_voip
,a.ytd_on_uvrs_hsia
,a.ytd_on_dsl_dry
,a.ytd_on_dish
,b.tfn
,b.placementname
order by a.[Scorecard_TypeC] desc
,b.days_in_home
,b.weeks_in_home
,a.[Campaign_Name]
,a.total_quantity desc
,a.total_budget