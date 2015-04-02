DROP VIEW [bvt_prod].Movers_Scorecard_Best_View_Forecast_VW
GO

CREATE VIEW [bvt_prod].[Movers_Scorecard_Best_View_Forecast_VW]
	AS 
	
	SELECT [owner_type_matrix_id_FK] as tactic_id,
		[Media],
		[KPI_Type],
		[Product_Code],
		[Media_Year],
		[Media_Month],
		[Media_Week],
		sum(forecast) as Forecast	
	
	FROM [bvt_prod].[Movers_Best_View_Forecast_VW]

	GROUP BY [owner_type_matrix_id_FK], [Media], 
		[KPI_Type], [Product_Code], [Media_Year], [Media_Month], [Media_Week]

	UNION

	select [owner_type_matrix_id_FK] as tactic_id, [Media], 'Budget' as KPI_TYPE, 'Budget' as Product_Code, [bill_year] as Media_Year,
		[bill_month] as Media_Month, mediaweek as Media_Week, sum(budget) as Forecast

	FROM [bvt_prod].[Movers_Financial_Budget_Forecast]
	where [owner_type_matrix_id_FK] is not null
	GROUP BY [owner_type_matrix_id_FK], [Media], [bill_year], [bill_month], mediaweek
