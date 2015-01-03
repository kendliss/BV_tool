


CREATE PROCEDURE [weekly_ops].[SP_OPS_10_UVLB_QC_SC_Slides2]
as 
if object_id('weekly_ops.OPS_10_UVLB_QC_SC_Slides2') is not null 
drop table weekly_ops.OPS_10_UVLB_QC_SC_Slides2

 select b.Scorecard_Program_Channel,a.reportweek_yyyyww,
      --actuals
      sum(isnull(itp_dir_calls,0)) as calls,
      sum(isnull(itp_dir_clicks,0)+isnull(ITP_Dir_QRScans,0)) as clicks
into weekly_ops.OPS_10_UVLB_QC_SC_Slides2
from javdb.ireport_2014.dbo.IR_Workbook_Data as a
	join javdb.ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
      on a.tactic_id=b.id
where b.Scorecard_Top_Tab = 'Direct Marketing'
and b.Scorecard_LOB_Tab = 'U-verse'
and b.Scorecard_tab = 'Uverse'
and b.Scorecard_Program_Channel not like '%social%'
and b.Scorecard_Program_Channel not like '%prospect%'
and a.parentid not in (181100) --a.Campaign_Parent_Name not like '%JUN13_UPRO_D2D_DetroitDoorHanger%' (parentid = 181100) so we do not pull in Prospect. Not sure why they are showing up LB.
and a.reportweek_yyyyww between ((select (ReportCycle_YYYYWW) from javdb.[IREPORT_2014].[dbo].[wb_00_reporting_cycle] group by ReportCycle_YYYYWW)-3) 
								and ((select (ReportCycle_YYYYWW) from javdb.[IREPORT_2014].[dbo].[wb_00_reporting_cycle] group by ReportCycle_YYYYWW)+7)
and excludefromscorecard <> 'Y'
group by b.Scorecard_Program_Channel
,a.reportweek_yyyyww
order by b.Scorecard_Program_Channel
,a.reportweek_yyyyww 

select * from weekly_ops.OPS_10_UVLB_QC_SC_Slides2


