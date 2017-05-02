alter VIEW [bvt_prod].[BV_SC_Daily]
AS SELECT
	Owner_type_matrix_id_FK as hierarchy_id
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
where Forecast_Daydate > '2016-01-01'
group by Owner_type_matrix_id_FK 
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, channel

union all

Select Owner_type_matrix_id_FK as hierarchy_id
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, Channel
	, sum(Forecast)  as forecast 
FROM openrowset(
	'SQLNCLI10'
	,'Server=S5280a04;Trusted_Connection=YES;'
	,'set fmtonly off exec bvt_prod.Forecasting_Calculations_PR 7'
	)
where Forecast_Daydate > '2016-01-01'
group by Owner_type_matrix_id_FK 
	, Forecast_Daydate
	, channel
	, KPI_Type
	, Product_Code

union all

Select Owner_type_matrix_id_FK as hierarchy_id
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, '9. Blue' as Channel
	, sum(Forecast)  as forecast
FROM openrowset(
	'SQLNCLI10'
	,'Server=S5280a04;Trusted_Connection=YES;'
	,'set fmtonly off exec bvt_prod.Forecasting_Calculations_PR 9'
	)
where Forecast_Daydate > '2016-01-01'
group by Owner_type_matrix_id_FK 
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, channel
union all

Select Owner_type_matrix_id_FK as hierarchy_id
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, Channel
	, sum(Forecast)  as forecast
FROM openrowset(
	'SQLNCLI10'
	,'Server=S5280a04;Trusted_Connection=YES;'
	,'set fmtonly off exec bvt_prod.Forecasting_Calculations_PR 4'
	)
where Forecast_Daydate > '2016-01-01'
group by Owner_type_matrix_id_FK 
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, channel
union all

Select Owner_type_matrix_id_FK as hierarchy_id
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, Channel
	, sum(Forecast)  as forecast
FROM openrowset(
	'SQLNCLI10'
	,'Server=S5280a04;Trusted_Connection=YES;'
	,'set fmtonly off exec bvt_prod.Forecasting_Calculations_PR 6'
	)
where Forecast_Daydate > '2016-01-01'
group by Owner_type_matrix_id_FK 
	, Forecast_Daydate 
	, KPI_Type
	, Product_Code
	, channel

union all

Select Owner_type_matrix_id_FK as hierarchy_id
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, Channel
	, sum(Forecast)  as forecast
FROM openrowset(
	'SQLNCLI10'
	,'Server=S5280a04;Trusted_Connection=YES;'
	,'set fmtonly off exec bvt_prod.Forecasting_Calculations_PR 11'
	)
where Forecast_Daydate > '2016-01-01'
group by Owner_type_matrix_id_FK 
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, channel
	

union all

Select Owner_type_matrix_id_FK as hierarchy_id
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, Channel
	, sum(Forecast)  as forecast
FROM openrowset(
	'SQLNCLI10'
	,'Server=S5280a04;Trusted_Connection=YES;'
	,'set fmtonly off exec bvt_prod.Forecasting_Calculations_PR 12'
	)
where Forecast_Daydate > '2016-01-01'
group by Owner_type_matrix_id_FK 
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, channel