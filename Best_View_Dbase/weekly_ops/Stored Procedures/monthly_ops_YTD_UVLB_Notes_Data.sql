
/*
Name:  [weekly_ops].[monthly_ops_YTD_UVLB_Notes_Data]
Description:  Monthly Ops Slides for UVLB and UPRO
Author:  Brittany
Modification Log: Create

Description                  Date        
Created procedure            02/28/14    
*/

CREATE PROCEDURE [weekly_ops].[monthly_ops_YTD_UVLB_Notes_Data] @MediaMonth_YYYYMM int
as
begin 
set nocount on 
if object_id('tempdb..#YTD') is not null drop table #YTD
select  b.Scorecard_tab,b.scorecard_program_channel,
      --actuals
      sum(isnull(itp_dir_calls,0)) as YTDcalls,
      sum(isnull(itp_dir_clicks,0)+isnull(ITP_Dir_QRScans,0)) as YTDclicks,
	  sum(isnull(itp_dir_sales_ts_uvrs_tv_n,0)+ isnull(itp_dir_sales_on_uvrs_tv_n,0)) as YTDactual_TV_sales,
	  --commitment view
      sum(isnull(CV_ITP_Dir_Calls,0)) as YTDcv_calls,
      sum(isnull(CV_ITP_Dir_Clicks,0)) as YTDcv_clicks,
      sum(isnull(CV_ITP_DIR_Sales_TS_UVRS_TV,0)+isnull(CV_ITP_DIR_Sales_ON_UVRS_TV,0)) as YTDcv_TV_sales,
      /*--rolling view
      sum(isnull(Goal_ITP_Dir_Calls,0)) as YTDgoal_calls,
      sum(isnull(Goal_ITP_Dir_Clicks,0)) as YTDgoal_clicks,*/
      --best view
      sum(isnull(BV_ITP_Dir_Calls,0)) as YTDBV_ITP_Dir_Calls,
      sum(isnull(BV_ITP_Dir_Clicks,0)) as YTDBV_ITP_Dir_Clicks
into #YTD
from javdb.ireport_2014.dbo.WB_04_Workbook_Data as a
	join javdb.ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
      on a.tactic_id=b.id
where b.Scorecard_Top_Tab = 'Direct Marketing'
and b.Scorecard_LOB_Tab = 'U-verse'
and b.Scorecard_tab in ('Uverse')
and b.scorecard_program_channel like '%u-verse%'
and b.scorecard_program_channel not like '%drag%'
and b.scorecard_program_channel not like '%D2R%'
and a.MediaMonth_YYYYMM > '201312'
and a.MediaMonth_YYYYMM <= @MediaMonth_YYYYMM
and excludefromscorecard <> 'Y'
group by b.Scorecard_tab,b.scorecard_program_channel

if object_id('weekly_ops.monthly_ops_04YTD_UVLB_Notes') is not null drop table weekly_ops.monthly_ops_04YTD_UVLB_Notes
select Scorecard_tab,scorecard_program_channel,
--actuals
      sum(isnull(YTDcalls,0)) as YTDcalls,
      sum(isnull(YTDcv_calls,0)) as YTDcv_calls,
      sum(isnull(YTDBV_ITP_Dir_Calls,0)) as YTDBV_Calls,      
      sum(isnull(YTDcalls,0))/sum(nullif(YTDcv_calls,0)) as [Calls % to CV],
      sum(isnull(YTDcalls,0))/sum(nullif(YTDBV_ITP_Dir_Calls,0)) as [Calls % to BV],       
      SUM(ISNULL(YTDcalls,0))/(select SUM(isnull(YTDcalls,0))
									as YTDcalls 
									from #YTD) as [Calls % of Total],
      
      sum(isnull(YTDclicks,0)) as YTDclicks,
      sum(isnull(YTDcv_clicks,0)) as YTDcv_clicks,
      sum(isnull(YTDBV_ITP_Dir_Clicks,0)) as YTDBV_Clicks,
      sum(isnull(YTDclicks,0))/sum(nullif(YTDcv_clicks,0)) as [Clicks % to CV],
      sum(isnull(YTDclicks,0))/sum(nullif(YTDBV_ITP_Dir_Clicks,0)) as [Clicks % to BV], 
      SUM(ISNULL(YTDclicks,0))/(select SUM(isnull(YTDclicks,0))as YTDclicks from #YTD) as [Clicks % of Total],
            
      sum(isnull(YTDactual_TV_sales,0)) as YTDactual_TV_sales,
      sum(isnull(YTDcv_TV_sales,0)) as YTDcv_TV_sales,
      sum(isnull(YTDactual_TV_sales,0))/sum(nullif(YTDcv_TV_sales,0)) as [TVSales % to CV],
      SUM(ISNULL(YTDactual_TV_sales,0))/(select SUM(isnull(YTDactual_TV_sales,0))as YTDactual_TV_sales from #YTD) as [TVSales % of Total]

 into weekly_ops.monthly_ops_04YTD_UVLB_Notes
 from #YTD
 group by Scorecard_tab,scorecard_program_channel
 select * from weekly_ops.monthly_ops_04YTD_UVLB_Notes
set nocount off
end
