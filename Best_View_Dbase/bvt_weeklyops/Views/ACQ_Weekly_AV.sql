USE [UVAQ]
GO

/****** Object:  View [bvt_weeklyops].[ACQ_Weekly_AV]    Script Date: 09/20/2016 10:42:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








ALTER VIEW [bvt_weeklyops].[ACQ_Weekly_AV]
AS
(
SELECT CASE WHEN b.CallStrat_ID IN (13.0) THEN 'DMDR'
WHEN b.CallStrat_ID IN (102.0) THEN 'DTV '
WHEN a.Parentid IN (265649) THEN 'DTV '
WHEN a.Parentid IN (274470) THEN 'DMDR'
WHEN a.Parentid IN (268228,247385,251690,252111,251111) THEN 'IBCC'
WHEN b.CallStrat_ID = 900.0 THEN 'NONE'
WHEN b.CallStrat_ID IS null THEN ''
ELSE 'IBCC' END AS Call_Center,
a.Report_Year,
a.Report_Week,

SUM(ISNULL(ITP_Quantity_Unapp,0)) AS AV_Volume,
SUM(ISNULL(ITP_Dir_Calls,0)) AS AV_Call,
SUM(ISNULL(ITP_Dir_Clicks,0)) AS AV_Online,
SUM(ISNULL(ITP_Dir_Sales_TS_LOCAL_ACCL_N,0)+ISNULL(ITP_Dir_Sales_TS_UVRS_VOIP_N,0)+
ISNULL(ITP_Dir_Sales_ON_LOCAL_ACCL_N,0)+ISNULL(ITP_Dir_Sales_ON_UVRS_VOIP_N,0)) AS AV_Voice_Sales,
SUM(ISNULL(ITP_Dir_Sales_TS_DSL_REG_N,0)+ISNULL(ITP_Dir_Sales_TS_DSL_DRY_N,0)+
ISNULL(ITP_Dir_Sales_ON_DSL_REG_N,0)+ISNULL(ITP_Dir_Sales_ON_DSL_DRY_N,0)) AS AV_DSL_Sales,
SUM(ISNULL(ITP_Dir_Sales_TS_UVRS_HSIA_N,0)+ISNULL(ITP_Dir_Sales_TS_DSL_IP_N,0)+
ISNULL(ITP_Dir_Sales_ON_UVRS_HSIA_N,0)+ISNULL(ITP_Dir_Sales_ON_DSL_IP_N,0)) AS AV_IPBB_Sales,
SUM(ISNULL(ITP_Dir_Sales_TS_UVRS_TV_N,0)+ISNULL(ITP_Dir_Sales_ON_UVRS_TV_N,0)) AS AV_IPTV_Sales,
SUM(ISNULL(Itp_Dir_Sales_TS_DISH_N,0)+ISNULL(ITP_Dir_Sales_ON_DISH_N,0)) AS AV_DTV_Sales,
SUM(ISNULL(ITP_Dir_Sales_TS_UVRS_TV_N,0)+ISNULL(ITP_Dir_Sales_ON_UVRS_TV_N,0)+
ISNULL(Itp_Dir_Sales_TS_DISH_N,0)+ISNULL(ITP_Dir_Sales_ON_DISH_N,0)) AS AV_TV_Sales,
SUM(ISNULL(ITP_Dir_Sales_TS_CING_DATA_N,0)+ISNULL(ITP_Dir_Sales_TS_CING_FAMILY_N,0)+
ISNULL(ITP_Dir_Sales_TS_CING_VOICE_N,0)+ISNULL(ITP_Dir_sales_TS_CING_WHP_N,0)+
ISNULL(ITP_Dir_Sales_ON_CING_DATA_N,0)+ISNULL(ITP_Dir_Sales_ON_CING_FAMILY_N,0)+
ISNULL(ITP_Dir_Sales_ON_CING_VOICE_N,0)+ISNULL(ITP_Dir_sales_ON_CING_WHP_N,0)) AS AV_WLS_Sales,
SUM(ISNULL(ITP_Dir_Sales_TS_DLIFE_N,0)+ISNULL(ITP_Dir_Sales_ON_DLIFE_N,0)) AS AV_DL_Sales


FROM bvt_prod.ACQ_Actuals_VW a
LEFT JOIN JAVDB.IREPORT_2015.dbo.WB_01_Campaign_List_WB_2016 b
on a.Parentid = b.parentID

GROUP BY 
CASE WHEN b.CallStrat_ID IN (13.0) THEN 'DMDR'
WHEN b.CallStrat_ID IN (102.0) THEN 'DTV '
WHEN a.Parentid IN (265649) THEN 'DTV '
WHEN a.Parentid IN (274470) THEN 'DMDR'
WHEN a.Parentid IN (268228,247385,251690,252111,251111) THEN 'IBCC'
WHEN b.CallStrat_ID = 900.0 THEN 'NONE'
WHEN b.CallStrat_ID IS null THEN ''
ELSE 'IBCC' END,
a.Report_Year,
a.Report_Week

)













GO


