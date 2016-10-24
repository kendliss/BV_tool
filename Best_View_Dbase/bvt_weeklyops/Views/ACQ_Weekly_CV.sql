USE [UVAQ]
GO

/****** Object:  View [bvt_weeklyops].[ACQ_Weekly_CV]    Script Date: 09/20/2016 10:42:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






ALTER VIEW [bvt_weeklyops].[ACQ_Weekly_CV]
AS
(
SELECT CASE WHEN b.Channel IN ('13. DMDR') THEN 'DMDR'
WHEN b.Channel IN ('100. DS Center') THEN 'DTV '
ELSE 'IBCC' END AS Call_Center,
Media_Year,
Media_Month,
Media_Week,
SUM(CASE WHEN Product_Code = 'Volume' THEN Forecast ELSE 0 END) AS CV_Volume,
SUM(CASE WHEN Product_Code = 'Call' THEN Forecast ELSE 0 END) AS CV_Call,
SUM(CASE WHEN Product_Code = 'Online' THEN Forecast ELSE 0 END) AS CV_Online,
SUM(CASE WHEN Product_Code IN ('Access Line','VoIP') THEN Forecast ELSE 0 END) AS CV_Voice_Sales,
SUM(CASE WHEN Product_Code IN ('DSL','DSL Direct') THEN Forecast ELSE 0 END) AS CV_DSL_Sales,
SUM(CASE WHEN Product_Code IN ('HSIA','IPDSL','Gigapower') THEN Forecast ELSE 0 END) AS CV_IPBB_Sales,
SUM(CASE WHEN Product_Code IN ('UVTV') THEN Forecast ELSE 0 END) AS CV_IPTV_Sales,
SUM(CASE WHEN Product_Code IN ('DirecTV') THEN Forecast ELSE 0 END) AS CV_DTV_Sales,
SUM(CASE WHEN Product_Code IN ('DirecTV', 'UVTV') THEN Forecast ELSE 0 END) AS CV_TV_Sales,
SUM(CASE WHEN Product_Code IN ('WRLS Voice','WRLS Data','WRLS Family','WRLS Home') THEN Forecast ELSE 0 END) AS CV_WLS_Sales,
SUM(CASE WHEN Product_Code IN ('Digital Life') THEN Forecast ELSE 0 END) AS CV_DL_Sales

FROM bvt_processed.Commitment_Views a
JOIN bvt_prod.Touch_Definition_VW b
on a.idProgram_Touch_Definitions_TBL_FK = b.idProgram_Touch_Definitions_TBL
WHERE CV_Submission = 'ACQ 2016 Commitment View Adj 20160509'

GROUP BY 
CASE WHEN b.Channel IN ('13. DMDR') THEN 'DMDR'
WHEN b.Channel IN ('100. DS Center') THEN 'DTV '
ELSE 'IBCC' END,
Media_Year,
Media_Month,
Media_Week

)











GO


