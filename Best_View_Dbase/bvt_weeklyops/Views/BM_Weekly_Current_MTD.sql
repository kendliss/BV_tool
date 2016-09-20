USE [UVAQ]
GO

/****** Object:  View [bvt_weeklyops].[BM_Weekly_Current_MTD]    Script Date: 09/20/2016 10:43:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--Drop View bvt_weeklyops.BM_Summary_Current

ALTER VIEW [bvt_weeklyops].[BM_Weekly_Current_MTD]
AS
(
SELECT Media,
Campaign_Type,
(Media+''+Campaign_Type) as 'Look_Up',
Media_Year,
Media_Month,
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
sum(ISNULL([Volume_AV],0)) as [Volume_AV],
sum(ISNULL([Call_AV], 0)) as [Call_AV], 
sum(ISNULL([Online_AV], 0)) as [Online_AV], 
sum(ISNULL([Online_sales_Access Line_AV], 0)+ISNULL([Online_sales_VoIP_AV], 0)+ISNULL([Telesales_Access Line_AV], 0)+ISNULL([Telesales_VoIP_AV], 0)) as Voice_Sales_AV, 
sum(ISNULL([Online_sales_DSL_AV], 0)+ISNULL([Online_sales_DSL Direct_AV], 0)+ISNULL([Telesales_DSL_AV], 0)+ISNULL([Telesales_DSL Direct_AV], 0)) as DSL_Sales_AV, 
sum(ISNULL([Online_sales_HSIA_AV], 0)+ISNULL([Online_sales_IPDSL_AV], 0)+ISNULL([Telesales_HSIA_AV], 0)+ISNULL([Telesales_IPDSL_AV], 0)
+ISNULL([Online_sales_Gigapower_AV], 0)+ISNULL([Telesales_Gigapower_AV], 0)) as IPBB_Sales_AV, 
sum(ISNULL([Online_sales_DirecTV_AV], 0)+ISNULL([Online_sales_UVTV_AV], 0)+ISNULL([Telesales_DirecTV_AV], 0)+ISNULL([Telesales_UVTV_AV], 0)) as TV_Sales_AV,
sum(ISNULL([Telesales_UVTV_AV], 0)+ISNULL([Online_sales_UVTV_AV], 0)) as IPTV_Sales_AV,
sum(ISNULL([Telesales_DirecTV_AV], 0)+ISNULL([Online_sales_DirecTV_AV], 0)) as DTV_Sales_AV,
sum(ISNULL([Online_sales_WRLS Data_AV], 0)+ISNULL([Online_sales_WRLS Family_AV], 0)+ISNULL([Online_sales_WRLS Voice_AV], 0)+ISNULL([Telesales_WRLS Data_AV], 0)+
ISNULL([Telesales_WRLS Family_AV], 0)+ISNULL([Telesales_WRLS Voice_AV], 0)+ isnull([Online_sales_WRLS Home_AV],0)+ isnull([Telesales_WRLS Home_AV],0)) as WRLS_Sales_AV,
SUM(ISNULL([Online_sales_Access Line_AV], 0)+ISNULL([Online_sales_VoIP_AV], 0)+ISNULL([Telesales_Access Line_AV], 0)+ISNULL([Telesales_VoIP_AV], 0)+
ISNULL([Online_sales_DSL_AV], 0)+ISNULL([Online_sales_DSL Direct_AV], 0)+ISNULL([Telesales_DSL_AV], 0)+ISNULL([Telesales_DSL Direct_AV], 0)+
ISNULL([Online_sales_HSIA_AV], 0)+ISNULL([Online_sales_IPDSL_AV], 0)+ISNULL([Telesales_HSIA_AV], 0)+ISNULL([Telesales_IPDSL_AV], 0)+
ISNULL([Online_sales_DirecTV_AV], 0)+ISNULL([Online_sales_UVTV_AV], 0)+ISNULL([Telesales_DirecTV_AV], 0)+ISNULL([Telesales_UVTV_AV], 0)+
ISNULL([Online_sales_WRLS Data_AV], 0)+ISNULL([Online_sales_WRLS Family_AV], 0)+ISNULL([Online_sales_WRLS Voice_AV], 0)+ISNULL([Telesales_WRLS Data_AV], 0)+
ISNULL([Telesales_WRLS Family_AV], 0)+ISNULL([Telesales_WRLS Voice_AV], 0)+ ISNULL([Online_sales_Digital Life_AV],0)+ ISNULL([Telesales_Digital Life_AV],0)+ 
isnull([Online_sales_WRLS Home_AV],0)+ isnull([Telesales_WRLS Home_AV],0)+ISNULL([Online_sales_Gigapower_AV], 0)+ISNULL([Telesales_Gigapower_AV], 0)) AS Total_Strat_Sales_AV


FROM bvt_prod.BM_Best_View_Pivot_VW
WHERE Media_Year = (select LEFT(ReportCycle_YYYYWW,4) from [JAVDB].[ireport_2015].[dbo].[wb_00_reporting_cycle] group by ReportCycle_YYYYWW)
AND Media_Week <= (select Right(ReportCycle_YYYYWW,2) from [JAVDB].[ireport_2015].[dbo].[wb_00_reporting_cycle] group by ReportCycle_YYYYWW)
AND Media_Month = 8


GROUP BY Media,
Campaign_Type,
Media+ ' '+Campaign_Type,
Media_Year,
Media_Month,
Media_Week
)






GO


