drop view [bvt_prod].[UVLB_SaleForecast_Weekly_VW]
GO

CREATE VIEW [bvt_prod].[UVLB_SaleForecast_Weekly_VW]
as 
select 
	idFlight_Plan_Records
	, A.[idProgram_Touch_Definitions_TBL_FK]
	, Campaign_Name
	, InHome_Date
	
---Media_Calendar_Info
	, Media_Year
	, Media_Week
	, Media_Month
	
---Touch Lookup Tables
	, Touch_Name
	, Program_Name
	, Tactic
	, Media
	, Campaign_Type
	, Audience
	, Creative_Name
	, Goal
	, Offer

----Metrics
	, KPI_Type
	, D.Product_Code
	, Forecast*[Sales_Rate]/[KPI_Rate] as Forecast

from [bvt_prod].[UVLB_Forecast_NOSALES_VW] as A
	inner join (SELECT * FROM [bvt_prod].[KPI_Rate_Start_End_FUN]('UVLB')) as B
		on A.idProgram_Touch_Definitions_TBL_FK=B.idProgram_Touch_Definitions_TBL_FK
		AND InHome_Date between Rate_Start_Date and b.END_DATE and A.idkpi_types_FK=B.idkpi_types_FK

	inner join (SELECT * FROM [bvt_prod].[Sales_Rate_Start_End_FUN]('UVLB') where sales_rate>0) as c 
		on A.idProgram_Touch_Definitions_TBL_FK=B.idProgram_Touch_Definitions_TBL_FK
		and InHome_Date between Sales_Rate_Start_Date and c.END_DATE and A.idkpi_types_FK=c.idkpi_type_FK

	left join [bvt_prod].[Product_LU_TBL] as D
		on C.[idProduct_LU_TBL_FK]=D.[idProduct_LU_TBL]

where KPI_Type <> 'Volume'