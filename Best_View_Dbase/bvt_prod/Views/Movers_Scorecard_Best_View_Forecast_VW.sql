DROP VIEW [bvt_prod].Movers_Scorecard_Best_View_Forecast_VW
GO

CREATE VIEW [bvt_prod].[Movers_Scorecard_Best_View_Forecast_VW]
	AS 

----Active Best View Data----	
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
------Budget Data-----------
	select [owner_type_matrix_id_FK] as tactic_id, [Media], 'Budget' as KPI_TYPE, 'Budget' as Product_Code, [bill_year] as Media_Year,
		[bill_month] as Media_Month, mediaweek as Media_Week, sum(budget) as Forecast

	

	FROM [bvt_prod].[Movers_Financial_Budget_Forecast]
	where [owner_type_matrix_id_FK] is not null
	GROUP BY [owner_type_matrix_id_FK], [Media], [bill_year], [bill_month], mediaweek

	union 
--------Drag Calls-----------
----pulling movers drag from the drag table
----careful! the id is hard coded here and I should try to fix in future revisions
	select 150801 as tactic_id, 'DR' as media, 'Response' as kpi_type, 'Call' as product_code, Media_Year, Media_Month, Media_Week, sum(Drag_calls) as Forecast
	FROM [bvt_prod].[Movers_Drag_Forecast_VW]
	group by  Media_Year, Media_Month, Media_Week

	union 
-------Drag Sales-----------
	select 150801, 'DR', 'Telesales', Product_Code, Media_Year, Media_Month, Media_Week, sum(drag_calls*conversion_rate) as Forecast

		from [bvt_prod].[Movers_Drag_Forecast_VW] as a 
			inner join bvt_prod.Drag_Conversion_Start_End_VW as b
				on a.date<b.end_date and a.date>=b.[Conv_Rate_Start_Date] 
			inner join [bvt_prod].[Product_LU_TBL] 
				on idProduct_LU_TBL_FK=idProduct_LU_TBL
------------------------Warning!!!!! Hardcoded id for Movers Drag HERE!!!!!!!!!-------------
			where idProgram_Touch_Definitions_TBL_FK=417
		group by Product_Code, Media_Year, Media_Month, Media_Week
-----------------------Could potentially generalize this code for all drag once everything in tool------------