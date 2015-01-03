



CREATE PROCEDURE [weekly_ops].[Vince_ad_sync_data1]
as 
drop table weekly_ops.Vince_ad_sync_responses
select ReportCycle_YYYYWW as Week
,c.End_Date as [data through]
,b.Scorecard_Type as Program
      ,sum(isnull(itp_dir_calls,0)) as [Directed Calls]
      ,sum(isnull(CV_ITP_Dir_Calls,0)) as [CV Calls]
      ,(sum(isnull(itp_dir_calls,0)))/(sum(isnull(CV_ITP_Dir_Calls,0))) as [Directed Calls % to CV]
	  ,sum(isnull(itp_dir_clicks,0)+isnull(ITP_Dir_QRScans,0)) as [Directed Online Responses]
      ,sum(isnull(CV_ITP_Dir_Clicks,0)) as [CV Online Responses]
      ,(sum(isnull(itp_dir_clicks,0)+isnull(ITP_Dir_QRScans,0)))/(sum(isnull(CV_ITP_Dir_Clicks,0))) as [Directed Online Responses % to CV]
into weekly_ops.Vince_ad_sync_responses
from javdb.ireport_2014.dbo.IR_Workbook_Data as a
	join javdb.ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
      on a.tactic_id=b.id
    join javdb.ireport_2014.dbo.WB_00_Media_Calendar_Weekly as c
	  on a.ReportCycle_YYYYWW=c.ReportWeek_YYYYWW
where b.Scorecard_Top_Tab = 'Direct Marketing'
and b.Scorecard_LOB_Tab = 'U-verse'
and b.Scorecard_tab in ('Uverse','Prospect','Uverse CLM','Movers Prospect')
and a.reportweek_yyyyww >= '201401'
and a.reportweek_yyyyww <= ReportCycle_YYYYWW
and excludefromscorecard <> 'Y'
group by ReportCycle_YYYYWW,b.Scorecard_Type,c.End_Date
order by (case when b.Scorecard_Type = 'Uverse Base Acq' then 1
				when b.Scorecard_Type = 'U-verse Prospect' then 2
				when b.Scorecard_Type = 'Movers Prospect' then 3
				when b.Scorecard_Type = 'Uverse CLM' then 4
				else 99
				end)
				,b.Scorecard_Type
select * from weekly_ops.Vince_ad_sync_responses


