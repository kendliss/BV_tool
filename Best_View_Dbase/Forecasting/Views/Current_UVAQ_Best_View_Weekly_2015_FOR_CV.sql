


CREATE VIEW [Forecasting].[Current_UVAQ_Best_View_Weekly_2015_FOR_CV]
  
  
AS  
SELECT [Touch_Type_FK]
      ,[Audience]
      ,[Project]
      ,[Media_Type]
      ,[Program_Owner]
      ,[Media_Week]
      ,[MediaMonth_Long]
      ,[InHome_Date]
      ,[BV_Finance_Budget]
      ,[BV_Project_Budget]
      ,[BV_Drop_Volume]
 ,BV_Calls * 0.989904058789604 as BV_Calls 
 ,BV_Clicks * 0.979161969109371 as BV_Clicks 
 ,BV_Call_TV_Sales * 0.98589905026764 as BV_Call_TV_Sales 
 ,BV_Call_Dish_Sales * 0.985975958786492 as BV_Call_Dish_Sales 
 ,BV_Call_HSIA_Sales * 1.0006676715231 as BV_Call_HSIA_Sales 
 ,BV_Call_DSL_Reg_Sales * 0.994801685080678 as BV_Call_DSL_Reg_Sales 
 ,BV_Call_DSL_Dry_Sales * 0.990006036622175 as BV_Call_DSL_Dry_Sales 
 ,BV_Call_VOIP_Sales * 0.998954898724872 as BV_Call_VOIP_Sales 
 ,BV_Call_Access_Sales * 0.995927110487691 as BV_Call_Access_Sales 
 ,BV_Call_Wrls_Voice_Sales * 0.989184154990111 as BV_Call_Wrls_Voice_Sales 
 ,BV_Call_WRLS_Data_Sales * 1.0074093206519 as BV_Call_WRLS_Data_Sales 
 ,BV_Call_WRLS_Family_Sales * 1.0032199397752 as BV_Call_WRLS_Family_Sales 
 ,BV_Call_IPDSL_Sales * 0.99930469888976 as BV_Call_IPDSL_Sales 
 ,BV_Online_TV_Sales * 0.922181924300962 as BV_Online_TV_Sales 
 ,BV_Online_Dish_Sales * 1.01754385964912 as BV_Online_Dish_Sales 
 ,BV_Online_HSIA_Sales * 0.984806935077212 as BV_Online_HSIA_Sales 
 ,BV_Online_DSL_Reg_Sales * 1.02654867256637 as BV_Online_DSL_Reg_Sales 
 ,BV_Online_DSL_Dry_Sales * 1 as BV_Online_DSL_Dry_Sales 
 ,BV_Online_VOIP_Sales * 0.981029563453477 as BV_Online_VOIP_Sales 
 ,BV_Online_Access_Sales * 0.995153473344104 as BV_Online_Access_Sales 
 ,BV_Online_Wrls_Voice_Sales * 0.950884795955219 as BV_Online_Wrls_Voice_Sales 
 ,BV_Online_WRLS_Data_Sales * 1.0655737704918 as BV_Online_WRLS_Data_Sales 
 ,BV_Online_WRLS_Family_Sales * 1 as BV_Online_WRLS_Family_Sales 
 ,BV_Online_IPDSL_Sales * 0.990108803165183 as BV_Online_IPDSL_Sales 
 ,[BV_Directed_Strategic_Call_Sales] * 0.994394835377475 as [BV_Directed_Strategic_Call_Sales] 
 ,[BV_Directed_Strategic_Online_Sales] * 0.948100079039148 as [BV_Directed_Strategic_Online_Sales] 

  FROM [UVAQ].[Forecasting].[Current_UVAQ_Best_View_Weekly_2015]
