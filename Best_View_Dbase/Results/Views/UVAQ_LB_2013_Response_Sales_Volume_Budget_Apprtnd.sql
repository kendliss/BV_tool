
create view Results.UVAQ_LB_2013_Response_Sales_Volume_Budget_Apprtnd
as select 
--Summary Variables
B.ParentID, B.Touch_Type_FK,Report_Week,Report_Year,CTD_Start_Date as [Start_Date], Media_Code as Media_Type,

SUM(ITP_Budget) as Budget, 
sum(ITP_Quantity) as Volume,
MAX(ITP_Budget_UnAPP) as Actual_Budget,
MAX(ITP_Quantity_UnApp) as Actual_Volume,
--Response

SUM(ITP_Dir_Calls) as Calls, SUM(ITP_Dir_Clicks) as Clicks, 
--Sales
SUM(ITP_Dir_Sales_TS_CING_N) as Wireless_Call_Sales,SUM(ITP_Dir_Sales_ON_CING_N) as Wireless_Click_Sales,
SUM(ITP_Dir_Sales_TS_CING_VOICE_N) as Wireless_Voice_Call_Sales,sum(ITP_Dir_Sales_ON_CING_VOICE_N) as Wireless_Voice_Click_Sales,
SUM(ITP_Dir_Sales_TS_CING_FAMILY_N) as Wireless_Family_Call_Sales,sum(ITP_Dir_Sales_TS_CING_FAMILY_N) as Wireless_Family_Click_Sales,
SUM(ITP_Dir_Sales_TS_CING_DATA_N) as Wireless_Data_Call_Sales,sum(ITP_Dir_Sales_TS_CING_DATA_N) as Wireless_Data_Click_Sales,
SUM(ITP_Dir_Sales_TS_DISH_N) as DirectTV_Call_Sales,SUM(ITP_Dir_Sales_ON_DISH_N) as DirectTV_Click_Sales,
SUM(ITP_Dir_Sales_TS_DSL_REG_N) as DSL_Direct_Call_Sales,SUM(ITP_Dir_Sales_ON_DSL_REG_N) as DSL_Direct_Click_Sales,
SUM(ITP_Dir_Sales_TS_DSL_DRY_N) as DSL_Dry_Loop_Call_Sales,SUM(ITP_Dir_Sales_ON_DSL_DRY_N) as DSL_Dry_Loop_Click_Sales,
SUM(ITP_Dir_Sales_TS_DSL_IP_N) as IPDSLAM_Call_Sales,SUM(ITP_Dir_Sales_ON_DSL_IP_N) as IPDSLAM_Click_Sales,
SUM(ITP_Dir_Sales_TS_UVRS_HSIA_N) as HSIA_Call_Sales,SUM(ITP_Dir_Sales_ON_UVRS_HSIA_N) as HSIA_Click_Sales,
SUM(ITP_Dir_Sales_TS_LOCAL_ACCL_N) as Local_Call_Sales,SUM(ITP_Dir_Sales_ON_LOCAL_ACCL_N) as Local_Click_Sales,
SUM(ITP_Dir_Sales_TS_UVRS_VOIP_N) as VOIP_Call_Sales,SUM(ITP_Dir_Sales_ON_UVRS_VOIP_N) as VOIP_Click_Sales,
SUM(ITP_Dir_Sales_TS_UVRS_TV_N) as UVERSE_TV_Call_Sales,SUM(ITP_Dir_Sales_ON_UVRS_TV_N) as UVERSE_TV_Click_Sales

FROM JAVDB.IREPORT.dbo.IR_Campaign_Data_Weekly_MAIN_2012 as A
	INNER JOIN Results.ParentID_Touch_Type_Link as B
	ON A.ParentID=B.ParentID
WHERE Report_Year=2013
GROUP BY B.ParentID, B.Touch_Type_FK, Report_Week, Report_Year, CTD_Start_Date, Media_Code