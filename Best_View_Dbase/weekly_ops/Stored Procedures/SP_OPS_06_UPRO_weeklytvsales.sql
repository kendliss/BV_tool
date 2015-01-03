



CREATE PROCEDURE [weekly_ops].[SP_OPS_06_UPRO_weeklytvsales]
as 
if object_id('weekly_ops.OPS_06_UPRO_weeklytvsales') is not null 
drop table weekly_ops.OPS_06_UPRO_weeklytvsales
select  c.[Report_Week],c.[End_Date], a.reportweek_yyyyww
	,sum(isnull(CV_ITP_Dir_Calls,0) +isnull(CV_ITP_Dir_Clicks,0)) as CV_responses
	,sum(isnull(CV_ITP_DIR_Sales_TS_UVRS_TV,0) +isnull(CV_ITP_DIR_Sales_ON_UVRS_TV,0)) as CV_tv_sales
	,sum(isnull(itp_dir_calls,0) +isnull(itp_dir_clicks,0)+isnull(ITP_Dir_QRScans,0)) as actual_responses
	,sum(isnull(itp_dir_sales_ts_uvrs_tv_n,0) +isnull(itp_dir_sales_on_uvrs_tv_n,0)) as uvrs_tv
into weekly_ops.OPS_06_UPRO_weeklytvsales
from javdb.ireport_2014.dbo.IR_Workbook_Data as a
	join javdb.ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
      on a.tactic_id=b.id
    join javdb.ireport_2014.dbo.WB_00_Media_Calendar_Weekly as c
		on a.reportweek_yyyyww=c.reportweek_yyyyww
where b.Scorecard_Top_Tab = 'Direct Marketing'
and b.Scorecard_LOB_Tab = 'U-verse'
and b.Scorecard_tab = 'Uverse'
and b.Scorecard_Program_Channel like '%Prospect%'
and Scorecard_Program_Channel not like 'U-verse Base Acq - Direct Marketing Drag'
and a.reportweek_yyyyww >= '201401'
and a.reportweek_yyyyww <='201452'
and excludefromscorecard <> 'Y'
group by c.[Report_Week],c.[End_Date], a.reportweek_yyyyww
order by c.[Report_Week],c.[End_Date], a.reportweek_yyyyww

select * from weekly_ops.OPS_06_UPRO_weeklytvsales



