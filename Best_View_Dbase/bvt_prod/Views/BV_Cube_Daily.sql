CREATE VIEW [bvt_prod].[BV_Cube_Daily]
	AS SELECT
	att_program_code
	, channel_name
	, scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, Channel
	, sum(Forecast) as forecast
FROM bvt_prod.[ACQ_Best_View_Forecast_VW]
	join [bvt_prod].[Program_Touch_Definitions_TBL]
	on [idProgram_Touch_Definitions_TBL_FK]=[idProgram_Touch_Definitions_TBL]
where Forecast_Daydate > '2016-01-01'
group by att_program_code
	, channel_name
	, scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, channel

union all

Select 	att_program_code
	, channel_name
	, scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, Channel
	, sum(Forecast)  as forecast 
FROM bvt_prod.BM_Forecast_VW
	join [bvt_prod].[Program_Touch_Definitions_TBL]
	on [idProgram_Touch_Definitions_TBL_FK]=[idProgram_Touch_Definitions_TBL]
where Forecast_Daydate > '2016-01-01'
group by 	att_program_code
	, channel_name
	, scorecard_group 
	, Forecast_Daydate
	, channel
	, KPI_Type
	, Product_Code

union all

Select 	att_program_code
	, channel_name
	, scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, '9. Blue' as Channel
	, sum(Forecast)  as forecast
FROM bvt_prod.CLM_Revenue_Forecast_VW
	join [bvt_prod].[Program_Touch_Definitions_TBL]
	on [idProgram_Touch_Definitions_TBL_FK]=[idProgram_Touch_Definitions_TBL]
where Forecast_Daydate > '2016-01-01'
group by 	att_program_code
	, channel_name
	, scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, channel
union all

Select 	att_program_code
	, channel_name
	, scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, Channel
	, sum(Forecast)  as forecast
FROM bvt_prod.Movers_Best_View_Forecast_VW
	join [bvt_prod].[Program_Touch_Definitions_TBL]
	on [idProgram_Touch_Definitions_TBL_FK]=[idProgram_Touch_Definitions_TBL]
where Forecast_Daydate > '2016-01-01'
group by 	att_program_code
	, channel_name
	, scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, channel
union all

Select 	att_program_code
	, channel_name
	, scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, Channel
	, sum(Forecast)  as forecast
FROM bvt_prod.XSell_Best_View_Forecast_VW
	join [bvt_prod].[Program_Touch_Definitions_TBL]
	on [idProgram_Touch_Definitions_TBL_FK]=[idProgram_Touch_Definitions_TBL]
where Forecast_Daydate > '2016-01-01'
group by 	att_program_code
	, channel_name
	, scorecard_group 
	, Forecast_Daydate 
	, KPI_Type
	, Product_Code
	, channel

union all

Select 	att_program_code
	, channel_name
	, scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, Channel
	, sum(Forecast)  as forecast
FROM bvt_prod.Email_Best_View_Forecast_VW
	join [bvt_prod].[Program_Touch_Definitions_TBL]
	on [idProgram_Touch_Definitions_TBL_FK]=[idProgram_Touch_Definitions_TBL]
where Forecast_Daydate > '2016-01-01'
group by att_program_code
	, channel_name
	, scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, channel
	

union all

Select 	att_program_code
	, channel_name
	, scorecard_group
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, Channel
	, sum(Forecast)  as forecast
FROM bvt_prod.Mig_Forecast_VW
	join [bvt_prod].[Program_Touch_Definitions_TBL]
	on [idProgram_Touch_Definitions_TBL_FK]=[idProgram_Touch_Definitions_TBL]
where Forecast_Daydate > '2016-01-01'
group by att_program_code
	, channel_name
	, scorecard_group 
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, channel
