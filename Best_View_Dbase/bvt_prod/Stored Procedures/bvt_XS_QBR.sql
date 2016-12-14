DROP procedure  [bvt_prod].[bvt_XS_QBR]
GO


CREATE procedure [bvt_prod].[bvt_XS_QBR]
as

SELECT DISTINCT
 Media_Week
,Media_Month
,Media
,Scorecard_Program_Channel
,Audience
,Scorecard_Group
,ISNULL(SUM(Volume_CV),0) AS CV_Volume
,ISNULL(SUM(Volume_BV),0) AS BV_Volume
,ISNULL(SUM(Call_CV),0) AS CV_Calls
,ISNULL(SUM(Call_BV),0) AS BV_Calls
,ISNULL(SUM(Online_CV),0) AS CV_Clicks
,ISNULL(SUM(Online_BV),0) AS BV_Clicks



-- CV Sales
,ISNULL(SUM([Online_sales_Access Line_CV]),0)
+ISNULL(SUM(Online_sales_DSL_CV),0)
+ISNULL(SUM([Online_sales_DSL Direct_CV]),0)
+ISNULL(SUM(Online_sales_HSIA_CV),0)
+ISNULL(SUM(Online_sales_IPDSL_CV),0)
+ISNULL(SUM(Online_sales_DirecTV_CV),0)
+ISNULL(SUM(Online_sales_UVTV_CV),0)
+ISNULL(SUM(Online_sales_VoIP_CV),0)
+ISNULL(SUM([Online_sales_WRLS Data_CV]),0)
+ISNULL(SUM([Online_sales_WRLS Family_CV]),0)
+ISNULL(SUM([Online_sales_WRLS Voice_CV]),0)
+ISNULL(SUM([Online_sales_WRLS Home_CV]),0)
+ISNULL(SUM([Online_sales_Digital Life_CV]),0) AS CV_Online_Sales

,ISNULL(SUM([Telesales_Access Line_CV]),0)
+ISNULL(SUM(Telesales_DSL_CV),0)
+ISNULL(SUM([Telesales_DSL Direct_CV]),0)
+ISNULL(SUM(Telesales_HSIA_CV),0)
+ISNULL(SUM(Telesales_IPDSL_CV),0)
+ISNULL(SUM(Telesales_DirecTV_CV),0)
+ISNULL(SUM(Telesales_UVTV_CV),0)
+ISNULL(SUM(Telesales_VoIP_CV),0)
+ISNULL(SUM([Telesales_WRLS Data_CV]),0)
+ISNULL(SUM([Telesales_WRLS Family_CV]),0)
+ISNULL(SUM([Telesales_WRLS Voice_CV]),0)
+ISNULL(SUM([Telesales_WRLS Home_CV]),0)
+ISNULL(SUM([Telesales_Digital Life_CV]),0) AS CV_Call_Sales

,ISNULL(SUM(Online_sales_DirecTV_CV),0)
+ISNULL(SUM(Telesales_DirecTV_CV),0) AS CV_DTV_Sales

,ISNULL(SUM(Online_sales_UVTV_CV),0)
+ISNULL(SUM(Telesales_UVTV_CV),0) AS CV_IPTV_Sales

,ISNULL(SUM(Online_sales_HSIA_CV),0)
+ISNULL(SUM(Online_sales_IPDSL_CV),0)
+ISNULL(SUM(Telesales_HSIA_CV),0)
+ISNULL(SUM(Telesales_IPDSL_CV),0) AS CV_Broadband_Sales

,ISNULL(SUM([Online_sales_Access Line_CV]),0)
+ISNULL(SUM(Online_sales_DSL_CV),0)
+ISNULL(SUM([Online_sales_DSL Direct_CV]),0)
+ISNULL(SUM(Online_sales_VoIP_CV),0)
+ISNULL(SUM([Online_sales_WRLS Data_CV]),0)
+ISNULL(SUM([Online_sales_WRLS Family_CV]),0)
+ISNULL(SUM([Online_sales_WRLS Voice_CV]),0)
+ISNULL(SUM([Online_sales_WRLS Home_CV]),0)
+ISNULL(SUM([Online_sales_Digital Life_CV]),0)
+ISNULL(SUM([Telesales_Access Line_CV]),0)
+ISNULL(SUM(Telesales_DSL_CV),0)
+ISNULL(SUM([Telesales_DSL Direct_CV]),0)
+ISNULL(SUM(Telesales_VoIP_CV),0)
+ISNULL(SUM([Telesales_WRLS Data_CV]),0)
+ISNULL(SUM([Telesales_WRLS Family_CV]),0)
+ISNULL(SUM([Telesales_WRLS Voice_CV]),0)
+ISNULL(SUM([Telesales_WRLS Home_CV]),0)
+ISNULL(SUM([Telesales_Digital Life_CV]),0) AS CV_Other_Sales

-- BV Sales
,ISNULL(SUM([Online_sales_Access Line_BV]),0)
+ISNULL(SUM(Online_sales_DSL_BV),0)
+ISNULL(SUM([Online_sales_DSL Direct_BV]),0)
+ISNULL(SUM(Online_sales_HSIA_BV),0)
+ISNULL(SUM(Online_sales_IPDSL_BV),0)
+ISNULL(SUM(Online_sales_DirecTV_BV),0)
+ISNULL(SUM(Online_sales_UVTV_BV),0)
+ISNULL(SUM(Online_sales_VoIP_BV),0)
+ISNULL(SUM([Online_sales_WRLS Data_BV]),0)
+ISNULL(SUM([Online_sales_WRLS Family_BV]),0)
+ISNULL(SUM([Online_sales_WRLS Voice_BV]),0)
+ISNULL(SUM([Online_sales_WRLS Home_BV]),0)
+ISNULL(SUM([Online_sales_Digital Life_BV]),0) AS BV_Online_Sales

,ISNULL(SUM([Telesales_Access Line_BV]),0)
+ISNULL(SUM(Telesales_DSL_BV),0)
+ISNULL(SUM([Telesales_DSL Direct_BV]),0)
+ISNULL(SUM(Telesales_HSIA_BV),0)
+ISNULL(SUM(Telesales_IPDSL_BV),0)
+ISNULL(SUM(Telesales_DirecTV_BV),0)
+ISNULL(SUM(Telesales_UVTV_BV),0)
+ISNULL(SUM(Telesales_VoIP_BV),0)
+ISNULL(SUM([Telesales_WRLS Data_BV]),0)
+ISNULL(SUM([Telesales_WRLS Family_BV]),0)
+ISNULL(SUM([Telesales_WRLS Voice_BV]),0)
+ISNULL(SUM([Telesales_WRLS Home_BV]),0)
+ISNULL(SUM([Telesales_Digital Life_BV]),0) AS BV_Call_Sales

,ISNULL(SUM(Online_sales_DirecTV_BV),0)
+ISNULL(SUM(Telesales_DirecTV_BV),0) AS BV_DTV_Sales

,ISNULL(SUM(Online_sales_UVTV_BV),0)
+ISNULL(SUM(Telesales_UVTV_BV),0) AS BV_IPTV_Sales

,ISNULL(SUM(Online_sales_HSIA_BV),0)
+ISNULL(SUM(Online_sales_IPDSL_BV),0)
+ISNULL(SUM(Telesales_HSIA_BV),0)
+ISNULL(SUM(Telesales_IPDSL_BV),0) AS BV_Broadband_Sales

,ISNULL(SUM([Online_sales_Access Line_BV]),0)
+ISNULL(SUM(Online_sales_DSL_BV),0)
+ISNULL(SUM([Online_sales_DSL Direct_BV]),0)
+ISNULL(SUM(Online_sales_VoIP_BV),0)
+ISNULL(SUM([Online_sales_WRLS Data_BV]),0)
+ISNULL(SUM([Online_sales_WRLS Family_BV]),0)
+ISNULL(SUM([Online_sales_WRLS Voice_BV]),0)
+ISNULL(SUM([Online_sales_WRLS Home_BV]),0)
+ISNULL(SUM([Online_sales_Digital Life_BV]),0)
+ISNULL(SUM([Telesales_Access Line_BV]),0)
+ISNULL(SUM(Telesales_DSL_BV),0)
+ISNULL(SUM([Telesales_DSL Direct_BV]),0)
+ISNULL(SUM(Telesales_VoIP_BV),0)
+ISNULL(SUM([Telesales_WRLS Data_BV]),0)
+ISNULL(SUM([Telesales_WRLS Family_BV]),0)
+ISNULL(SUM([Telesales_WRLS Voice_BV]),0)
+ISNULL(SUM([Telesales_WRLS Home_BV]),0)
+ISNULL(SUM([Telesales_Digital Life_BV]),0) AS BV_Other_Sales

FROM bvt_prod.XSell_Best_View_Pivot_VW

WHERE Media_Year = '2016'

GROUP BY Media_Month, Media_Week, Media, Scorecard_Program_Channel, Audience, Scorecard_Group




GO


