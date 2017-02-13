USE [UVAQ]
GO
/****** Object:  StoredProcedure [bvt_prod].[Campaign_Data_Weekly_Main_2012_PR]    Script Date: 01/25/2017 13:11:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [bvt_prod].[Campaign_Data_Weekly_Main_2012_PR]
	
AS
	DROP TABLE from_javdb.IR_Campaign_Data_Weekly_MAIN_2012_Sbset;
	
--	INSERT INTO from_javdb.IR_Campaign_Data_Weekly_MAIN_2012_Sbset



select Distinct a.Project_ID, a.Parentid, idFlight_Plan_Records_FK, a.[Report_Year], a.[Report_Week], CAST(LEFT(CalendarMonth_YYYYMM,4) AS INT)  as Calendar_Year,
		CAST(RIGHT(CalendarMonth_YYYYMM,2) AS INT) as Calendar_Month, a.[Start_Date], a.[End_Date_Traditional], a.[eCRW_Project_Name], a.[Campaign_Name]
		, a.[media_code], a.Program, a.[Toll_Free_Numbers], a.[URL_List], a.ExcludefromScorecard, a.[CTD_Quantity], a.[ITP_Quantity], a.[ITP_Quantity_Unapp], a.[CTD_Budget], a.[ITP_Budget]
		, a.[ITP_Dir_Calls], a.[ITP_Dir_Calls_BH], a.[ITP_Dir_Clicks], a.[ITP_Dir_Sales_TS_CING_N], a.[ITP_Dir_Sales_TS_CING_VOICE_N], a.[ITP_Dir_Sales_TS_CING_FAMILY_N]
		, a.[ITP_Dir_Sales_TS_CING_DATA_N], a.[ITP_Dir_Sales_TS_DISH_N], a.[ITP_Dir_Sales_TS_LD_N], a.[ITP_Dir_Sales_TS_DSL_REG_N], a.[ITP_Dir_Sales_TS_DSL_DRY_N]
		, a.[ITP_Dir_Sales_TS_DSL_IP_N], Coalesce(b.[ITP_Dir_Sales_TS_UVRS_HSIA_N], a.[ITP_Dir_Sales_TS_UVRS_HSIA_N],0) as[ITP_Dir_Sales_TS_UVRS_HSIA_N]
		, Coalesce(b.[ITP_Dir_Sales_TS_UVRS_HSIAG_N],0) as[ITP_Dir_Sales_TS_UVRS_HSIAG_N]
		, a.[ITP_Dir_Sales_TS_UVRS_TV_N], a.[ITP_Dir_Sales_TS_UVRS_BOLT_N]
		, a.[ITP_Dir_Sales_TS_LOCAL_ACCL_N], a.[ITP_Dir_Sales_TS_UVRS_VOIP_N], a.[ITP_Dir_Sales_TS_CTECH_N], a.[ITP_Dir_Sales_TS_DLIFE_N], a.[ITP_Dir_sales_TS_CING_WHP_N], a.[ITP_Dir_Sales_TS_Migrations]
		, a.[ITP_Dir_Sales_ON_CING_N], a.[ITP_Dir_Sales_ON_CING_VOICE_N], a.[ITP_Dir_Sales_ON_CING_FAMILY_N], a.[ITP_Dir_Sales_ON_CING_DATA_N], a.[ITP_Dir_Sales_ON_DISH_N]
		, a.[ITP_Dir_Sales_ON_LD_N], a.[ITP_Dir_Sales_ON_DSL_REG_N], a.[ITP_Dir_Sales_ON_DSL_DRY_N], a.[ITP_Dir_Sales_ON_DSL_IP_N]
		, Coalesce(b.[ITP_Dir_Sales_ON_UVRS_HSIA_N], a.[ITP_Dir_Sales_ON_UVRS_HSIA_N],0) as[ITP_Dir_Sales_ON_UVRS_HSIA_N]
		, Coalesce(b.[ITP_Dir_Sales_ON_UVRS_HSIAG_N],0) as[ITP_Dir_Sales_ON_UVRS_HSIAG_N]
		, a.[ITP_Dir_Sales_ON_UVRS_TV_N], a.[ITP_Dir_Sales_ON_UVRS_BOLT_N], a.[ITP_Dir_Sales_ON_LOCAL_ACCL_N], a.[ITP_Dir_Sales_ON_UVRS_VOIP_N], a.[ITP_Dir_Sales_ON_DLIFE_N]
		, a.[ITP_Dir_Sales_ON_CING_WHP_N], a.[ITP_Dir_Sales_ON_Migrations], a.[ITP_Dir_Sales_TS_TOTAL], a.[ITP_Dir_Sales_TS_Strat], a.[ITP_Dir_Sales_ON_TOTAL], a.[ITP_Dir_Sales_ON_Strat]
		, a.[LTV_ITP_DIRECTED], a.[LTV_ITP_TOTAL], a.[LTV_ITP_TS_TOTAL], a.[LTV_ITP_ON_TOTAL]
 INTO from_javdb.IR_Campaign_Data_Weekly_MAIN_2012_Sbset		

from javdb.ireport.[dbo].[vw_IR_Campaign_Data_Weekly_MAIN_CAL] a
	left join (Select parentID, Report_week, Report_Year, CalendarWeek_YYYYWW, [ITP_Dir_Sales_TS_UVRS_HSIA_N], [ITP_Dir_Sales_ON_UVRS_HSIA_N], [ITP_Dir_Sales_TS_UVRS_HSIAG_N], [ITP_Dir_Sales_ON_UVRS_HSIAG_N] 
	from javdb.ireport_2015.dbo.IR_Workbook_Data_2017_Cal
				Where Report_Year = 2017
			UNION  Select parentID, Report_week, Report_Year, CalendarWeek_YYYYWW, [ITP_Dir_Sales_TS_UVRS_HSIA_N], [ITP_Dir_Sales_ON_UVRS_HSIA_N], [ITP_Dir_Sales_TS_UVRS_HSIAG_N], [ITP_Dir_Sales_ON_UVRS_HSIAG_N] 
			 from javdb.ireport_2015.dbo.IR_Workbook_Data_2016_Cal
				Where Report_Year = 2016) b
	on a.parentID = b.parentID and a.Report_Year = b.Report_Year and a.Report_Week = b.Report_Week
	and a.CalendarWeek_YYYYWW = b.CalendarWeek_YYYYWW
		inner join 
		---subquery to get linkage from flightplan records to parent ids
		(SELECT Source_System_id , idFlight_Plan_Records_FK
		from [bvt_prod].Flight_Plan_Records as fltpln
			inner join [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records] as junction
			on fltpln.idFlight_Plan_Records=junction.idFlight_Plan_Records_FK
			inner join [bvt_prod].[External_ID_linkage_TBL] as extrnl
			on junction.idExternal_ID_linkage_TBL_FK=extrnl.idExternal_ID_linkage_TBL
		where idSource_System_LU_FK=1
			and idSource_Field_Name_LU_FK=1
		group by Source_System_ID, idFlight_Plan_Records_FK) as linkage

		---linking fields
		on CAST(a.parentid as Varchar(20))=  linkage.Source_System_id 
RETURN 0

