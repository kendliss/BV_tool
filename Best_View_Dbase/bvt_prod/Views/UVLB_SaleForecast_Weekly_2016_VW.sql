DROP VIEW [bvt_prod].[UVLB_SaleForecast_Weekly_2016_VW]
GO

CREATE VIEW [bvt_prod].[UVLB_SaleForecast_Weekly_2016_VW]
as 
select 
	idFlight_Plan_Records
	, AA.[idProgram_Touch_Definitions_TBL_FK]
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
	, case when isnull(kpi_rate,0)=0 then 0
		else Forecast/KPI_Rate end as Forecast

from

(select 
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
	, idkpi_types_FK
	, idProduct_LU_TBL_FK
	, Forecast*[Sales_Rate] as Forecast

from [bvt_prod].[UVLB_Forecast_NOSALES_2016_VW] as A
	inner join (SELECT * FROM [bvt_prod].[Sales_Rate_Start_End_FUN]('UVLB') where sales_rate>0) as c 
		on A.idProgram_Touch_Definitions_TBL_FK=c.idProgram_Touch_Definitions_TBL_FK
		and InHome_Date between Sales_Rate_Start_Date and c.END_DATE and A.idkpi_types_FK=c.idkpi_type_FK
	where KPI_Type <> 'Volume' and Media_Year>2015 and Media_Year is not null) as AA

	inner join (SELECT * FROM [bvt_prod].[KPI_Rate_Start_End_FUN]('UVLB')) as B
		on AA.idProgram_Touch_Definitions_TBL_FK=B.idProgram_Touch_Definitions_TBL_FK
		AND InHome_Date between Rate_Start_Date and b.END_DATE and AA.idkpi_types_FK=B.idkpi_types_FK

	

	left join [bvt_prod].[Product_LU_TBL] as D
		on AA.[idProduct_LU_TBL_FK]=D.[idProduct_LU_TBL]

