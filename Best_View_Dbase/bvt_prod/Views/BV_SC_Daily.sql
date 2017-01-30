CREATE VIEW [bvt_prod].[BV_SC_Daily]
AS SELECT
	Owner_type_matrix_id_FK as hierarchy_id
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, Channel
	, sum(Forecast) as forecast
FROM bvt_prod.[ACQ_Best_View_Forecast_VW]
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
FROM bvt_prod.BM_Forecast_VW
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
FROM bvt_prod.CLM_Revenue_Forecast_VW
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
FROM bvt_prod.Movers_Best_View_Forecast_VW
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
FROM bvt_prod.XSell_Best_View_Forecast_VW
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
FROM bvt_prod.Email_Best_View_Forecast_VW
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
FROM bvt_prod.Mig_Forecast_VW
where Forecast_Daydate > '2016-01-01'
group by Owner_type_matrix_id_FK 
	, Forecast_Daydate
	, KPI_Type
	, Product_Code
	, channel