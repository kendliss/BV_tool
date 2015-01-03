
/*
Name:  [weekly_ops].[monthly_ops_MTD]
Description:  Monthly Ops Slides for UVLB and UPRO
Author:  Brittany
Modification Log: Create

Description                  Date        
Created procedure            02/12/14    
*/

CREATE PROCEDURE [weekly_ops].[monthly_ops_MTD] @MediaMonth_YYYYMM int
as
begin 
set nocount on 
if object_id('tempdb..#MTD') is not null drop table #MTD
select b.Scorecard_tab,a.MediaMonth_YYYYMM,
      --actuals
      sum(isnull(itp_dir_calls,0)) as MTDcalls,
      sum(isnull(itp_dir_clicks,0)+isnull(ITP_Dir_QRScans,0)) as MTDclicks,
	  sum(isnull(itp_dir_sales_ts_uvrs_tv_n,0)+ isnull(itp_dir_sales_on_uvrs_tv_n,0)) as MTDactual_TV_sales,
	  --commitment view
      sum(isnull(CV_ITP_Dir_Calls,0)) as MTDcv_calls,
      sum(isnull(CV_ITP_Dir_Clicks,0)) as MTDcv_clicks,
      sum(isnull(CV_ITP_DIR_Sales_TS_UVRS_TV,0)+isnull(CV_ITP_DIR_Sales_ON_UVRS_TV,0)) as MTDcv_TV_sales,
      /*--rolling view
      sum(isnull(Goal_ITP_Dir_Calls,0)) as MTDgoal_calls,
      sum(isnull(Goal_ITP_Dir_Clicks,0)) as MTDgoal_clicks,*/
      --best view
      sum(isnull(BV_ITP_Dir_Calls,0)) as MTDBV_ITP_Dir_Calls,
      sum(isnull(BV_ITP_Dir_Clicks,0)) as MTDBV_ITP_Dir_Clicks
into #MTD
from javdb.ireport_2014.dbo.WB_04_Workbook_Data as a
	join javdb.ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
      on a.tactic_id=b.id
where b.Scorecard_Top_Tab = 'Direct Marketing'
and b.Scorecard_LOB_Tab = 'U-verse'
and b.Scorecard_tab in ('Uverse', 'Prospect')
and b.scorecard_program_channel like '%u-verse%'
and b.scorecard_program_channel not like '%drag%'
and excludefromscorecard <> 'Y'
and a.MediaMonth_YYYYMM > '201312'
group by b.Scorecard_tab,a.MediaMonth_YYYYMM

if object_id('weekly_ops.monthly_ops_01MTD') is not null drop table weekly_ops.monthly_ops_01MTD
select Scorecard_tab,MediaMonth_YYYYMM,
	  --actuals
      sum(isnull(MTDcalls,0)) as MTDcalls,
      sum(isnull(MTDclicks,0)) as MTDclicks,
	  sum(isnull(MTDactual_TV_sales,0)) as MTDactual_TV_sales,
	  --commitment view
      sum(isnull(MTDcv_calls,0)) as MTDcv_calls,
      sum(isnull(MTDcv_clicks,0)) as MTDcv_clicks,
      sum(isnull(MTDcv_TV_sales,0)) as MTDcv_TV_sales,
      /*--rolling view
      sum(isnull(MTDgoal_calls,0)) as MTDgoal_calls,
      sum(isnull(MTDgoal_clicks,0)) as MTDgoal_clicks,*/
      --best view
      sum(isnull(MTDBV_ITP_Dir_Calls,0)) as MTDBV_Calls,
      sum(isnull(MTDBV_ITP_Dir_Clicks,0)) as MTDBV_Clicks
   into weekly_ops.monthly_ops_01MTD
   from #MTD
   where MediaMonth_YYYYMM = @MediaMonth_YYYYMM
   group by Scorecard_tab,MediaMonth_YYYYMM

select * from weekly_ops.monthly_ops_01MTD


set nocount off
end

