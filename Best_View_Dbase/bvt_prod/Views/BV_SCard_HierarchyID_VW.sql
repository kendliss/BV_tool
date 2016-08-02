ALTER VIEW [bvt_prod].[BV_SCard_HierarchyID_VW]
	AS 
	
SELECT
	Owner_type_matrix_id_FK as hierarchy_id
	, Media_Year
	, Media_Week
	, Media_Month
	, month(Forecast_Daydate) as calendar_month
	, KPI_Type
	, Product_Code
	, sum(Forecast) as forecast
FROM bvt_prod.[ACQ_Best_View_Forecast_VW]
where media_year>=2016
group by Owner_type_matrix_id_FK 
	, Media_Year
	, Media_Week
	, Media_Month
	, month(Forecast_Daydate) 
	, KPI_Type
	, Product_Code

union all
/*Temporary removal of BM Best view as it is not yet active 5-3-2016
Select Owner_type_matrix_id_FK as hierarchy_id
	, Media_Year
	, Media_Week
	, Media_Month
	, month(Forecast_Daydate) as calendar_month
	, KPI_Type
	, Product_Code
	, sum(Forecast)  as forecast 
FROM bvt_prod.BM_Forecast_VW
where media_year>=2016
group by Owner_type_matrix_id_FK 
	, Media_Year
	, Media_Week
	, Media_Month
	, month(Forecast_Daydate) 
	, KPI_Type
	, Product_Code
*/
-----This code pulls in the bill media touches from the old UVLB and VALB best views
SELECT
	Owner_type_matrix_id_FK as hierarchy_id
	, Media_Year
	, Media_Week
	, Media_Month
	, month(Forecast_Daydate) as calendar_month
	, KPI_Type
	, Product_Code
	, sum(Forecast) as forecast
FROM bvt_prod.[UVLB_Best_View_Forecast_VW]
where media_year>=2016
	and media in ('BI','FYI','FPC','Onsert','OE','RE','BAM')
group by Owner_type_matrix_id_FK 
	, Media_Year
	, Media_Week
	, Media_Month
	, month(Forecast_Daydate) 
	, KPI_Type
	, Product_Code

union all

SELECT
	Owner_type_matrix_id_FK as hierarchy_id
	, Media_Year
	, Media_Week
	, Media_Month
	, month(Forecast_week_date) as calendar_month
	, KPI_Type
	, Product_Code
	, sum(Forecast) as forecast
FROM bvt_prod.[VALB_Best_View_Forecast_VW]
where media_year>=2016
	and media in ('BI','FYI','FPC','Onsert','OE','RE','BAM')
group by Owner_type_matrix_id_FK 
	, Media_Year
	, Media_Week
	, Media_Month
	, month(Forecast_week_date) 
	, KPI_Type
	, Product_Code

union all
-----End of Temporary code for use of UVLB and VALB for bill media

Select Owner_type_matrix_id_FK as hierarchy_id
	, Media_Year
	, Media_Week
	, Media_Month
	, month(Forecast_Daydate) as calendar_month
	, KPI_Type
	, Product_Code
	, sum(Forecast)  as forecast
FROM bvt_prod.CLM_Revenue_Forecast_VW
where media_year>=2016 and media_week<=27
group by Owner_type_matrix_id_FK 
	, Media_Year
	, Media_Week
	, Media_Month
	, month(Forecast_Daydate) 
	, KPI_Type
	, Product_Code

union all

Select Owner_type_matrix_id_FK as hierarchy_id
	, Media_Year
	, Media_Week
	, Media_Month
	, month(Forecast_Daydate) as calendar_month
	, KPI_Type
	, Product_Code
	, sum(Forecast)  as forecast
FROM bvt_prod.Movers_Best_View_Forecast_VW
where media_year>=2016
group by Owner_type_matrix_id_FK 
	, Media_Year
	, Media_Week
	, Media_Month
	, month(Forecast_Daydate) 
	, KPI_Type
	, Product_Code

union all

Select Owner_type_matrix_id_FK as hierarchy_id
	, Media_Year
	, Media_Week
	, Media_Month
	, month(Forecast_Daydate) as calendar_month
	, KPI_Type
	, Product_Code
	, sum(Forecast)  as forecast
FROM bvt_prod.UCLM_Best_View_Forecast_VW
where media_year>=2016 and media_week<=27
group by Owner_type_matrix_id_FK 
	, Media_Year
	, Media_Week
	, Media_Month
	, month(Forecast_Daydate) 
	, KPI_Type
	, Product_Code

union all

Select Owner_type_matrix_id_FK as hierarchy_id
	, Media_Year
	, Media_Week
	, Media_Month
	, month(Forecast_Daydate) as calendar_month
	, KPI_Type
	, Product_Code
	, sum(Forecast)  as forecast
FROM bvt_prod.XSell_Best_View_Forecast_VW
where media_year>=2016
group by Owner_type_matrix_id_FK 
	, Media_Year
	, Media_Week
	, Media_Month
	, month(Forecast_Daydate) 
	, KPI_Type
	, Product_Code

