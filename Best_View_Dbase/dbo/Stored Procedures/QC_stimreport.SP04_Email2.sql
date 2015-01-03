
CREATE procedure [dbo].[QC_stimreport.SP04_Email2] as 
--Check for emails with 0 clicks and sales
select campaign_type as [Scorecard Type]
,campaign_name as [Campaign Name]
,project_id as [Campaign ID]
,start_date
,ParentID
,tfn_description as [Cell Name]
,total_quantity
,ytd_clicks
,SUM(isnull(ytd_on_local_accl,0)+ isnull(ytd_on_ld,0)+ isnull(ytd_on_dsl_reg,0)+ isnull(ytd_on_dsl_ip,0)
	+ isnull(ytd_on_uvrs_tv,0)+ isnull(ytd_on_cing,0)+ isnull(ytd_on_uvrs_voip,0)+ isnull(ytd_on_uvrs_hsia,0)
	+ isnull(ytd_on_dsl_dry,0)+ isnull(ytd_on_dish,0)) as online_sales
from javdb.ireport_2014.dbo.WB_07_Stim_report
where medium_type like '%e-mail%'
group by campaign_type
,campaign_name
,project_id
,start_date
,ParentID
,tfn_description
,total_quantity
,ytd_clicks
having (SUM(isnull(ytd_on_local_accl,0)+ isnull(ytd_on_ld,0)+ isnull(ytd_on_dsl_reg,0)+ isnull(ytd_on_dsl_ip,0)
	+ isnull(ytd_on_uvrs_tv,0)+ isnull(ytd_on_cing,0)+ isnull(ytd_on_uvrs_voip,0)+ isnull(ytd_on_uvrs_hsia,0)
	+ isnull(ytd_on_dsl_dry,0)+ isnull(ytd_on_dish,0))>0) and ytd_clicks=0
order by start_date desc
,ytd_clicks desc
