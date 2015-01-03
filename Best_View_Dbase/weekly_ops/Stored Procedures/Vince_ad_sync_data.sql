
CREATE PROCEDURE [weekly_ops].[Vince_ad_sync_data]
as 
drop table weekly_ops.Vince_ad_sync_responses
select ReportCycle_YYYYWW as Week
,c.End_Date as [data through]
,b.Scorecard_Type
      ,sum(isnull(itp_dir_calls,0)) as [Directed Calls]
      ,sum(isnull(CV_ITP_Dir_Calls,0)) as [CV Calls]
      ,(sum(isnull(itp_dir_calls,0)))/(sum(isnull(CV_ITP_Dir_Calls,0))) as [Directed Calls % to CV]
	  ,sum(isnull(itp_dir_clicks,0)+isnull(ITP_Dir_QRScans,0)) as [Directed Online Responses]
      ,sum(isnull(CV_ITP_Dir_Clicks,0)) as [CV Online Responses]
      ,(sum(isnull(itp_dir_clicks,0)+isnull(ITP_Dir_QRScans,0)))/(sum(isnull(CV_ITP_Dir_Clicks,0))) as [Directed Online Responses % to CV]
into weekly_ops.Vince_ad_sync_responses
from javdb.ireport_2014.dbo.WB_04_Workbook_Data as a
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
order by b.Scorecard_Type 

--sales
drop table weekly_ops.Vince_ad_sync_sales
select (ReportCycle_YYYYWW-2) as Week
,c.End_Date as [data through]
,b.Scorecard_Type
      ,sum(  
            isnull(ITP_Dir_Sales_TS_CING_VOICE_N,0)+
                  isnull(ITP_Dir_Sales_TS_CING_FAMILY_N,0)+
                  isnull(ITP_Dir_Sales_TS_CING_DATA_N,0)+
                  isnull(ITP_Dir_Sales_TS_CING_WHP_N,0)+		--wireless home phone added 1/21/2014
				  isnull(itp_dir_sales_ts_dish_n,0)+
                  isnull(itp_dir_sales_ts_dsl_reg_n,0)+
                  isnull(itp_dir_sales_ts_dsl_dry_n,0)+
                  isnull(ITP_Dir_Sales_TS_DSL_IP_N,0)+
                  isnull(itp_dir_sales_ts_uvrs_hsia_n,0)+
                  isnull(itp_dir_sales_ts_uvrs_tv_n,0)+
                  isnull(itp_dir_sales_ts_local_accl_n,0)+
                  isnull(itp_dir_sales_ts_uvrs_voip_n,0)+
                  isnull(ITP_Dir_Sales_TS_DLIFE_N,0)+		--digital life added 1/21/2014
                  isnull(ITP_Dir_Sales_ON_CING_VOICE_N,0)+
                  isnull(ITP_Dir_Sales_ON_CING_FAMILY_N,0)+
                  isnull(ITP_Dir_Sales_ON_CING_DATA_N,0) +
                  isnull(ITP_Dir_Sales_ON_CING_WHP_N,0) +		--wireless home phone added 1/21/2014
                  isnull(itp_dir_sales_on_dish_n,0) +
                  isnull(itp_dir_sales_on_dsl_reg_n,0) +
                  isnull(itp_dir_sales_on_dsl_dry_n,0) +
                  isnull(ITP_Dir_Sales_ON_DSL_IP_N,0) +
                  isnull(itp_dir_sales_on_uvrs_hsia_n,0) +
                  isnull(itp_dir_sales_on_uvrs_tv_n,0) +
                  isnull(itp_dir_sales_on_local_accl_n,0) +
                  isnull(itp_dir_sales_on_uvrs_voip_n,0) +
                  isnull(ITP_Dir_Sales_ON_DLIFE_N,0))			--digital life added 1/21/2014
                              as [Directed Strategic Sales]
      ,sum(isnull(CV_ITP_Dir_Sales_TS,0)+isnull(CV_ITP_Dir_Sales_ON,0)) as [CV Strategic Sales]
      ,(sum(  
            isnull(ITP_Dir_Sales_TS_CING_VOICE_N,0)+
                  isnull(ITP_Dir_Sales_TS_CING_FAMILY_N,0)+
                  isnull(ITP_Dir_Sales_TS_CING_DATA_N,0)+
                  isnull(ITP_Dir_Sales_TS_CING_WHP_N,0)+		--wireless home phone added 1/21/2014
				  isnull(itp_dir_sales_ts_dish_n,0)+
                  isnull(itp_dir_sales_ts_dsl_reg_n,0)+
                  isnull(itp_dir_sales_ts_dsl_dry_n,0)+
                  isnull(ITP_Dir_Sales_TS_DSL_IP_N,0)+
                  isnull(itp_dir_sales_ts_uvrs_hsia_n,0)+
                  isnull(itp_dir_sales_ts_uvrs_tv_n,0)+
                  isnull(itp_dir_sales_ts_local_accl_n,0)+
                  isnull(itp_dir_sales_ts_uvrs_voip_n,0)+
                  isnull(ITP_Dir_Sales_TS_DLIFE_N,0)+		--digital life added 1/21/2014
                  isnull(ITP_Dir_Sales_ON_CING_VOICE_N,0)+
                  isnull(ITP_Dir_Sales_ON_CING_FAMILY_N,0)+
                  isnull(ITP_Dir_Sales_ON_CING_DATA_N,0) +
                  isnull(ITP_Dir_Sales_ON_CING_WHP_N,0) +		--wireless home phone added 1/21/2014
                  isnull(itp_dir_sales_on_dish_n,0) +
                  isnull(itp_dir_sales_on_dsl_reg_n,0) +
                  isnull(itp_dir_sales_on_dsl_dry_n,0) +
                  isnull(ITP_Dir_Sales_ON_DSL_IP_N,0) +
                  isnull(itp_dir_sales_on_uvrs_hsia_n,0) +
                  isnull(itp_dir_sales_on_uvrs_tv_n,0) +
                  isnull(itp_dir_sales_on_local_accl_n,0) +
                  isnull(itp_dir_sales_on_uvrs_voip_n,0) +
                  isnull(ITP_Dir_Sales_ON_DLIFE_N,0)))/(sum(isnull(CV_ITP_Dir_Sales_TS,0)+isnull(CV_ITP_Dir_Sales_ON,0))) as [Directed Strategic Sales % to CV]
      ,sum(isnull(itp_dir_sales_ts_uvrs_tv_n,0)+isnull(itp_dir_sales_on_uvrs_tv_n,0)) as [Directed UVTV Sales]
      ,sum(isnull(CV_ITP_DIR_Sales_TS_UVRS_TV,0)+isnull(CV_ITP_DIR_Sales_ON_UVRS_TV,0)) as [CV UVTV Sales]
      ,(sum(isnull(itp_dir_sales_ts_uvrs_tv_n,0)+isnull(itp_dir_sales_on_uvrs_tv_n,0)))/(sum(isnull(CV_ITP_DIR_Sales_TS_UVRS_TV,0)+isnull(CV_ITP_DIR_Sales_ON_UVRS_TV,0))) as [Directed UVTV Sales % to CV]
into weekly_ops.Vince_ad_sync_sales
from javdb.ireport_2014.dbo.WB_04_Workbook_Data as a
	join javdb.ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
      on a.tactic_id=b.id
    join javdb.ireport_2014.dbo.WB_00_Media_Calendar_Weekly as c
	  on (a.ReportCycle_YYYYWW-2)=(c.ReportWeek_YYYYWW)
where b.Scorecard_Top_Tab = 'Direct Marketing'
and b.Scorecard_LOB_Tab = 'U-verse'
and b.Scorecard_tab in ('Uverse','Prospect','Uverse CLM','Movers Prospect')
and a.reportweek_yyyyww >= '201401'
and a.reportweek_yyyyww <= (ReportCycle_YYYYWW-2)
and excludefromscorecard <> 'Y'
group by ReportCycle_YYYYWW,b.Scorecard_Type,c.End_Date
order by b.Scorecard_Type 
