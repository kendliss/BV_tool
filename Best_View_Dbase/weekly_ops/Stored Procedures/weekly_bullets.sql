



CREATE PROCEDURE [weekly_ops].[weekly_bullets]
as 

if object_id('weekly_ops.weekly_bullets_MTDdata') is not null drop table weekly_ops.weekly_bullets_MTDdata
select  
b.Scorecard_Program_Channel,
      sum(isnull(itp_dir_calls,0)) as calls,
      sum(isnull(CV_ITP_Dir_Calls,0)) as cv_calls,
      sum(isnull(itp_dir_clicks,0)+isnull(ITP_Dir_QRScans,0)) as clicks,
	  sum(isnull(CV_ITP_Dir_Clicks,0)) as cv_clicks,
	  sum(isnull(itp_dir_sales_ts_uvrs_tv_n,0)+ isnull(itp_dir_sales_on_uvrs_tv_n,0)) as actual_TV_sales,
      sum(isnull(CV_ITP_DIR_Sales_TS_UVRS_TV,0)+isnull(CV_ITP_DIR_Sales_ON_UVRS_TV,0)) as cv_TV_sales
into weekly_ops.weekly_bullets_MTDdata
from javdb.ireport_2014.dbo.IR_Workbook_Data as a
	join javdb.ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
      on a.tactic_id=b.id
where b.Scorecard_Top_Tab = 'Direct Marketing'
and b.Scorecard_LOB_Tab = 'U-verse'
and b.Scorecard_tab = 'Uverse'
and Scorecard_Program_Channel not in ('U-verse Base Acq - Direct Marketing Drag','U-verse Base Acq - Direct Marketing Drag Hisp')
and a.MediaMonth_YYYYMM = (select MediaMonth_YYYYMM 
							from javdb.ireport_2014.dbo.WB_00_Media_Calendar_Weekly 
							where reportweek_YYYYWW=(select ReportCycle_YYYYWW from javdb.ireport_2014.dbo.IR_Workbook_Data group by ReportCycle_YYYYWW))
and a.reportweek_YYYYWW <=ReportCycle_YYYYWW
group by b.Scorecard_Program_Channel
order by b.Scorecard_Program_Channel
select * from weekly_ops.weekly_bullets_MTDdata

if object_id('weekly_ops.weekly_bullets_top5calls') is not null drop table weekly_ops.weekly_bullets_top5calls
select top 5 eCRW_project_name
,sum(isnull(itp_dir_calls,0)) as calls
into weekly_ops.weekly_bullets_top5calls
from javdb.ireport_2014.dbo.IR_Workbook_Data as a
	join javdb.ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
      on a.tactic_id=b.id
where b.Scorecard_Top_Tab = 'Direct Marketing'
and b.Scorecard_LOB_Tab = 'U-verse'
and b.Scorecard_tab = 'Uverse'
and Scorecard_Program_Channel not in ( 'U-verse Base Acq - Direct Marketing Drag','U-verse Base Acq - Direct Marketing Drag Hisp')
and a.MediaMonth_YYYYMM = (select MediaMonth_YYYYMM 
							from javdb.ireport_2014.dbo.WB_00_Media_Calendar_Weekly 
							where reportweek_YYYYWW=(select ReportCycle_YYYYWW from javdb.ireport_2014.dbo.IR_Workbook_Data group by ReportCycle_YYYYWW))
and a.reportweek_YYYYWW <=ReportCycle_YYYYWW
group by eCRW_project_name
order by calls desc
select * from weekly_ops.weekly_bullets_top5calls

if object_id('weekly_ops.weekly_bullets_top5clicks') is not null drop table weekly_ops.weekly_bullets_top5clicks
select top 5 eCRW_project_name
,sum(isnull(itp_dir_clicks,0)+isnull(ITP_Dir_QRScans,0)) as clicks
into weekly_ops.weekly_bullets_top5clicks
from javdb.ireport_2014.dbo.IR_Workbook_Data as a
	join javdb.ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
      on a.tactic_id=b.id
where b.Scorecard_Top_Tab = 'Direct Marketing'
and b.Scorecard_LOB_Tab = 'U-verse'
and b.Scorecard_tab = 'Uverse'
and Scorecard_Program_Channel not in ( 'U-verse Base Acq - Direct Marketing Drag','U-verse Base Acq - Direct Marketing Drag Hisp')
and a.MediaMonth_YYYYMM = (select MediaMonth_YYYYMM 
							from javdb.ireport_2014.dbo.WB_00_Media_Calendar_Weekly 
							where reportweek_YYYYWW=(select ReportCycle_YYYYWW from javdb.ireport_2014.dbo.IR_Workbook_Data group by ReportCycle_YYYYWW))
and a.reportweek_YYYYWW <=ReportCycle_YYYYWW
group by eCRW_project_name
order by clicks desc
select * from weekly_ops.weekly_bullets_top5clicks



