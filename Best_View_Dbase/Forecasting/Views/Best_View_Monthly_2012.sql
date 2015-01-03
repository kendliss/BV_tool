
CREATE VIEW Forecasting.Best_View_Monthly_2012

as SELECT
	Coalesce(BV_Weekly_Query.Project,cv_budget_query.Project) as Project,
	Coalesce(BV_Weekly_Query.Media_Type,cv_budget_query.Media_Type) as Media_Type,
	Coalesce(BV_Weekly_Query.Program_Owner,cv_budget_query.Program_Owner) as Program_Owner,
	Coalesce(BV_Weekly_Query.[Month], cv_budget_query.[month]) as [Month],
	Coalesce(BV_Weekly_Query.InHome_Date,cv_budget_query.InHome_Date) as InHome_Date,
	Actual_Apportioned_Budget,
	Actual_Apportioned_Volume,
	Actual_Project_Budget,
	Actual_Calls,
	Actual_Clicks,
	Actual_Call_TV_Sales,
	Actual_Online_TV_Sales,
	Actual_Call_HSIA_Sales,
	Actual_Online_HSIA_Sales,
	Actual_Call_VOIP_Sales,
	Actual_Online_VOIP_Sales,
	Actual_Directed_Strategic_Call_Sales,
	Actual_Directed_Strategic_Online_Sales,
	
	--amy add
	Actual_Call_Wrls_Voice_Sales,
	Actual_Online_Wrls_Voice_Sales,
	Actual_Call_WRLS_Family_Sales,
	Actual_Online_WRLS_Family_Sales,
	Actual_Call_WRLS_Data_Sales,
	Actual_Online_WRLS_Data_Sales,
	Actual_Call_Dish_Sales,
	Actual_Online_Dish_Sales,
	Actual_Call_DSL_Reg_Sales,
	Actual_Online_DSL_Reg_Sales,
	Actual_Call_DSL_Dry_Sales,
	Actual_Online_DSL_Dry_Sales,
	Actual_Call_IPDSL_Sales,
	Actual_Online_IPDSL_Sales,
	Actual_Call_Access_Sales,
	Actual_Online_Access_Sales,
    -- end amy add
	
--Best View, Combineds actual and forecast data
	BV_Finance_Budget,
	BV_Drop_Volume,
	BV_Project_Budget,
	
	BV_Calls,
	BV_Clicks,
	BV_Call_TV_Sales,	
	BV_Online_TV_Sales,
	BV_Call_HSIA_Sales,
	BV_Online_HSIA_Sales,
	BV_Call_VOIP_Sales,
	BV_Online_VOIP_Sales,
	BV_Directed_Strategic_Call_Sales,
	BV_Directed_Strategic_Online_Sales, 
	--amy add
	BV_Call_DSL_Reg_Sales,
	BV_Call_DSL_Dry_Sales,
	BV_Call_Access_Sales,
	BV_Call_Wrls_Voice_Sales,
	BV_Call_Dish_Sales,
	BV_Call_WRLS_Family_Sales,
	BV_Call_WRLS_Data_Sales,
	BV_Call_IPDSL_Sales,
	BV_Online_DSL_Reg_Sales,
	BV_Online_DSL_Dry_Sales,
	BV_Online_Access_Sales,
	BV_Online_Wrls_Voice_Sales,
	BV_Online_Dish_Sales,
	BV_Online_WRLS_Family_Sales,
	BV_Online_WRLS_Data_Sales,
	BV_Online_IPDSL_Sales,
	--end amy add
	
	isnull(sum(cv_budget_query.CV_Budget),0)as CV_Budget,
	CV_Project_Budget,
	CV_Volume,
	CV_Clicks,
	CV_Calls,
	CV_Call_TV_Sales, 
	CV_Call_HSIA_Sales,
	CV_Online_TV_Sales,
	CV_Online_HSIA_Sales,
	CV_Call_VOIP_Sales,
	CV_Online_VOIP_Sales,
	CV_Directed_Strategic_Call_Sales,
	CV_Directed_Strategic_Online_Sales,
	--amy add
	 CV_DSLREG_Call_Sales,
	 CV_DSLREG_Click_Sales,
	 CV_DSLDRY_Call_Sales,
	 CV_DSLDRY_Click_Sales,
	 CV_ACCLNE_Call_Sales,
	 CV_ACCLNE_Click_Sales,
	 CV_Wireless_Voice_Call_Sales,
	 CV_Wireless_Voice_Click_Sales,
	 CV_Wireless_Family_Call_Sales,
	 CV_Wireless_Family_Click_Sales,
	 CV_Wireless_Data_Call_Sales,
	 CV_Wireless_Data_Click_Sales,
	 CV_IPDSL_Call_Sales,
	 CV_IPDSL_Click_Sales,
	 CV_DISH_Call_Sales,
	 CV_DISH_Click_Sales
    --end of amy add	
	
FROM	

(SELECT Project,
	Media_Type,
	Program_Owner,
	[Month],
	InHome_Date,
	isnull(sum(Actual_Apportioned_Budget),0) as Actual_Apportioned_Budget,
	isnull(sum(Actual_Apportioned_Volume),0) as Actual_Apportioned_Volume,
	isnull(sum(Actual_Project_Budget),0) as Actual_Project_Budget,
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
	
	isnull(sum(CV_Project_Budget),0) as CV_Project_Budget,
	isnull(sum(CV_Volume),0)as CV_Volume,
	isnull(sum(CV_Clicks),0)as CV_Clicks,
	isnull(sum(CV_Calls),0)as CV_Calls,
	isnull(sum(CV_Call_TV_Sales),0) as CV_Call_TV_Sales, 
	isnull(sum(CV_Call_HSIA_Sales),0)as CV_Call_HSIA_Sales,
	isnull(sum(CV_Online_TV_Sales),0)as CV_Online_TV_Sales,
	isnull(sum(CV_Online_HSIA_Sales),0)as CV_Online_HSIA_Sales,
	isnull(sum(CV_Call_VOIP_Sales),0)as CV_Call_VOIP_Sales,
	isnull(sum(CV_Online_VOIP_Sales),0)as CV_Online_VOIP_Sales,
	isnull(sum(CV_Directed_Strategic_Call_Sales),0)as CV_Directed_Strategic_Call_Sales,
	isnull(sum(CV_Directed_Strategic_Online_Sales),0)as CV_Directed_Strategic_Online_Sales,
	--amy add
	isnull(sum(CV_DSLREG_Call_Sales),0) as  CV_DSLREG_Call_Sales,
	isnull(sum(CV_DSLREG_Click_Sales),0) as  CV_DSLREG_Click_Sales,
	isnull(sum(CV_DSLDRY_Call_Sales),0) as  CV_DSLDRY_Call_Sales,
	isnull(sum(CV_DSLDRY_Click_Sales),0) as  CV_DSLDRY_Click_Sales,
	isnull(sum(CV_ACCLNE_Call_Sales),0) as  CV_ACCLNE_Call_Sales,
	isnull(sum(CV_ACCLNE_Click_Sales),0) as  CV_ACCLNE_Click_Sales,
	isnull(sum(CV_Wireless_Voice_Call_Sales),0) as  CV_Wireless_Voice_Call_Sales,
	isnull(sum(CV_Wireless_Voice_Click_Sales),0) as  CV_Wireless_Voice_Click_Sales,
	isnull(sum(CV_Wireless_Family_Call_Sales),0) as  CV_Wireless_Family_Call_Sales,
	isnull(sum(CV_Wireless_Family_Click_Sales),0) as  CV_Wireless_Family_Click_Sales,
	isnull(sum(CV_Wireless_Data_Call_Sales),0) as  CV_Wireless_Data_Call_Sales,
	isnull(sum(CV_Wireless_Data_Click_Sales),0) as  CV_Wireless_Data_Click_Sales,
	isnull(sum(CV_IPDSL_Call_Sales),0) as  CV_IPDSL_Call_Sales,
	isnull(sum(CV_IPDSL_Click_Sales),0) as  CV_IPDSL_Click_Sales,
	isnull(sum(CV_DISH_Call_Sales),0) as  CV_DISH_Call_Sales,
	isnull(sum(CV_DISH_Click_Sales),0) as  CV_DISH_Click_Sales
	--end amy add
	

FROM Forecasting.Current_UVAQ_Best_View_Weekly_2012
	INNER JOIN DIM.Media_Calendar 
	ON Forecasting.Current_UVAQ_Best_View_Weekly_2012.Media_Week=DIM.Media_Calendar.[ISO_Week]
		WHERE DIM.Media_Calendar.Week_Year=2012
	GROUP BY 
	Project,
	Media_Type,
	Program_Owner,
	[Month],
	InHome_Date) as BV_Weekly_Query
	
---Pull CV Budget by Calendar Month rather than MediaMonth because Nate was an idiot--------------	
	FULL JOIN 
	(select 
	
	(Touch_Name + ' ' + Touch_Name_2) as project, 
	Media_Type, 
	Program_Owner, 
	month(Bill_Date) as Month, 
	InHOme_Date,
	sum(Bill_Amount) as CV_Budget 
from Commitment_Versions.CV_2012_Final_Billing_View 
	
	FULL JOIN
	
(SELECT Flight_Plan_Record_ID, Media_Type, Touch_Name, Touch_Name_2, Touch_Type_ID, Audience_Type_Name as Audience, Program_Owner, InHome_Date 
				from Forecasting.Flight_Plan_Records AS A, Forecasting.Touch_Type as B, Forecasting.Media_Type as C, Forecasting.Audience as D, 
					Forecasting.Program_Owners as E
				Where A.Touch_Type_FK=B.Touch_Type_ID and B.Media_Type_FK=C.Media_Type_ID and B.Audience_FK=D.Audience_ID 
					and B.Program_Owner_FK=E.Program_Owner_ID) as flight_plan_record 
					
 ON Commitment_Versions.CV_2012_Final_Billing_View.Flight_Plan_Record_ID=flight_plan_record.Flight_Plan_Record_ID
 Where bill_date between '2012-01-01' and '2012-12-31'
 GROup by 
 (Touch_Name + ' ' + Touch_Name_2),
 Media_Type,
 Program_Owner,
 InHOme_Date,
 month(Bill_Date)) as cv_budget_query
 
 ON cv_budget_query.project=BV_Weekly_Query.project 
	and cv_budget_query.Media_Type=BV_Weekly_Query.Media_Type 
	and cv_budget_query.Program_Owner=BV_Weekly_Query.Program_Owner
	and cv_budget_query.InHome_Date=BV_Weekly_Query.InHome_Date
	and cv_budget_query.[month]=BV_Weekly_Query.[month]
	
	

	GROUP BY coalesce(BV_Weekly_Query.Project,cv_budget_query.Project),
	Coalesce(BV_Weekly_Query.Media_Type,cv_budget_query.Media_Type),
	Coalesce(BV_Weekly_Query.Program_Owner,cv_budget_query.Program_Owner),
	Coalesce(BV_Weekly_Query.[Month], cv_budget_query.[month]), 
	Coalesce(BV_Weekly_Query.InHome_Date,cv_budget_query.InHome_Date),
	Actual_Apportioned_Budget,
	Actual_Apportioned_Volume,
	Actual_Project_Budget,
	Actual_Calls,
	Actual_Clicks,
	Actual_Call_TV_Sales,
	Actual_Online_TV_Sales,
	Actual_Call_HSIA_Sales,
	Actual_Online_HSIA_Sales,
	Actual_Call_VOIP_Sales,
	Actual_Online_VOIP_Sales,
	Actual_Directed_Strategic_Call_Sales,
	Actual_Directed_Strategic_Online_Sales,
	--amy add
	Actual_Call_Wrls_Voice_Sales,
	Actual_Online_Wrls_Voice_Sales,
	Actual_Call_WRLS_Family_Sales,
	Actual_Online_WRLS_Family_Sales,
	Actual_Call_WRLS_Data_Sales,
	Actual_Online_WRLS_Data_Sales,
	Actual_Call_Dish_Sales,
	Actual_Online_Dish_Sales,
	Actual_Call_DSL_Reg_Sales,
	Actual_Online_DSL_Reg_Sales,
	Actual_Call_DSL_Dry_Sales,
	Actual_Online_DSL_Dry_Sales,
	Actual_Call_IPDSL_Sales,
	Actual_Online_IPDSL_Sales,
	Actual_Call_Access_Sales,
	Actual_Online_Access_Sales,
	--end amy add
	
--Best View, Combineds actual and forecast data
	BV_Finance_Budget,
	BV_Drop_Volume,
	BV_Project_Budget,
	
	BV_Calls,
	BV_Clicks,
	BV_Call_TV_Sales,	
	BV_Online_TV_Sales,
	BV_Call_HSIA_Sales,
	BV_Online_HSIA_Sales,
	BV_Call_VOIP_Sales,
	BV_Online_VOIP_Sales,
	BV_Directed_Strategic_Call_Sales,
	BV_Directed_Strategic_Online_Sales, 
	--amy add
	BV_Call_DSL_Reg_Sales,
	BV_Call_DSL_Dry_Sales,
	BV_Call_Access_Sales,
	BV_Call_Wrls_Voice_Sales,
	BV_Call_Dish_Sales,
	BV_Call_WRLS_Family_Sales,
	BV_Call_WRLS_Data_Sales,
	BV_Call_IPDSL_Sales,
	BV_Online_DSL_Reg_Sales,
	BV_Online_DSL_Dry_Sales,
	BV_Online_Access_Sales,
	BV_Online_Wrls_Voice_Sales,
	BV_Online_Dish_Sales,
	BV_Online_WRLS_Family_Sales,
	BV_Online_WRLS_Data_Sales,
	BV_Online_IPDSL_Sales,
	--end amy add
	
	CV_Project_Budget,
	CV_Volume,
	CV_Clicks,
	CV_Calls,
	CV_Call_TV_Sales, 
	CV_Call_HSIA_Sales,
	CV_Online_TV_Sales,
	CV_Online_HSIA_Sales,
	CV_Call_VOIP_Sales,
	CV_Online_VOIP_Sales,
	CV_Directed_Strategic_Call_Sales,
	CV_Directed_Strategic_Online_Sales,
	
	--amy add
	CV_DSLREG_Call_Sales,
	CV_DSLREG_Click_Sales,
	CV_DSLDRY_Call_Sales,
	CV_DSLDRY_Click_Sales,
	CV_ACCLNE_Call_Sales,
	CV_ACCLNE_Click_Sales,
	CV_Wireless_Voice_Call_Sales,
	CV_Wireless_Voice_Click_Sales,
	CV_Wireless_Family_Call_Sales,
	CV_Wireless_Family_Click_Sales,
	CV_Wireless_Data_Call_Sales,
	CV_Wireless_Data_Click_Sales,
	CV_IPDSL_Call_Sales,
	CV_IPDSL_Click_Sales,	
	CV_DISH_Call_Sales,
	CV_DISH_Click_Sales
	--end amy add