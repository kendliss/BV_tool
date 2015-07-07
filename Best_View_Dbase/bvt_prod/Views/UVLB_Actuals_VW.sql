drop view [bvt_prod].[UVLB_Actuals_VW]
go

CREATE VIEW [bvt_prod].[UVLB_Actuals_VW]

	AS	select Parentid, idFlight_Plan_Records_FK, [Report_Year], [Report_Week], [Start_Date], [End_Date_Traditional], IR_Campaign_Data_Weekly_MAIN_2012_Sbset.[Campaign_Name], [media_code]
		, [Toll_Free_Numbers] , [URL_List] , [CTD_Quantity], [CTD_Budget]
		, [ITP_Dir_Calls], [ITP_Dir_Calls_BH], [ITP_Dir_Clicks], [ITP_Dir_Sales_TS_CING_N], [ITP_Dir_Sales_TS_CING_VOICE_N], [ITP_Dir_Sales_TS_CING_FAMILY_N]
		, [ITP_Dir_Sales_TS_CING_DATA_N], [ITP_Dir_Sales_TS_DISH_N], [ITP_Dir_Sales_TS_LD_N], [ITP_Dir_Sales_TS_DSL_REG_N], [ITP_Dir_Sales_TS_DSL_DRY_N]
		, [ITP_Dir_Sales_TS_DSL_IP_N], [ITP_Dir_Sales_TS_UVRS_HSIA_N], [ITP_Dir_Sales_TS_UVRS_TV_N], [ITP_Dir_Sales_TS_UVRS_BOLT_N], [ITP_Dir_Sales_TS_LOCAL_ACCL_N]
		, [ITP_Dir_Sales_TS_UVRS_VOIP_N], [ITP_Dir_Sales_TS_CTECH_N], [ITP_Dir_Sales_TS_DLIFE_N], [ITP_Dir_sales_TS_CING_WHP_N], [ITP_Dir_Sales_TS_Migrations]
		, [ITP_Dir_Sales_ON_CING_N], [ITP_Dir_Sales_ON_CING_VOICE_N], [ITP_Dir_Sales_ON_CING_FAMILY_N], [ITP_Dir_Sales_ON_CING_DATA_N], [ITP_Dir_Sales_ON_DISH_N]
		, [ITP_Dir_Sales_ON_LD_N], [ITP_Dir_Sales_ON_DSL_REG_N], [ITP_Dir_Sales_ON_DSL_DRY_N], [ITP_Dir_Sales_ON_DSL_IP_N], [ITP_Dir_Sales_ON_UVRS_HSIA_N], [ITP_Dir_Sales_ON_UVRS_TV_N]
		, [ITP_Dir_Sales_ON_UVRS_BOLT_N], [ITP_Dir_Sales_ON_LOCAL_ACCL_N], [ITP_Dir_Sales_ON_UVRS_VOIP_N], [ITP_Dir_Sales_ON_DLIFE_N], [ITP_Dir_Sales_ON_CING_WHP_N]
		, [ITP_Dir_Sales_ON_Migrations]
		from from_javdb.IR_Campaign_Data_Weekly_MAIN_2012_Sbset

		inner join 
		
		[bvt_processed].[UVLB_Flight_Plan] as fltpln
		

		---linking fields
		on IR_Campaign_Data_Weekly_MAIN_2012_Sbset.idFlight_Plan_Records_FK= fltpln.idFlight_Plan_Records
