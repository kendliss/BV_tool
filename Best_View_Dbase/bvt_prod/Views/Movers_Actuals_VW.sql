drop view [bvt_prod].[Movers_Actuals_VW]
go

CREATE VIEW [bvt_prod].[Movers_Actuals_VW]

	AS	select [Report_Year], [Report_Week], [Start_Date], [End_Date_Traditional], [Campaign_Name], [media_code]
		, [Toll_Free_Numbers] , [URL_List] , [CTD_Quantity], [CTD_Budget]
		, [ITP_Dir_Calls], [ITP_Dir_Calls_BH], [ITP_Dir_Clicks], [ITP_Dir_Sales_TS_CING_N], [ITP_Dir_Sales_TS_CING_VOICE_N], [ITP_Dir_Sales_TS_CING_FAMILY_N]
		, [ITP_Dir_Sales_TS_CING_DATA_N], [ITP_Dir_Sales_TS_DISH_N], [ITP_Dir_Sales_TS_LD_N], [ITP_Dir_Sales_TS_DSL_REG_N], [ITP_Dir_Sales_TS_DSL_DRY_N]
		, [ITP_Dir_Sales_TS_DSL_IP_N], [ITP_Dir_Sales_TS_UVRS_HSIA_N], [ITP_Dir_Sales_TS_UVRS_TV_N], [ITP_Dir_Sales_TS_UVRS_BOLT_N], [ITP_Dir_Sales_TS_LOCAL_ACCL_N]
		, [ITP_Dir_Sales_TS_UVRS_VOIP_N], [ITP_Dir_Sales_TS_CTECH_N], [ITP_Dir_Sales_TS_DLIFE_N], [ITP_Dir_sales_TS_CING_WHP_N], [ITP_Dir_Sales_TS_Migrations]
		, [ITP_Dir_Sales_ON_CING_N], [ITP_Dir_Sales_ON_CING_VOICE_N], [ITP_Dir_Sales_ON_CING_FAMILY_N], [ITP_Dir_Sales_ON_CING_DATA_N], [ITP_Dir_Sales_ON_DISH_N]
		, [ITP_Dir_Sales_ON_LD_N], [ITP_Dir_Sales_ON_DSL_REG_N], [ITP_Dir_Sales_ON_DSL_DRY_N], [ITP_Dir_Sales_ON_DSL_IP_N], [ITP_Dir_Sales_ON_UVRS_HSIA_N], [ITP_Dir_Sales_ON_UVRS_TV_N]
		, [ITP_Dir_Sales_ON_UVRS_BOLT_N], [ITP_Dir_Sales_ON_LOCAL_ACCL_N], [ITP_Dir_Sales_ON_UVRS_VOIP_N], [ITP_Dir_Sales_ON_DLIFE_N], [ITP_Dir_Sales_ON_CING_WHP_N]
		, [ITP_Dir_Sales_ON_Migrations]
		from javdb.ireport.[dbo].[IR_Campaign_Data_Weekly_MAIN_2012]

		where parentid in (SELECT Source_System_id 
		from [bvt_processed].[Movers_Flight_Plan] as fltpln
			inner join [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records] as junction
			on fltpln.idFlight_Plan_Records=junction.idFlight_Plan_Records_FK
			inner join [bvt_prod].[External_ID_linkage_TBL] as extrnl
			on junction.idExternal_ID_linkage_TBL_FK=extrnl.idExternal_ID_linkage_TBL
			
		where idSource_System_LU_FK=1
			and idSource_Field_Name_LU_FK=1
		group by Source_System_ID)
