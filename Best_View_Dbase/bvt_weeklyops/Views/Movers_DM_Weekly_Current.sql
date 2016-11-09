

ALTER VIEW [bvt_weeklyops].[Movers_DM_Weekly_Current]
AS
(
SELECT 'Movers DM' as Type,
Media_Year,
Media_Week,
sum(ISNULL([Volume_CV],0)) as [Volume_CV],
sum(ISNULL([Call_CV], 0)) as [Call_CV], 
sum(ISNULL([Online_CV], 0)) as [Online_CV], 
sum(ISNULL([Online_sales_Access Line_CV], 0)+ISNULL([Online_sales_VoIP_CV], 0)+ISNULL([Telesales_Access Line_CV], 0)+ISNULL([Telesales_VoIP_CV], 0)) as Voice_Sales_CV, 
sum(ISNULL([Online_sales_DSL_CV], 0)+ISNULL([Online_sales_DSL Direct_CV], 0)+ISNULL([Telesales_DSL_CV], 0)+ISNULL([Telesales_DSL Direct_CV], 0)) as DSL_Sales_CV, 
sum(ISNULL([Online_sales_HSIA_CV], 0)+ISNULL([Online_sales_IPDSL_CV], 0)+ISNULL([Telesales_HSIA_CV], 0)+ISNULL([Telesales_IPDSL_CV], 0)) as IPBB_Sales_CV, 
sum(ISNULL([Online_sales_DirecTV_CV], 0)+ISNULL([Online_sales_UVTV_CV], 0)+ISNULL([Telesales_DirecTV_CV], 0)+ISNULL([Telesales_UVTV_CV], 0)) as TV_Sales_CV,
sum(ISNULL([Telesales_UVTV_CV], 0)+ISNULL([Online_sales_UVTV_CV], 0)) as IPTV_Sales_CV,
sum(ISNULL([Telesales_DirecTV_CV], 0)+ISNULL([Online_sales_DirecTV_CV], 0)) as DTV_Sales_CV,
sum(ISNULL([Online_sales_WRLS Data_CV], 0)+ISNULL([Online_sales_WRLS Family_CV], 0)+ISNULL([Online_sales_WRLS Voice_CV], 0)+ISNULL([Telesales_WRLS Data_CV], 0)+
ISNULL([Telesales_WRLS Family_CV], 0)+ISNULL([Telesales_WRLS Voice_CV], 0)+ isnull([Online_sales_WRLS Home_CV],0)+ isnull([Telesales_WRLS Home_CV],0)) as WRLS_Sales_CV,
SUM(ISNULL([Online_sales_Access Line_CV], 0)+ISNULL([Online_sales_VoIP_CV], 0)+ISNULL([Telesales_Access Line_CV], 0)+ISNULL([Telesales_VoIP_CV], 0)+
ISNULL([Online_sales_DSL_CV], 0)+ISNULL([Online_sales_DSL Direct_CV], 0)+ISNULL([Telesales_DSL_CV], 0)+ISNULL([Telesales_DSL Direct_CV], 0)+
ISNULL([Online_sales_HSIA_CV], 0)+ISNULL([Online_sales_IPDSL_CV], 0)+ISNULL([Telesales_HSIA_CV], 0)+ISNULL([Telesales_IPDSL_CV], 0)+
ISNULL([Online_sales_DirecTV_CV], 0)+ISNULL([Online_sales_UVTV_CV], 0)+ISNULL([Telesales_DirecTV_CV], 0)+ISNULL([Telesales_UVTV_CV], 0)+
ISNULL([Online_sales_WRLS Data_CV], 0)+ISNULL([Online_sales_WRLS Family_CV], 0)+ISNULL([Online_sales_WRLS Voice_CV], 0)+ISNULL([Telesales_WRLS Data_CV], 0)+
ISNULL([Telesales_WRLS Family_CV], 0)+ISNULL([Telesales_WRLS Voice_CV], 0)+ ISNULL([Online_sales_Digital Life_CV],0)+ ISNULL([Telesales_Digital Life_CV],0)) AS Total_Strat_Sales_CV,
sum(ISNULL([Volume_FV],0)) as [Volume_AV],
sum(ISNULL([Call_AV], 0)) as [Call_AV], 
sum(ISNULL([Online_AV], 0)) as [Online_AV], 
sum(ISNULL([Online_sales_Access Line_AV], 0)+ISNULL([Online_sales_VoIP_AV], 0)+ISNULL([Telesales_Access Line_AV], 0)+ISNULL([Telesales_VoIP_AV], 0)) as Voice_Sales_AV, 
sum(ISNULL([Online_sales_DSL_AV], 0)+ISNULL([Online_sales_DSL Direct_AV], 0)+ISNULL([Telesales_DSL_AV], 0)+ISNULL([Telesales_DSL Direct_AV], 0)) as DSL_Sales_AV, 
sum(ISNULL([Online_sales_HSIA_AV], 0)+ISNULL([Online_sales_IPDSL_AV], 0)+ISNULL([Telesales_HSIA_AV], 0)+ISNULL([Telesales_IPDSL_AV], 0)) as IPBB_Sales_AV, 
sum(ISNULL([Online_sales_DirecTV_AV], 0)+ISNULL([Online_sales_UVTV_AV], 0)+ISNULL([Telesales_DirecTV_AV], 0)+ISNULL([Telesales_UVTV_AV], 0)) as TV_Sales_AV,
sum(ISNULL([Telesales_UVTV_AV], 0)+ISNULL([Online_sales_UVTV_AV], 0)) as IPTV_Sales_AV,
sum(ISNULL([Telesales_DirecTV_AV], 0)+ISNULL([Online_sales_DirecTV_AV], 0)) as DTV_Sales_AV,
sum(ISNULL([Online_sales_WRLS Data_AV], 0)+ISNULL([Online_sales_WRLS Family_AV], 0)+ISNULL([Online_sales_WRLS Voice_AV], 0)+ISNULL([Telesales_WRLS Data_AV], 0)+
ISNULL([Telesales_WRLS Family_AV], 0)+ISNULL([Telesales_WRLS Voice_AV], 0)+ isnull([Online_sales_WRLS Home_AV],0)+ isnull([Telesales_WRLS Home_AV],0)) as WRLS_Sales_AV,
SUM(ISNULL([Online_sales_Digital Life_AV],0)+ ISNULL([Telesales_Digital Life_AV],0)) AS DL_Sales_AV,
SUM(ISNULL([Online_sales_Access Line_AV], 0)+ISNULL([Online_sales_VoIP_AV], 0)+ISNULL([Telesales_Access Line_AV], 0)+ISNULL([Telesales_VoIP_AV], 0)+
ISNULL([Online_sales_DSL_AV], 0)+ISNULL([Online_sales_DSL Direct_AV], 0)+ISNULL([Telesales_DSL_AV], 0)+ISNULL([Telesales_DSL Direct_AV], 0)+
ISNULL([Online_sales_HSIA_AV], 0)+ISNULL([Online_sales_IPDSL_AV], 0)+ISNULL([Telesales_HSIA_AV], 0)+ISNULL([Telesales_IPDSL_AV], 0)+
ISNULL([Online_sales_DirecTV_AV], 0)+ISNULL([Online_sales_UVTV_AV], 0)+ISNULL([Telesales_DirecTV_AV], 0)+ISNULL([Telesales_UVTV_AV], 0)+
ISNULL([Online_sales_WRLS Data_AV], 0)+ISNULL([Online_sales_WRLS Family_AV], 0)+ISNULL([Online_sales_WRLS Voice_AV], 0)+ISNULL([Telesales_WRLS Data_AV], 0)+
ISNULL([Telesales_WRLS Family_AV], 0)+ISNULL([Telesales_WRLS Voice_AV], 0)+ ISNULL([Online_sales_Digital Life_AV],0)+ ISNULL([Telesales_Digital Life_AV],0)
+ isnull([Online_sales_WRLS Home_AV],0)+ isnull([Telesales_WRLS Home_AV],0)) AS Total_Strat_Sales_AV


FROM bvt_prod.Movers_Best_View_Pivot_VW
WHERE Media_Year = (select LEFT(ReportCycle_YYYYWW,4) from [JAVDB].[ireport_2015].[dbo].[wb_00_reporting_cycle] group by ReportCycle_YYYYWW)
And Media = 'DM'

GROUP BY
Media_Year,
Media_Month,
Media_Week

UNION


Select 'Movers DM - Drag' as [Type],
Report_Year as Media_Year,
Report_Week as Media_Week, 
SUM(isnull(CV_ITP_Quantity,0)) as Volume_CV,
sum(isnull(CV_ITP_Dir_Calls,0)) as Call_CV,
SUM(ISNULL(CV_ITP_Dir_Clicks,0)) as Online_CV,
sum(isnull(CV_ITP_DIR_Sales_TS_ACCL,0) + isnull(CV_ITP_DIR_Sales_ON_ACCL,0) + isnull(CV_ITP_DIR_Sales_TS_UVRS_VOIP,0) + isnull(CV_ITP_DIR_Sales_ON_UVRS_VOIP,0))as Voice_Sales_CV,
sum(isnull(CV_ITP_DIR_Sales_TS_DSL_REG,0) + isnull(CV_ITP_DIR_Sales_ON_DSL_REG,0)+isnull(CV_ITP_DIR_Sales_TS_DSL_DRY,0)+isnull(CV_ITP_DIR_Sales_ON_DSL_DRY,0)) as DSL_Sales_CV,
sum(isnull(CV_ITP_DIR_Sales_TS_UVRS_HSIA,0)+isnull(CV_ITP_DIR_Sales_ON_UVRS_HSIA,0)	+isnull(CV_ITP_DIR_Sales_TS_DSL_IP,0)+isnull(CV_ITP_DIR_Sales_ON_DSL_IP,0)) as IPBB_Sales_CV,
sum(isnull(CV_ITP_DIR_Sales_TS_UVRS_TV,0)+isnull(CV_ITP_DIR_Sales_ON_UVRS_TV,0)+isnull(CV_ITP_DIR_Sales_TS_DISH,0)+isnull(CV_ITP_DIR_Sales_ON_DISH,0)) as TV_Sales_CV,
sum(isnull(CV_ITP_DIR_Sales_TS_UVRS_TV,0)+isnull(CV_ITP_DIR_Sales_ON_UVRS_TV,0)) AS IPTV_Sales_CV,
SUM(isnull(CV_ITP_DIR_Sales_TS_DISH,0)+isnull(CV_ITP_DIR_Sales_ON_DISH,0)) AS DTV_Sales_CV,
sum(isnull(CV_ITP_DIR_Sales_ON_CING_VOICE,0)+isnull(CV_ITP_DIR_Sales_ON_CING_FAMILY,0)+isnull(CV_ITP_DIR_Sales_ON_CING_DATA,0)+isnull(CV_ITP_DIR_Sales_TS_CING_VOICE,0)
+isnull(CV_ITP_DIR_Sales_TS_CING_FAMILY,0)+isnull(CV_ITP_DIR_Sales_TS_CING_DATA,0)) AS WRLS_Sales_CV,
sum(isnull(CV_ITP_Dir_Sales_TS,0)+isnull(CV_ITP_Dir_Sales_ON,0)) as Total_Strat_Sales_CV,
SUM(ISNULL(ITP_Quantity_Unapp,0)) as Volume_AV,
sum(isnull(ITP_Dir_Calls,0)) as Call_AV,
SUM(ISNULL(ITP_Dir_Clicks,0)) as Online_AV,
sum(isnull(ITP_Dir_Sales_TS_LOCAL_ACCL_N,0) + isnull(ITP_Dir_Sales_ON_LOCAL_ACCL_N,0) + isnull(ITP_DIR_Sales_TS_UVRS_VOIP_N,0) + isnull(ITP_Dir_Sales_ON_UVRS_VOIP_N,0))as Voice_Sales_AV,
sum(isnull(ITP_Dir_Sales_TS_DSL_REG_N,0) + isnull(ITP_Dir_Sales_ON_DSL_REG_N,0)+isnull(ITP_Dir_Sales_TS_DSL_DRY_N,0)+isnull(ITP_Dir_Sales_ON_DSL_DRY_N,0)) as DSL_Sales_AV,
sum(isnull(ITP_Dir_Sales_TS_UVRS_HSIA_N,0)+isnull(ITP_Dir_Sales_ON_UVRS_HSIA_N,0)	+isnull(ITP_Dir_Sales_TS_DSL_IP_N,0)+isnull(ITP_Dir_Sales_ON_DSL_IP_N,0)
+ISNULL(ITP_Dir_Sales_TS_UVRS_HSIAG_N,0)+ISNULL(ITP_Dir_Sales_ON_UVRS_HSIAG_N,0)) as IPBB_Sales_AV,
sum(isnull(ITP_Dir_Sales_TS_UVRS_TV_N,0)+isnull(ITP_Dir_Sales_ON_UVRS_TV_N,0)+isnull(ITP_Dir_Sales_TS_DISH_N,0)+isnull(ITP_Dir_Sales_ON_DISH_N,0)) as TV_Sales_AV,
sum(isnull(ITP_Dir_Sales_TS_UVRS_TV_N,0)+isnull(ITP_Dir_Sales_ON_UVRS_TV_N,0)) AS IPTV_Sales_AV,
SUM(isnull(ITP_Dir_Sales_TS_DISH_N,0)+isnull(ITP_Dir_Sales_ON_DISH_N,0)) AS DTV_Sales_AV,
sum(isnull(ITP_Dir_Sales_ON_CING_VOICE_N,0)+isnull(ITP_Dir_Sales_ON_CING_FAMILY_N,0)+isnull(ITP_Dir_Sales_ON_CING_DATA_N,0)+isnull(ITP_Dir_Sales_TS_CING_VOICE_N,0)
+isnull(ITP_Dir_Sales_TS_CING_FAMILY_N,0)+isnull(ITP_Dir_Sales_TS_CING_DATA_N,0)+ISNULL(ITP_Dir_Sales_TS_CING_WHP_N,0)+isnull(ITP_Dir_Sales_ON_CING_WHP_N,0)) AS WRLS_Sales_AV,
SUM(ISNULL(ITP_Dir_Sales_TS_DLIFE_N,0)+ISNULL(ITP_Dir_Sales_ON_DLIFE_N,0)) as DL_Sales_AV,
sum(isnull(ITP_Dir_Sales_TS_LOCAL_ACCL_N,0) + isnull(ITP_Dir_Sales_ON_LOCAL_ACCL_N,0) + isnull(ITP_DIR_Sales_TS_UVRS_VOIP_N,0) + isnull(ITP_Dir_Sales_ON_UVRS_VOIP_N,0)+
isnull(ITP_Dir_Sales_TS_DSL_REG_N,0) + isnull(ITP_Dir_Sales_ON_DSL_REG_N,0)+isnull(ITP_Dir_Sales_TS_DSL_DRY_N,0)+isnull(ITP_Dir_Sales_ON_DSL_DRY_N,0)+
isnull(ITP_Dir_Sales_TS_UVRS_HSIA_N,0)+isnull(ITP_Dir_Sales_ON_UVRS_HSIA_N,0)	+isnull(ITP_Dir_Sales_TS_DSL_IP_N,0)+isnull(ITP_Dir_Sales_ON_DSL_IP_N,0)
+ISNULL(ITP_Dir_Sales_TS_UVRS_HSIAG_N,0)+ISNULL(ITP_Dir_Sales_ON_UVRS_HSIAG_N,0)+isnull(ITP_Dir_Sales_TS_UVRS_TV_N,0)+isnull(ITP_Dir_Sales_ON_UVRS_TV_N,0)+
isnull(ITP_Dir_Sales_TS_DISH_N,0)+isnull(ITP_Dir_Sales_ON_DISH_N,0)+isnull(ITP_Dir_Sales_TS_UVRS_TV_N,0)+isnull(ITP_Dir_Sales_ON_UVRS_TV_N,0)+isnull(ITP_Dir_Sales_TS_DISH_N,0)+
isnull(ITP_Dir_Sales_ON_DISH_N,0)+isnull(ITP_Dir_Sales_ON_CING_VOICE_N,0)+isnull(ITP_Dir_Sales_ON_CING_FAMILY_N,0)+isnull(ITP_Dir_Sales_ON_CING_DATA_N,0)+isnull(ITP_Dir_Sales_TS_CING_VOICE_N,0)
+isnull(ITP_Dir_Sales_TS_CING_FAMILY_N,0)+isnull(ITP_Dir_Sales_TS_CING_DATA_N,0)+ISNULL(ITP_Dir_Sales_TS_CING_WHP_N,0)+isnull(ITP_Dir_Sales_ON_CING_WHP_N,0)+
ISNULL(ITP_Dir_Sales_TS_DLIFE_N,0)+ISNULL(ITP_Dir_Sales_ON_DLIFE_N,0)) as Total_Strat_Sales_AV

 from Javdb.ireport_2015.dbo.IR_Workbook_Data_2016
where parentID in (265632,160147)
GROUP BY Report_Year, Report_Week

)





GO


