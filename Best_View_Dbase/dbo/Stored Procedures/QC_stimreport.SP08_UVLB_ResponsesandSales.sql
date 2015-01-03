CREATE PROCEDURE [dbo].[QC_stimreport.SP08_UVLB_ResponsesandSales]
as 


if object_id('tempdb..#UVLB_ResponsesandSales') is not null drop table #UVLB_ResponsesandSales
select Scorecard_TypeC
, sum(isnull(ytd_calls,0)) as ytd_calls
, sum(isnull(ytd_clicks,0)) as ytd_clicks
, sum(isnull(ytd_ts_uvrs_tv,0)) as ytd_ts_uvrs_tv
, sum(isnull(ytd_ts_uvrs_hsia,0)) as ytd_ts_uvrs_hsia
, sum(isnull(ytd_ts_uvrs_voip,0)) as ytd_ts_uvrs_voip

, sum(isnull(ytd_ts_cing,0)) as ytd_ts_cing
, sum(isnull(ytd_ts_dish,0)) as ytd_ts_dish
, sum(isnull(ytd_ts_dsl_dry,0)) as ytd_ts_dsl_dry
, sum(isnull(ytd_ts_dsl_ip,0)) as ytd_ts_dsl_ip
, sum(isnull(ytd_ts_dsl_reg,0)) as ytd_ts_dsl_reg
, sum(isnull(ytd_ts_local_accl,0)) as ytd_ts_local_accl

, sum(isnull(ytd_on_uvrs_tv,0)) as ytd_on_uvrs_tv
, sum(isnull(ytd_on_uvrs_hsia,0)) as ytd_on_uvrs_hsia
, sum(isnull(ytd_on_uvrs_voip,0)) as ytd_on_uvrs_voip

, sum(isnull(ytd_on_cing,0)) as ytd_on_cing
, sum(isnull(ytd_on_dish,0)) as ytd_on_dish
, sum(isnull(ytd_on_dsl_dry,0)) as ytd_on_dsl_dry
, sum(isnull(ytd_on_dsl_ip,0)) as ytd_on_dsl_ip
, sum(isnull(ytd_on_dsl_reg,0)) as ytd_on_dsl_reg
, sum(isnull(ytd_on_ld,0)) as ytd_on_ld
, sum(isnull(ytd_on_local_accl,0)) as ytd_on_local_accl


into #UVLB_ResponsesandSales
from javdb.ireport_2014.dbo.WB_07_Stim_Report_WOW
where Scorecard_TypeC in ('Uverse Base Acq')
group by Scorecard_TypeC
select * from #UVLB_ResponsesandSales