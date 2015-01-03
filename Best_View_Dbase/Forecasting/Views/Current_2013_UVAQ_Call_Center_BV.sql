CREATE VIEW Forecasting.Current_2013_UVAQ_Call_Center_BV

AS

SELECT

	Project,
	Media_Type,
	Program_Owner,
	Media_Week,
	InHome_Date,
	Case when Audience like '%DMDR%' then 'DMDR'
	     when Audience like '%BL%' then 'HISP'
		 else 'CCC/LT'
		 End as Call_Center,
--Scorecard Actuals ITP
	Sum(Actual_Apportioned_Budget) as Actual_Apportioned_Budget,
	Sum(Actual_Apportioned_Volume) as Actual_Apportioned_Volume,
	Sum(Actual_Project_Budget) as Actual_Project_Budget,
	Sum(Actual_Calls) as Actual_Calls,
	Sum(Actual_Clicks) as Actual_Clicks,
	Sum(Actual_Call_TV) as Actual_Call_TV,
	Sum(Actual_Online_TV_Sales) as Actual_Online_TV_Sales,
	Sum(Actual_Call_HSIA_Sales) as Actual_Call_HSIA_Sales,
	Sum(Actual_Online_HSIA_Sales) as Actual_Online_HSIA_Sales,
	Sum(Actual_Call_VOIP_Sales) as Actual_Call_VOIP_Sales,
	Sum(Actual_Online_VOIP_Sales) as Actual_Online_VOIP_Sales,
	Sum(Actual_Directed_Strategic_Call_Sales) as Actual_Directed_Strategic_Call_Sales,
	Sum(Actual_Directed_Strategic_Online_Sales) as Actual_Directed_Strategic_Online_Sales,
	

	Sum(Actual_Call_Wrls_Voice_Sales) as Actual_Call_Wrls_Voice_Sales,
	Sum(Actual_Online_Wrls_Voice_Sales) as Actual_Online_Wrls_Voice_Sales,
	Sum(Actual_Call_WRLS_Family_Sales) as Actual_Call_WRLS_Family_Sales,
	Sum(Actual_Online_WRLS_Family_Sales) as Actual_Online_WRLS_Family_Sales,
	Sum(Actual_Call_WRLS_Data_Sales) as Actual_Call_WRLS_Data_Sales,
	Sum(Actual_Online_WRLS_Data_Sales) as Actual_Online_WRLS_Data_Sales,
	Sum(Actual_Call_Dish_Sales) as Actual_Call_Dish_Sales,
	Sum(Actual_Online_Dish_Sales) as Actual_Online_Dish_Sales,
	Sum(Actual_Call_DSL_Reg_Sales) as Actual_Call_DSL_Reg_Sales,
	Sum(Actual_Online_DSL_Reg_Sales) as Actual_Online_DSL_Reg_Sales,
	Sum(Actual_Call_DSL_Dry_Sales) as Actual_Call_DSL_Dry_Sales,
	Sum(Actual_Online_DSL_Dry_Sales) as Actual_Online_DSL_Dry_Sales,
	Sum(Actual_Call_IPDSL_Sales) as Actual_Call_IPDSL_Sales,
	Sum(Actual_Online_IPDSL_Sales) as Actual_Online_IPDSL_Sales,
	Sum(Actual_Call_Access_Sales) as Actual_Call_Access_Sales,
	Sum(Actual_Online_Access_Sales) as Actual_Online_Access_Sales,

	
--Best View	
	Sum(BV_Finance_Budget) as BV_Finance_Budget,
	Sum(BV_Project_Budget) as BV_Project_Budget,
	Sum(BV_Drop_Volume) as BV_Drop_Volume,



	Sum(BV_Calls) as BV_Calls,
	Sum(BV_Clicks) as BV_Clicks,
	Sum(BV_Call_TV_Sales) as BV_Call_TV_Sales,
	Sum(BV_Online_TV_Sales) as BV_Online_TV_Sales,
	Sum(BV_Call_HSIA_Sales) as BV_Call_HSIA_Sales,
	Sum(BV_Online_HSIA_Sales) as  BV_Online_HSIA_Sales,
	Sum(BV_Call_VOIP_Sales) as  BV_Call_VOIP_Sales,
	Sum(BV_Online_VOIP_Sales) as  BV_Online_VOIP_Sales,

	Sum(BV_Call_DSL_Reg_Sales) as  BV_Call_DSL_Reg_Sales,
	Sum(BV_Call_DSL_Dry_Sales) as  BV_Call_DSL_Dry_Sales,
	Sum(BV_Call_Access_Sales) as  BV_Call_Access_Sales,
	Sum(BV_Call_Wrls_Voice_Sales) as  BV_Call_Wrls_Voice_Sales,
	Sum(BV_Call_Dish_Sales) as  BV_Call_Dish_Sales,
	Sum(BV_Call_WRLS_Family_Sales) as  BV_Call_WRLS_Family_Sales,
	Sum(BV_Call_WRLS_Data_Sales) as  BV_Call_WRLS_Data_Sales,
	Sum(BV_Call_IPDSL_Sales) as  BV_Call_IPDSL_Sales,

	Sum(BV_Online_DSL_Reg_Sales) as  BV_Online_DSL_Reg_Sales,
	Sum(BV_Online_DSL_Dry_Sales) as  BV_Online_DSL_Dry_Sales,
	Sum(BV_Online_Access_Sales) as  BV_Online_Access_Sales,
	Sum(BV_Online_Wrls_Voice_Sales) as  BV_Online_Wrls_Voice_Sales,
	Sum(BV_Online_Dish_Sales) as  BV_Online_Dish_Sales,
	Sum(BV_Online_WRLS_Family_Sales) as  BV_Online_WRLS_Family_Sales,
	Sum(BV_Online_WRLS_Data_Sales) as  BV_Online_WRLS_Data_Sales,
	Sum(BV_Online_IPDSL_Sales) as  BV_Online_IPDSL_Sales,

	Sum(BV_Directed_Strategic_Call_Sales) as  BV_Directed_Strategic_Call_Sales,
	Sum(BV_Directed_Strategic_Online_Sales) as  BV_Directed_Strategic_Online_Sales,
	  
--Commitment View
	Sum(CV_Budget) as CV_Budget,
	Sum(CV_Project_Budget) as CV_Project_Budget,
	Sum(CV_Volume) as CV_Volume,
	Sum(CV_Calls) as CV_Calls,
	Sum(CV_Clicks) as CV_Clicks,
	Sum(CV_Call_TV_Sales ) as CV_Call_TV_Sales, 
	Sum(CV_Call_HSIA_Sales) as CV_Call_HSIA_Sales,
	Sum(CV_Online_TV_Sales) as CV_Online_TV_Sales,
	Sum(CV_Online_HSIA_Sales) as CV_Online_HSIA_Sales,
	Sum(CV_Call_VOIP_Sales) as CV_Call_VOIP_Sales,
	Sum(CV_Online_VOIP_Sales) as CV_Online_VOIP_Sales,
	Sum(CV_Directed_Strategic_Call_Sales) as CV_Directed_Strategic_Call_Sales,
	Sum(CV_Directed_Strategic_Online_Sales) as CV_Directed_Strategic_Online_Sales,

	Sum(CV_DSLREG_Call_Sales) as  CV_DSLREG_Call_Sales,
	Sum(CV_DSLREG_Click_Sales) as  CV_DSLREG_Click_Sales,
	Sum(CV_DSLDRY_Call_Sales) as  CV_DSLDRY_Call_Sales,
	Sum(CV_DSLDRY_Click_Sales) as  CV_DSLDRY_Click_Sales,
	Sum(CV_ACCLNE_Call_Sales) as  CV_ACCLNE_Call_Sales,
	Sum(CV_ACCLNE_Click_Sales) as  CV_ACCLNE_Click_Sales,
	Sum(CV_Wireless_Voice_Call_Sales) as  CV_Wireless_Voice_Call_Sales,
	Sum(CV_Wireless_Voice_Click_Sales) as  CV_Wireless_Voice_Click_Sales,
	Sum(CV_Wireless_Family_Call_Sales) as  CV_Wireless_Family_Call_Sales,
	Sum(CV_Wireless_Family_Click_Sales) as  CV_Wireless_Family_Click_Sales,
	Sum(CV_Wireless_Data_Call_Sales) as  CV_Wireless_Data_Call_Sales,
	Sum(CV_Wireless_Data_Click_Sales) as  CV_Wireless_Data_Click_Sales,
	Sum(CV_IPDSL_Call_Sales) as  CV_IPDSL_Call_Sales,
	Sum(CV_IPDSL_Click_Sales) as  CV_IPDSL_Click_Sales,
	Sum(CV_DISH_Call_Sales) as  CV_DISH_Call_Sales,
	Sum(CV_DISH_Click_Sales) as  CV_DISH_Click_Sales

	from Forecasting.Current_2013_UVAQ_Best_View_Weekly_Touch_Type

	Group By 	Project,
				Media_Type,
				Audience,
				Program_Owner,
				Media_Week,
				InHome_Date