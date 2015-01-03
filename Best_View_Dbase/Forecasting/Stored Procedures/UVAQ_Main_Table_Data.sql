


CREATE procedure [Forecasting].[UVAQ_Main_Table_Data] 
@StartMediaWeek numeric(11,0), @EndMediaWeek numeric(11,0), @CampaignStartDate datetime, @weeks_tracking numeric
as

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
-------START CALCULATE BV AND AVERAGE RATES--------------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------
--Actual Data from Main Table
----------------------------------------------------------------------
if object_id('tempdb..#actualdata') is not null drop table #actualdata
select c.Touch_Type_FK
,case when b.id = 255 then 'U-verse Base Acq - DM - Hisp'
	        when (b.id = 51 and a.Campaign_Parent_Name like '%HISP%') then 'U-verse Base Acq - Catalog - Hisp'
	else b.Scorecard_Program_Channel
	end as Scorecard_Program_Channel
,b.id as tactic_id
,a.start_date
,a.End_Date_Traditional
,datediff(ww,start_date,(select b.End_Date 
	from javdb.ireport_2014.dbo.wb_00_reporting_cycle as a 
	join javdb.ireport_2014.dbo.WB_00_Media_Calendar_Weekly as b 
	on a.ReportCycle_YYYYWW=b.ReportWeek_YYYYWW 
	group by b.End_Date)) as [Weeks Tracking]
,a.media_code
,d.Media_Type
,d.Touch_Name
,d.Touch_Name_2
,d.Audience_Type_Name
,d.Program_Owner
,a.parentid
,a.ecrw_project_name
,a.Campaign_Parent_Name
, case when e.tfn_type like '22-state' then 'LT/CCC'
	   when a.parentid in ('821010',	'825250',	'825270',	'830510',	'831410',	'833400', '840110') then 'Hispanic 5 RR' --hispanic catalogs
	   when a.Media_code = 'FYI' and a.Campaign_Parent_Name like '%spanish%' then 'Hispanic 5 RR' --spanish bill messages
	   when a.Media_code = 'FYI' and Touch_Name = 'Wireline' and Touch_Name_2 = 'Bill Message' and tfn_type = 'Hispanic 5 RR' then 'LT/CCC'  --Corrects LT/CCC TFN getting a Hispanic TFN 
	   when e.tfn_type like '9-state' then 'LT/CCC'
	   when e.tfn_type like '13-state' then 'LT/CCC'
	   when a.media_code like 'DM' and e.tfn_type in ('22-state','LT/CCC') 
		and a.Campaign_Parent_Name NOT LIKE '%IRU%' and a.Campaign_Parent_Name not like '%WLN w/ WLS%' 
		and a.Campaign_Parent_Name not like '%WLS+O%'  and a.Campaign_Parent_Name not like '%non wls%' 
		and a.Campaign_Parent_Name not like '%WLS/WLN%' and a.Campaign_Parent_Name not like '%WLN/WLS%' 
		and a.Campaign_Parent_Name not like '%WRLS/WLN%' and a.Campaign_Parent_Name not like '%WLN/WRLS%' 
		and a.Campaign_Parent_Name not like '%(WLN w/ or w/o WLS)%' and a.Campaign_Parent_Name not like '%+ WLS%' 
		and a.Campaign_Parent_Name not like '%WLS +%' and a.Campaign_Parent_Name not like '%nonwls%' 
		and a.Campaign_Parent_Name not like '%nonwrls%' and a.Campaign_Parent_Name not like '%Non-wireless%' 
		and a.Campaign_Parent_Name not like '%w/o wireless%' 
		and (a.Campaign_Parent_Name like '%WLS%' or a.Campaign_Parent_Name like '%WRLS%' or a.Campaign_Parent_Name like '%smartphone%'
			or a.Campaign_Parent_Name like '%wireless only%'or a.Campaign_Parent_Name like '%wireless%') then 'DMDR'
	else e.tfn_type
	end as tfn_type
, case when a.parentid in ('840910', '840920', '840960', '843690', '844180', '839720', '839920', '833120', '840120', '826960','844060','843020')
			then 'PURL'
			end as PURL_Flag
,case when a.Campaign_Parent_Name like ('%IRU%') and a.Campaign_Parent_Name not like ('%non%') then 'IRU'
	  when a.Campaign_Parent_Name like ('%green%') or a.Campaign_Parent_Name like ('%- NG -%') or a.Campaign_Parent_Name like ('%FRESH%')or a.Campaign_Parent_Name like ('%FSH%') then 'NewGreen'
	  when (a.Campaign_Parent_Name like ('%hisp%')  or  a.Campaign_Parent_Name like ('%hsp%')) and a.media_code = 'CA' then 'BL'
	  when a.parentid in ('900270',	'900260',	'943720',	'976020',	'943710',	'943780',	'943790',	'976070',	'976090',	'976060',	'976080', '180431',	'180432',	'180433',	'180434') then 'Account Review SL'
	  when a.Campaign_Parent_Name like ('%tv upsell%') and (a.Campaign_Parent_Name like ('%never%') or a.Campaign_Parent_Name like ('% NH %')) then 'Neverhad'
	  when a.Campaign_Parent_Name like ('%tv upsell%') and (a.Campaign_Parent_Name like ('%win%') or a.Campaign_Parent_Name like ('% WB %')) then 'Winback'
	  when a.Campaign_Parent_Name like ('%tv upsell%') then 'NH and WB'
			else ''
			end as audience
,project = (Touch_Name + ' ' + Touch_Name_2 + ' ' + a.media_code)
      --actuals
     ,sum(isnull(ITP_Quantity_UnApp,0)) as ITP_Quantity_UnApp
     ,sum(isnull(ITP_Budget_UnApp,0)) as ITP_Budget_UnApp
      ,sum(isnull(itp_dir_calls,0)) as calls
      ,sum(isnull(itp_dir_clicks,0)) as clicks
      ,sum(isnull(ITP_Dir_Sales_TS_CING_VOICE_N,0)+
                  isnull(ITP_Dir_Sales_TS_CING_FAMILY_N,0)+
                  isnull(ITP_Dir_Sales_TS_CING_DATA_N,0)+
				  isnull(itp_dir_sales_ts_dish_n,0)+
                  isnull(itp_dir_sales_ts_dsl_reg_n,0)+
                  isnull(itp_dir_sales_ts_dsl_dry_n,0)+
                  isnull(ITP_Dir_Sales_TS_DSL_IP_N,0)+
                  isnull(itp_dir_sales_ts_uvrs_hsia_n,0)+
                  isnull(itp_dir_sales_ts_uvrs_tv_n,0)+
                  isnull(itp_dir_sales_ts_local_accl_n,0)+
                  isnull(itp_dir_sales_ts_uvrs_voip_n,0) ) 
                              as strat_telesales,
        sum(isnull(ITP_Dir_Sales_ON_CING_VOICE_N,0)+
                  isnull(ITP_Dir_Sales_ON_CING_FAMILY_N,0)+
                  isnull(ITP_Dir_Sales_ON_CING_DATA_N,0) +
                  isnull(itp_dir_sales_on_dish_n,0) +
                  isnull(itp_dir_sales_on_dsl_reg_n,0) +
                  isnull(itp_dir_sales_on_dsl_dry_n,0) +
                  isnull(ITP_Dir_Sales_ON_DSL_IP_N,0) +
                  isnull(itp_dir_sales_on_uvrs_hsia_n,0) +
                  isnull(itp_dir_sales_on_uvrs_tv_n,0) +
                  isnull(itp_dir_sales_on_local_accl_n,0) +
                  isnull(itp_dir_sales_on_uvrs_voip_n,0)) 
                              as strat_onlinesales
        ,sum(isnull(ITP_Dir_Sales_TS_CING_VOICE_N,0)) as ITP_Dir_Sales_TS_CING_VOICE_N
        ,sum(isnull(ITP_Dir_Sales_TS_CING_FAMILY_N,0)) as ITP_Dir_Sales_TS_CING_FAMILY_N
        ,sum(isnull(ITP_Dir_Sales_TS_CING_DATA_N,0)) as ITP_Dir_Sales_TS_CING_DATA_N
		,sum(isnull(itp_dir_sales_ts_dish_n,0)) as itp_dir_sales_ts_dish_n
        ,sum(isnull(itp_dir_sales_ts_ld_n,0)) as itp_dir_sales_ts_ld_n
        ,sum(isnull(itp_dir_sales_ts_dsl_reg_n,0)) as itp_dir_sales_ts_dsl_reg_n
        ,sum(isnull(itp_dir_sales_ts_dsl_dry_n,0)) as itp_dir_sales_ts_dsl_dry_n
        ,sum(isnull(ITP_Dir_Sales_TS_DSL_IP_N,0)) as ITP_Dir_Sales_TS_DSL_IP_N
        ,sum(isnull(itp_dir_sales_ts_uvrs_hsia_n,0)) as itp_dir_sales_ts_uvrs_hsia_n
        ,sum(isnull(itp_dir_sales_ts_uvrs_tv_n,0)) as itp_dir_sales_ts_uvrs_tv_n
        ,sum(isnull(itp_dir_sales_ts_local_accl_n,0)) as itp_dir_sales_ts_local_accl_n
        ,sum(isnull(itp_dir_sales_ts_uvrs_voip_n,0)) as itp_dir_sales_ts_uvrs_voip_n
        ,sum(isnull(ITP_Dir_Sales_ON_CING_VOICE_N,0)) as ITP_Dir_Sales_ON_CING_VOICE_N
        ,sum(isnull(ITP_Dir_Sales_ON_CING_FAMILY_N,0)) as ITP_Dir_Sales_ON_CING_FAMILY_N
        ,sum(isnull(ITP_Dir_Sales_ON_CING_DATA_N,0) ) as ITP_Dir_Sales_ON_CING_DATA_N
        ,sum(isnull(itp_dir_sales_on_dish_n,0) ) as itp_dir_sales_on_dish_n
        ,sum(isnull(itp_dir_sales_on_ld_n,0)) as itp_dir_sales_on_ld_n
        ,sum(isnull(itp_dir_sales_on_dsl_reg_n,0)) as itp_dir_sales_on_dsl_reg_n
        ,sum(isnull(itp_dir_sales_on_dsl_dry_n,0)) as itp_dir_sales_on_dsl_dry_n
        ,sum(isnull(ITP_Dir_Sales_ON_DSL_IP_N,0)) as ITP_Dir_Sales_ON_DSL_IP_N
        ,sum(isnull(itp_dir_sales_on_uvrs_hsia_n,0)) as itp_dir_sales_on_uvrs_hsia_n
        ,sum(isnull(itp_dir_sales_on_uvrs_tv_n,0)) as itp_dir_sales_on_uvrs_tv_n
        ,sum(isnull(itp_dir_sales_on_local_accl_n,0)) as itp_dir_sales_on_local_accl_n
        ,sum(isnull(itp_dir_sales_on_uvrs_voip_n,0)) as itp_dir_sales_on_uvrs_voip_n
into #actualdata
from javdb.ireport.dbo.IR_Campaign_Data_Weekly_MAIN_2012 as a
	join javdb.ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
      on a.tactic_id=b.id
	join UVAQ.Results.ParentID_Touch_Type_Link as c
	  on a.parentid=c.parentid
	join UVAQ.dbo.[Touch Type Human View] as d
	  on c.Touch_Type_FK=d.Touch_Type_id
	left join (select * from javdb.ireport.dbo.WB_01_TFN_List_eCRW UNION select * from javdb.ireport_2014.dbo.WB_01_TFN_List_eCRW) as e
            on a.parentid=e.parentid
where b.Scorecard_Top_Tab = 'Direct Marketing'
and b.Scorecard_LOB_Tab = 'U-verse'
and b.Scorecard_tab = 'Uverse Base Acq'
and a.reportweek_yyyyww >= @StartMediaWeek
and a.reportweek_yyyyww <= @EndMediaWeek
and a.start_date >=@CampaignStartDate
--and a.End_Date_Traditional <=@CampaignEndDate --only including campaigns that have been tracking for ~10 weeks
and ExcludeFromScorecard  <> 'Y'
and a.parentid not in ('833320','832060','832070') --exclude catalog multi mailer
      and a.parentid not in ('836140','843250') --exclude double counting QR Projects 
      and a.parentid not in ('826150','826160', '830380', '830390', '830400')  --exclude Phone Cards
      and a.parentid not in ('848800',	'848810',	'848820',	'848830',	
							'848840',	'844800',	'844810',	'848870',	
							'844830',	'844840',	'844850',	'850150',	
							'850160',	'850170',	'850180',	'850190',	
							'850200',	'864190',	'873580',	'867920',	
							'867930',	'867940',	'867950',	'867960',	
							'867970',	'867980',	'867990',	'868000',	
							'868010',	'868020',	'868030',	'868040',	
							'868050',	'868470',	'868480',	'868490',	
							'868500',	'868510',	'868520',	'868530',	
							'868540',	'868550',	'868560',	'868570',	
							'868580',	'868590',	'868600',	'876560',
							'848760',	'848770',	'848780',	'848790',	'876570') --exclude all 2012 TV upsell campaigns
and (a.eCRW_project_name not like '%2012 TV upsell%')
group by c.Touch_Type_FK
,b.Scorecard_Program_Channel
,a.start_date
,a.End_Date_Traditional
,a.media_code
,d.Media_Type
,d.Touch_Name
,d.Touch_Name_2
,d.Audience_Type_Name
,d.Program_Owner
,a.Campaign_Parent_Name
,a.parentid
,a.Toll_Free_Numbers
,a.ecrw_project_name
,a.vendor
,b.id
,e.tfn_type
having datediff(ww,start_date,(select b.End_Date 
	from javdb.ireport_2014.dbo.wb_00_reporting_cycle as a 
	join javdb.ireport_2014.dbo.WB_00_Media_Calendar_Weekly as b 
	on a.ReportCycle_YYYYWW=b.ReportWeek_YYYYWW 
	group by b.End_Date))>@weeks_tracking
order by c.Touch_Type_FK
,b.Scorecard_Program_Channel
,a.start_date
,a.End_Date_Traditional
,a.media_code
,d.Media_Type
,d.Touch_Name
,d.Touch_Name_2
,d.Audience_Type_Name
,d.Program_Owner
,a.Campaign_Parent_Name
,a.parentid
,a.ecrw_project_name
,a.vendor
,b.id
,e.tfn_type

/*
--campaigns in actual data
select Touch_Type_FK
,parentid
,start_date as [Campaign Start Date]
,End_Date_Traditional [Campaign End Tracking Date]
,[Weeks Tracking]
,ecrw_project_name as [eCRW Campaign Name]
,Campaign_Parent_Name as [cell title]
,tfn_type
,Media_Type
,Touch_Name
,Touch_Name_2
,Audience_Type_Name
,Program_Owner
from #actualdata
group by Touch_Type_FK
,start_date
,End_Date_Traditional
,[Weeks Tracking]
,parentid
,ecrw_project_name
,Campaign_Parent_Name
,tfn_type
,Media_Type
,Touch_Name
,Touch_Name_2
,Audience_Type_Name
,Program_Owner
*/

--Actual Rates by Touch_Type_FK
if object_id('tempdb..#Actual_Rates') is not null drop table #Actual_Rates
select Touch_Type_FK
,Media_Type
,Touch_Name
,Touch_Name_2
,Audience_Type_Name
,Program_Owner
,sum(ISNULL(calls,0))/SUM(nullif(ITP_Quantity_UnApp,0)) as [CALL RR]
,sum(ISNULL(clicks,0))/SUM(nullif(ITP_Quantity_UnApp,0)) as [CLICK RR]
,sum(ISNULL(strat_telesales,0))/SUM(nullif(calls,0)) as [STRAT CALL CR]
,sum(ISNULL(strat_onlinesales,0))/SUM(nullif(clicks,0)) as [STRAT CLICK CR]
,sum(isnull(ITP_Dir_Sales_TS_CING_VOICE_N,0))/sum(nullif(calls,0)) as [WRLS_VOICE CALL CR]
,sum(isnull(ITP_Dir_Sales_TS_CING_FAMILY_N,0))/sum(nullif(calls,0)) as [WRLS_FAM CALL CR]
,sum(isnull(ITP_Dir_Sales_TS_CING_DATA_N,0))/sum(nullif(calls,0)) as [WRLS_DATA CALL CR]
,sum(isnull(itp_dir_sales_ts_dish_n,0))/sum(nullif(calls,0)) as [DIRECTV CALL CR]
,sum(isnull(itp_dir_sales_ts_dsl_reg_n,0))/sum(nullif(calls,0)) as [DSLREG CALL CR]
,sum(isnull(itp_dir_sales_ts_dsl_dry_n,0))/sum(nullif(calls,0)) as [DSLDRY CALL CR]
,sum(isnull(ITP_Dir_Sales_TS_DSL_IP_N,0))/sum(nullif(calls,0)) as [IPDSL CALL CR]
,sum(isnull(itp_dir_sales_ts_uvrs_hsia_n,0))/sum(nullif(calls,0)) as [HSIA CALL CR]
,sum(isnull(itp_dir_sales_ts_uvrs_tv_n,0))/sum(nullif(calls,0)) as [UVTV CALL CR]
,sum(isnull(itp_dir_sales_ts_local_accl_n,0))/sum(nullif(calls,0)) as [ACCL CALL CR]
,sum(isnull(itp_dir_sales_ts_uvrs_voip_n,0))/sum(nullif(calls,0)) as [VOIP CALL CR]
,sum(isnull(ITP_Dir_Sales_ON_CING_VOICE_N,0))/sum(nullif(clicks,0)) as [WRLS_VOICE CLICK CR]
,sum(isnull(ITP_Dir_Sales_ON_CING_FAMILY_N,0))/sum(nullif(clicks,0)) as [WRLS_FAM CLICK CR]
,sum(isnull(ITP_Dir_Sales_ON_CING_DATA_N,0))/sum(nullif(clicks,0)) as [WRLS_DATA CLICK CR]
,sum(isnull(itp_dir_sales_on_dish_n,0))/sum(nullif(clicks,0)) as [DIRECTV CLICK CR]
,sum(isnull(itp_dir_sales_on_dsl_reg_n,0))/sum(nullif(clicks,0)) as [DSLREG CLICK CR]
,sum(isnull(itp_dir_sales_on_dsl_dry_n,0))/sum(nullif(clicks,0)) as [DSLDRY CLICK CR]
,sum(isnull(ITP_Dir_Sales_ON_DSL_IP_N,0))/sum(nullif(clicks,0)) as [IPDSL CLICK CR]
,sum(isnull(itp_dir_sales_on_uvrs_hsia_n,0))/sum(nullif(clicks,0)) as [HSIA CLICK CR]
,sum(isnull(itp_dir_sales_on_uvrs_tv_n,0))/sum(nullif(clicks,0)) as [UVTV CLICK CR]
,sum(isnull(itp_dir_sales_on_local_accl_n,0))/sum(nullif(clicks,0)) as [ACCL CLICK CR]
,sum(isnull(itp_dir_sales_on_uvrs_voip_n,0))/sum(nullif(clicks,0)) as [VOIP CLICK CR]
into #Actual_Rates
from #actualdata
where ecrw_project_name <> '2013 Hispanic Sept LM DM'
group by Touch_Type_FK
,Media_Type
,Touch_Name
,Touch_Name_2
,Audience_Type_Name
,Program_Owner
--select * from #Actual_Rates

----------------------------------------------------------------------
--Current BV Base Assumptions
----------------------------------------------------------------------
----------------------------------------------------------------------
--base response rates
----------------------------------------------------------------------
if object_id('tempdb..#RR') is not null drop table #RR
select a.Touch_Type_FK, Touch_Name, Touch_Name_2, Audience_Type_Name, Media_Type, Response_Channel, Response_Rate, Conversion_Rate,
	CASE WHEN Response_Channel='CALL' then Conversion_Rate*Call_Percent_of_Sales
	ELSE Conversion_Rate*Click_Percent_of_Sales
	END as UVTV_Conversion_Rate
	into #RR
	from Forecasting.Most_Recent_RR_Assumptions as A
		INNER JOIN Forecasting.Touch_Type as B
			ON A.Touch_Type_FK=B.Touch_Type_ID
		INNER JOIN Forecasting.Media_Type as C
			on B.Media_Type_FK=C.Media_Type_ID
		INNER JOIN Forecasting.Audience as D
			ON B.Audience_FK=D.Audience_ID
		INNER JOIN Forecasting.Most_Recent_Conversions_View as E
			ON A.Touch_Type_FK=E.Touch_Type_FK and A.Response_Channel_FK=E.Response_Channel_FK
		INNER JOIN Forecasting.Response_Channel as F
			ON A.Response_Channel_FK=F.Response_Channel_ID
		INNER JOIN Forecasting.Most_Recent_Sales_Percents_View as G
			ON A.Touch_Type_FK=G.Touch_Type_FK and Product_FK=1
order by Response_Channel, a.Touch_Type_FK

if object_id('sandbox.base_rrs') is not null drop table sandbox.base_rrs
DECLARE @cols AS NVARCHAR(MAX),
    @query  AS NVARCHAR(MAX);

select @cols = STUFF((SELECT distinct ',' + QUOTENAME(c.response_channel) 
            FROM #RR c
            FOR XML PATH('')),1,1,'')

set @query = 'SELECT touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, ' + @cols + ' 
				into sandbox.base_rrs from 
            (
                select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, response_channel, response_rate
                from #RR
           ) x
            pivot 
            (
                 max(response_rate)
                for response_channel in (' + @cols + ')
            ) p '


execute(@query)

if object_id('tempdb..#base_rrs') is not null drop table #base_rrs
select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type,
call as [BASE CALL RR],
click as [BASE CLICK RR]
into #base_rrs
from sandbox.base_rrs
drop table sandbox.base_rrs


----------------------------------------------------------------------
--strategic conversion rates
----------------------------------------------------------------------
if object_id('tempdb..#strat') is not null drop table #strat
select a.Touch_Type_FK, Touch_Name, Touch_Name_2, Audience_Type_Name, Media_Type, Response_Channel, Response_Rate, Conversion_Rate,
	CASE WHEN Response_Channel='CALL' then Conversion_Rate*Call_Percent_of_Sales
	ELSE Conversion_Rate*Click_Percent_of_Sales
	END as TV_Conversion_Rate
	into #strat
	from Forecasting.Most_Recent_RR_Assumptions as A
		INNER JOIN Forecasting.Touch_Type as B
			ON A.Touch_Type_FK=B.Touch_Type_ID
		INNER JOIN Forecasting.Media_Type as C
			on B.Media_Type_FK=C.Media_Type_ID
		INNER JOIN Forecasting.Audience as D
			ON B.Audience_FK=D.Audience_ID
		INNER JOIN Forecasting.Most_Recent_Conversions_View as E
			ON A.Touch_Type_FK=E.Touch_Type_FK and A.Response_Channel_FK=E.Response_Channel_FK
		INNER JOIN Forecasting.Response_Channel as F
			ON A.Response_Channel_FK=F.Response_Channel_ID
		INNER JOIN Forecasting.Most_Recent_Sales_Percents_View as G
			ON A.Touch_Type_FK=G.Touch_Type_FK and Product_FK=1
order by Response_Channel, a.Touch_Type_FK

if object_id('sandbox.strat_crs') is not null drop table sandbox.strat_crs
DECLARE @cols_strat_crs AS NVARCHAR(MAX),
    @query_strat_crs  AS NVARCHAR(MAX);

select @cols_strat_crs = STUFF((SELECT distinct ',' + QUOTENAME(c.response_channel) 
            FROM #strat c
            FOR XML PATH('')),1,1,'')

set @query_strat_crs = 'SELECT touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, ' + @cols_strat_crs + ' 
				into sandbox.strat_crs from 
            (
                select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, response_channel, conversion_rate
                from #strat
           ) x
            pivot 
            (
                 max(conversion_rate)
                for response_channel in (' + @cols_strat_crs + ')
            ) p '


execute(@query_strat_crs)

if object_id('tempdb..#strat_crs') is not null drop table #strat_crs
select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type,
call as [STRAT CALL CR],
click as [STRAT CLICK CR]
into #strat_crs
from sandbox.strat_crs
drop table sandbox.strat_crs

----------------------------------------------------------------------
--tv conversion rates
----------------------------------------------------------------------
if object_id('tempdb..#UVTV') is not null drop table #UVTV
select a.Touch_Type_FK, Touch_Name, Touch_Name_2, Audience_Type_Name, Media_Type, Response_Channel, Response_Rate, Conversion_Rate,
	CASE WHEN Response_Channel='CALL' then Conversion_Rate*Call_Percent_of_Sales
	ELSE Conversion_Rate*Click_Percent_of_Sales
	END as UVTV_Conversion_Rate
	into #UVTV
	from Forecasting.Most_Recent_RR_Assumptions as A
		INNER JOIN Forecasting.Touch_Type as B
			ON A.Touch_Type_FK=B.Touch_Type_ID
		INNER JOIN Forecasting.Media_Type as C
			on B.Media_Type_FK=C.Media_Type_ID
		INNER JOIN Forecasting.Audience as D
			ON B.Audience_FK=D.Audience_ID
		INNER JOIN Forecasting.Most_Recent_Conversions_View as E
			ON A.Touch_Type_FK=E.Touch_Type_FK and A.Response_Channel_FK=E.Response_Channel_FK
		INNER JOIN Forecasting.Response_Channel as F
			ON A.Response_Channel_FK=F.Response_Channel_ID
		INNER JOIN Forecasting.Most_Recent_Sales_Percents_View as G
			ON A.Touch_Type_FK=G.Touch_Type_FK and Product_FK=1
order by Response_Channel, a.Touch_Type_FK

if object_id('sandbox.UVTV_crs') is not null drop table sandbox.UVTV_crs
DECLARE @cols_UVTV_crs AS NVARCHAR(MAX),
    @query_UVTV_crs  AS NVARCHAR(MAX);

select @cols_UVTV_crs = STUFF((SELECT distinct ',' + QUOTENAME(c.response_channel) 
            FROM #UVTV c
            FOR XML PATH('')),1,1,'')

set @query_UVTV_crs = 'SELECT touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, ' + @cols_UVTV_crs + ' 
				into sandbox.UVTV_crs from 
            (
                select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, response_channel, UVTV_conversion_rate
                from #UVTV
           ) x
            pivot 
            (
                 max(UVTV_conversion_rate)
                for response_channel in (' + @cols_UVTV_crs + ')
            ) p '


execute(@query_UVTV_crs)

if object_id('tempdb..#UVTV_crs') is not null drop table #UVTV_crs
select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type,
call as [UVTV CALL CR],
click as [UVTV CLICK CR]
into #UVTV_crs
from sandbox.UVTV_crs
drop table sandbox.UVTV_crs

----------------------------------------------------------------------
--HSIA conversion rates
----------------------------------------------------------------------
if object_id('tempdb..#HSIA') is not null drop table #HSIA
select a.Touch_Type_FK, Touch_Name, Touch_Name_2, Audience_Type_Name, Media_Type, Response_Channel, Response_Rate, Conversion_Rate,
	CASE WHEN Response_Channel='CALL' then Conversion_Rate*Call_Percent_of_Sales
	ELSE Conversion_Rate*Click_Percent_of_Sales
	END as HSIA_Conversion_Rate
	into #HSIA
	from Forecasting.Most_Recent_RR_Assumptions as A
		INNER JOIN Forecasting.Touch_Type as B
			ON A.Touch_Type_FK=B.Touch_Type_ID
		INNER JOIN Forecasting.Media_Type as C
			on B.Media_Type_FK=C.Media_Type_ID
		INNER JOIN Forecasting.Audience as D
			ON B.Audience_FK=D.Audience_ID
		INNER JOIN Forecasting.Most_Recent_Conversions_View as E
			ON A.Touch_Type_FK=E.Touch_Type_FK and A.Response_Channel_FK=E.Response_Channel_FK
		INNER JOIN Forecasting.Response_Channel as F
			ON A.Response_Channel_FK=F.Response_Channel_ID
		INNER JOIN Forecasting.Most_Recent_Sales_Percents_View as G
			ON A.Touch_Type_FK=G.Touch_Type_FK and Product_FK=3
order by Response_Channel, a.Touch_Type_FK

if object_id('sandbox.HSIA_crs') is not null drop table sandbox.HSIA_crs
DECLARE @cols_HSIA_crs AS NVARCHAR(MAX),
    @query_HSIA_crs  AS NVARCHAR(MAX);

select @cols_HSIA_crs = STUFF((SELECT distinct ',' + QUOTENAME(c.response_channel) 
            FROM #HSIA c
            FOR XML PATH('')),1,1,'')

set @query_HSIA_crs = 'SELECT touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, ' + @cols_HSIA_crs + ' 
				into sandbox.HSIA_crs from 
            (
                select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, response_channel, HSIA_conversion_rate
                from #HSIA
           ) x
            pivot 
            (
                 max(HSIA_conversion_rate)
                for response_channel in (' + @cols_HSIA_crs + ')
            ) p '


execute(@query_HSIA_crs)

if object_id('tempdb..#HSIA_crs') is not null drop table #HSIA_crs
select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type,
call as [HSIA CALL CR],
click as [HSIA CLICK CR]
into #HSIA_crs
from sandbox.HSIA_crs
drop table sandbox.HSIA_crs

----------------------------------------------------------------------
--DSLREG conversion rates
----------------------------------------------------------------------
if object_id('tempdb..#DSLREG') is not null drop table #DSLREG
select a.Touch_Type_FK, Touch_Name, Touch_Name_2, Audience_Type_Name, Media_Type, Response_Channel, Response_Rate, Conversion_Rate,
	CASE WHEN Response_Channel='CALL' then Conversion_Rate*Call_Percent_of_Sales
	ELSE Conversion_Rate*Click_Percent_of_Sales
	END as DSLREG_Conversion_Rate
	into #DSLREG
	from Forecasting.Most_Recent_RR_Assumptions as A
		INNER JOIN Forecasting.Touch_Type as B
			ON A.Touch_Type_FK=B.Touch_Type_ID
		INNER JOIN Forecasting.Media_Type as C
			on B.Media_Type_FK=C.Media_Type_ID
		INNER JOIN Forecasting.Audience as D
			ON B.Audience_FK=D.Audience_ID
		INNER JOIN Forecasting.Most_Recent_Conversions_View as E
			ON A.Touch_Type_FK=E.Touch_Type_FK and A.Response_Channel_FK=E.Response_Channel_FK
		INNER JOIN Forecasting.Response_Channel as F
			ON A.Response_Channel_FK=F.Response_Channel_ID
		INNER JOIN Forecasting.Most_Recent_Sales_Percents_View as G
			ON A.Touch_Type_FK=G.Touch_Type_FK and Product_FK=4
order by Response_Channel, a.Touch_Type_FK

if object_id('sandbox.DSLREG_crs') is not null drop table sandbox.DSLREG_crs
DECLARE @cols_DSLREG_crs AS NVARCHAR(MAX),
    @query_DSLREG_crs  AS NVARCHAR(MAX);

select @cols_DSLREG_crs = STUFF((SELECT distinct ',' + QUOTENAME(c.response_channel) 
            FROM #DSLREG c
            FOR XML PATH('')),1,1,'')

set @query_DSLREG_crs = 'SELECT touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, ' + @cols_DSLREG_crs + ' 
				into sandbox.DSLREG_crs from 
            (
                select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, response_channel, DSLREG_conversion_rate
                from #DSLREG
           ) x
            pivot 
            (
                 max(DSLREG_conversion_rate)
                for response_channel in (' + @cols_DSLREG_crs + ')
            ) p '


execute(@query_DSLREG_crs)

if object_id('tempdb..#DSLREG_crs') is not null drop table #DSLREG_crs
select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type,
call as [DSLREG CALL CR],
click as [DSLREG CLICK CR]
into #DSLREG_crs
from sandbox.DSLREG_crs
drop table sandbox.DSLREG_crs


----------------------------------------------------------------------
--DSLDRY conversion rates
----------------------------------------------------------------------
if object_id('tempdb..#DSLDRY') is not null drop table #DSLDRY
select a.Touch_Type_FK, Touch_Name, Touch_Name_2, Audience_Type_Name, Media_Type, Response_Channel, Response_Rate, Conversion_Rate,
	CASE WHEN Response_Channel='CALL' then Conversion_Rate*Call_Percent_of_Sales
	ELSE Conversion_Rate*Click_Percent_of_Sales
	END as DSLDRY_Conversion_Rate
	into #DSLDRY
	from Forecasting.Most_Recent_RR_Assumptions as A
		INNER JOIN Forecasting.Touch_Type as B
			ON A.Touch_Type_FK=B.Touch_Type_ID
		INNER JOIN Forecasting.Media_Type as C
			on B.Media_Type_FK=C.Media_Type_ID
		INNER JOIN Forecasting.Audience as D
			ON B.Audience_FK=D.Audience_ID
		INNER JOIN Forecasting.Most_Recent_Conversions_View as E
			ON A.Touch_Type_FK=E.Touch_Type_FK and A.Response_Channel_FK=E.Response_Channel_FK
		INNER JOIN Forecasting.Response_Channel as F
			ON A.Response_Channel_FK=F.Response_Channel_ID
		INNER JOIN Forecasting.Most_Recent_Sales_Percents_View as G
			ON A.Touch_Type_FK=G.Touch_Type_FK and Product_FK=5
order by Response_Channel, a.Touch_Type_FK

if object_id('sandbox.DSLDRY_crs') is not null drop table sandbox.DSLDRY_crs
DECLARE @cols_DSLDRY_crs AS NVARCHAR(MAX),
    @query_DSLDRY_crs  AS NVARCHAR(MAX);

select @cols_DSLDRY_crs = STUFF((SELECT distinct ',' + QUOTENAME(c.response_channel) 
            FROM #DSLDRY c
            FOR XML PATH('')),1,1,'')

set @query_DSLDRY_crs = 'SELECT touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, ' + @cols_DSLDRY_crs + ' 
				into sandbox.DSLDRY_crs from 
            (
                select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, response_channel, DSLDRY_conversion_rate
                from #DSLDRY
           ) x
            pivot 
            (
                 max(DSLDRY_conversion_rate)
                for response_channel in (' + @cols_DSLDRY_crs + ')
            ) p '


execute(@query_DSLDRY_crs)

if object_id('tempdb..#DSLDRY_crs') is not null drop table #DSLDRY_crs
select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type,
call as [DSLDRY CALL CR],
click as [DSLDRY CLICK CR]
into #DSLDRY_crs
from sandbox.DSLDRY_crs
drop table sandbox.DSLDRY_crs

----------------------------------------------------------------------
--ACCL conversion rates
----------------------------------------------------------------------
if object_id('tempdb..#ACCL') is not null drop table #ACCL
select a.Touch_Type_FK, Touch_Name, Touch_Name_2, Audience_Type_Name, Media_Type, Response_Channel, Response_Rate, Conversion_Rate,
	CASE WHEN Response_Channel='CALL' then Conversion_Rate*Call_Percent_of_Sales
	ELSE Conversion_Rate*Click_Percent_of_Sales
	END as ACCL_Conversion_Rate
	into #ACCL
	from Forecasting.Most_Recent_RR_Assumptions as A
		INNER JOIN Forecasting.Touch_Type as B
			ON A.Touch_Type_FK=B.Touch_Type_ID
		INNER JOIN Forecasting.Media_Type as C
			on B.Media_Type_FK=C.Media_Type_ID
		INNER JOIN Forecasting.Audience as D
			ON B.Audience_FK=D.Audience_ID
		INNER JOIN Forecasting.Most_Recent_Conversions_View as E
			ON A.Touch_Type_FK=E.Touch_Type_FK and A.Response_Channel_FK=E.Response_Channel_FK
		INNER JOIN Forecasting.Response_Channel as F
			ON A.Response_Channel_FK=F.Response_Channel_ID
		INNER JOIN Forecasting.Most_Recent_Sales_Percents_View as G
			ON A.Touch_Type_FK=G.Touch_Type_FK and Product_FK=6
order by Response_Channel, a.Touch_Type_FK

if object_id('sandbox.ACCL_crs') is not null drop table sandbox.ACCL_crs
DECLARE @cols_ACCL_crs AS NVARCHAR(MAX),
    @query_ACCL_crs  AS NVARCHAR(MAX);

select @cols_ACCL_crs = STUFF((SELECT distinct ',' + QUOTENAME(c.response_channel) 
            FROM #ACCL c
            FOR XML PATH('')),1,1,'')

set @query_ACCL_crs = 'SELECT touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, ' + @cols_ACCL_crs + ' 
				into sandbox.ACCL_crs from 
            (
                select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, response_channel, ACCL_conversion_rate
                from #ACCL
           ) x
            pivot 
            (
                 max(ACCL_conversion_rate)
                for response_channel in (' + @cols_ACCL_crs + ')
            ) p '


execute(@query_ACCL_crs)

if object_id('tempdb..#ACCL_crs') is not null drop table #ACCL_crs
select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type,
call as [ACCL CALL CR],
click as [ACCL CLICK CR]
into #ACCL_crs
from sandbox.ACCL_crs
drop table sandbox.ACCL_crs


----------------------------------------------------------------------
--WRLS_VOICE conversion rates
----------------------------------------------------------------------
if object_id('tempdb..#WRLS_VOICE') is not null drop table #WRLS_VOICE
select a.Touch_Type_FK, Touch_Name, Touch_Name_2, Audience_Type_Name, Media_Type, Response_Channel, Response_Rate, Conversion_Rate,
	CASE WHEN Response_Channel='CALL' then Conversion_Rate*Call_Percent_of_Sales
	ELSE Conversion_Rate*Click_Percent_of_Sales
	END as WRLS_VOICE_Conversion_Rate
	into #WRLS_VOICE
	from Forecasting.Most_Recent_RR_Assumptions as A
		INNER JOIN Forecasting.Touch_Type as B
			ON A.Touch_Type_FK=B.Touch_Type_ID
		INNER JOIN Forecasting.Media_Type as C
			on B.Media_Type_FK=C.Media_Type_ID
		INNER JOIN Forecasting.Audience as D
			ON B.Audience_FK=D.Audience_ID
		INNER JOIN Forecasting.Most_Recent_Conversions_View as E
			ON A.Touch_Type_FK=E.Touch_Type_FK and A.Response_Channel_FK=E.Response_Channel_FK
		INNER JOIN Forecasting.Response_Channel as F
			ON A.Response_Channel_FK=F.Response_Channel_ID
		INNER JOIN Forecasting.Most_Recent_Sales_Percents_View as G
			ON A.Touch_Type_FK=G.Touch_Type_FK and Product_FK=8
order by Response_Channel, a.Touch_Type_FK

if object_id('sandbox.WRLS_VOICE_crs') is not null drop table sandbox.WRLS_VOICE_crs
DECLARE @cols_WRLS_VOICE_crs AS NVARCHAR(MAX),
    @query_WRLS_VOICE_crs  AS NVARCHAR(MAX);

select @cols_WRLS_VOICE_crs = STUFF((SELECT distinct ',' + QUOTENAME(c.response_channel) 
            FROM #WRLS_VOICE c
            FOR XML PATH('')),1,1,'')

set @query_WRLS_VOICE_crs = 'SELECT touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, ' + @cols_WRLS_VOICE_crs + ' 
				into sandbox.WRLS_VOICE_crs from 
            (
                select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, response_channel, WRLS_VOICE_conversion_rate
                from #WRLS_VOICE
           ) x
            pivot 
            (
                 max(WRLS_VOICE_conversion_rate)
                for response_channel in (' + @cols_WRLS_VOICE_crs + ')
            ) p '


execute(@query_WRLS_VOICE_crs)

if object_id('tempdb..#WRLS_VOICE_crs') is not null drop table #WRLS_VOICE_crs
select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type,
call as [WRLS_VOICE CALL CR],
click as [WRLS_VOICE CLICK CR]
into #WRLS_VOICE_crs
from sandbox.WRLS_VOICE_crs
drop table sandbox.WRLS_VOICE_crs

----------------------------------------------------------------------
--VOIP conversion rates
----------------------------------------------------------------------
if object_id('tempdb..#VOIP') is not null drop table #VOIP
select a.Touch_Type_FK, Touch_Name, Touch_Name_2, Audience_Type_Name, Media_Type, Response_Channel, Response_Rate, Conversion_Rate,
	CASE WHEN Response_Channel='CALL' then Conversion_Rate*Call_Percent_of_Sales
	ELSE Conversion_Rate*Click_Percent_of_Sales
	END as VOIP_Conversion_Rate
	into #VOIP
	from Forecasting.Most_Recent_RR_Assumptions as A
		INNER JOIN Forecasting.Touch_Type as B
			ON A.Touch_Type_FK=B.Touch_Type_ID
		INNER JOIN Forecasting.Media_Type as C
			on B.Media_Type_FK=C.Media_Type_ID
		INNER JOIN Forecasting.Audience as D
			ON B.Audience_FK=D.Audience_ID
		INNER JOIN Forecasting.Most_Recent_Conversions_View as E
			ON A.Touch_Type_FK=E.Touch_Type_FK and A.Response_Channel_FK=E.Response_Channel_FK
		INNER JOIN Forecasting.Response_Channel as F
			ON A.Response_Channel_FK=F.Response_Channel_ID
		INNER JOIN Forecasting.Most_Recent_Sales_Percents_View as G
			ON A.Touch_Type_FK=G.Touch_Type_FK and Product_FK=9
order by Response_Channel, a.Touch_Type_FK

if object_id('sandbox.VOIP_crs') is not null drop table sandbox.VOIP_crs
DECLARE @cols_VOIP_crs AS NVARCHAR(MAX),
    @query_VOIP_crs  AS NVARCHAR(MAX);

select @cols_VOIP_crs = STUFF((SELECT distinct ',' + QUOTENAME(c.response_channel) 
            FROM #VOIP c
            FOR XML PATH('')),1,1,'')

set @query_VOIP_crs = 'SELECT touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, ' + @cols_VOIP_crs + ' 
				into sandbox.VOIP_crs from 
            (
                select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, response_channel, VOIP_conversion_rate
                from #VOIP
           ) x
            pivot 
            (
                 max(VOIP_conversion_rate)
                for response_channel in (' + @cols_VOIP_crs + ')
            ) p '


execute(@query_VOIP_crs)

if object_id('tempdb..#VOIP_crs') is not null drop table #VOIP_crs
select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type,
call as [VOIP CALL CR],
click as [VOIP CLICK CR]
into #VOIP_crs
from sandbox.VOIP_crs
drop table sandbox.VOIP_crs


----------------------------------------------------------------------
--DIRECTV conversion rates
----------------------------------------------------------------------
if object_id('tempdb..#DIRECTV') is not null drop table #DIRECTV
select a.Touch_Type_FK, Touch_Name, Touch_Name_2, Audience_Type_Name, Media_Type, Response_Channel, Response_Rate, Conversion_Rate,
	CASE WHEN Response_Channel='CALL' then Conversion_Rate*Call_Percent_of_Sales
	ELSE Conversion_Rate*Click_Percent_of_Sales
	END as DIRECTV_Conversion_Rate
	into #DIRECTV
	from Forecasting.Most_Recent_RR_Assumptions as A
		INNER JOIN Forecasting.Touch_Type as B
			ON A.Touch_Type_FK=B.Touch_Type_ID
		INNER JOIN Forecasting.Media_Type as C
			on B.Media_Type_FK=C.Media_Type_ID
		INNER JOIN Forecasting.Audience as D
			ON B.Audience_FK=D.Audience_ID
		INNER JOIN Forecasting.Most_Recent_Conversions_View as E
			ON A.Touch_Type_FK=E.Touch_Type_FK and A.Response_Channel_FK=E.Response_Channel_FK
		INNER JOIN Forecasting.Response_Channel as F
			ON A.Response_Channel_FK=F.Response_Channel_ID
		INNER JOIN Forecasting.Most_Recent_Sales_Percents_View as G
			ON A.Touch_Type_FK=G.Touch_Type_FK and Product_FK=10
order by Response_Channel, a.Touch_Type_FK

if object_id('sandbox.DIRECTV_crs') is not null drop table sandbox.DIRECTV_crs
DECLARE @cols_DIRECTV_crs AS NVARCHAR(MAX),
    @query_DIRECTV_crs  AS NVARCHAR(MAX);

select @cols_DIRECTV_crs = STUFF((SELECT distinct ',' + QUOTENAME(c.response_channel) 
            FROM #DIRECTV c
            FOR XML PATH('')),1,1,'')

set @query_DIRECTV_crs = 'SELECT touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, ' + @cols_DIRECTV_crs + ' 
				into sandbox.DIRECTV_crs from 
            (
                select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, response_channel, DIRECTV_conversion_rate
                from #DIRECTV
           ) x
            pivot 
            (
                 max(DIRECTV_conversion_rate)
                for response_channel in (' + @cols_DIRECTV_crs + ')
            ) p '


execute(@query_DIRECTV_crs)

if object_id('tempdb..#DIRECTV_crs') is not null drop table #DIRECTV_crs
select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type,
call as [DIRECTV CALL CR],
click as [DIRECTV CLICK CR]
into #DIRECTV_crs
from sandbox.DIRECTV_crs
drop table sandbox.DIRECTV_crs

----------------------------------------------------------------------
--WRLS_FAM conversion rates
----------------------------------------------------------------------
if object_id('tempdb..#WRLS_FAM') is not null drop table #WRLS_FAM
select a.Touch_Type_FK, Touch_Name, Touch_Name_2, Audience_Type_Name, Media_Type, Response_Channel, Response_Rate, Conversion_Rate,
	CASE WHEN Response_Channel='CALL' then Conversion_Rate*Call_Percent_of_Sales
	ELSE Conversion_Rate*Click_Percent_of_Sales
	END as WRLS_FAM_Conversion_Rate
	into #WRLS_FAM
	from Forecasting.Most_Recent_RR_Assumptions as A
		INNER JOIN Forecasting.Touch_Type as B
			ON A.Touch_Type_FK=B.Touch_Type_ID
		INNER JOIN Forecasting.Media_Type as C
			on B.Media_Type_FK=C.Media_Type_ID
		INNER JOIN Forecasting.Audience as D
			ON B.Audience_FK=D.Audience_ID
		INNER JOIN Forecasting.Most_Recent_Conversions_View as E
			ON A.Touch_Type_FK=E.Touch_Type_FK and A.Response_Channel_FK=E.Response_Channel_FK
		INNER JOIN Forecasting.Response_Channel as F
			ON A.Response_Channel_FK=F.Response_Channel_ID
		INNER JOIN Forecasting.Most_Recent_Sales_Percents_View as G
			ON A.Touch_Type_FK=G.Touch_Type_FK and Product_FK=12
order by Response_Channel, a.Touch_Type_FK

if object_id('sandbox.WRLS_FAM_crs') is not null drop table sandbox.WRLS_FAM_crs
DECLARE @cols_WRLS_FAM_crs AS NVARCHAR(MAX),
    @query_WRLS_FAM_crs  AS NVARCHAR(MAX);

select @cols_WRLS_FAM_crs = STUFF((SELECT distinct ',' + QUOTENAME(c.response_channel) 
            FROM #WRLS_FAM c
            FOR XML PATH('')),1,1,'')

set @query_WRLS_FAM_crs = 'SELECT touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, ' + @cols_WRLS_FAM_crs + ' 
				into sandbox.WRLS_FAM_crs from 
            (
                select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, response_channel, WRLS_FAM_conversion_rate
                from #WRLS_FAM
           ) x
            pivot 
            (
                 max(WRLS_FAM_conversion_rate)
                for response_channel in (' + @cols_WRLS_FAM_crs + ')
            ) p '


execute(@query_WRLS_FAM_crs)

if object_id('tempdb..#WRLS_FAM_crs') is not null drop table #WRLS_FAM_crs
select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type,
call as [WRLS_FAM CALL CR],
click as [WRLS_FAM CLICK CR]
into #WRLS_FAM_crs
from sandbox.WRLS_FAM_crs
drop table sandbox.WRLS_FAM_crs

----------------------------------------------------------------------
--WRLS_DATA conversion rates
----------------------------------------------------------------------
if object_id('tempdb..#WRLS_DATA') is not null drop table #WRLS_DATA
select a.Touch_Type_FK, Touch_Name, Touch_Name_2, Audience_Type_Name, Media_Type, Response_Channel, Response_Rate, Conversion_Rate,
	CASE WHEN Response_Channel='CALL' then Conversion_Rate*Call_Percent_of_Sales
	ELSE Conversion_Rate*Click_Percent_of_Sales
	END as WRLS_DATA_Conversion_Rate
	into #WRLS_DATA
	from Forecasting.Most_Recent_RR_Assumptions as A
		INNER JOIN Forecasting.Touch_Type as B
			ON A.Touch_Type_FK=B.Touch_Type_ID
		INNER JOIN Forecasting.Media_Type as C
			on B.Media_Type_FK=C.Media_Type_ID
		INNER JOIN Forecasting.Audience as D
			ON B.Audience_FK=D.Audience_ID
		INNER JOIN Forecasting.Most_Recent_Conversions_View as E
			ON A.Touch_Type_FK=E.Touch_Type_FK and A.Response_Channel_FK=E.Response_Channel_FK
		INNER JOIN Forecasting.Response_Channel as F
			ON A.Response_Channel_FK=F.Response_Channel_ID
		INNER JOIN Forecasting.Most_Recent_Sales_Percents_View as G
			ON A.Touch_Type_FK=G.Touch_Type_FK and Product_FK=13
order by Response_Channel, a.Touch_Type_FK

if object_id('sandbox.WRLS_DATA_crs') is not null drop table sandbox.WRLS_DATA_crs
DECLARE @cols_WRLS_DATA_crs AS NVARCHAR(MAX),
    @query_WRLS_DATA_crs  AS NVARCHAR(MAX);

select @cols_WRLS_DATA_crs = STUFF((SELECT distinct ',' + QUOTENAME(c.response_channel) 
            FROM #WRLS_DATA c
            FOR XML PATH('')),1,1,'')

set @query_WRLS_DATA_crs = 'SELECT touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, ' + @cols_WRLS_DATA_crs + ' 
				into sandbox.WRLS_DATA_crs from 
            (
                select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, response_channel, WRLS_DATA_conversion_rate
                from #WRLS_DATA
           ) x
            pivot 
            (
                 max(WRLS_DATA_conversion_rate)
                for response_channel in (' + @cols_WRLS_DATA_crs + ')
            ) p '


execute(@query_WRLS_DATA_crs)

if object_id('tempdb..#WRLS_DATA_crs') is not null drop table #WRLS_DATA_crs
select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type,
call as [WRLS_DATA CALL CR],
click as [WRLS_DATA CLICK CR]
into #WRLS_DATA_crs
from sandbox.WRLS_DATA_crs
drop table sandbox.WRLS_DATA_crs

----------------------------------------------------------------------
--IPDSL conversion rates
----------------------------------------------------------------------
if object_id('tempdb..#IPDSL') is not null drop table #IPDSL
select a.Touch_Type_FK, Touch_Name, Touch_Name_2, Audience_Type_Name, Media_Type, Response_Channel, Response_Rate, Conversion_Rate,
	CASE WHEN Response_Channel='CALL' then Conversion_Rate*Call_Percent_of_Sales
	ELSE Conversion_Rate*Click_Percent_of_Sales
	END as IPDSL_Conversion_Rate
	into #IPDSL
	from Forecasting.Most_Recent_RR_Assumptions as A
		INNER JOIN Forecasting.Touch_Type as B
			ON A.Touch_Type_FK=B.Touch_Type_ID
		INNER JOIN Forecasting.Media_Type as C
			on B.Media_Type_FK=C.Media_Type_ID
		INNER JOIN Forecasting.Audience as D
			ON B.Audience_FK=D.Audience_ID
		INNER JOIN Forecasting.Most_Recent_Conversions_View as E
			ON A.Touch_Type_FK=E.Touch_Type_FK and A.Response_Channel_FK=E.Response_Channel_FK
		INNER JOIN Forecasting.Response_Channel as F
			ON A.Response_Channel_FK=F.Response_Channel_ID
		INNER JOIN Forecasting.Most_Recent_Sales_Percents_View as G
			ON A.Touch_Type_FK=G.Touch_Type_FK and Product_FK=14
order by Response_Channel, a.Touch_Type_FK


if object_id('sandbox.IPDSL_crs') is not null drop table sandbox.IPDSL_crs
DECLARE @cols_IPDSL_crs AS NVARCHAR(MAX),
    @query_IPDSL_crs  AS NVARCHAR(MAX);

select @cols_IPDSL_crs = STUFF((SELECT distinct ',' + QUOTENAME(c.response_channel) 
            FROM #IPDSL c
            FOR XML PATH('')),1,1,'')

set @query_IPDSL_crs = 'SELECT touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, ' + @cols_IPDSL_crs + ' 
				into sandbox.IPDSL_crs from 
            (
                select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type, response_channel, IPDSL_conversion_rate
                from #IPDSL
           ) x
            pivot 
            (
                 max(IPDSL_conversion_rate)
                for response_channel in (' + @cols_IPDSL_crs + ')
            ) p '


execute(@query_IPDSL_crs)

if object_id('tempdb..#IPDSL_crs') is not null drop table #IPDSL_crs
select touch_type_fk, touch_name, touch_name_2, audience_type_name, media_type,
call as [IPDSL CALL CR],
click as [IPDSL CLICK CR]
into #IPDSL_crs
from sandbox.IPDSL_crs
drop table sandbox.IPDSL_crs


----------------------------------------------------------------------
--Current_BV_Base_Rates
----------------------------------------------------------------------
if object_id('tempdb..#Current_BV_Base_Rates') is not null drop table #Current_BV_Base_Rates
select coalesce(a.touch_type_fk, 	b.touch_type_fk, 	c.touch_type_fk, 	d.touch_type_fk, 	e.touch_type_fk, 	f.touch_type_fk, 	g.touch_type_fk, 	h.touch_type_fk, 	i.touch_type_fk, 	j.touch_type_fk, 	k.touch_type_fk, 	l.touch_type_fk, 	m.touch_type_fk) as touch_type_fk
, coalesce(a.touch_name, 	b.touch_name, 	c.touch_name, 	d.touch_name, 	e.touch_name, 	f.touch_name, 	g.touch_name, 	h.touch_name, 	i.touch_name, 	j.touch_name, 	k.touch_name, 	l.touch_name, 	m.touch_name) as touch_name
, coalesce(a.touch_name_2, 	b.touch_name_2, 	c.touch_name_2, 	d.touch_name_2, 	e.touch_name_2, 	f.touch_name_2, 	g.touch_name_2, 	h.touch_name_2, 	i.touch_name_2, 	j.touch_name_2, 	k.touch_name_2, 	l.touch_name_2, 	m.touch_name_2) as touch_name_2
, coalesce(a.audience_type_name, 	b.audience_type_name, 	c.audience_type_name, 	d.audience_type_name, 	e.audience_type_name, 	f.audience_type_name, 	g.audience_type_name, 	h.audience_type_name, 	i.audience_type_name, 	j.audience_type_name, 	k.audience_type_name, 	l.audience_type_name, 	m.audience_type_name) as audience_type_name
, coalesce(a.media_type, 	b.media_type, 	c.media_type, 	d.media_type, 	e.media_type, 	f.media_type, 	g.media_type, 	h.media_type, 	i.media_type, 	j.media_type, 	k.media_type, 	l.media_type, 	m.media_type) as media_type
,isnull(a.[BASE CALL RR],0) as [BASE CALL RR]
,isnull(a.[BASE CLICK RR],0) as [BASE CLICK RR]
,isnull(b.[STRAT CALL CR],0) as [BV STRAT CALL CR]
,isnull(b.[STRAT CLICK CR],0) as [BV STRAT CLICK CR]
,isnull(c.[UVTV CALL CR],0) as [BV UVTV CALL CR]
,isnull(c.[UVTV CLICK CR],0) as [BV UVTV CLICK CR]
,isnull(d.[HSIA CALL CR],0) as [BV HSIA CALL CR]
,isnull(d.[HSIA CLICK CR],0) as [BV HSIA CLICK CR]
,isnull(i.[VOIP CALL CR],0) as [BV VOIP CALL CR]
,isnull(i.[VOIP CLICK CR],0) as [BV VOIP CLICK CR]
,isnull(e.[DSLREG CALL CR],0) as [BV DSLREG CALL CR]
,isnull(e.[DSLREG CLICK CR],0) as [BV DSLREG CLICK CR]
,isnull(f.[DSLDRY CALL CR],0) as [BV DSLDRY CALL CR]
,isnull(f.[DSLDRY CLICK CR],0) as [BV DSLDRY CLICK CR]
,isnull(m.[IPDSL CALL CR],0) as [BV IPDSL CALL CR]
,isnull(m.[IPDSL CLICK CR],0) as [BV IPDSL CLICK CR]
,isnull(j.[DIRECTV CALL CR],0) as [BV DIRECTV CALL CR]
,isnull(j.[DIRECTV CLICK CR],0) as [BV DIRECTV CLICK CR]
,isnull(g.[ACCL CALL CR],0) as [BV ACCL CALL CR]
,isnull(g.[ACCL CLICK CR],0) as [BV ACCL CLICK CR]
,isnull(h.[WRLS_VOICE CALL CR],0) as [BV WRLS_VOICE CALL CR]
,isnull(h.[WRLS_VOICE CLICK CR],0) as [BV WRLS_VOICE CLICK CR]
,isnull(k.[WRLS_FAM CALL CR],0) as [BV WRLS_FAM CALL CR]
,isnull(k.[WRLS_FAM CLICK CR],0) as [BV WRLS_FAM CLICK CR]
,isnull(l.[WRLS_DATA CALL CR],0) as [BV WRLS_DATA CALL CR]
,isnull(l.[WRLS_DATA CLICK CR],0) as [BV WRLS_DATA CLICK CR]
into #Current_BV_Base_Rates
from #base_rrs as a 
join #strat_crs as b
on (a.touch_type_fk=b.touch_type_fk)
join #UVTV_crs as c
on (a.touch_type_fk=c.touch_type_fk)
join #HSIA_crs as d
on (a.touch_type_fk=d.touch_type_fk)
join #DSLREG_crs as e
on (a.touch_type_fk=e.touch_type_fk)
join #DSLDRY_crs as f
on (a.touch_type_fk=f.touch_type_fk)
join #ACCL_crs as g
on (a.touch_type_fk=g.touch_type_fk)
join #WRLS_VOICE_crs as h
on (a.touch_type_fk=h.touch_type_fk)
join #VOIP_crs as i
on (a.touch_type_fk=i.touch_type_fk)
join #DIRECTV_crs as j
on (a.touch_type_fk=j.touch_type_fk)
join #WRLS_FAM_crs as k
on (a.touch_type_fk=k.touch_type_fk)
join #WRLS_DATA_crs as l
on (a.touch_type_fk=l.touch_type_fk)
join #IPDSL_crs as m
on (a.touch_type_fk=m.touch_type_fk)

--select * from #Current_BV_Base_Rates

----------------------------------------------------------------------
--Join Actual and BV Rates
----------------------------------------------------------------------
if object_id('tempdb..#Current_BV_AVG_Rates') is not null drop table #Current_BV_AVG_Rates

select coalesce(a.touch_type_fk,b.touch_type_fk) as touch_type_fk
, coalesce(a.touch_name,b.touch_name) as touch_name
, coalesce(a.touch_name_2,b.touch_name_2) as touch_name_2
, coalesce(a.audience_type_name,b.audience_type_name) as audience_type_name
, coalesce(a.media_type,b.media_type) as media_type
, b.program_owner
, isnull(a.[Base Call RR],0) as [BV Call RR]
, isnull(b.[Call RR],0) as [Call RR]
, isnull(b.[Call RR]-a.[Base Call RR],0) as [Diff Call RR]

, isnull(a.[Base CLICK RR],0) as [BV CLICK RR]
, isnull(b.[CLICK RR],0) as [CLICK RR]
, isnull(b.[CLICK RR]-a.[Base CLICK RR],0) as [Diff CLICK RR]

, isnull(a.[BV STRAT CALL CR],0) as [BV STRAT CALL CR]
, isnull(b.[STRAT CALL CR],0) as [STRAT CALL CR]
, isnull(b.[STRAT CALL CR]-a.[BV STRAT CALL CR],0) as [Diff STRAT CALL CR]

, isnull(a.[BV STRAT CLICK CR],0) as [BV STRAT CLICK CR]
, isnull(b.[STRAT CLICK CR],0) as [STRAT CLICK CR]
, isnull(b.[STRAT CLICK CR]-a.[BV STRAT CLICK CR],0) as [Diff STRAT CLICK CR]

, isnull(a.[BV UVTV CALL CR],0) as [BV UVTV CALL CR]
, isnull(b.[UVTV CALL CR],0) as [UVTV CALL CR]
, isnull(b.[UVTV CALL CR]-a.[BV UVTV CALL CR],0) as [Diff UVTV CALL CR]

, isnull(a.[BV UVTV CLICK CR],0) as [BV UVTV CLICK CR]
, isnull(b.[UVTV CLICK CR],0) as [UVTV CLICK CR]
, isnull(b.[UVTV CLICK CR]-a.[BV UVTV CLICK CR],0) as [Diff UVTV CLICK CR]

, isnull(a.[BV HSIA CALL CR],0) as  [BV HSIA CALL CR]
, isnull(b.[HSIA CALL CR],0) as [HSIA CALL CR]
, isnull(b.[HSIA CALL CR]-a.[BV HSIA CALL CR],0) as [Diff HSIA CALL CR]

, isnull(a.[BV HSIA CLICK CR],0) as [BV HSIA CLICK CR]
, isnull(b.[HSIA CLICK CR],0) as [HSIA CLICK CR]
, isnull(b.[HSIA CLICK CR]-a.[BV HSIA CLICK CR],0) as [Diff HSIA CLICK CR]

, isnull(a.[BV VOIP CALL CR],0) as [BV VOIP CALL CR]
, isnull(b.[VOIP CALL CR],0) as [VOIP CALL CR]
, isnull(b.[VOIP CALL CR]-a.[BV VOIP CALL CR],0) as [Diff VOIP CALL CR]

, isnull(a.[BV VOIP CLICK CR],0) as [BV VOIP CLICK CR]
, isnull(b.[VOIP CLICK CR],0) as [VOIP CLICK CR]
, isnull(b.[VOIP CLICK CR]-a.[BV VOIP CLICK CR],0) as [Diff VOIP CLICK CR]

, isnull(a.[BV DSLREG CALL CR],0) as [BV DSLREG CALL CR]
, isnull(b.[DSLREG CALL CR],0) as [DSLREG CALL CR]
, isnull(b.[DSLREG CALL CR]-a.[BV DSLREG CALL CR],0) as [Diff DSLREG CALL CR]

, isnull(a.[BV DSLREG CLICK CR],0) as [BV DSLREG CLICK CR]
, isnull(b.[DSLREG CLICK CR],0) as [DSLREG CLICK CR]
, isnull(b.[DSLREG CLICK CR]-a.[BV DSLREG CLICK CR],0) as [Diff DSLREG CLICK CR]

, isnull(a.[BV DSLDRY CALL CR],0) as [BV DSLDRY CALL CR]
, isnull(b.[DSLDRY CALL CR],0) as [DSLDRY CALL CR]
, isnull(b.[DSLDRY CALL CR]-a.[BV DSLDRY CALL CR],0) as [Diff DSLDRY CALL CR]

, isnull(a.[BV DSLDRY CLICK CR],0) as [BV DSLDRY CLICK CR]
, isnull(b.[DSLDRY CLICK CR],0) as [DSLDRY CLICK CR]
, isnull(b.[DSLDRY CLICK CR]-a.[BV DSLDRY CLICK CR],0) as [Diff DSLDRY CLICK CR]

, isnull(a.[BV IPDSL CALL CR],0) as [BV IPDSL CALL CR]
, isnull(b.[IPDSL CALL CR],0) as [IPDSL CALL CR]
, isnull(b.[IPDSL CALL CR]-a.[BV IPDSL CALL CR],0) as [Diff IPDSL CALL CR]

, isnull(a.[BV IPDSL CLICK CR],0) as [BV IPDSL CLICK CR]
, isnull(b.[IPDSL CLICK CR],0) as [IPDSL CLICK CR]
, isnull(b.[IPDSL CLICK CR]-a.[BV IPDSL CLICK CR],0) as [Diff IPDSL CLICK CR]

, isnull(a.[BV ACCL CALL CR],0) as [BV ACCL CALL CR]
, isnull(b.[ACCL CALL CR],0) as [ACCL CALL CR]
, isnull(b.[ACCL CALL CR]-a.[BV ACCL CALL CR],0) as [Diff ACCL CALL CR]

, isnull(a.[BV ACCL CLICK CR],0) as [BV ACCL CLICK CR]
, isnull(b.[ACCL CLICK CR],0) as [ACCL CLICK CR]
, isnull(b.[ACCL CLICK CR]-a.[BV ACCL CLICK CR],0) as [Diff ACCL CLICK CR]

, isnull(a.[BV DIRECTV CALL CR],0) as [BV DIRECTV CALL CR]
, isnull(b.[DIRECTV CALL CR],0) as [DIRECTV CALL CR]
, isnull(b.[DIRECTV CALL CR]-a.[BV DIRECTV CALL CR],0) as [Diff DIRECTV CALL CR]

, isnull(a.[BV DIRECTV CLICK CR],0) as [BV DIRECTV CLICK CR]
, isnull(b.[DIRECTV CLICK CR],0) as [DIRECTV CLICK CR]
, isnull(b.[DIRECTV CLICK CR]-a.[BV DIRECTV CLICK CR],0) as [Diff DIRECTV CLICK CR]

, isnull(a.[BV WRLS_FAM CALL CR],0) as [BV WRLS_FAM CALL CR]
, isnull(b.[WRLS_FAM CALL CR],0) as [WRLS_FAM CALL CR]
, isnull(b.[WRLS_FAM CALL CR]-a.[BV WRLS_FAM CALL CR],0) as [Diff WRLS_FAM CALL CR]

, isnull(a.[BV WRLS_FAM CLICK CR],0) as [BV WRLS_FAM CLICK CR]
, isnull(b.[WRLS_FAM CLICK CR],0) as [WRLS_FAM CLICK CR]
, isnull(b.[WRLS_FAM CLICK CR]-a.[BV WRLS_FAM CLICK CR],0) as [Diff WRLS_FAM CLICK CR]

, isnull(a.[BV WRLS_DATA CALL CR],0) as [BV WRLS_DATA CALL CR]
, isnull(b.[WRLS_DATA CALL CR],0) as [WRLS_DATA CALL CR]
, isnull(b.[WRLS_DATA CALL CR]-a.[BV WRLS_DATA CALL CR],0) as [Diff WRLS_DATA CALL CR]

, isnull(a.[BV WRLS_DATA CLICK CR],0) as [BV WRLS_DATA CLICK CR]
, isnull(b.[WRLS_DATA CLICK CR],0) as [WRLS_DATA CLICK CR]
, isnull(b.[WRLS_DATA CLICK CR]-a.[BV WRLS_DATA CLICK CR],0) as [Diff WRLS_DATA CLICK CR]

, isnull(a.[BV WRLS_VOICE CALL CR],0) as [BV WRLS_VOICE CALL CR]
, isnull(b.[WRLS_VOICE CALL CR],0) as [WRLS_VOICE CALL CR]
, isnull(b.[WRLS_VOICE CALL CR]-a.[BV WRLS_VOICE CALL CR],0) as [Diff WRLS_VOICE CALL CR]

, isnull(a.[BV WRLS_VOICE CLICK CR],0) as [BV WRLS_VOICE CLICK CR]
, isnull(b.[WRLS_VOICE CLICK CR],0) as [WRLS_VOICE CLICK CR]
, isnull(b.[WRLS_VOICE CLICK CR]-a.[BV WRLS_VOICE CLICK CR],0) as [Diff WRLS_VOICE CLICK CR]

--actual sales percents for actual CRs

,isnull(isnull([UVTV CALL CR],0)/nullif([STRAT CALL CR],0),0) as [% UVTV CALL]
,isnull(isnull([HSIA CALL CR],0)/nullif([STRAT CALL CR],0),0) as [% HSIA CALL]
,isnull(isnull([VOIP CALL CR],0)/nullif([STRAT CALL CR],0),0) as [% VOIP CALL]
,isnull(isnull([DSLREG CALL CR],0)/nullif([STRAT CALL CR],0),0) as [% DSLREG CALL]
,isnull(isnull([DSLDRY CALL CR],0)/nullif([STRAT CALL CR],0),0) as [% DSLDRY CALL]
,isnull(isnull([IPDSL CALL CR],0)/nullif([STRAT CALL CR],0),0) as [% IPDSL CALL]
,isnull(isnull([ACCL CALL CR],0)/nullif([STRAT CALL CR],0),0) as [% ACCL CALL]
,isnull(isnull([DIRECTV CALL CR],0)/nullif([STRAT CALL CR],0),0) as [% DIRECTV CALL]
,isnull(isnull([WRLS_FAM CALL CR],0)/nullif([STRAT CALL CR],0),0) as [% WRLS_FAM CALL]
,isnull(isnull([WRLS_DATA CALL CR],0)/nullif([STRAT CALL CR],0),0) as [% WRLS_DATA CALL]
,isnull(isnull([WRLS_VOICE CALL CR],0)/nullif([STRAT CALL CR],0),0) as [% WRLS_VOICE CALL]

,isnull(isnull([UVTV CLICK CR],0)/nullif([STRAT CLICK CR],0),0) as [% UVTV CLICK]
,isnull(isnull([HSIA CLICK CR],0)/nullif([STRAT CLICK CR],0),0) as [% HSIA CLICK]
,isnull(isnull([VOIP CLICK CR],0)/nullif([STRAT CLICK CR],0),0) as [% VOIP CLICK]
,isnull(isnull([DSLREG CLICK CR],0)/nullif([STRAT CLICK CR],0),0) as [% DSLREG CLICK]
,isnull(isnull([DSLDRY CLICK CR],0)/nullif([STRAT CLICK CR],0),0) as [% DSLDRY CLICK]
,isnull(isnull([IPDSL CLICK CR],0)/nullif([STRAT CLICK CR],0),0) as [% IPDSL CLICK]
,isnull(isnull([ACCL CLICK CR],0)/nullif([STRAT CLICK CR],0),0) as [% ACCL CLICK]
,isnull(isnull([DIRECTV CLICK CR],0)/nullif([STRAT CLICK CR],0),0) as [% DIRECTV CLICK]
,isnull(isnull([WRLS_FAM CLICK CR],0)/nullif([STRAT CLICK CR],0),0) as [% WRLS_FAM CLICK]
,isnull(isnull([WRLS_DATA CLICK CR],0)/nullif([STRAT CLICK CR],0),0) as [% WRLS_DATA CLICK]
,isnull(isnull([WRLS_VOICE CLICK CR],0)/nullif([STRAT CLICK CR],0),0) as [% WRLS_VOICE CLICK]

--current BV sales percents for actual CRs

,isnull(isnull([BV UVTV CALL CR],0)/nullif([BV STRAT CALL CR],0),0) as [BV % UVTV CALL]
,isnull(isnull([BV HSIA CALL CR],0)/nullif([BV STRAT CALL CR],0),0) as [BV % HSIA CALL]
,isnull(isnull([BV VOIP CALL CR],0)/nullif([BV STRAT CALL CR],0),0) as [BV % VOIP CALL]
,isnull(isnull([BV DSLREG CALL CR],0)/nullif([BV STRAT CALL CR],0),0) as [BV % DSLREG CALL]
,isnull(isnull([BV DSLDRY CALL CR],0)/nullif([BV STRAT CALL CR],0),0) as [BV % DSLDRY CALL]
,isnull(isnull([BV IPDSL CALL CR],0)/nullif([BV STRAT CALL CR],0),0) as [BV % IPDSL CALL]
,isnull(isnull([BV ACCL CALL CR],0)/nullif([BV STRAT CALL CR],0),0) as [BV % ACCL CALL]
,isnull(isnull([BV DIRECTV CALL CR],0)/nullif([BV STRAT CALL CR],0),0) as [BV % DIRECTV CALL]
,isnull(isnull([BV WRLS_FAM CALL CR],0)/nullif([BV STRAT CALL CR],0),0) as [BV % WRLS_FAM CALL]
,isnull(isnull([BV WRLS_DATA CALL CR],0)/nullif([BV STRAT CALL CR],0),0) as [BV % WRLS_DATA CALL]
,isnull(isnull([BV WRLS_VOICE CALL CR],0)/nullif([BV STRAT CALL CR],0),0) as [BV % WRLS_VOICE CALL]

,isnull(isnull([BV UVTV CLICK CR],0)/nullif([BV STRAT CLICK CR],0),0) as [BV % UVTV CLICK]
,isnull(isnull([BV HSIA CLICK CR],0)/nullif([BV STRAT CLICK CR],0),0) as [BV % HSIA CLICK]
,isnull(isnull([BV VOIP CLICK CR],0)/nullif([BV STRAT CLICK CR],0),0) as [BV % VOIP CLICK]
,isnull(isnull([BV DSLREG CLICK CR],0)/nullif([BV STRAT CLICK CR],0),0) as [BV % DSLREG CLICK]
,isnull(isnull([BV DSLDRY CLICK CR],0)/nullif([BV STRAT CLICK CR],0),0) as [BV % DSLDRY CLICK]
,isnull(isnull([BV IPDSL CLICK CR],0)/nullif([BV STRAT CLICK CR],0),0) as [BV % IPDSL CLICK]
,isnull(isnull([BV ACCL CLICK CR],0)/nullif([BV STRAT CLICK CR],0),0) as [BV % ACCL CLICK]
,isnull(isnull([BV DIRECTV CLICK CR],0)/nullif([BV STRAT CLICK CR],0),0) as [BV % DIRECTV CLICK]
,isnull(isnull([BV WRLS_FAM CLICK CR],0)/nullif([BV STRAT CLICK CR],0),0) as [BV % WRLS_FAM CLICK]
,isnull(isnull([BV WRLS_DATA CLICK CR],0)/nullif([BV STRAT CLICK CR],0),0) as [BV % WRLS_DATA CLICK]
,isnull(isnull([BV WRLS_VOICE CLICK CR],0)/nullif([BV STRAT CLICK CR],0),0) as [BV % WRLS_VOICE CLICK]
into #Current_BV_AVG_Rates
from #Current_BV_Base_Rates as a 
join #Actual_Rates as b
on a.touch_type_fk=b.touch_type_fk

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
-------END CALCULATE BV AND AVERAGE RATES----------------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
-------START UVAQ MAIN TABLE DATA PULL BY CAMPAIGN--------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

if object_id('tempdb..#CAMPAIGN_DATA') is not null drop table #CAMPAIGN_DATA

select c.Touch_Type_FK
,case when b.id = 255 then 'U-verse Base Acq - DM - Hisp'
	        when (b.id = 51 and a.Campaign_Parent_Name like '%HISP%') then 'U-verse Base Acq - Catalog - Hisp'
	else b.Scorecard_Program_Channel
	end as Scorecard_Program_Channel
,b.id as tactic_id
,a.start_date
,a.End_Date_Traditional
,datediff(ww,start_date,(select b.End_Date 
	from javdb.ireport_2014.dbo.wb_00_reporting_cycle as a 
	join javdb.ireport_2014.dbo.WB_00_Media_Calendar_Weekly as b 
	on a.ReportCycle_YYYYWW=b.ReportWeek_YYYYWW 
	group by b.End_Date)) as [Weeks Tracking]
,a.media_code
,d.Media_Type
,d.Touch_Name
,d.Touch_Name_2
,d.Audience_Type_Name
,d.Program_Owner
,a.parentid
,a.ecrw_project_name
,a.Campaign_Parent_Name
, case when e.tfn_type like '22-state' then 'LT/CCC'
	   when a.parentid in ('821010',	'825250',	'825270',	'830510',	'831410',	'833400', '840110') then 'Hispanic 5 RR' --hispanic catalogs
	   when a.Media_code = 'FYI' and a.Campaign_Parent_Name like '%spanish%' then 'Hispanic 5 RR' --spanish bill messages
	   when a.Media_code = 'FYI' and Touch_Name = 'Wireline' and Touch_Name_2 = 'Bill Message' and tfn_type = 'Hispanic 5 RR' then 'LT/CCC'  --Corrects LT/CCC TFN getting a Hispanic TFN 
	   when e.tfn_type like '9-state' then 'LT/CCC'
	   when e.tfn_type like '13-state' then 'LT/CCC'
	   when a.media_code like 'DM' and e.tfn_type in ('22-state','LT/CCC') 
		and a.Campaign_Parent_Name NOT LIKE '%IRU%' and a.Campaign_Parent_Name not like '%WLN w/ WLS%' 
		and a.Campaign_Parent_Name not like '%WLS+O%'  and a.Campaign_Parent_Name not like '%non wls%' 
		and a.Campaign_Parent_Name not like '%WLS/WLN%' and a.Campaign_Parent_Name not like '%WLN/WLS%' 
		and a.Campaign_Parent_Name not like '%WRLS/WLN%' and a.Campaign_Parent_Name not like '%WLN/WRLS%' 
		and a.Campaign_Parent_Name not like '%(WLN w/ or w/o WLS)%' and a.Campaign_Parent_Name not like '%+ WLS%' 
		and a.Campaign_Parent_Name not like '%WLS +%' and a.Campaign_Parent_Name not like '%nonwls%' 
		and a.Campaign_Parent_Name not like '%nonwrls%' and a.Campaign_Parent_Name not like '%Non-wireless%' 
		and a.Campaign_Parent_Name not like '%w/o wireless%' 
		and (a.Campaign_Parent_Name like '%WLS%' or a.Campaign_Parent_Name like '%WRLS%' or a.Campaign_Parent_Name like '%smartphone%'
			or a.Campaign_Parent_Name like '%wireless only%'or a.Campaign_Parent_Name like '%wireless%') then 'DMDR'
	else e.tfn_type
	end as tfn_type
, case when a.parentid in ('840910', '840920', '840960', '843690', '844180', '839720', '839920', '833120', '840120', '826960','844060','843020')
			then 'PURL'
			end as PURL_Flag
,case when a.Campaign_Parent_Name like ('%IRU%') and a.Campaign_Parent_Name not like ('%non%') then 'IRU'
	  when a.Campaign_Parent_Name like ('%green%') or a.Campaign_Parent_Name like ('%- NG -%') or a.Campaign_Parent_Name like ('%FRESH%')or a.Campaign_Parent_Name like ('%FSH%') then 'NewGreen'
	  when (a.Campaign_Parent_Name like ('%hisp%')  or  a.Campaign_Parent_Name like ('%hsp%')) and a.media_code = 'CA' then 'BL'
	  when a.parentid in ('900270',	'900260',	'943720',	'976020',	'943710',	'943780',	'943790',	'976070',	'976090',	'976060',	'976080', '180431',	'180432',	'180433',	'180434') then 'Account Review SL'
	  when a.Campaign_Parent_Name like ('%tv upsell%') and (a.Campaign_Parent_Name like ('%never%') or a.Campaign_Parent_Name like ('% NH %')) then 'Neverhad'
	  when a.Campaign_Parent_Name like ('%tv upsell%') and (a.Campaign_Parent_Name like ('%win%') or a.Campaign_Parent_Name like ('% WB %')) then 'Winback'
	  when a.Campaign_Parent_Name like ('%tv upsell%') then 'NH and WB'
			else ''
			end as audience
,project = (Touch_Name + ' ' + Touch_Name_2 + ' ' + a.media_code)
      --actuals
     ,sum(isnull(ITP_Quantity_UnApp,0)) as ITP_Quantity_UnApp
     ,sum(isnull(ITP_Budget_UnApp,0)) as ITP_Budget_UnApp
      ,sum(isnull(itp_dir_calls,0)) as calls
      ,sum(isnull(itp_dir_clicks,0)) as clicks
      ,sum(isnull(ITP_Dir_Sales_TS_CING_VOICE_N,0)+
                  isnull(ITP_Dir_Sales_TS_CING_FAMILY_N,0)+
                  isnull(ITP_Dir_Sales_TS_CING_DATA_N,0)+
				  isnull(itp_dir_sales_ts_dish_n,0)+
                  isnull(itp_dir_sales_ts_dsl_reg_n,0)+
                  isnull(itp_dir_sales_ts_dsl_dry_n,0)+
                  isnull(ITP_Dir_Sales_TS_DSL_IP_N,0)+
                  isnull(itp_dir_sales_ts_uvrs_hsia_n,0)+
                  isnull(itp_dir_sales_ts_uvrs_tv_n,0)+
                  isnull(itp_dir_sales_ts_local_accl_n,0)+
                  isnull(itp_dir_sales_ts_uvrs_voip_n,0) ) 
                              as strat_telesales,
        sum(isnull(ITP_Dir_Sales_ON_CING_VOICE_N,0)+
                  isnull(ITP_Dir_Sales_ON_CING_FAMILY_N,0)+
                  isnull(ITP_Dir_Sales_ON_CING_DATA_N,0) +
                  isnull(itp_dir_sales_on_dish_n,0) +
                  isnull(itp_dir_sales_on_dsl_reg_n,0) +
                  isnull(itp_dir_sales_on_dsl_dry_n,0) +
                  isnull(ITP_Dir_Sales_ON_DSL_IP_N,0) +
                  isnull(itp_dir_sales_on_uvrs_hsia_n,0) +
                  isnull(itp_dir_sales_on_uvrs_tv_n,0) +
                  isnull(itp_dir_sales_on_local_accl_n,0) +
                  isnull(itp_dir_sales_on_uvrs_voip_n,0)) 
                              as strat_onlinesales
        ,sum(isnull(ITP_Dir_Sales_TS_CING_VOICE_N,0)) as ITP_Dir_Sales_TS_CING_VOICE_N
        ,sum(isnull(ITP_Dir_Sales_TS_CING_FAMILY_N,0)) as ITP_Dir_Sales_TS_CING_FAMILY_N
        ,sum(isnull(ITP_Dir_Sales_TS_CING_DATA_N,0)) as ITP_Dir_Sales_TS_CING_DATA_N
		,sum(isnull(itp_dir_sales_ts_dish_n,0)) as itp_dir_sales_ts_dish_n
        ,sum(isnull(itp_dir_sales_ts_ld_n,0)) as itp_dir_sales_ts_ld_n
        ,sum(isnull(itp_dir_sales_ts_dsl_reg_n,0)) as itp_dir_sales_ts_dsl_reg_n
        ,sum(isnull(itp_dir_sales_ts_dsl_dry_n,0)) as itp_dir_sales_ts_dsl_dry_n
        ,sum(isnull(ITP_Dir_Sales_TS_DSL_IP_N,0)) as ITP_Dir_Sales_TS_DSL_IP_N
        ,sum(isnull(itp_dir_sales_ts_uvrs_hsia_n,0)) as itp_dir_sales_ts_uvrs_hsia_n
        ,sum(isnull(itp_dir_sales_ts_uvrs_tv_n,0)) as itp_dir_sales_ts_uvrs_tv_n
        ,sum(isnull(itp_dir_sales_ts_local_accl_n,0)) as itp_dir_sales_ts_local_accl_n
        ,sum(isnull(itp_dir_sales_ts_uvrs_voip_n,0)) as itp_dir_sales_ts_uvrs_voip_n
        ,sum(isnull(ITP_Dir_Sales_ON_CING_VOICE_N,0)) as ITP_Dir_Sales_ON_CING_VOICE_N
        ,sum(isnull(ITP_Dir_Sales_ON_CING_FAMILY_N,0)) as ITP_Dir_Sales_ON_CING_FAMILY_N
        ,sum(isnull(ITP_Dir_Sales_ON_CING_DATA_N,0) ) as ITP_Dir_Sales_ON_CING_DATA_N
        ,sum(isnull(itp_dir_sales_on_dish_n,0) ) as itp_dir_sales_on_dish_n
        ,sum(isnull(itp_dir_sales_on_ld_n,0)) as itp_dir_sales_on_ld_n
        ,sum(isnull(itp_dir_sales_on_dsl_reg_n,0)) as itp_dir_sales_on_dsl_reg_n
        ,sum(isnull(itp_dir_sales_on_dsl_dry_n,0)) as itp_dir_sales_on_dsl_dry_n
        ,sum(isnull(ITP_Dir_Sales_ON_DSL_IP_N,0)) as ITP_Dir_Sales_ON_DSL_IP_N
        ,sum(isnull(itp_dir_sales_on_uvrs_hsia_n,0)) as itp_dir_sales_on_uvrs_hsia_n
        ,sum(isnull(itp_dir_sales_on_uvrs_tv_n,0)) as itp_dir_sales_on_uvrs_tv_n
        ,sum(isnull(itp_dir_sales_on_local_accl_n,0)) as itp_dir_sales_on_local_accl_n
        ,sum(isnull(itp_dir_sales_on_uvrs_voip_n,0)) as itp_dir_sales_on_uvrs_voip_n
into #CAMPAIGN_DATA
from javdb.ireport.dbo.IR_Campaign_Data_Weekly_MAIN_2012 as a
	join javdb.ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
      on a.tactic_id=b.id
	join UVAQ.Results.ParentID_Touch_Type_Link as c
	  on a.parentid=c.parentid
	join UVAQ.dbo.[Touch Type Human View] as d
	  on c.Touch_Type_FK=d.Touch_Type_id
	left join (select * from javdb.ireport.dbo.WB_01_TFN_List_eCRW UNION select * from javdb.ireport_2014.dbo.WB_01_TFN_List_eCRW) as e
            on a.parentid=e.parentid
where b.Scorecard_Top_Tab = 'Direct Marketing'
and b.Scorecard_LOB_Tab = 'U-verse'
and b.Scorecard_tab = 'Uverse Base Acq'
and a.reportweek_yyyyww >= @StartMediaWeek
and a.reportweek_yyyyww <= @EndMediaWeek
and a.start_date >= @CampaignStartDate
--and a.End_Date_Traditional <=@CampaignEndDate --only including campaigns that have been tracking for ~10 weeks
and ExcludeFromScorecard  <> 'Y'
and a.parentid not in ('833320','832060','832070') --exclude catalog multi mailer
      and a.parentid not in ('836140','843250') --exclude double counting QR Projects 
      and a.parentid not in ('826150','826160', '830380', '830390', '830400')  --exclude Phone Cards
      and a.parentid not in ('848800',	'848810',	'848820',	'848830',	
							'848840',	'844800',	'844810',	'848870',	
							'844830',	'844840',	'844850',	'850150',	
							'850160',	'850170',	'850180',	'850190',	
							'850200',	'864190',	'873580',	'867920',	
							'867930',	'867940',	'867950',	'867960',	
							'867970',	'867980',	'867990',	'868000',	
							'868010',	'868020',	'868030',	'868040',	
							'868050',	'868470',	'868480',	'868490',	
							'868500',	'868510',	'868520',	'868530',	
							'868540',	'868550',	'868560',	'868570',	
							'868580',	'868590',	'868600',	'876560',
							'848760',	'848770',	'848780',	'848790',	'876570') --exclude all 2012 TV upsell campaigns
and (a.eCRW_project_name not like '%2012 TV upsell%')
group by c.Touch_Type_FK
,b.Scorecard_Program_Channel
,a.start_date
,a.End_Date_Traditional
,a.media_code
,d.Media_Type
,d.Touch_Name
,d.Touch_Name_2
,d.Audience_Type_Name
,d.Program_Owner
,a.Campaign_Parent_Name
,a.parentid
,a.Toll_Free_Numbers
,a.ecrw_project_name
,a.vendor
,b.id
,e.tfn_type
having datediff(ww,start_date,(select b.End_Date 
	from javdb.ireport_2014.dbo.wb_00_reporting_cycle as a 
	join javdb.ireport_2014.dbo.WB_00_Media_Calendar_Weekly as b 
	on a.ReportCycle_YYYYWW=b.ReportWeek_YYYYWW 
	group by b.End_Date))> @weeks_tracking
order by c.Touch_Type_FK
,b.Scorecard_Program_Channel
,a.start_date
,a.End_Date_Traditional
,a.media_code
,d.Media_Type
,d.Touch_Name
,d.Touch_Name_2
,d.Audience_Type_Name
,d.Program_Owner
,a.Campaign_Parent_Name
,a.parentid
,a.ecrw_project_name
,a.vendor
,b.id
,e.tfn_type


----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
-------END UVAQ MAIN TABLE DATA PULL BY CAMPAIGN----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
--------------------------START --------------------------------------------------------------------------------------------------------
------------COMBINE BV_AVG DATA AND CAMPAIGN DATA---------------------------------------------------------------------------------------
-------CREATE TABLE 'UVAQ.Results.UVAQ_Main_Table_Data'---------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

if object_id('UVAQ.Results.UVAQ_Main_Table_Data') is not null drop table UVAQ.Results.UVAQ_Main_Table_Data

SELECT a.[Touch_Type_FK]
      ,a.[Scorecard_Program_Channel]
      ,a.[tactic_id]
      ,a.[start_date]
      ,a.[End_Date_Traditional]
      ,a.[Weeks Tracking]
      ,a.[media_code]
      ,a.[Media_Type]
      ,a.[Touch_Name]
      ,a.[Touch_Name_2]
      ,case when a.[media_code] = 'CA' and a.[Audience_Type_Name] IN ('Wrls Oly', 'Wln Mix') then 'LT'
        else a.[Audience_Type_Name] end as [Audience_Type_Name]
      ,a.[Program_Owner]
      ,a.[parentid]
      ,a.[ecrw_project_name]
      ,a.[Campaign_Parent_Name]
      ,a.[tfn_type]
      ,a.[PURL_Flag]
      ,a.[audience]
      ,a.[project]
      ,a.[ITP_Quantity_UnApp]
      ,a.[ITP_Budget_UnApp]
      ,a.[calls]
      ,a.[clicks]
      ,a.[strat_telesales]
      ,a.[strat_onlinesales]
      ,a.[ITP_Dir_Sales_TS_CING_VOICE_N]
      ,a.[ITP_Dir_Sales_TS_CING_FAMILY_N]
      ,a.[ITP_Dir_Sales_TS_CING_DATA_N]
      ,a.[itp_dir_sales_ts_dish_n]
      ,a.[itp_dir_sales_ts_ld_n]
      ,a.[itp_dir_sales_ts_dsl_reg_n]
      ,a.[itp_dir_sales_ts_dsl_dry_n]
      ,a.[ITP_Dir_Sales_TS_DSL_IP_N]
      ,a.[itp_dir_sales_ts_uvrs_hsia_n]
      ,a.[itp_dir_sales_ts_uvrs_tv_n]
      ,a.[itp_dir_sales_ts_local_accl_n]
      ,a.[itp_dir_sales_ts_uvrs_voip_n]
      ,a.[ITP_Dir_Sales_ON_CING_VOICE_N]
      ,a.[ITP_Dir_Sales_ON_CING_FAMILY_N]
      ,a.[ITP_Dir_Sales_ON_CING_DATA_N]
      ,a.[itp_dir_sales_on_dish_n]
      ,a.[itp_dir_sales_on_ld_n]
      ,a.[itp_dir_sales_on_dsl_reg_n]
      ,a.[itp_dir_sales_on_dsl_dry_n]
      ,a.[ITP_Dir_Sales_ON_DSL_IP_N]
      ,a.[itp_dir_sales_on_uvrs_hsia_n]
      ,a.[itp_dir_sales_on_uvrs_tv_n]
      ,a.[itp_dir_sales_on_local_accl_n]
      ,a.[itp_dir_sales_on_uvrs_voip_n]
      ,b.[BV Call RR] as BV_CALL_RR
	  ,b.[Call RR] as ACT_CALL_RR
	  ,b.[BV CLICK RR] as BV_CLICK_RR
	  ,b.[CLICK RR] as ACT_CLICK_RR
,b. [BV UVTV CALL CR] as BV_TV_Call_CR
,b. [BV HSIA CALL CR] as BV_HSIA_Call_CR
,b. [BV VOIP CALL CR] as BV_Voip_Call_CR
,b. [BV DSLREG CALL CR] as BV_DSL_LS_Call_CR
,b. [BV DSLDRY CALL CR] as BV_DSL_Dir_Call_CR
,b. [BV IPDSL CALL CR] as BV_IPDSL_Call_CR
,b. [BV ACCL CALL CR] as BV_ACCL_Call_CR
,b. [BV DIRECTV CALL CR] as BV_DTV_Call_CR
,b. [BV WRLS_FAM CALL CR] as BV_WLS_FAM_Call_CR
,b. [BV WRLS_DATA CALL CR] as BV_WLS_Data_Call_CR
,b. [BV WRLS_VOICE CALL CR] as BV_WLS_Voice_Call_CR
,b. [UVTV CALL CR] as Avg_TV_Call_CR
,b. [HSIA CALL CR] as Avg_HSIA_Call_CR
,b. [VOIP CALL CR] as Avg_Voip_Call_CR
,b. [DSLREG CALL CR] as Avg_DSL_LS_Call_CR
,b. [DSLDRY CALL CR] as Avg_DSL_Dir_Call_CR
,b. [IPDSL CALL CR] as Avg_IPDSL_Call_CR
,b. [ACCL CALL CR] as Avg_ACCL_Call_CR
,b. [DIRECTV CALL CR] as Avg_DTV_Call_CR
,b. [WRLS_FAM CALL CR] as Avg_WLS_FAM_Call_CR
,b. [WRLS_DATA CALL CR] as Avg_WLS_Data_Call_CR
,b. [WRLS_VOICE CALL CR] as Avg_WLS_Voice_Call_CR
,b. [BV UVTV CLICK CR] as BV_TV_Click_CR
,b. [BV HSIA CLICK CR] as BV_HSIA_Click_CR
,b. [BV VOIP CLICK CR] as BV_Voip_Click_CR
,b. [BV DSLREG CLICK CR] as BV_DSL_LS_Click_CR
,b. [BV DSLDRY CLICK CR] as BV_DSL_Dir_Click_CR
,b. [BV IPDSL CLICK CR] as BV_IPDSL_Click_CR
,b. [BV ACCL CLICK CR] as BV_ACCL_Click_CR
,b. [BV DIRECTV CLICK CR] as BV_DTV_Click_CR
,b. [BV WRLS_FAM CLICK CR] as BV_WLS_FAM_Click_CR
,b. [BV WRLS_DATA CLICK CR] as BV_WLS_Data_Click_CR
,b. [BV WRLS_VOICE CLICK CR] as BV_WLS_Voice_Click_CR
,b. [UVTV CLICK CR] as Avg_TV_Click_CR
,b. [HSIA CLICK CR] as Avg_HSIA_Click_CR
,b. [VOIP CLICK CR] as Avg_Voip_Click_CR
,b. [DSLREG CLICK CR] as Avg_DSL_LS_Click_CR
,b. [DSLDRY CLICK CR] as Avg_DSL_Dir_Click_CR
,b. [IPDSL CLICK CR] as Avg_IPDSL_Click_CR
,b. [ACCL CLICK CR] as Avg_ACCL_Click_CR
,b. [DIRECTV CLICK CR] as Avg_DTV_Click_CR
,b. [WRLS_FAM CLICK CR] as Avg_WLS_FAM_Click_CR
,b. [WRLS_DATA CLICK CR] as Avg_WLS_Data_Click_CR
,b. [WRLS_VOICE CLICK CR] as Avg_WLS_Voice_Click_CR


into UVAQ.Results.UVAQ_Main_Table_Data
  FROM #CAMPAIGN_DATA as a
		left join 
	   #Current_BV_AVG_Rates as b
	    on
	   a.[Touch_Type_FK] = b.[Touch_Type_FK]




