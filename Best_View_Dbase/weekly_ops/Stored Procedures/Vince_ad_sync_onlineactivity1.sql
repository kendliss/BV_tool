






CREATE PROCEDURE [weekly_ops].[Vince_ad_sync_onlineactivity1]
as 

if object_id('weekly_ops.Vince_ad_sync_onlineactivity') is not null drop table weekly_ops.Vince_ad_sync_onlineactivity
select c.End_date as [YTD data through],
b.Scorecard_tab,
b.Scorecard_Program_Channel,
      sum(isnull(itp_dir_clicks,0)+isnull(ITP_Dir_QRScans,0)) as clicks,
	  sum(isnull(CV_ITP_Dir_Clicks,0)) as cv_clicks,
	  sum(isnull(itp_dir_sales_on_uvrs_tv_n,0)) as actual_online_TV_sales,
      sum(isnull(CV_ITP_DIR_Sales_ON_UVRS_TV,0)) as cv_online_TV_sales
into weekly_ops.Vince_ad_sync_onlineactivity
from javdb.ireport_2014.dbo.ir_Workbook_Data as a
	join javdb.ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
      on a.tactic_id=b.id
    join javdb.ireport_2014.dbo.WB_00_Media_Calendar_Weekly as c
    on a.ReportCycle_YYYYWW=c.reportweek_YYYYWW
where b.Scorecard_Top_Tab = 'Direct Marketing'
and b.Scorecard_LOB_Tab = 'U-verse'
and b.Scorecard_tab in ('Uverse Base Acq')
--and (Scorecard_Program_Channel like '%U-verse%' or Scorecard_Program_Channel like '%Prospect%')
and Scorecard_Program_Channel not in ('U-verse Base Acq - Direct Marketing Drag','U-verse Base Acq - Direct Marketing Drag Hisp')
and a.reportweek_yyyyww <= '201446'--(select ReportCycle_YYYYWW from JAVDB.[IREPORT_2014].[dbo].[wb_00_reporting_cycle] group by ReportCycle_YYYYWW)
and a.reportweek_yyyyww >= '201401'
group by c.End_date,b.Scorecard_tab, b.Scorecard_Program_Channel
order by c.End_date,b.Scorecard_tab, b.Scorecard_Program_Channel
select * from weekly_ops.Vince_ad_sync_onlineactivity







