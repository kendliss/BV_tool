




CREATE PROCEDURE [weekly_ops].[SP_OPS_02_UPRO_currentweek]
as 
/*
--Define temp workbook
if object_id('tempdb..#workbook_data') is not null drop table workbook_data
select * into #workbook_data from javdb.ireport_2014.dbo.ir_workbook_data

--Get ITP Quantities from apportioned table
update #workbook_data
set itp_quantity=b.itp_quantity
from #workbook_data a join javdb.ireport_2014.dbo.WB_03_Weekly_Quantity_Budget_WB b
on a.parentid=b.parentid
and a.reportweek_yyyyww=b.reportweek_yyyyww
*/


 if object_id('tempdb..#UPRO_CV') is not null drop table #UPRO_CV 
 select case when [media] = 'Catalog' then 416
	when [media] = 'Direct Digital' then 543
	when [media] = 'Direct Mail' then 415
	when [media] = 'Total' then 95
	end as tactic_id
	, [media]
	, sum(isnull(CV_Drop_Volume,0)) as CV_Quantity
	, sum(isnull(CV_Clicks,0)) as CV_Clicks
	, sum(isnull(CV_Calls,0)) as CV_Calls
	, SUM(isnull(CV_CALL_Access_Sales,0) +
			isnull(CV_CALL_Dish_Sales,0) +
			isnull(CV_Call_DSL_Dry_Sales,0) +
			isnull(CV_Call_DSL_Reg_Sales,0) +
			isnull(CV_Call_HSIA_Sales,0) +
			isnull(CV_Call_IPDSL_Sales,0) +
			isnull(CV_Call_TV_Sales,0) +
			isnull(CV_Call_VOIP_Sales,0) +
			isnull(CV_Call_WRLS_Data_Sales,0) +
			isnull(CV_Call_WRLS_Family_Sales,0) +
			isnull(CV_Call_Wrls_Voice_Sales,0)) as cv_tele_sales
	, SUM(isnull(CV_ONLINE_Access_Sales,0) +
			isnull(CV_ONLINE_Dish_Sales,0) +
			isnull(CV_ONLINE_DSL_Dry_Sales,0) +
			isnull(CV_ONLINE_DSL_Reg_Sales,0) +
			isnull(CV_ONLINE_HSIA_Sales,0) +
			isnull(CV_ONLINE_IPDSL_Sales,0) +
			isnull(CV_ONLINE_TV_Sales,0) +
			isnull(CV_ONLINE_VOIP_Sales,0) +
			isnull(CV_ONLINE_WRLS_Data_Sales,0) +
			isnull(CV_ONLINE_WRLS_Family_Sales,0) +
			isnull(CV_ONLINE_Wrls_Voice_Sales,0)) as cv_online_sales
	, SUM(isnull(CV_CALL_Access_Sales,0) +
			isnull(CV_CALL_Dish_Sales,0) +
			isnull(CV_Call_DSL_Dry_Sales,0) +
			isnull(CV_Call_DSL_Reg_Sales,0) +
			isnull(CV_Call_HSIA_Sales,0) +
			isnull(CV_Call_IPDSL_Sales,0) +
			isnull(CV_Call_TV_Sales,0) +
			isnull(CV_Call_VOIP_Sales,0) +
			isnull(CV_Call_WRLS_Data_Sales,0) +
			isnull(CV_Call_WRLS_Family_Sales,0) +
			isnull(CV_Call_Wrls_Voice_Sales,0) +
			isnull(CV_ONLINE_Access_Sales,0) +
			isnull(CV_ONLINE_Dish_Sales,0) +
			isnull(CV_ONLINE_DSL_Dry_Sales,0) +
			isnull(CV_ONLINE_DSL_Reg_Sales,0) +
			isnull(CV_ONLINE_HSIA_Sales,0) +
			isnull(CV_ONLINE_IPDSL_Sales,0) +
			isnull(CV_ONLINE_TV_Sales,0) +
			isnull(CV_ONLINE_VOIP_Sales,0) +
			isnull(CV_ONLINE_WRLS_Data_Sales,0) +
			isnull(CV_ONLINE_WRLS_Family_Sales,0) +
			isnull(CV_ONLINE_Wrls_Voice_Sales,0)) as cv_strategic_sales
	,sum(isnull(CV_Call_TV_Sales,0)) as cv_tele_tv
	,sum(isnull(CV_ONLINE_TV_Sales,0)) as cv_online_tv
	,sum(isnull(CV_Call_TV_Sales,0)+isnull(CV_ONLINE_TV_Sales,0)) as cv_tv_sales
   into #UPRO_CV
   FROM [UVAQ].[Forecasting].[UV_Prospect_2014_CV_Final]
   where [reportweek_YYYYWW]<=(select ReportCycle_YYYYWW from [JAVDB].[IREPORT_2014].[dbo].[wb_00_reporting_cycle] group by ReportCycle_YYYYWW)
   group by [media]

if object_id('tempdb..#UPRO_current') is not null drop table #UPRO_current
select case when b.id = 255 then 'U-verse Base Acq - DM - Hisp'
		when (a.vendor like '%dieste%' and a.Campaign_Parent_Name like '%hisp%') then 'U-verse Base Acq - DM - Hisp'
	    when ((b.id = 51 and (a.Campaign_Parent_Name like '%HISP%' or a.Campaign_Parent_Name like '%SPANISH%')) or a.Campaign_Parent_Name like '%Aug Cat Control 5%') then  'U-verse Base Acq - Catalog - Hisp'
	else b.Scorecard_Program_Channel
	end as Scorecard_Program_Channel
,b.id as tactic_id
,a.media_code
,case when a.vendor like '%dieste%' then 'Y' --hispanic actuals
	when b.id = 255 then 'Y' --hispanic CV
	else 'N'
	end as hisp_ind
,a.parentid
,a.ecrw_project_name
,a.Campaign_Parent_Name
      --actuals
      ,case when a.Campaign_Parent_Name like '%over%' then 0
		--else sum(isnull(itp_quantity,0))
		else sum(isnull(ITP_Quantity_UnApp,0))
		end as unapp_quantity,
      sum(isnull(itp_dir_calls,0)) as calls,
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
      sum(isnull(Goal_ITP_Dir_Clicks,0)) as Goal_ITP_Dir_Clicks
into #UPRO_current
from 
--#workbook_data as a
[JAVDB].ireport_2014.dbo.IR_Workbook_Data as a
	join [JAVDB].ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
      on a.tactic_id=b.id
where b.Scorecard_Top_Tab = 'Direct Marketing'
and b.Scorecard_LOB_Tab = 'U-verse'
and b.Scorecard_tab = 'Uverse'
and b.Scorecard_Program_Channel like '%Prospect%'
and a.parentid not in (181100) --a.Campaign_Parent_Name not like '%JUN13_UPRO_D2D_DetroitDoorHanger%' (parentid = 181100) so we do not pull in Prospect. Not sure why they are showing up LB.
and a.reportweek_yyyyww >= '201401'
and a.reportweek_yyyyww <= (select ReportCycle_YYYYWW from [JAVDB].[IREPORT_2014].[dbo].[wb_00_reporting_cycle] group by ReportCycle_YYYYWW)
and excludefromscorecard <> 'Y'
group by b.Scorecard_Program_Channel
,a.media_code
,a.Campaign_Parent_Name
,a.parentid
,a.ecrw_project_name
,a.vendor
,b.id
order by b.Scorecard_Program_Channel
,a.media_code
,a.Campaign_Parent_Name
,a.parentid
,a.ecrw_project_name
,a.vendor
,b.id

if object_id('weekly_ops.OPS_02_UPRO_currentweek') is not null drop table weekly_ops.OPS_02_UPRO_currentweek
select 
case when a.Scorecard_Program_Channel = 'U-verse Prospect - Catalog' then 'Catalog'
	when a.Scorecard_Program_Channel = 'U-verse Prospect - DM' then 'Direct Mail'
	when a.Scorecard_Program_Channel = 'U-verse Prospect - Direct Digital' then 'Digital Direct'
	when a.Scorecard_Program_Channel = 'U-verse Prospect - Program Level' then 'Program Level'
	when a.Scorecard_Program_Channel = 'U-verse Prospect - Doorhanger' then 'Door Hanger'
		else 'NEW!'
	end as [Lookup Name]
	,a.Scorecard_Program_Channel
	,sum(unapp_quantity) as unapp_quantity
	,sum(calls) as calls
	,sum(clicks) as clicks
	,sum(telesales + onlinesales) as strategic_sales
	,sum(tv_telesales + tv_onlinesales) as uvtv_sales
	,max(b.CV_Calls) as cv_calls
	,max(b.CV_Clicks) as cv_clicks
	,max(b.cv_strategic_sales) as CV_strat_sales
	,max(b.cv_tv_sales) as CV_tv_sales
	,max(b.CV_Quantity) as cv_quantity
into weekly_ops.OPS_02_UPRO_currentweek
from #UPRO_current as a	
	left join (select Scorecard_Program_Channel
			,CV_Quantity
			,CV_Calls
			,CV_Clicks
			,cv_strategic_sales
			,cv_tv_sales
			from #UPRO_CV as a 
				join [JAVDB].ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
				on a.tactic_id=b.id) as b
	on a.Scorecard_Program_Channel=b.Scorecard_Program_Channel				
group by a.Scorecard_Program_Channel
order by a.Scorecard_Program_Channel

select * from weekly_ops.OPS_02_UPRO_currentweek




