USE [UVAQ]
GO

/****** Object:  View [bvt_prod].[Combined_New_Best_View_Pivot_VW]    Script Date: 02/22/2016 13:37:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






ALTER View [bvt_prod].[Combined_New_Best_View_Pivot_VW] 
AS 
	Select
	[idFlight_Plan_Records_FK], [InHome_Date], [Media_Year], [Media_Week], [Media_Month], [Program_Name],  [Media], 
	[Touch_Name], [New_Program], [New_Touch_Name], CCF_Category,New_Audience,CCF_Sub_Category, CCF_Description,
sum(isnull([Call_CV], 0)) as [Call_CV], 
sum(isnull([Online_CV], 0)) as [Online_CV], 
sum(isnull([Online_sales_Access Line_CV], 0)) as [Online_sales_Access Line_CV], 
sum(isnull([Online_sales_DSL_CV], 0)) as [Online_sales_DSL_CV], 
sum(isnull([Online_sales_DSL Direct_CV], 0)) as [Online_sales_DSL Direct_CV], 
sum(isnull([Online_sales_HSIA_CV], 0)) as [Online_sales_HSIA_CV], 
sum(isnull([Online_sales_IPDSL_CV], 0)) as [Online_sales_IPDSL_CV], 
sum(isnull([Online_sales_DirecTV_CV], 0)) as [Online_sales_DirecTV_CV], 
sum(isnull([Online_sales_UVTV_CV], 0)) as [Online_sales_UVTV_CV], 
sum(isnull([Online_sales_VoIP_CV], 0)) as [Online_sales_VoIP_CV], 
sum(isnull([Online_sales_WRLS Data_CV], 0)) as [Online_sales_WRLS Data_CV], 
sum(isnull([Online_sales_WRLS Family_CV], 0)) as [Online_sales_WRLS Family_CV], 
sum(isnull([Online_sales_WRLS Voice_CV], 0)) as [Online_sales_WRLS Voice_CV], 
sum(isnull([Telesales_Access Line_CV], 0)) as [Telesales_Access Line_CV], 
sum(isnull([Telesales_DSL_CV], 0)) as [Telesales_DSL_CV], 
sum(isnull([Telesales_DSL Direct_CV], 0)) as [Telesales_DSL Direct_CV], 
sum(isnull([Telesales_HSIA_CV], 0)) as [Telesales_HSIA_CV], 
sum(isnull([Telesales_IPDSL_CV], 0)) as [Telesales_IPDSL_CV], 
sum(isnull([Telesales_DirecTV_CV], 0)) as [Telesales_DirecTV_CV], 
sum(isnull([Telesales_UVTV_CV], 0)) as [Telesales_UVTV_CV], 
sum(isnull([Telesales_VoIP_CV], 0)) as [Telesales_VoIP_CV], 
sum(isnull([Telesales_WRLS Data_CV], 0)) as [Telesales_WRLS Data_CV], 
sum(isnull([Telesales_WRLS Family_CV], 0)) as [Telesales_WRLS Family_CV], 
sum(isnull([Telesales_WRLS Voice_CV], 0)) as [Telesales_WRLS Voice_CV], 
sum(isnull([Volume_CV],0)) as [Volume_CV],
sum(isnull([Call_FV], 0)) as [Call_FV], 
sum(isnull([Online_FV], 0)) as [Online_FV], 
sum(isnull([Online_sales_Access Line_FV], 0)) as [Online_sales_Access Line_FV], 
sum(isnull([Online_sales_DSL_FV], 0)) as [Online_sales_DSL_FV], 
sum(isnull([Online_sales_DSL Direct_FV], 0)) as [Online_sales_DSL Direct_FV], 
sum(isnull([Online_sales_HSIA_FV], 0)) as [Online_sales_HSIA_FV], 
sum(isnull([Online_sales_IPDSL_FV], 0)) as [Online_sales_IPDSL_FV], 
sum(isnull([Online_sales_DirecTV_FV], 0)) as [Online_sales_DirecTV_FV], 
sum(isnull([Online_sales_UVTV_FV], 0)) as [Online_sales_UVTV_FV], 
sum(isnull([Online_sales_VoIP_FV], 0)) as [Online_sales_VoIP_FV], 
sum(isnull([Online_sales_WRLS Data_FV], 0)) as [Online_sales_WRLS Data_FV], 
sum(isnull([Online_sales_WRLS Family_FV], 0)) as [Online_sales_WRLS Family_FV], 
sum(isnull([Online_sales_WRLS Voice_FV], 0)) as [Online_sales_WRLS Voice_FV], 
sum(isnull([Telesales_Access Line_FV], 0)) as [Telesales_Access Line_FV], 
sum(isnull([Telesales_DSL_FV], 0)) as [Telesales_DSL_FV], 
sum(isnull([Telesales_DSL Direct_FV], 0)) as [Telesales_DSL Direct_FV], 
sum(isnull([Telesales_HSIA_FV], 0)) as [Telesales_HSIA_FV], 
sum(isnull([Telesales_IPDSL_FV], 0)) as [Telesales_IPDSL_FV], 
sum(isnull([Telesales_DirecTV_FV], 0)) as [Telesales_DirecTV_FV], 
sum(isnull([Telesales_UVTV_FV], 0)) as [Telesales_UVTV_FV], 
sum(isnull([Telesales_VoIP_FV], 0)) as [Telesales_VoIP_FV], 
sum(isnull([Telesales_WRLS Data_FV], 0)) as [Telesales_WRLS Data_FV], 
sum(isnull([Telesales_WRLS Family_FV], 0)) as [Telesales_WRLS Family_FV], 
sum(isnull([Telesales_WRLS Voice_FV], 0)) as [Telesales_WRLS Voice_FV], 
sum(isnull([Volume_FV],0)) as [Volume_FV],
sum(isnull([Online_sales_Access Line_CV], 0))+ sum(isnull([Online_sales_DSL_CV], 0))+ sum(isnull([Online_sales_DSL Direct_CV], 0))+ sum(isnull([Online_sales_HSIA_CV], 0))+ sum(isnull([Online_sales_IPDSL_CV], 0))+ sum(isnull([Online_sales_DirecTV_CV], 0))+ sum(isnull([Online_sales_UVTV_CV], 0))+ sum(isnull([Online_sales_VoIP_CV], 0))+ sum(isnull([Online_sales_WRLS Data_CV], 0))+ sum(isnull([Online_sales_WRLS Family_CV], 0))+ sum(isnull([Online_sales_WRLS Voice_CV], 0)) as Online_Strat_CV,
sum(isnull([Online_sales_Access Line_FV], 0))+ sum(isnull([Online_sales_DSL_FV], 0))+ sum(isnull([Online_sales_DSL Direct_FV], 0))+ sum(isnull([Online_sales_HSIA_FV], 0))+ sum(isnull([Online_sales_IPDSL_FV], 0))+ sum(isnull([Online_sales_DirecTV_FV], 0))+ sum(isnull([Online_sales_UVTV_FV], 0))+ sum(isnull([Online_sales_VoIP_FV], 0))+ sum(isnull([Online_sales_WRLS Data_FV], 0))+ sum(isnull([Online_sales_WRLS Family_FV], 0))+ sum(isnull([Online_sales_WRLS Voice_FV], 0)) as Online_Strat_FV,
sum(isnull([Telesales_Access Line_CV], 0))+ sum(isnull([Telesales_DSL_CV], 0))+ sum(isnull([Telesales_DSL Direct_CV], 0))+ sum(isnull([Telesales_HSIA_CV], 0))+ sum(isnull([Telesales_IPDSL_CV], 0))+ sum(isnull([Telesales_DirecTV_CV], 0))+ sum(isnull([Telesales_UVTV_CV], 0))+ sum(isnull([Telesales_VoIP_CV], 0))+ sum(isnull([Telesales_WRLS Data_CV], 0))+ sum(isnull([Telesales_WRLS Family_CV], 0))+ sum(isnull([Telesales_WRLS Voice_CV], 0)) as Telesales_Strat_CV,
sum(isnull([Telesales_Access Line_FV], 0))+ sum(isnull([Telesales_DSL_FV], 0))+ sum(isnull([Telesales_DSL Direct_FV], 0))+ sum(isnull([Telesales_HSIA_FV], 0))+ sum(isnull([Telesales_IPDSL_FV], 0))+ sum(isnull([Telesales_DirecTV_FV], 0))+ sum(isnull([Telesales_UVTV_FV], 0))+ sum(isnull([Telesales_VoIP_FV], 0))+ sum(isnull([Telesales_WRLS Data_FV], 0))+ sum(isnull([Telesales_WRLS Family_FV], 0))+ sum(isnull([Telesales_WRLS Voice_FV], 0)) as Telesales_Strat_FV
	FROM
		(SELECT  
	[idFlight_Plan_Records_FK], [InHome_Date], [Media_Year], [Media_Week], [Media_Month], [Program_Name],  [Media], 
	[Touch_Name], [New_Program],CCF_Category,New_Audience,CCF_Sub_Category, CCF_Description, [New_Touch_Name], [New_Forecast], [New_Commitment]
	,Case when kpi_type in ('Response','Volume','Budget') then Product_Code+'_CV'
		Else [KPI_Type]+'_'+[Product_Code]+'_CV' end as CV_metric 
	,Case when kpi_type in ('Response','Volume','Budget') then Product_Code+'_FV'
		Else [KPI_Type]+'_'+[Product_Code]+'_FV' end as FV_metric

	FROM [bvt_prod].[Combined_New_Best_View_VW]) as transform

	pivot 
	(SUM(New_Commitment) for CV_METRIC IN ([Call_CV], 
[Online_CV], 
[Online_sales_Access Line_CV], 
[Online_sales_DSL_CV], 
[Online_sales_DSL Direct_CV], 
[Online_sales_HSIA_CV], 
[Online_sales_IPDSL_CV], 
[Online_sales_DirecTV_CV], 
[Online_sales_UVTV_CV], 
[Online_sales_VoIP_CV], 
[Online_sales_WRLS Data_CV], 
[Online_sales_WRLS Family_CV], 
[Online_sales_WRLS Voice_CV], 
[Telesales_Access Line_CV], 
[Telesales_DSL_CV], 
[Telesales_DSL Direct_CV], 
[Telesales_HSIA_CV], 
[Telesales_IPDSL_CV], 
[Telesales_DirecTV_CV], 
[Telesales_UVTV_CV], 
[Telesales_VoIP_CV], 
[Telesales_WRLS Data_CV], 
[Telesales_WRLS Family_CV], 
[Telesales_WRLS Voice_CV], 
[Volume_CV]
)) as P1

	pivot(sum(New_forecast) for FV_Metric in ([Call_FV], 
[Online_FV], 
[Online_sales_Access Line_FV], 
[Online_sales_DSL_FV], 
[Online_sales_DSL Direct_FV], 
[Online_sales_HSIA_FV], 
[Online_sales_IPDSL_FV], 
[Online_sales_DirecTV_FV], 
[Online_sales_UVTV_FV], 
[Online_sales_VoIP_FV], 
[Online_sales_WRLS Data_FV], 
[Online_sales_WRLS Family_FV], 
[Online_sales_WRLS Voice_FV], 
[Telesales_Access Line_FV], 
[Telesales_DSL_FV], 
[Telesales_DSL Direct_FV], 
[Telesales_HSIA_FV], 
[Telesales_IPDSL_FV], 
[Telesales_DirecTV_FV], 
[Telesales_UVTV_FV], 
[Telesales_VoIP_FV], 
[Telesales_WRLS Data_FV], 
[Telesales_WRLS Family_FV], 
[Telesales_WRLS Voice_FV], 
[Volume_FV])) as P2

	

group by 	[idFlight_Plan_Records_FK], [InHome_Date], [Media_Year], [Media_Week], [Media_Month], [Program_Name],  [Media], 
	[Touch_Name], [New_Program],CCF_Category, [New_Touch_Name], New_Audience,CCF_Sub_Category, CCF_Description





GO


