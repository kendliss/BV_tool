

/*
Name:  [weekly_ops].[monthly_ops]
Description:  Monthly Ops Slides for UVLB and UPRO
Author:  Brittany
Modification Log: Create

Description                  Date        
Created procedure            03/06/14    
*/

CREATE PROCEDURE [weekly_ops].[monthly_ops] @MediaMonth_YYYYMM int
as
begin 
set nocount on 

/*MTD Data*/
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
and a.MediaMonth_YYYYMM = @MediaMonth_YYYYMM
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
      --best view
      sum(isnull(MTDBV_ITP_Dir_Calls,0)) as MTDBV_Calls,
      sum(isnull(MTDBV_ITP_Dir_Clicks,0)) as MTDBV_Clicks
   into weekly_ops.monthly_ops_01MTD
   from #MTD
   group by Scorecard_tab,MediaMonth_YYYYMM

--select * from weekly_ops.monthly_ops_01MTD

/*YTD Data*/
if object_id('tempdb..#YTD') is not null drop table #YTD
select  b.scorecard_program_channel,
      --actuals
      sum(isnull(itp_dir_calls,0)) as YTDcalls,
      sum(isnull(itp_dir_clicks,0)+isnull(ITP_Dir_QRScans,0)) as YTDclicks,
	  sum(isnull(itp_dir_sales_ts_uvrs_tv_n,0)+ isnull(itp_dir_sales_on_uvrs_tv_n,0)) as YTDactual_TV_sales,
	  --commitment view
      sum(isnull(CV_ITP_Dir_Calls,0)) as YTDcv_calls,
      sum(isnull(CV_ITP_Dir_Clicks,0)) as YTDcv_clicks,
      sum(isnull(CV_ITP_DIR_Sales_TS_UVRS_TV,0)+isnull(CV_ITP_DIR_Sales_ON_UVRS_TV,0)) as YTDcv_TV_sales,
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
and a.MediaMonth_YYYYMM > '201312'
and a.MediaMonth_YYYYMM <= @MediaMonth_YYYYMM
and excludefromscorecard <> 'Y'
group by b.scorecard_program_channel

if object_id('weekly_ops.monthly_ops_02YTD') is not null drop table weekly_ops.monthly_ops_02YTD
select scorecard_program_channel,
	  --actuals
      sum(isnull(YTDcalls,0)) as YTDcalls,
      sum(isnull(YTDclicks,0)) as YTDclicks,
	  sum(isnull(YTDactual_TV_sales,0)) as YTDactual_TV_sales,
	  --commitment view
      sum(isnull(YTDcv_calls,0)) as YTDcv_calls,
      sum(isnull(YTDcv_clicks,0)) as YTDcv_clicks,
      sum(isnull(YTDcv_TV_sales,0)) as YTDcv_TV_sales,
      --best view
      sum(isnull(YTDBV_ITP_Dir_Calls,0)) as YTDBV_Calls,
      sum(isnull(YTDBV_ITP_Dir_Clicks,0)) as YTDBV_Clicks
 into weekly_ops.monthly_ops_02YTD
 from #YTD
 group by scorecard_program_channel

/*MTD Notes Data*/
if object_id('tempdb..#MTDNotes') is not null drop table #MTDNotes
select b.Scorecard_tab,b.scorecard_program_channel,a.MediaMonth_YYYYMM,
      --actuals
      sum(isnull(itp_dir_calls,0)) as MTDcalls,
      sum(isnull(itp_dir_clicks,0)+isnull(ITP_Dir_QRScans,0)) as MTDclicks,
	  sum(isnull(itp_dir_sales_ts_uvrs_tv_n,0)+ isnull(itp_dir_sales_on_uvrs_tv_n,0)) as MTDactual_TV_sales,
	  --commitment view
      sum(isnull(CV_ITP_Dir_Calls,0)) as MTDcv_calls,
      sum(isnull(CV_ITP_Dir_Clicks,0)) as MTDcv_clicks,
      sum(isnull(CV_ITP_DIR_Sales_TS_UVRS_TV,0)+isnull(CV_ITP_DIR_Sales_ON_UVRS_TV,0)) as MTDcv_TV_sales,
      --best view
      sum(isnull(BV_ITP_Dir_Calls,0)) as MTDBV_ITP_Dir_Calls,
      sum(isnull(BV_ITP_Dir_Clicks,0)) as MTDBV_ITP_Dir_Clicks
into #MTDNotes
from javdb.ireport_2014.dbo.WB_04_Workbook_Data as a
	join javdb.ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
      on a.tactic_id=b.id
where b.Scorecard_Top_Tab = 'Direct Marketing'
and b.Scorecard_LOB_Tab = 'U-verse'
and b.Scorecard_tab in ('Uverse')
and b.scorecard_program_channel like '%u-verse%'
and b.scorecard_program_channel not like '%drag%'
and b.scorecard_program_channel not like '%D2R%'
and excludefromscorecard <> 'Y'
and a.MediaMonth_YYYYMM > '201312'
and a.MediaMonth_YYYYMM = @MediaMonth_YYYYMM
group by b.Scorecard_tab,b.scorecard_program_channel,a.MediaMonth_YYYYMM

if object_id('weekly_ops.monthly_ops_03MTD_UVLB_Notes') is not null drop table weekly_ops.monthly_ops_03MTD_UVLB_Notes
select Scorecard_tab,scorecard_program_channel,MediaMonth_YYYYMM,
      sum(isnull(MTDcalls,0)) as MTDcalls,
      sum(isnull(MTDcv_calls,0)) as MTDcv_calls,
      sum(isnull(MTDBV_ITP_Dir_Calls,0)) as MTDBV_Calls,
      sum(isnull(MTDcalls,0))/sum(nullif(MTDcv_calls,0)) as [Calls % to CV],
      sum(isnull(MTDcalls,0))/sum(nullif(MTDBV_ITP_Dir_Calls,0)) as [Calls % to BV],  
      SUM(ISNULL(MTDcalls,0))/(select SUM(isnull(MTDcalls,0))
									as MTDcalls 
									from #MTDNotes) as [Calls % of Total],
      
      sum(isnull(MTDclicks,0)) as MTDclicks,
	  sum(isnull(MTDcv_clicks,0)) as MTDcv_clicks,
	  sum(isnull(MTDBV_ITP_Dir_Clicks,0)) as MTDBV_Clicks,
      sum(isnull(MTDclicks,0))/sum(nullif(MTDcv_clicks,0)) as [Clicks % to CV],
      sum(isnull(MTDclicks,0))/sum(nullif(MTDBV_ITP_Dir_Clicks,0)) as [Clicks % to BV], 
      SUM(ISNULL(MTDclicks,0))/(select SUM(isnull(MTDclicks,0))as MTDclicks from #MTDNotes) as [Clicks % of Total],
      	  
	  sum(isnull(MTDactual_TV_sales,0)) as MTDactual_TV_sales,
      sum(isnull(MTDcv_TV_sales,0)) as MTDcv_TV_sales,
      sum(isnull(MTDactual_TV_sales,0))/sum(nullif(MTDcv_TV_sales,0)) as [TVSales % to CV],
      SUM(ISNULL(MTDactual_TV_sales,0))/(select SUM(isnull(MTDactual_TV_sales,0))as MTDactual_TV_sales from #MTDNotes) as [TVSales % of Total]
      
   into weekly_ops.monthly_ops_03MTD_UVLB_Notes
   from #MTDNotes
   group by Scorecard_tab,scorecard_program_channel,MediaMonth_YYYYMM

/*YTD Notes Data*/
if object_id('tempdb..#YTDNotes') is not null drop table #YTDNotes
select  b.Scorecard_tab,b.scorecard_program_channel,
      --actuals
      sum(isnull(itp_dir_calls,0)) as YTDcalls,
      sum(isnull(itp_dir_clicks,0)+isnull(ITP_Dir_QRScans,0)) as YTDclicks,
	  sum(isnull(itp_dir_sales_ts_uvrs_tv_n,0)+ isnull(itp_dir_sales_on_uvrs_tv_n,0)) as YTDactual_TV_sales,
	  --commitment view
      sum(isnull(CV_ITP_Dir_Calls,0)) as YTDcv_calls,
      sum(isnull(CV_ITP_Dir_Clicks,0)) as YTDcv_clicks,
      sum(isnull(CV_ITP_DIR_Sales_TS_UVRS_TV,0)+isnull(CV_ITP_DIR_Sales_ON_UVRS_TV,0)) as YTDcv_TV_sales,
      --best view
      sum(isnull(BV_ITP_Dir_Calls,0)) as YTDBV_ITP_Dir_Calls,
      sum(isnull(BV_ITP_Dir_Clicks,0)) as YTDBV_ITP_Dir_Clicks
into #YTDNotes
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
      sum(isnull(YTDcalls,0)) as YTDcalls,
      sum(isnull(YTDcv_calls,0)) as YTDcv_calls,
      sum(isnull(YTDBV_ITP_Dir_Calls,0)) as YTDBV_Calls,      
      sum(isnull(YTDcalls,0))/sum(nullif(YTDcv_calls,0)) as [Calls % to CV],
      sum(isnull(YTDcalls,0))/sum(nullif(YTDBV_ITP_Dir_Calls,0)) as [Calls % to BV],       
      SUM(ISNULL(YTDcalls,0))/(select SUM(isnull(YTDcalls,0))
									as YTDcalls 
									from #YTDNotes) as [Calls % of Total],
      
      sum(isnull(YTDclicks,0)) as YTDclicks,
      sum(isnull(YTDcv_clicks,0)) as YTDcv_clicks,
      sum(isnull(YTDBV_ITP_Dir_Clicks,0)) as YTDBV_Clicks,
      sum(isnull(YTDclicks,0))/sum(nullif(YTDcv_clicks,0)) as [Clicks % to CV],
      sum(isnull(YTDclicks,0))/sum(nullif(YTDBV_ITP_Dir_Clicks,0)) as [Clicks % to BV], 
      SUM(ISNULL(YTDclicks,0))/(select SUM(isnull(YTDclicks,0))as YTDclicks from #YTDNotes) as [Clicks % of Total],
            
      sum(isnull(YTDactual_TV_sales,0)) as YTDactual_TV_sales,
      sum(isnull(YTDcv_TV_sales,0)) as YTDcv_TV_sales,
      sum(isnull(YTDactual_TV_sales,0))/sum(nullif(YTDcv_TV_sales,0)) as [TVSales % to CV],
      SUM(ISNULL(YTDactual_TV_sales,0))/(select SUM(isnull(YTDactual_TV_sales,0))as YTDactual_TV_sales from #YTDNotes) as [TVSales % of Total]

 into weekly_ops.monthly_ops_04YTD_UVLB_Notes
 from #YTDNotes
 group by Scorecard_tab,scorecard_program_channel


set nocount off
end


