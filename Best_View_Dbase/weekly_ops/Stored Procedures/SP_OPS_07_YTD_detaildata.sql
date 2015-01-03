


CREATE PROCEDURE [weekly_ops].[SP_OPS_07_YTD_detaildata]
as 
if object_id('weekly_ops.OPS_07_YTD_detaildata') is not null 
drop table weekly_ops.OPS_07_YTD_detaildata

if object_id('tempdb..#detail_data') is not null drop table #detail_data
select a.reportweek_yyyyww
,a.MediaMonth_YYYYMM
,b.Scorecard_tab
,case when b.id = 255 then 'U-verse Base Acq - DM - Hisp'
		when (a.vendor like '%dieste%' and a.Campaign_Parent_Name like '%hisp%') then 'U-verse Base Acq - DM - Hisp'
	    when ((b.id = 51 and (a.Campaign_Parent_Name like '%HISP%' or a.Campaign_Parent_Name like '%SPANISH%')) or a.Campaign_Parent_Name like '%Aug Cat Control 5%') then  'U-verse Base Acq - Catalog - Hisp'
	else b.Scorecard_Program_Channel
	end as Scorecard_Program_Channel,b.id as tactic_id
,a.media_code
,case when a.vendor like '%dieste%' then 'Y' --hispanic actuals
	when b.id = 255 then 'Y' --hispanic CV
	else 'N'
	end as hisp_ind
,a.parentid
,case when a.ecrw_project_name is null then a.Campaign_Parent_Name
	else a.ecrw_project_name
	end as ecrw_project_name
,a.Campaign_Parent_Name
      --actuals
      ,case when a.Campaign_Parent_Name like '%over%' then 0
		else sum(isnull(ITP_Quantity_UnApp,0))
		end as unapp_quantity
	 ,case when a.Campaign_Parent_Name like '%over%' then 0
		else sum(isnull(ITP_Budget_UnApp,0))
		end as Budget_UnApp
      ,sum(isnull(itp_dir_calls,0)) as calls,
      sum(isnull(itp_dir_clicks,0)+isnull(ITP_Dir_QRScans,0)) as clicks,
      sum(  
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
                  isnull(ITP_Dir_Sales_TS_DLIFE_N,0))			--digital life added 1/21/2014
                              as telesales,
        sum(      
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
                              as onlinesales,
        sum(isnull(itp_dir_sales_ts_uvrs_tv_n,0)) as tv_telesales,
        sum(isnull(itp_dir_sales_on_uvrs_tv_n,0)) as tv_onlinesales,
        --commitment view
      sum(isnull(CV_ITP_Dir_Calls,0)) as cv_calls,
      sum(isnull(CV_ITP_Dir_Clicks,0)) as cv_clicks,
      sum(isnull(CV_ITP_Dir_Sales_TS,0)) as cv_tele_sales,
      sum(isnull(CV_ITP_Dir_Sales_ON,0)) as cv_on_sales,
      sum(isnull(CV_ITP_DIR_Sales_TS_UVRS_TV,0)) as cv_tele_tv,
      sum(isnull(CV_ITP_DIR_Sales_ON_UVRS_TV,0)) as cv_on_tv,
      sum(isnull(CV_ITP_QUANTITY,0)) as cv_quantity,
      --rolling view
      sum(isnull(Goal_ITP_Dir_Calls,0)) as Goal_ITP_Dir_Calls,
      sum(isnull(Goal_ITP_Dir_Clicks,0)) as Goal_ITP_Dir_Clicks,
      --best view
      sum(isnull(BV_ITP_Dir_Calls,0)) as BV_ITP_Dir_Calls,
      sum(isnull(BV_ITP_Dir_Clicks,0)) as BV_ITP_Dir_Clicks,
      excludefromscorecard
into #detail_data
from javdb.ireport_2014.dbo.IR_Workbook_Data as a
	join javdb.ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
      on a.tactic_id=b.id
where b.Scorecard_Top_Tab = 'Direct Marketing'
and b.Scorecard_LOB_Tab = 'U-verse'
and b.Scorecard_tab = 'Uverse'
and a.parentid not in (181100) --a.Campaign_Parent_Name not like '%JUN13_UPRO_D2D_DetroitDoorHanger%' (parentid = 181100) so we do not pull in Prospect. Not sure why they are showing up LB.
and b.Scorecard_Program_Channel not like '%social%'
and b.Scorecard_Program_Channel not like '%movers%'
and a.reportweek_yyyyww >= '201401'
and a.reportweek_yyyyww <= (select (ReportCycle_YYYYWW) from javdb.[IREPORT_2014].[dbo].[wb_00_reporting_cycle] group by ReportCycle_YYYYWW)
--and excludefromscorecard <> 'Y'
group by a.reportweek_yyyyww
,a.MediaMonth_YYYYMM
,b.Scorecard_tab
,b.Scorecard_Program_Channel
,a.media_code
,a.Campaign_Parent_Name
,a.parentid
,a.ecrw_project_name
,a.vendor
,b.id
,excludefromscorecard
order by a.reportweek_yyyyww
,a.MediaMonth_YYYYMM
,b.Scorecard_tab
,b.Scorecard_Program_Channel
,a.media_code
,a.Campaign_Parent_Name
,a.parentid
,a.ecrw_project_name
,a.vendor
,b.id
,excludefromscorecard


select reportweek_yyyyww
, MediaMonth_YYYYMM
, Scorecard_tab
, Scorecard_Program_Channel
, tactic_id
, ecrw_project_name
, sum(unapp_quantity) as unapp_quantity
, sum(Budget_UnApp) as Budget_UnApp
, sum(calls) as calls
, sum(clicks) as clicks
, sum(telesales) as telesales
, sum(onlinesales) as onlinesales
, sum(tv_telesales) as tv_telesales
, sum(tv_onlinesales) as tv_onlinesales
, sum(cv_calls) as cv_calls
, sum(cv_clicks) as cv_clicks
, sum(cv_tele_sales) as cv_tele_sales
, sum(cv_on_sales) as cv_on_sales
, sum(cv_tele_tv) as cv_tele_tv
, sum(cv_on_tv) as cv_on_tv
, sum(cv_quantity) as cv_quantity
, sum(Goal_ITP_Dir_Calls) as Goal_ITP_Dir_Calls
, sum(Goal_ITP_Dir_Clicks) as Goal_ITP_Dir_Clicks
, sum(isnull(BV_ITP_Dir_Calls,0)) as BV_ITP_Dir_Calls
, sum(isnull(BV_ITP_Dir_Clicks,0)) as BV_ITP_Dir_Clicks
, excludefromscorecard
into weekly_ops.OPS_07_YTD_detaildata
 from #detail_data
 group by reportweek_yyyyww
, MediaMonth_YYYYMM
, Scorecard_tab
, Scorecard_Program_Channel
, tactic_id
, ecrw_project_name 
, excludefromscorecard
order by reportweek_yyyyww
, MediaMonth_YYYYMM
, Scorecard_tab
, Scorecard_Program_Channel
, tactic_id
, ecrw_project_name
, excludefromscorecard

select * from weekly_ops.OPS_07_YTD_detaildata


