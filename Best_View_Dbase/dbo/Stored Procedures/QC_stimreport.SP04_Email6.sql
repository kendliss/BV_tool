
CREATE procedure [dbo].[QC_stimreport.SP04_Email6] as 
--ytd_clicks=0 and ytd_quantity_delivered=0 and ytd_unique_opens =0 and ytd_opt_outs=0
select campaign_type as [Scorecard Type]
,campaign_name as [Campaign Name]
,project_id as [Campaign ID]
,start_date
,ParentID
,tfn_description as [Cell Name]
,total_quantity
,ytd_clicks
,ytd_quantity_delivered
,ytd_unique_opens
,ytd_opt_outs
,SUM(isnull(ytd_on_local_accl,0)+ isnull(ytd_on_ld,0)+ isnull(ytd_on_dsl_reg,0)+ isnull(ytd_on_dsl_ip,0)
	+ isnull(ytd_on_uvrs_tv,0)+ isnull(ytd_on_cing,0)+ isnull(ytd_on_uvrs_voip,0)+ isnull(ytd_on_uvrs_hsia,0)
	+ isnull(ytd_on_dsl_dry,0)+ isnull(ytd_on_dish,0)) as online_sales
from javdb.ireport_2014.dbo.WB_07_Stim_report
where (ytd_clicks=0 and ytd_quantity_delivered=0 and ytd_unique_opens =0 and ytd_opt_outs=0)
and medium_type like '%e-mail%'
and campaign_name not like '%2013 November Early Month EM Initial%'
group by campaign_type 
,campaign_name
,project_id
,start_date
,ParentID
,tfn_description
,total_quantity
,ytd_clicks
,ytd_quantity_delivered
,ytd_unique_opens
,ytd_opt_outs
order by start_date desc
,ytd_clicks desc