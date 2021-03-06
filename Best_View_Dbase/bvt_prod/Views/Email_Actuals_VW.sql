USE [UVAQ]
GO

/****** Object:  View [bvt_prod].[Email_Actuals_VW]    Script Date: 05/05/2016 11:19:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [bvt_prod].[Email_Actuals_VW]

	AS	SELECT IR_Campaign_Data_Weekly_MAIN_2012_Sbset.Parentid, idFlight_Plan_Records_FK, [Report_Year], [Report_Week], IR_Campaign_Data_Weekly_MAIN_2012_Sbset.[Calendar_Year]
		, IR_Campaign_Data_Weekly_MAIN_2012_Sbset.[Calendar_Month], [Start_Date], [End_Date_Traditional], IR_Campaign_Data_Weekly_MAIN_2012_Sbset.[Campaign_Name], [eCRW_Project_Name]
	    , [media_code], [Toll_Free_Numbers] , [URL_List] , [CTD_Quantity], [ITP_Quantity], [ITP_Quantity_Unapp] ,[CTD_Budget], [ITP_Budget]
		, isnull([ITP_Dir_Calls],0) as [ITP_Dir_Calls], isnull([ITP_Dir_Calls_BH],0) as [ITP_Dir_Calls_BH], isnull([ITP_Dir_Clicks],0) as [ITP_Dir_Clicks]
		, isnull([ITP_Dir_Sales_TS_CING_N],0) as [ITP_Dir_Sales_TS_CING_N], isnull([ITP_Dir_Sales_TS_CING_VOICE_N],0) as [ITP_Dir_Sales_TS_CING_VOICE_N]
		, isnull([ITP_Dir_Sales_TS_CING_FAMILY_N],0) as [ITP_Dir_Sales_TS_CING_FAMILY_N], isnull([ITP_Dir_Sales_TS_CING_DATA_N],0) as [ITP_Dir_Sales_TS_CING_DATA_N]
		, isnull([ITP_Dir_Sales_TS_DISH_N],0) as [Itp_Dir_Sales_TS_DISH_N], isnull([ITP_Dir_Sales_TS_LD_N],0) as [ITP_Dir_Sales_TS_LD_N]
		, isnull([ITP_Dir_Sales_TS_DSL_REG_N],0) as [ITP_Dir_Sales_TS_DSL_REG_N], isnull([ITP_Dir_Sales_TS_DSL_DRY_N],0) as [ITP_Dir_Sales_TS_DSL_DRY_N]
		, isnull([ITP_Dir_Sales_TS_DSL_IP_N],0) as [ITP_Dir_Sales_TS_DSL_IP_N], isnull([ITP_Dir_Sales_TS_UVRS_HSIA_N],0) as [ITP_Dir_Sales_TS_UVRS_HSIA_N]
		, isnull([ITP_Dir_Sales_TS_UVRS_HSIAG_N],0) as [ITP_Dir_Sales_TS_UVRS_HSIAG_N]
		, isnull([ITP_Dir_Sales_TS_UVRS_TV_N],0) as [ITP_Dir_Sales_TS_UVRS_TV_N], isnull([ITP_Dir_Sales_TS_UVRS_BOLT_N],0) as [ITP_Dir_Sales_TS_UVRS_BOLT_N]
		, isnull([ITP_Dir_Sales_TS_LOCAL_ACCL_N],0) as [ITP_Dir_Sales_TS_LOCAL_ACCL_N], isnull([ITP_Dir_Sales_TS_UVRS_VOIP_N],0) as [ITP_Dir_Sales_TS_UVRS_VOIP_N]
		, isnull([ITP_Dir_Sales_TS_CTECH_N],0) as [ITP_Dir_Sales_TS_CTECH_N], isnull([ITP_Dir_Sales_TS_DLIFE_N],0) as [ITP_Dir_Sales_TS_DLIFE_N]
		, isnull([ITP_Dir_sales_TS_CING_WHP_N],0) as [ITP_Dir_sales_TS_CING_WHP_N], isnull([ITP_Dir_Sales_TS_Migrations],0) as [ITP_Dir_Sales_TS_Migrations]
		, isnull([ITP_Dir_Sales_ON_CING_N],0) as [ITP_Dir_Sales_ON_CING_N], isnull([ITP_Dir_Sales_ON_CING_VOICE_N],0) as [ITP_Dir_Sales_ON_CING_VOICE_N]
		, isnull([ITP_Dir_Sales_ON_CING_FAMILY_N],0) as [ITP_Dir_Sales_ON_CING_FAMILY_N], isnull([ITP_Dir_Sales_ON_CING_DATA_N],0) as [ITP_Dir_Sales_ON_CING_DATA_N]
		, isnull([ITP_Dir_Sales_ON_DISH_N],0) as [ITP_Dir_Sales_ON_DISH_N], isnull([ITP_Dir_Sales_ON_LD_N],0) as [ITP_Dir_Sales_ON_LD_N]
		, isnull([ITP_Dir_Sales_ON_DSL_REG_N],0) as [ITP_Dir_Sales_ON_DSL_REG_N], isnull([ITP_Dir_Sales_ON_DSL_DRY_N],0) as [ITP_Dir_Sales_ON_DSL_DRY_N]
		, isnull([ITP_Dir_Sales_ON_DSL_IP_N],0) as [ITP_Dir_Sales_ON_DSL_IP_N], isnull([ITP_Dir_Sales_ON_UVRS_HSIA_N],0) as [ITP_Dir_Sales_ON_UVRS_HSIA_N]
		, isnull([ITP_Dir_Sales_ON_UVRS_HSIAG_N],0) as [ITP_Dir_Sales_ON_UVRS_HSIAG_N]
		, isnull([ITP_Dir_Sales_ON_UVRS_TV_N],0) as [ITP_Dir_Sales_ON_UVRS_TV_N], isnull([ITP_Dir_Sales_ON_UVRS_BOLT_N],0) as [ITP_Dir_Sales_ON_UVRS_BOLT_N]
		, isnull([ITP_Dir_Sales_ON_LOCAL_ACCL_N],0) as [ITP_Dir_Sales_ON_LOCAL_ACCL_N], isnull([ITP_Dir_Sales_ON_UVRS_VOIP_N],0) as [ITP_Dir_Sales_ON_UVRS_VOIP_N]
		, isnull([ITP_Dir_Sales_ON_DLIFE_N],0) as [ITP_Dir_Sales_ON_DLIFE_N], isnull([ITP_Dir_Sales_ON_CING_WHP_N],0) as [ITP_Dir_Sales_ON_CING_WHP_N]
		, isnull([ITP_Dir_Sales_ON_Migrations],0) as [ITP_Dir_Sales_ON_Migrations], ISNULL(DTV_Now_Sales,0) as [ITP_Dir_Sales_ON_DTVNOW_N]
		
		from from_javdb.IR_Campaign_Data_Weekly_MAIN_2012_Sbset

		inner join 
		
		[bvt_prod].[Email_Flight_Plan_VW] as fltpln
		

		---linking fields
		on IR_Campaign_Data_Weekly_MAIN_2012_Sbset.idFlight_Plan_Records_FK= fltpln.idFlight_Plan_Records
		
		LEFT JOIN 
		
		(Select parentID, SUM(Daily_Sales) as DTV_Now_Sales, b.ISO_Week, ISO_Week_Year, MONTH(a.Date) as Calendar_Month, YEAR(a.Date) as Calendar_Year
			from (
			Select a.eCRW_Project_Name, b.parentID, a.Date, a.[Online Sales]*b.Cell_Percent as Daily_Sales 
			from bvt_processed.DTV_Now_Sales_by_day a
			JOIN  bvt_prod.DTV_Now_Sales_App_VW b
				on a.eCRW_Cell_ID = b.ecrw_Cell_ID
			UNION ALL
			Select a.eCRW_Project_Name, b.parentID, a.Date, a.[Online Sales]*b.Cell_Percent as Daily_Sales from 
				(Select * from bvt_processed.DTV_Now_Sales_by_day
				where eCRW_Cell_ID is null) a
				JOIN  (Select * from bvt_prod.DTV_Now_Sales_App_VW
				where Cell_percent <> 1) b
				on a.eCRW_Project_Name = b.eCRW_Project_Name
				where a.eCRW_Cell_ID is null) a
				JOIN dim.Media_Calendar_Daily b
				on a.Date = b.Date
			GROUP BY parentID, ISO_Week, ISO_Week_Year, MONTH(a.Date), YEAR(a.Date)) DTV_Now
			ON IR_Campaign_Data_Weekly_MAIN_2012_Sbset.Parentid = DTV_Now.parentID
				and IR_Campaign_Data_Weekly_MAIN_2012_Sbset.Report_Week = DTV_Now.ISO_Week
				and IR_Campaign_Data_Weekly_MAIN_2012_Sbset.Calendar_Month = DTV_Now.Calendar_Month
				and IR_Campaign_Data_Weekly_MAIN_2012_Sbset.Report_Year = DTV_Now.ISO_Week_Year
						
		where ExcludefromScorecard = 'N'

GO


