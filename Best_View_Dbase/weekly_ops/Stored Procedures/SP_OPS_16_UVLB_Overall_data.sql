



CREATE procedure [weekly_ops].[SP_OPS_16_UVLB_Overall_data]
as 

/*current week temp table*/
if object_id('tempdb..#CA_CV') is not null drop table #CA_CV
SELECT 
case when [Touch_Type_FK] =69 then 'U-verse Base Acq - Catalog'
		end as Scorecard_Program_Channel
	,Audience
      ,'201400'+media_week as ReportWeek_YYYYWW
      ,sum([CV_Drop_Volume]) as CV_quantity
      ,sum([CV_Calls]) as [CV_Calls]
      ,sum([CV_Clicks]) as [CV_Clicks]
      ,sum([CV_Directed_Strategic_Call_Sales] +[CV_Directed_Strategic_Online_Sales]) as CV_strat_sales 
      ,sum([CV_Call_TV_Sales]+[CV_Online_TV_Sales]) as CV_tv_sales
      into #CA_CV
      FROM UVAQ.Commitment_Versions.CV_2014_Final_20131206_Volume_Calls_Clicks_Sales_v2
      where [Touch_Type_FK] in (1,69,68,163,70,71) --catalog touch types
      and '201400'+media_week <=(select ReportCycle_YYYYWW from [JAVDB].[IREPORT_2014].[dbo].[wb_00_reporting_cycle] group by ReportCycle_YYYYWW)
      group by [Touch_Type_FK],
      [Media_Week]
      ,Audience

if object_id('tempdb..#CA_CV_sum_curr') is not null drop table #CA_CV_sum_curr
select Scorecard_Program_Channel
      ,sum(CV_quantity) as CV_quantity
      ,sum([CV_Calls]) as [CV_Calls]
      ,sum([CV_Clicks]) as [CV_Clicks]
      ,sum(CV_strat_sales) as CV_strat_sales 
      ,sum(CV_tv_sales) as CV_tv_sales
      into #CA_CV_sum_curr
      from #CA_CV
      group by Scorecard_Program_Channel

--current week's data
if object_id('tempdb..#LB_current') is not null drop table #LB_current
select case when b.id = 255 then 'U-verse Base Acq - DM - Hisp'
		when (a.vendor like '%dieste%' and a.Campaign_Parent_Name like '%hisp%') then 'U-verse Base Acq - DM - Hisp'
	    when ((b.id = 51 and (a.Campaign_Parent_Name like '%HISP%' or a.Campaign_Parent_Name like '%SPANISH%')) or a.Campaign_Parent_Name like '%Aug Cat Control 5%') then  'U-verse Base Acq - Catalog'
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
into #LB_current
from JAVDB.ireport_2014.dbo.IR_Workbook_Data as a
	join JAVDB.ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
      on a.tactic_id=b.id
where b.Scorecard_Top_Tab = 'Direct Marketing'
and b.Scorecard_LOB_Tab = 'U-verse'
and b.Scorecard_tab = 'Uverse'
and b.Scorecard_Program_Channel not like '%social%'
and b.Scorecard_Program_Channel not like '%prospect%'
and a.parentid not in (181100) --a.Campaign_Parent_Name not like '%JUN13_UPRO_D2D_DetroitDoorHanger%' (parentid = 181100) so we do not pull in Prospect. Not sure why they are showing up LB.
and a.reportweek_yyyyww >= '201401'
and a.reportweek_yyyyww <= (select ReportCycle_YYYYWW from JAVDB.[IREPORT_2014].[dbo].[wb_00_reporting_cycle] group by ReportCycle_YYYYWW)
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


if object_id('tempdb..#OPS_01_UVLB_currentweek') is not null drop table #OPS_01_UVLB_currentweek
select 
case when a.Scorecard_Program_Channel = 'U-verse Base Acq - Bill Insert' then 'Bill Insert'
	when a.Scorecard_Program_Channel = 'U-verse Base Acq - Bill Media' then 'Bill Message'
	when a.Scorecard_Program_Channel = 'U-verse Base Acq - Catalog' then 'Catalog'
	when a.Scorecard_Program_Channel = 'U-verse Base Acq - Catalog - Hisp' then 'Catalog'
	when a.Scorecard_Program_Channel = 'U-verse Base Acq - Direct Marketing Drag' then 'Drag'
	when a.Scorecard_Program_Channel = 'U-verse Base Acq - Direct Marketing Drag Hisp' then 'Drag Hisp'	
	when a.Scorecard_Program_Channel = 'U-verse Base Acq - DM' then 'Direct Mail'		
	when a.Scorecard_Program_Channel = 'U-verse Base Acq - DM - Hisp' then 'Direct Mail - Hisp'	
	when a.Scorecard_Program_Channel = 'U-verse Base Acq - Email' then 'Email'	
	when a.Scorecard_Program_Channel = 'U-verse Base Acq - Shared Mail/FSI' then 'Shared Mail'	
	when a.Scorecard_Program_Channel = 'U-verse Base Acq D2R - DM' then 'Drive To Retail DM'
	when a.Scorecard_Program_Channel = 'U-verse Base Acq - First Page Communication' then 'First Page Communication'		
		else 'NEW!'
	end as [Lookup Name]
	,a.Scorecard_Program_Channel
	,sum(a.unapp_quantity) as unapp_quantity
	,sum(calls) as calls
	,sum(clicks) as clicks
	,sum(telesales + onlinesales) as strategic_sales
	,sum(tv_telesales + tv_onlinesales) as uvtv_sales
	,case when a.Scorecard_Program_Channel like '%catalog%' then max(c.cv_calls)
		else sum(a.cv_calls)
		end as cv_calls
	,case when a.Scorecard_Program_Channel like '%catalog%' then max(c.cv_clicks)
		else sum(a.cv_clicks) 
		end as cv_clicks
	,case when a.Scorecard_Program_Channel like '%catalog%' then max(c.CV_strat_sales)
		else sum(a.cv_tele_sales + a.cv_on_sales) 
		end as CV_strat_sales
	,case when a.Scorecard_Program_Channel like '%catalog%' then max(c.CV_tv_sales)
		 else sum(a.cv_tele_tv + a.cv_on_tv) 
		 end as CV_tv_sales
	,case when a.Scorecard_Program_Channel like '%catalog%' then max(c.cv_quantity)
		else sum(a.cv_quantity)
		end as cv_quantity
into #OPS_01_UVLB_currentweek
from #LB_current as a 
		left join (select Scorecard_Program_Channel
					, sum(cv_calls) as cv_calls
					, sum(cv_clicks) as cv_clicks
					, sum(CV_strat_sales) as CV_strat_sales
					, sum(CV_tv_sales) as CV_tv_sales
					, sum(cv_quantity) as cv_quantity
					 from #CA_CV_sum_curr
					 group by Scorecard_Program_Channel) as c
		on a.Scorecard_Program_Channel=c.Scorecard_Program_Channel
group by a.Scorecard_Program_Channel
order by a.Scorecard_Program_Channel

/*previous week temp table*/
if object_id('tempdb..#CA_CV_prev') is not null drop table #CA_CV_prev
SELECT 
case when [Touch_Type_FK] =69 then 'U-verse Base Acq - Catalog'
		end as Scorecard_Program_Channel
	,Audience
      ,'201400'+media_week as ReportWeek_YYYYWW
      ,sum([CV_Drop_Volume]) as CV_quantity
      ,sum([CV_Calls]) as [CV_Calls]
      ,sum([CV_Clicks]) as [CV_Clicks]
      ,sum([CV_Directed_Strategic_Call_Sales] +[CV_Directed_Strategic_Online_Sales]) as CV_strat_sales 
      ,sum([CV_Call_TV_Sales]+[CV_Online_TV_Sales]) as CV_tv_sales
      into #CA_CV_prev
      FROM UVAQ.Commitment_Versions.CV_2014_Final_20131206_Volume_Calls_Clicks_Sales_v2
      where [Touch_Type_FK] in (1,69,68,163,70,71) --catalog touch types
      and '201400'+media_week <=(select (ReportCycle_YYYYWW-1) from javdb.[IREPORT_2014].[dbo].[wb_00_reporting_cycle] group by ReportCycle_YYYYWW)
      group by [Touch_Type_FK],
      [Media_Week]
      ,Audience

if object_id('tempdb..#CA_CV_sum_prev') is not null drop table #CA_CV_sum_prev
select Scorecard_Program_Channel
      ,sum(CV_quantity) as CV_quantity
      ,sum([CV_Calls]) as [CV_Calls]
      ,sum([CV_Clicks]) as [CV_Clicks]
      ,sum(CV_strat_sales) as CV_strat_sales 
      ,sum(CV_tv_sales) as CV_tv_sales
      into #CA_CV_sum_prev
      from #CA_CV_prev
      group by Scorecard_Program_Channel


--previous week's data
if object_id('tempdb..#LB_prev') is not null drop table #LB_prev
select case when b.id = 255 then 'U-verse Base Acq - DM - Hisp'
		when (a.vendor like '%dieste%' and a.Campaign_Parent_Name like '%hisp%') then 'U-verse Base Acq - DM - Hisp'
	    when ((b.id = 51 and (a.Campaign_Parent_Name like '%HISP%' or a.Campaign_Parent_Name like '%SPANISH%')) or a.Campaign_Parent_Name like '%Aug Cat Control 5%') then  'U-verse Base Acq - Catalog'
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
      ,case when a.Campaign_Parent_Name like '%over%' then 0
		else sum(isnull(ITP_Quantity_UnApp,0))
		end as unapp_quantity
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
      sum(isnull(Goal_ITP_Dir_Clicks,0)) as Goal_ITP_Dir_Clicks
into #LB_prev
from javdb.ireport_2014.dbo.WB_04_Workbook_Data as a
	join javdb.ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
      on a.tactic_id=b.id
where b.Scorecard_Top_Tab = 'Direct Marketing'
and b.Scorecard_LOB_Tab = 'U-verse'
and b.Scorecard_tab = 'Uverse'
and b.Scorecard_Program_Channel not like '%social%'
and a.parentid not in (181100) --a.Campaign_Parent_Name not like '%JUN13_UPRO_D2D_DetroitDoorHanger%' (parentid = 181100) so we do not pull in Prospect. Not sure why they are showing up LB.
and a.reportweek_yyyyww >= '201401'
and a.reportweek_yyyyww <= (select (ReportCycle_YYYYWW-1) from javdb.[IREPORT_2014].[dbo].[wb_00_reporting_cycle] group by ReportCycle_YYYYWW)
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


if object_id('tempdb..#OPS_03_UVLB_previousweek') is not null drop table #OPS_03_UVLB_previousweek
select 
case when a.Scorecard_Program_Channel = 'U-verse Base Acq - Bill Insert' then 'Bill Insert'
	when a.Scorecard_Program_Channel = 'U-verse Base Acq - Bill Media' then 'Bill Message'
	when a.Scorecard_Program_Channel = 'U-verse Base Acq - Catalog' then 'Catalog'
	when a.Scorecard_Program_Channel = 'U-verse Base Acq - Catalog - Hisp' then 'Catalog'
	when a.Scorecard_Program_Channel = 'U-verse Base Acq - Direct Marketing Drag' then 'Drag'
	when a.Scorecard_Program_Channel = 'U-verse Base Acq - Direct Marketing Drag Hisp' then 'Drag Hisp'	
	when a.Scorecard_Program_Channel = 'U-verse Base Acq - DM' then 'Direct Mail'		
	when a.Scorecard_Program_Channel = 'U-verse Base Acq - DM - Hisp' then 'Direct Mail - Hisp'	
	when a.Scorecard_Program_Channel = 'U-verse Base Acq - Email' then 'Email'	
	when a.Scorecard_Program_Channel = 'U-verse Base Acq - Shared Mail/FSI' then 'Shared Mail'	
	when a.Scorecard_Program_Channel = 'U-verse Base Acq D2R - DM' then 'Drive To Retail DM'
	when a.Scorecard_Program_Channel = 'U-verse Base Acq - First Page Communication' then 'First Page Communication'		
		else 'NEW!'
	end as [Lookup Name]
	,a.Scorecard_Program_Channel
	,sum(a.unapp_quantity) as unapp_quantity
	,sum(calls) as calls
	,sum(clicks) as clicks
	,sum(telesales + onlinesales) as strategic_sales
	,sum(tv_telesales + tv_onlinesales) as uvtv_sales
	,case when a.Scorecard_Program_Channel like '%catalog%' then max(c.cv_calls)
		else sum(a.cv_calls)
		end as cv_calls
	,case when a.Scorecard_Program_Channel like '%catalog%' then max(c.cv_clicks)
		else sum(a.cv_clicks) 
		end as cv_clicks
	,case when a.Scorecard_Program_Channel like '%catalog%' then max(c.CV_strat_sales)
		else sum(a.cv_tele_sales + a.cv_on_sales) 
		end as CV_strat_sales
	,case when a.Scorecard_Program_Channel like '%catalog%' then max(c.CV_tv_sales)
		 else sum(a.cv_tele_tv + a.cv_on_tv) 
		 end as CV_tv_sales
	,case when a.Scorecard_Program_Channel like '%catalog%' then max(c.cv_quantity)
		else sum(a.cv_quantity)
		end as cv_quantity
into #OPS_03_UVLB_previousweek
from #LB_prev as a 
		left join (select Scorecard_Program_Channel
					, sum(cv_calls) as cv_calls
					, sum(cv_clicks) as cv_clicks
					, sum(CV_strat_sales) as CV_strat_sales
					, sum(CV_tv_sales) as CV_tv_sales
					, sum(cv_quantity) as cv_quantity
					 from #CA_CV_sum_prev
					 group by Scorecard_Program_Channel) as c
		on a.Scorecard_Program_Channel=c.Scorecard_Program_Channel
group by a.Scorecard_Program_Channel
order by a.Scorecard_Program_Channel

/*notes*/

if object_id('tempdb..#WOWnotes') is not null drop table #WOWnotes
SELECT (convert(varchar(50), (round(
			(((sum(isnull(a.[unapp_quantity],0)))/(sum(nullif(a.[cv_quantity],0))))
							-((sum(isnull(b.[unapp_quantity],0)))/(sum(nullif(b.[cv_quantity],0))))),2)*100))+'%') as [Quantity % to CV]
	  ,(convert(varchar(50), (round(
			(((sum(isnull(a.[calls],0)))/(sum(nullif(a.[cv_calls],0))))
							-((sum(isnull(b.[calls],0)))/(sum(nullif(b.[cv_calls],0))))),2)*100))+'%') as [Calls % to CV]
	  ,(convert(varchar(50), (round(
			(((sum(isnull(a.[clicks],0)))/(sum(nullif(a.[cv_clicks],0))))
							-((sum(isnull(b.[clicks],0)))/(sum(nullif(b.[cv_clicks],0))))),2)*100))+'%') as [Clicks % to CV]							
	  ,(convert(varchar(50), (round(
			(((sum(isnull(a.[strategic_sales],0)))/(sum(nullif(a.[CV_strat_sales],0))))
							-((sum(isnull(b.[strategic_sales],0)))/(sum(nullif(b.[CV_strat_sales],0))))),2)*100))+'%') as [Strat. Sales % to CV]								
	  ,(convert(varchar(50), (round(
			(((sum(isnull(a.[uvtv_sales],0)))/(sum(nullif(a.[CV_tv_sales],0))))
							-((sum(isnull(b.[uvtv_sales],0)))/(sum(nullif(b.[CV_tv_sales],0))))),2)*100))+'%') as [UVTV Sales % to CV]								
  into #WOWnotes
  FROM #OPS_01_UVLB_currentweek as a
	join #OPS_03_UVLB_previousweek as b
	on (a.[Lookup Name]=b.[Lookup Name] and a.Scorecard_Program_Channel=b.Scorecard_Program_Channel)
  where a.Scorecard_Program_Channel not like '%D2R%'
	and a.Scorecard_Program_Channel not like '%drag%'

alter table #WOWnotes
 add [Program] varchar(max)
update #WOWnotes
 set [Program]='UVLB'
select * from #WOWnotes




