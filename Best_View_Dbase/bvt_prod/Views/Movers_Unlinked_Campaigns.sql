DROP VIEW [bvt_prod].[Movers_Unlinked_Campaigns]
GO

CREATE VIEW [bvt_prod].[Movers_Unlinked_Campaigns]
	AS SELECT [eCRW_Project_Name], [Project_Id], [ParentID], [Campaign_Name], [Campaign_Parent_Name], [Campaign_Description], [media_code]
		,[Start_Date], [End_Date_Traditional],  [Toll_Free_Numbers] , [URL_List] , [CTD_Quantity], [CTD_Budget], [CTD_Dir_Calls], [CTD_Dir_Clicks]
	FROM javdb.ireport.[dbo].[IR_Campaign_Data_Latest_MAIN_2012]
	where  
	program='Movers' 
	and	parentid not in (SELECT Source_System_id 
		from [bvt_processed].[Movers_Flight_Plan] as fltpln
			inner join [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records] as junction
			on fltpln.idFlight_Plan_Records=junction.idFlight_Plan_Records_FK
			inner join [bvt_prod].[External_ID_linkage_TBL] as extrnl
			on junction.idExternal_ID_linkage_TBL_FK=extrnl.idExternal_ID_linkage_TBL
			
		where idSource_System_LU_FK=1
			and idSource_Field_Name_LU_FK=1
		group by Source_System_ID)
