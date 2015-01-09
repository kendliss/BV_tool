CREATE VIEW [bvt_prod].[Movers_Unlinked_Campaigns]
	AS SELECT [Start_Date], [End_Date_Traditional], [Campaign_Name], [media_code]
		, [Toll_Free_Numbers] , [URL_List] , [CTD_Quantity], [CTD_Budget] 
	FROM javdb.ireport.[dbo].[IR_Campaign_Data_Latest_MAIN_2012]
	where  
	program='Movers' 
	and	parentid not in (SELECT Source_System_id 
		from [bvt_processed].[Movers_Flight_Plan] as fltpln
			inner join [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records] as junction
			on fltpln.idFlight_Plan_Records=junction.idFlight_Plan_Records_FK
			inner join [bvt_prod].[External_ID_linkage_TBL] as extrnl
			on junction.idExternal_ID_linkage_TBL_FK=extrnl.idExternal_ID_linkage_TBL
			
		where Source_System='Scorecard'
			and Field_Name='parentid'
		group by Source_System_ID)
