

CREATE procedure [Forecasting].[UPRO_actuals]
as
--actual data from main table for UPRO
if object_id('tempdb..#UPROcampaignsweekly') is not null drop table #UPROcampaignsweekly
select 
c.Month_Long
,a.reportweek_YYYYWW
,b.Scorecard_Program_Channel
,case when b.Scorecard_Program_Channel = 'U-verse Prospect - Catalog' then 'Catalog'
	when b.Scorecard_Program_Channel = 'U-verse Prospect - DM' and 
		(eCRW_project_name like '%catalog%'
		or campaign_parent_name like '%catalog%'
		) then 'Catalog'
	when b.Scorecard_Program_Channel = 'U-verse Prospect - DM' then 'Direct Mail' 
	when b.Scorecard_Program_Channel = 'U-verse Prospect - Doorhanger' then 'Direct Mail' 
	when (b.Scorecard_Program_Channel = 'U-verse Prospect - Direct Digital' OR b.Scorecard_Program_Channel like '%mobile%') then 'Direct Digital' 
	when b.Scorecard_Program_Channel = 'U-verse Prospect - Program Level' then 'Total' 
	else 'update'
	end as [Media]
,case when b.Scorecard_Program_Channel = 'U-verse Prospect - Catalog' then 'Catalog'
	when b.Scorecard_Program_Channel = 'U-verse Prospect - DM' and 
		(eCRW_project_name like '%catalog%'
		or campaign_parent_name like '%catalog%'
		) then 'Catalog'
	when (b.Scorecard_Program_Channel = 'U-verse Prospect - Direct Digital' OR b.Scorecard_Program_Channel like '%mobile%') then 'Direct Digital' 
	when b.Scorecard_Program_Channel = 'U-verse Prospect - Program Level' then 'Total'
	when b.Scorecard_Program_Channel = 'U-verse Prospect - DM' and 
		(eCRW_project_name like '%new green%'
		or eCRW_project_name like '%newgreen%'
		) then 'New Green'
	when b.Scorecard_Program_Channel = 'U-verse Prospect - DM' and 
		(eCRW_project_name like '%recontact%' 
			or eCRW_project_name like '%resp%'
			or eCRW_project_name like '%upward%'
			or eCRW_project_name like '%winback%'
			or eCRW_project_name like '%disconnect%'
				)then 'Triggers' 
	when b.Scorecard_Program_Channel = 'U-verse Prospect - DM' and 
			(eCRW_project_name like '%Door%' 
			or eCRW_project_name like '%OEC%'
			or eCRW_project_name like '%BAU%'
			) then 'Core Touch 1'
	when b.Scorecard_Program_Channel = 'U-verse Prospect - DM' and 
		(eCRW_project_name like '%OV%' 
		 )then 'Core T2 Overlay'
	else 'Core Touch 1'
	end as [Program]
,ecrw_project_name
,campaign_parent_name
,parentid
--actuals
,sum(isnull(ITP_Budget_UnApp,0)) as Actual_Project_Budget
,sum(isnull(ITP_quantity_UnApp,0)) as Actual_Project_Volume
,sum(isnull(ITP_Dir_Calls,0)) as Actual_Calls
,sum(isnull(ITP_Dir_Clicks,0)) as Actual_Clicks
,sum(isnull(ITP_Dir_Sales_TS_CING_VOICE_N,0)) as  Actual_Call_Wrls_Voice_Sales
,sum(isnull(ITP_Dir_Sales_TS_CING_FAMILY_N,0)) as Actual_Call_WRLS_Family_Sales
,sum(isnull(ITP_Dir_Sales_TS_CING_DATA_N,0)) as  Actual_Call_WRLS_Data_Sales
,sum(isnull(ITP_Dir_Sales_TS_DISH_N,0)) as Actual_CALL_Dish_Sales
,sum(isnull(ITP_Dir_Sales_TS_DSL_REG_N,0)) as Actual_Call_DSL_Reg_Sales
,sum(isnull(ITP_Dir_Sales_TS_DSL_DRY_N,0)) as Actual_Call_DSL_Dry_Sales
,sum(isnull(ITP_Dir_Sales_TS_DSL_IP_N,0)) as Actual_Call_IPDSL_Sales
,sum(isnull(ITP_Dir_Sales_TS_UVRS_HSIA_N,0)) as Actual_Call_HSIA_Sales
,sum(isnull(ITP_Dir_Sales_TS_UVRS_TV_N,0)) as Actual_Call_TV_Sales
,sum(isnull(ITP_Dir_Sales_TS_LOCAL_ACCL_N,0)) as Actual_CALL_Access_Sales
,sum(isnull(ITP_Dir_Sales_TS_UVRS_VOIP_N,0)) as Actual_Call_VOIP_Sales
,sum(isnull(ITP_Dir_Sales_ON_CING_VOICE_N,0)) as Actual_ONLINE_Wrls_Voice_Sales
,sum(isnull(ITP_Dir_Sales_ON_CING_FAMILY_N,0)) as Actual_ONLINE_WRLS_Family_Sales
,sum(isnull(ITP_Dir_Sales_ON_CING_DATA_N,0)) as Actual_ONLINE_WRLS_Data_Sales
,sum(isnull(ITP_Dir_Sales_ON_DISH_N,0)) as Actual_ONLINE_Dish_Sales
,sum(isnull(ITP_Dir_Sales_ON_DSL_REG_N,0)) as Actual_ONLINE_DSL_Reg_Sales
,sum(isnull(ITP_Dir_Sales_ON_DSL_DRY_N,0)) as Actual_ONLINE_DSL_Dry_Sales
,sum(isnull(ITP_Dir_Sales_ON_DSL_IP_N,0)) as Actual_ONLINE_IPDSL_Sales
,sum(isnull(ITP_Dir_Sales_ON_UVRS_HSIA_N,0)) as Actual_ONLINE_HSIA_Sales
,sum(isnull(ITP_Dir_Sales_ON_UVRS_TV_N,0)) as Actual_ONLINE_TV_Sales
,sum(isnull(ITP_Dir_Sales_ON_UVRS_VOIP_N,0)) as Actual_ONLINE_VOIP_Sales
,sum(isnull(ITP_Dir_Sales_ON_LOCAL_ACCL_N,0)) as Actual_ONLINE_Access_Sales
into #UPROcampaignsweekly
 from javdb.ireport.dbo.IR_Camp_Data_Weekly_MAIN_2012 as a 
	join javdb.ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
	on a.tactic_id = b.id
	join dim.Media_Calendar as c
	on a.reportweek_YYYYWW=c.ISO_Week_YYYYWW
where 
a.report_year in (2014)
and campaign_name not like '%commitment%'
and campaign_name not like '%objective%'
and b.Scorecard_Top_Tab = 'Direct Marketing'
and b.Scorecard_LOB_Tab = 'U-verse'
and b.Scorecard_tab = 'Uverse'
and b.Scorecard_Program_Channel like '%Prospect%'
--and excludefromscorecard <> 'Y'
group by c.Month_Long
,a.reportweek_YYYYWW
,b.Scorecard_Program_Channel
,ecrw_project_name
,campaign_parent_name
,parentid
order by  c.Month_Long
,a.reportweek_YYYYWW
,b.Scorecard_Program_Channel
,ecrw_project_name
,campaign_parent_name
,parentid



if object_id('forecasting.UV_Prospect_2014_Actuals') is not null drop table forecasting.UV_Prospect_2014_Actuals
select Month_Long
,reportweek_YYYYWW
,program
,media
, sum(isnull(Actual_Project_Budget,0)) as Actual_Project_Budget
, sum(isnull(Actual_Project_Volume,0)) as Actual_Project_Volume
, sum(isnull(Actual_Calls,0)) as Actual_Calls
, sum(isnull(Actual_Clicks,0)) as Actual_Clicks
, sum(isnull(Actual_Call_Wrls_Voice_Sales,0)) as Actual_Call_Wrls_Voice_Sales
, sum(isnull(Actual_Call_WRLS_Family_Sales,0)) as Actual_Call_WRLS_Family_Sales
, sum(isnull(Actual_Call_WRLS_Data_Sales,0)) as Actual_Call_WRLS_Data_Sales
, sum(isnull(Actual_CALL_Dish_Sales,0)) as Actual_CALL_Dish_Sales
, sum(isnull(Actual_Call_DSL_Reg_Sales,0)) as Actual_Call_DSL_Reg_Sales
, sum(isnull(Actual_Call_DSL_Dry_Sales,0)) as Actual_Call_DSL_Dry_Sales
, sum(isnull(Actual_Call_IPDSL_Sales,0)) as Actual_Call_IPDSL_Sales
, sum(isnull(Actual_Call_HSIA_Sales,0)) as Actual_Call_HSIA_Sales
, sum(isnull(Actual_Call_TV_Sales,0)) as Actual_Call_TV_Sales
, sum(isnull(Actual_CALL_Access_Sales,0)) as Actual_CALL_Access_Sales
, sum(isnull(Actual_Call_VOIP_Sales,0)) as Actual_Call_VOIP_Sales
, sum(isnull(Actual_ONLINE_Wrls_Voice_Sales,0)) as Actual_ONLINE_Wrls_Voice_Sales
, sum(isnull(Actual_ONLINE_WRLS_Family_Sales,0)) as Actual_ONLINE_WRLS_Family_Sales
, sum(isnull(Actual_ONLINE_WRLS_Data_Sales,0)) as Actual_ONLINE_WRLS_Data_Sales
, sum(isnull(Actual_ONLINE_Dish_Sales,0)) as Actual_ONLINE_Dish_Sales
, sum(isnull(Actual_ONLINE_DSL_Reg_Sales,0)) as Actual_ONLINE_DSL_Reg_Sales
, sum(isnull(Actual_ONLINE_DSL_Dry_Sales,0)) as Actual_ONLINE_DSL_Dry_Sales
, sum(isnull(Actual_ONLINE_IPDSL_Sales,0)) as Actual_ONLINE_IPDSL_Sales
, sum(isnull(Actual_ONLINE_HSIA_Sales,0)) as Actual_ONLINE_HSIA_Sales
, sum(isnull(Actual_ONLINE_TV_Sales,0)) as Actual_ONLINE_TV_Sales
, sum(isnull(Actual_ONLINE_VOIP_Sales,0)) as Actual_ONLINE_VOIP_Sales
, sum(isnull(Actual_ONLINE_Access_Sales,0)) as Actual_ONLINE_Access_Sales
into forecasting.UV_Prospect_2014_Actuals
from #UPROcampaignsweekly
group by Month_Long
,reportweek_YYYYWW
,program
,media

if object_id('Forecasting.UV_Prospect_2014_Campaigns') is not null drop table Forecasting.UV_Prospect_2014_Campaigns
select Media
, PROGRAM
, eCRW_project_name as [Campaign Name]
, campaign_parent_name as [Cell Name]
into Forecasting.UV_Prospect_2014_Campaigns
from #UPROcampaignsweekly
group by Media
, PROGRAM
, eCRW_project_name
, campaign_parent_name


