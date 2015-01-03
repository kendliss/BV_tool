
CREATE VIEW Forecasting.Best_View_Monthly_2013


as SELECT Project,
	Media_Type,
	Program_Owner,
	[Month],
	InHome_Date,
	Audience,
	isnull(sum(Actual_Apportioned_Budget),0) as Actual_Apportioned_Budget,
	isnull(sum(Actual_Apportioned_Volume),0) as Actual_Apportioned_Volume,
	isnull(sum(Actual_Volume),0) as Actual_Project_Volume,
	isnull(sum(Actual_Budget),0) as Actual_Project_Budget,
	isnull(sum(Actual_Calls),0) as Actual_Calls,
	isnull(sum(Actual_Clicks),0) as Actual_Clicks,
	isnull(sum(Actual_Call_TV),0) as Actual_Call_TV_Sales,
	isnull(sum(Actual_Online_TV_Sales),0) as Actual_Online_TV_Sales,
	isnull(sum(Actual_Call_HSIA_Sales),0) as Actual_Call_HSIA_Sales,
	isnull(sum(Actual_Online_HSIA_Sales),0) as Actual_Online_HSIA_Sales,
	isnull(sum(Actual_Call_VOIP_Sales),0) as Actual_Call_VOIP_Sales,
	isnull(sum(Actual_Online_VOIP_Sales),0) as Actual_Online_VOIP_Sales,
	isnull(sum(Actual_Directed_Strategic_Call_Sales),0) as Actual_Directed_Strategic_Call_Sales,
	isnull(sum(Actual_Directed_Strategic_Online_Sales),0) as Actual_Directed_Strategic_Online_Sales,
	--amy add
	isnull(sum(Actual_Call_Wrls_Voice_Sales),0) as Actual_Call_Wrls_Voice_Sales,
	isnull(sum(Actual_Online_Wrls_Voice_Sales),0) as Actual_Online_Wrls_Voice_Sales,
	isnull(sum(Actual_Call_WRLS_Family_Sales),0) as Actual_Call_WRLS_Family_Sales,
	isnull(sum(Actual_Online_WRLS_Family_Sales),0) as Actual_Online_WRLS_Family_Sales,
	isnull(sum(Actual_Call_WRLS_Data_Sales),0) as Actual_Call_WRLS_Data_Sales,
	isnull(sum(Actual_Online_WRLS_Data_Sales),0) as Actual_Online_WRLS_Data_Sales,
	isnull(sum(Actual_Call_Dish_Sales),0) as Actual_Call_Dish_Sales,
	isnull(sum(Actual_Online_Dish_Sales),0) as Actual_Online_Dish_Sales,
	isnull(sum(Actual_Call_DSL_Reg_Sales),0) as Actual_Call_DSL_Reg_Sales,
	isnull(sum(Actual_Online_DSL_Reg_Sales),0) as Actual_Online_DSL_Reg_Sales,
	isnull(sum(Actual_Call_DSL_Dry_Sales),0) as Actual_Call_DSL_Dry_Sales,
	isnull(sum(Actual_Online_DSL_Dry_Sales),0) as Actual_Online_DSL_Dry_Sales,
	isnull(sum(Actual_Call_IPDSL_Sales),0) as Actual_Call_IPDSL_Sales,
	isnull(sum(Actual_Online_IPDSL_Sales),0) as Actual_Online_IPDSL_Sales,
	isnull(sum(Actual_Call_Access_Sales),0) as Actual_Call_Access_Sales,
	isnull(sum(Actual_Online_Access_Sales),0) as Actual_Online_Access_Sales,
	--end amy add
	
	
--Best View, Combineds actual and forecast data
	isnull(sum(BV_Finance_Budget),0) as BV_Finance_Budget,
	isnull(sum(BV_Drop_Volume),0) as BV_Drop_Volume,
	isnull(sum(BV_Project_Budget),0) as BV_Project_Budget,
	
	sum(BV_Calls) as BV_Calls,
	sum(BV_Clicks) as BV_Clicks,
	sum(BV_Call_TV_Sales)as BV_Call_TV_Sales,	
	sum(BV_Online_TV_Sales) as BV_Online_TV_Sales,
	sum(BV_Call_HSIA_Sales) as BV_Call_HSIA_Sales,
	sum(BV_Online_HSIA_Sales) as BV_Online_HSIA_Sales,
	sum(BV_Call_VOIP_Sales) as BV_Call_VOIP_Sales,
	sum(BV_Online_VOIP_Sales) as BV_Online_VOIP_Sales,
	sum(BV_Directed_Strategic_Call_Sales) as BV_Directed_Strategic_Call_Sales,
	sum(BV_Directed_Strategic_Online_Sales) as BV_Directed_Strategic_Online_Sales, 
	--amy add
	sum(BV_Call_DSL_Reg_Sales) as BV_Call_DSL_Reg_Sales,
	sum(BV_Call_DSL_Dry_Sales) as BV_Call_DSL_Dry_Sales,
	sum(BV_Call_Access_Sales) as BV_Call_Access_Sales,
	sum(BV_Call_Wrls_Voice_Sales) as BV_Call_Wrls_Voice_Sales,
	sum(BV_Call_Dish_Sales) as BV_Call_Dish_Sales,
	sum(BV_Call_WRLS_Family_Sales) as BV_Call_WRLS_Family_Sales,
	sum(BV_Call_WRLS_Data_Sales) as BV_Call_WRLS_Data_Sales,
	sum(BV_Call_IPDSL_Sales) as BV_Call_IPDSL_Sales,
	sum(BV_Online_DSL_Reg_Sales) as BV_Online_DSL_Reg_Sales,
	sum(BV_Online_DSL_Dry_Sales) as BV_Online_DSL_Dry_Sales,
	sum(BV_Online_Access_Sales) as BV_Online_Access_Sales,
	sum(BV_Online_Wrls_Voice_Sales) as BV_Online_Wrls_Voice_Sales,
	sum(BV_Online_Dish_Sales) as BV_Online_Dish_Sales,
	sum(BV_Online_WRLS_Family_Sales) as BV_Online_WRLS_Family_Sales,
	sum(BV_Online_WRLS_Data_Sales) as BV_Online_WRLS_Data_Sales,
	sum(BV_Online_IPDSL_Sales) as BV_Online_IPDSL_Sales,
    --amy add end
	
	
	----Commitment View Data-------------------------------------------
	isnull(sum(CV_Finance_Budget),0) as CV_Finance_Budget,
isnull(sum(CV_Project_Budget),0) as CV_Project_Budget,
isnull(sum(CV_Drop_Volume),0) as CV_Drop_Volume,
isnull(sum(CV_Calls),0) as CV_Calls,
isnull(sum(CV_Clicks),0) as CV_Clicks,
isnull(sum(CV_Call_TV_Sales),0) as CV_Call_TV_Sales,
isnull(sum(CV_Call_HSIA_Sales),0) as CV_Call_HSIA_Sales,
isnull(sum(CV_Online_TV_Sales),0) as CV_Online_TV_Sales,
isnull(sum(CV_Online_HSIA_Sales),0) as CV_Online_HSIA_Sales,
isnull(sum(CV_Call_VOIP_Sales),0) as CV_Call_VOIP_Sales,
isnull(sum(CV_Online_VOIP_Sales),0) as CV_Online_VOIP_Sales,
isnull(sum(CV_Directed_Strategic_Call_Sales),0) as CV_Directed_Strategic_Call_Sales,
isnull(sum(CV_Directed_Strategic_Online_Sales),0) as CV_Directed_Strategic_Online_Sales,
isnull(sum(CV_Call_DSL_Reg_Sales),0) as CV_Call_DSL_Reg_Sales,
isnull(sum(CV_Online_DSL_Reg_Sales),0) as CV_Online_DSL_Reg_Sales,
isnull(sum(CV_Call_dsl_dry_Sales),0) as CV_Call_dsl_dry_Sales,
isnull(sum(CV_Online_DSL_Dry_Sales),0) as CV_Online_DSL_Dry_Sales,
isnull(sum(CV_Call_access_Sales),0) as CV_Call_access_Sales,
isnull(sum(CV_online_access_Sales),0) as CV_online_access_Sales,
isnull(sum(CV_Call_Wrls_Voice_Sales),0) as CV_Call_Wrls_Voice_Sales,
isnull(sum(CV_Online_Wrls_Voice_Sales),0) as CV_Online_Wrls_Voice_Sales,
isnull(sum(CV_Call_Wrls_Family_Sales),0) as CV_Call_Wrls_Family_Sales,
isnull(sum(CV_online_Wrls_Family_Sales),0) as CV_online_Wrls_Family_Sales,
isnull(sum(CV_call_Wrls_data_Sales),0) as CV_call_Wrls_data_Sales,
isnull(sum(CV_online_Wrls_data_Sales),0) as CV_online_Wrls_data_Sales,
isnull(sum(CV_Call_IPDSL_Sales),0) as CV_Call_IPDSL_Sales,
isnull(sum(CV_Online_IPDSL_Sales),0) as CV_Online_IPDSL_Sales,
isnull(sum(CV_call_DISH_Sales),0) as CV_call_DISH_Sales,
isnull(sum(CV_Online_DISH_Sales),0) as CV_Online_DISH_Sales
----------------End CV Data----------------------------------------------------------
	

FROM Forecasting.Current_UVAQ_Best_View_Weekly_2013
	INNER JOIN DIM.Media_Calendar ON Forecasting.Current_UVAQ_Best_View_Weekly_2013.Media_Week=DIM.Media_Calendar.[ISO_Week]
		WHERE ISO_Week_YYYYWW>201253 and ISO_Week_YYYYWW<201401
	GROUP BY 
	Project,
	Media_Type,
	Program_Owner,
	[Month],
	InHome_Date,
	Audience