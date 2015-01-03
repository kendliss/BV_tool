create procedure [QC_stimreport.SP07_CallsandSales2] as 
--Check for campaigns with 0 calls and sales
select 
campaign_type as [Scorecard_Type]
,campaign_name as [Campaign Name]
,project_id as [Campaign ID]
,start_date
,ParentID
,tfn_description as [Cell Name]
,total_quantity
,ytd_calls
,SUM(isnull(ytd_ts_local_accl,0)+ isnull(ytd_ts_ld,0)+ isnull(ytd_ts_dsl_reg,0)+ isnull(ytd_ts_dsl_ip,0)
	+ isnull(ytd_ts_uvrs_tv,0)+ isnull(ytd_ts_cing,0)+ isnull(ytd_ts_uvrs_voip,0)+ isnull(ytd_ts_uvrs_hsia,0)
	+ isnull(ytd_ts_dsl_dry,0)+ isnull(ytd_ts_dish,0+ isnull(ytd_TS_DLIFE,0))) as call_sales
from javdb.ireport_2014.dbo.WB_07_Stim_report
group by campaign_type
,campaign_name
,project_id
,start_date
,ParentID
,tfn_description
,total_quantity
,ytd_calls
having (SUM(isnull(ytd_ts_local_accl,0)+ isnull(ytd_ts_ld,0)+ isnull(ytd_ts_dsl_reg,0)+ isnull(ytd_ts_dsl_ip,0)
	+ isnull(ytd_ts_uvrs_tv,0)+ isnull(ytd_ts_cing,0)+ isnull(ytd_ts_uvrs_voip,0)+ isnull(ytd_ts_uvrs_hsia,0)
	+ isnull(ytd_ts_dsl_dry,0)+ isnull(ytd_ts_dish,0)+ isnull(ytd_TS_DLIFE,0))>0) and ytd_calls=0
order by start_date desc
,ytd_calls desc