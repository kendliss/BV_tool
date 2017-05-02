alter VIEW [bvt_prod].[BV_Cube_Daily]
	AS SELECT
	att_program_code
	, channel_name
	, fv.scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, Channel
	, sum(Forecast) as forecast
FROM openrowset(
	'SQLNCLI10'
	,'Server=S5280a04;Trusted_Connection=YES;'
	,'set fmtonly off exec bvt_prod.Forecasting_Calculations_PR 8'
	) as fv
	join [bvt_prod].[Program_Touch_Definitions_TBL]
	on [idProgram_Touch_Definitions_TBL_FK]=[idProgram_Touch_Definitions_TBL]
where Forecast_Daydate > '2016-01-01'
group by att_program_code
	, channel_name
	, fv.scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, channel

union all

Select 	att_program_code
	, channel_name
	, fv.scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, Channel
	, sum(Forecast)  as forecast 
FROM openrowset(
	'SQLNCLI10'
	,'Server=S5280a04;Trusted_Connection=YES;'
	,'set fmtonly off exec bvt_prod.Forecasting_Calculations_PR 7'
	) as fv
	join [bvt_prod].[Program_Touch_Definitions_TBL]
	on [idProgram_Touch_Definitions_TBL_FK]=[idProgram_Touch_Definitions_TBL]
where Forecast_Daydate > '2016-01-01'
group by 	att_program_code
	, channel_name
	, fv.scorecard_group 
	, Forecast_Daydate
	, channel
	, KPI_Type
	, Product_Code

union all

Select 	att_program_code
	, channel_name
	, fv.scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, '9. Blue' as Channel
	, sum(Forecast)  as forecast
FROM openrowset(
	'SQLNCLI10'
	,'Server=S5280a04;Trusted_Connection=YES;'
	,'set fmtonly off exec bvt_prod.Forecasting_Calculations_PR 9'
	) as fv
	join [bvt_prod].[Program_Touch_Definitions_TBL]
	on [idProgram_Touch_Definitions_TBL_FK]=[idProgram_Touch_Definitions_TBL]
where Forecast_Daydate > '2016-01-01'
group by 	att_program_code
	, channel_name
	, fv.scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, channel
union all

Select 	att_program_code
	, channel_name
	, fv.scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, Channel
	, sum(Forecast)  as forecast
FROM openrowset(
	'SQLNCLI10'
	,'Server=S5280a04;Trusted_Connection=YES;'
	,'set fmtonly off exec bvt_prod.Forecasting_Calculations_PR 4'
	) as fv
	join [bvt_prod].[Program_Touch_Definitions_TBL]
	on [idProgram_Touch_Definitions_TBL_FK]=[idProgram_Touch_Definitions_TBL]
where Forecast_Daydate > '2016-01-01'
group by 	att_program_code
	, channel_name
	, fv.scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, channel
union all

Select 	att_program_code
	, channel_name
	, fv.scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, Channel
	, sum(Forecast)  as forecast
FROM openrowset(
	'SQLNCLI10'
	,'Server=S5280a04;Trusted_Connection=YES;'
	,'set fmtonly off exec bvt_prod.Forecasting_Calculations_PR 6'
	) as fv
	join [bvt_prod].[Program_Touch_Definitions_TBL]
	on [idProgram_Touch_Definitions_TBL_FK]=[idProgram_Touch_Definitions_TBL]
where Forecast_Daydate > '2016-01-01'
group by 	att_program_code
	, channel_name
	, fv.scorecard_group 
	, Forecast_Daydate 
	, KPI_Type
	, Product_Code
	, channel

union all

Select 	att_program_code
	, channel_name
	, fv.scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, Channel
	, sum(Forecast)  as forecast
FROM openrowset(
	'SQLNCLI10'
	,'Server=S5280a04;Trusted_Connection=YES;'
	,'set fmtonly off exec bvt_prod.Forecasting_Calculations_PR 11'
	) as fv
	join [bvt_prod].[Program_Touch_Definitions_TBL]
	on [idProgram_Touch_Definitions_TBL_FK]=[idProgram_Touch_Definitions_TBL]
where Forecast_Daydate > '2016-01-01'
group by att_program_code
	, channel_name
	, fv.scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, channel
	

union all

Select 	att_program_code
	, channel_name
	, fv.scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, Channel
	, sum(Forecast)  as forecast
FROM openrowset(
	'SQLNCLI10'
	,'Server=S5280a04;Trusted_Connection=YES;'
	,'set fmtonly off exec bvt_prod.Forecasting_Calculations_PR 12'
	) as fv
	join [bvt_prod].[Program_Touch_Definitions_TBL]
	on [idProgram_Touch_Definitions_TBL_FK]=[idProgram_Touch_Definitions_TBL]
where Forecast_Daydate > '2016-01-01'
group by att_program_code
	, channel_name
	, fv.scorecard_group 
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, channel
