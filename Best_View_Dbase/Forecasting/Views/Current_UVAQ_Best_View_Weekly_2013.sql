
CREATE VIEW [Forecasting].[Current_UVAQ_Best_View_Weekly_2013]  
  
  
AS  
  
SELECT  
---Join Actuals with CV and BV  
 COALESCE(cv_bv_combo.Touch_Type_FK, actual.Touch_Type_FK) as Touch_Type_FK,  
 COALESCE(cv_bv_combo.Audience, actual.Audience) as Audience,  
 COALESCE(cv_bv_combo.Project, actual.Project) as Project,  
 COALESCE(cv_bv_combo.Media_Type, actual.Media_Type) as Media_Type,  
 COALESCE(cv_bv_combo.Program_Owner, actual.Program_Owner) as Program_Owner,  
 COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) as Media_Week,  
 COALESCE(cv_bv_combo.InHome_Date, actual.InHome_Date) as InHome_Date,  
--Scorecard Actuals ITP  
 Actual_Apportioned_Budget,  
 Actual_Budget,
 Actual_Apportioned_Volume,
 Actual_Volume,  
 Actual_Calls,  
 Actual_Clicks,  
 Actual_Call_TV,  
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
   
--Best View   
 BV_Finance_Budget,  
 BV_Project_Budget,  
 BV_Drop_Volume,  
  
  /*Removal to switch back to coalescing actuals with BV numbers
--A temporary Add to get rid of actuals from best view numbers   
 BV_Calls,  
 BV_Clicks,  
 BV_Call_TV_Sales,  
 BV_Online_TV_Sales,  
 BV_Call_HSIA_Sales,  
  BV_Online_HSIA_Sales,  
  BV_Call_VOIP_Sales,  
  BV_Online_VOIP_Sales,  
 --amy add (added the is null to make it like the others)  
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
  BV_Directed_Strategic_Call_Sales,  
  BV_Directed_Strategic_Online_Sales,  
 */   
/* Comment out at the end of year to stop inflating sales if refreshed in 2014 


 case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Calls   
  else Actual_Calls end as BV_Calls,  
 case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Clicks   
  else Actual_Clicks end as BV_Clicks,  
--Adjusted Actuals for Sales Lag   
 case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Call_TV_Sales  
  when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Call_TV/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Call_TV/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Call_TV/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Call_TV/0.97  
     else Actual_Call_TV end as BV_Call_TV_Sales,   
 case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Online_TV_Sales  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Online_TV_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Online_TV_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Online_TV_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Online_TV_Sales/0.97  
     else Actual_Online_TV_Sales end as BV_Online_TV_Sales,  
 case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Call_HSIA_Sales  
  when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Call_HSIA_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Call_HSIA_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Call_HSIA_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Call_HSIA_Sales/0.97  
     else Actual_Call_HSIA_Sales end as BV_Call_HSIA_Sales,  
 case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Online_HSIA_Sales  
    when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Online_HSIA_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Online_HSIA_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Online_HSIA_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Online_HSIA_Sales/0.97  
     else Actual_Online_HSIA_Sales end as BV_Online_HSIA_Sales,  
 case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Call_VOIP_Sales  
  when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Call_VOIP_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Call_VOIP_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Call_VOIP_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Call_VOIP_Sales/0.97  
     else Actual_Call_VOIP_Sales end as BV_Call_VOIP_Sales,  
 case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Online_VOIP_Sales  
    when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Online_VOIP_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Online_VOIP_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Online_VOIP_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Online_VOIP_Sales/0.97  
     else Actual_Online_VOIP_Sales end as BV_Online_VOIP_Sales,  
   
--------  
--amy add   
case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Call_DSL_Reg_Sales  
    when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Call_DSL_Reg_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Call_DSL_Reg_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Call_DSL_Reg_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Call_DSL_Reg_Sales/0.97  
     else Actual_Call_DSL_Reg_Sales end as BV_Call_DSL_Reg_Sales,  
  
case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Call_DSL_Dry_Sales  
    when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Call_DSL_Dry_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Call_DSL_Dry_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Call_DSL_Dry_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Call_DSL_Dry_Sales/0.97  
     else  Actual_Call_DSL_Dry_Sales end as BV_Call_DSL_Dry_Sales,  
       
       
case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Call_Access_Sales  
    when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Call_Access_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Call_Access_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Call_Access_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Call_Access_Sales/0.97  
     else Actual_Call_Access_Sales end as BV_Call_Access_Sales,  
  
  
case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Call_Wrls_Voice_Sales  
    when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Call_Wrls_Voice_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Call_Wrls_Voice_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Call_Wrls_Voice_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Call_Wrls_Voice_Sales/0.97  
     else Actual_Call_Wrls_Voice_Sales end as BV_Call_Wrls_Voice_Sales,  
  
case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Call_Dish_Sales  
    when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Call_Dish_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Call_Dish_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Call_Dish_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Call_Dish_Sales/0.97  
     else Actual_Call_Dish_Sales end as BV_Call_Dish_Sales,  
  
case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Call_WRLS_Family_Sales  
    when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Call_WRLS_Family_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Call_WRLS_Family_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Call_WRLS_Family_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Call_WRLS_Family_Sales/0.97  
     else Actual_Call_WRLS_Family_Sales end as BV_Call_WRLS_Family_Sales,  
  
case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Call_WRLS_Data_Sales  
    when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Call_WRLS_Data_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Call_WRLS_Data_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Call_WRLS_Data_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Call_WRLS_Data_Sales/0.97  
     else Actual_Call_WRLS_Data_Sales end as BV_Call_WRLS_Data_Sales,  
  
case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Call_IPDSL_Sales  
    when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Call_IPDSL_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Call_IPDSL_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Call_IPDSL_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Call_IPDSL_Sales/0.97  
     else Actual_Call_IPDSL_Sales end as BV_Call_IPDSL_Sales,  
  
case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Online_DSL_Reg_Sales  
    when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Online_DSL_Reg_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Online_DSL_Reg_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Online_DSL_Reg_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Online_DSL_Reg_Sales/0.97  
     else  Actual_Online_DSL_Reg_Sales end as BV_Online_DSL_Reg_Sales,  
  
case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Online_DSL_Dry_Sales  
    when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Online_DSL_Dry_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Online_DSL_Dry_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Online_DSL_Dry_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Online_DSL_Dry_Sales/0.97  
     else Actual_Online_DSL_Dry_Sales end as BV_Online_DSL_Dry_Sales,   
  
case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Online_Access_Sales  
    when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Online_Access_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Online_Access_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Online_Access_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Online_Access_Sales/0.97  
     else  Actual_Online_Access_Sales end as BV_Online_Access_Sales,   
  
case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Online_Wrls_Voice_Sales  
    when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Online_Wrls_Voice_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Online_Wrls_Voice_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Online_Wrls_Voice_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Online_Wrls_Voice_Sales/0.97  
     else  Actual_Online_Wrls_Voice_Sales end as BV_Online_Wrls_Voice_Sales,   
  
case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Online_Dish_Sales  
    when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Online_Dish_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Online_Dish_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Online_Dish_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Online_Dish_Sales/0.97  
     else Actual_Online_Dish_Sales end as BV_Online_Dish_Sales,   
  
case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Online_WRLS_Family_Sales  
    when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Online_WRLS_Family_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Online_WRLS_Family_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Online_WRLS_Family_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Online_WRLS_Family_Sales/0.97  
     else Actual_Online_WRLS_Family_Sales end as BV_Online_WRLS_Family_Sales,   
   
case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Online_WRLS_Data_Sales  
    when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Online_WRLS_Data_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Online_WRLS_Data_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Online_WRLS_Data_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Online_WRLS_Data_Sales/0.97  
     else  Actual_Online_WRLS_Data_Sales end as BV_Online_WRLS_Data_Sales,  
  
case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Online_IPDSL_Sales  
    when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Online_IPDSL_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Online_IPDSL_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Online_IPDSL_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Online_IPDSL_Sales/0.97  
     else Actual_Online_IPDSL_Sales end as BV_Online_IPDSL_Sales,  
 --end of amy add  
  
---------   
   
 case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Directed_Strategic_Call_Sales  
    when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Directed_Strategic_Call_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Directed_Strategic_Call_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Directed_Strategic_Call_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Directed_Strategic_Call_Sales/0.97  
     else Actual_Directed_Strategic_Call_Sales end as BV_Directed_Strategic_Call_Sales,  
 case when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) > DATEPART(wk,getdate())-2 then BV_Directed_Strategic_Online_Sales  
   when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-2 then  Actual_Directed_Strategic_Online_Sales/0.4  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-3 then  Actual_Directed_Strategic_Online_Sales/0.7  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-4 then  Actual_Directed_Strategic_Online_Sales/0.85  
     when COALESCE(cv_BV_combo.Media_Week, actual.Media_Week) = DATEPART(wk,getdate())-5 then  Actual_Directed_Strategic_Online_Sales/0.97  
     else Actual_Directed_Strategic_Online_Sales end as BV_Directed_Strategic_Online_Sales,   
*/
---Added for post end of the year
Actual_Calls as BV_Calls,    
 Actual_Clicks as BV_Clicks,
 Actual_Call_TV as BV_Call_TV_Sales,  
 Actual_Online_TV_Sales as BV_Online_TV_Sales,    
 Actual_Call_HSIA_Sales as BV_Call_HSIA_Sales,  
  Actual_Online_HSIA_Sales as BV_Online_HSIA_Sales,
  Actual_Call_VOIP_Sales as BV_Call_VOIP_Sales,   
 Actual_Online_VOIP_Sales as BV_Online_VOIP_Sales,    
 
  
 --amy add  
 Actual_Call_Wrls_Voice_Sales as BV_Call_Wrls_Voice_Sales,  
 Actual_Online_Wrls_Voice_Sales as BV_Online_Wrls_Voice_Sales,  
 Actual_Call_WRLS_Family_Sales as BV_Call_WRLS_Family_Sales,  
 Actual_Online_WRLS_Family_Sales as BV_Online_WRLS_Family_Sales,  
 Actual_Call_WRLS_Data_Sales as BV_Call_WRLS_Data_Sales,  
 Actual_Online_WRLS_Data_Sales as BV_Online_WRLS_Data_Sales,  
 Actual_Call_Dish_Sales as BV_Call_Dish_Sales,  
 Actual_Online_Dish_Sales as BV_Online_Dish_Sales ,  
 Actual_Call_DSL_Reg_Sales as BV_Call_DSL_Reg_Sales,  
 Actual_Online_DSL_Reg_Sales as BV_Online_DSL_Reg_Sales,  
 Actual_Call_DSL_Dry_Sales as BV_Call_DSL_Dry_Sales,  
 Actual_Online_DSL_Dry_Sales as BV_Online_DSL_Dry_Sales,  
 Actual_Call_IPDSL_Sales as BV_Call_IPDSL_Sales,  
 Actual_Online_IPDSL_Sales as BV_Online_IPDSL_Sales,  
 Actual_Call_Access_Sales as BV_Call_Access_Sales,  
 Actual_Online_Access_Sales as BV_Online_Access_Sales,
Actual_Directed_Strategic_Call_Sales as BV_Directed_Strategic_Call_Sales,  
 Actual_Directed_Strategic_Online_Sales as BV_Directed_Strategic_Online_Sales,  

 
   
   
 
   
    
   


     
--Commitment View  
 CV_Finance_Budget,  
 CV_Project_Budget,  
  CV_Drop_Volume,  
 CV_Calls,  
 CV_Clicks,  
 CV_Call_TV_Sales,   
 CV_Call_HSIA_Sales,  
 CV_Online_TV_Sales,  
 CV_Online_HSIA_Sales,  
 CV_Call_VOIP_Sales,  
 CV_Online_VOIP_Sales,  
 CV_Directed_Strategic_Call_Sales,  
 CV_Directed_Strategic_Online_Sales,  
   
 --Amy Added  
  CV_Call_DSL_Reg_Sales,  
  CV_Online_DSL_Reg_Sales,  
  CV_Call_DSL_dry_Sales,  
  CV_Online_DSL_Dry_Sales,  
  CV_call_access_Sales,  
  CV_online_access_Sales,  
  CV_Call_Wrls_Voice_Sales,  
  CV_Online_Wrls_Voice_Sales,  
  CV_Call_Wrls_Family_Sales,  
  CV_online_Wrls_Family_Sales,  
  CV_call_Wrls_data_Sales,  
  CV_online_Wrls_data_Sales,  
  CV_Call_IPDSL_Sales,  
  CV_Online_IPDSL_Sales,  
  CV_call_DISH_Sales,  
  CV_Online_DISH_Sales  
    --end of amy add  
   
---------------------Join BV with CV to create CV_BV_combo  
FROM   
  
(SELECT  
 COALESCE(cv_query.Touch_Type_FK,forecast_query.Touch_Type_FK) as Touch_Type_FK,  
 COALESCE(cv_query.Audience,forecast_query.Audience) as Audience,  
 COALESCE(cv_query.Project,forecast_query.Project) as Project,  
 COALESCE(cv_query.Media_Type,forecast_query.Media_Type) as Media_Type,  
 COALESCE(cv_query.Program_Owner,forecast_query.Program_Owner) as Program_Owner,  
 COALESCE(cv_query.Media_Week,forecast_query.Media_week) as Media_Week,  
 COALESCE(forecast_query.InHome_Date, cv_query.InHome_Date) as InHome_Date,  
 isnull(BV_Finance_Budget,0) as BV_Finance_Budget,  
 isnull(BV_Project_Budget,0) as BV_Project_Budget,  
 isnull(BV_Drop_Volume,0) as BV_Drop_Volume,  
 isnull(BV_Calls,0) as BV_Calls,  
 isnull(BV_Clicks,0)as BV_Clicks,  
 isnull(BV_Call_TV_Sales,0)as BV_Call_TV_Sales,  
 isnull(BV_Online_TV_Sales,0)as BV_Online_TV_Sales,  
 isnull(BV_Call_HSIA_Sales,0)as BV_Call_HSIA_Sales,  
 isnull(BV_Online_HSIA_Sales,0)as BV_Online_HSIA_Sales,  
 isnull(BV_Call_VOIP_Sales,0)as BV_Call_VOIP_Sales,  
 isnull(BV_Online_VOIP_Sales,0)as BV_Online_VOIP_Sales,  
 --amy add (added the is null to make it like the others)  
 isnull(BV_Call_DSL_Reg_Sales, 0) as BV_Call_DSL_Reg_Sales,  
 isnull(BV_Call_DSL_Dry_Sales, 0) as BV_Call_DSL_Dry_Sales,  
 isnull(BV_Call_Access_Sales, 0) as BV_Call_Access_Sales,  
 isnull(BV_Call_Wrls_Voice_Sales, 0) as BV_Call_Wrls_Voice_Sales,  
 isnull(BV_Call_Dish_Sales, 0) as BV_Call_Dish_Sales,  
 isnull(BV_Call_WRLS_Family_Sales, 0) as BV_Call_WRLS_Family_Sales,  
 isnull(BV_Call_WRLS_Data_Sales, 0) as BV_Call_WRLS_Data_Sales,  
 isnull(BV_Call_IPDSL_Sales, 0) as BV_Call_IPDSL_Sales,  
  
 isnull(BV_Online_DSL_Reg_Sales, 0) as BV_Online_DSL_Reg_Sales,  
 isnull(BV_Online_DSL_Dry_Sales, 0) as BV_Online_DSL_Dry_Sales,  
 isnull(BV_Online_Access_Sales, 0) as BV_Online_Access_Sales,  
 isnull(BV_Online_Wrls_Voice_Sales, 0) as BV_Online_Wrls_Voice_Sales,  
 isnull(BV_Online_Dish_Sales, 0) as BV_Online_Dish_Sales,  
 isnull(BV_Online_WRLS_Family_Sales, 0) as BV_Online_WRLS_Family_Sales,  
 isnull(BV_Online_WRLS_Data_Sales, 0) as BV_Online_WRLS_Data_Sales,  
 isnull(BV_Online_IPDSL_Sales, 0) as BV_Online_IPDSL_Sales,  
      --end amy add  
 isnull(BV_Directed_Strategic_Call_Sales,0)as BV_Directed_Strategic_Call_Sales,  
 isnull(BV_Directed_Strategic_Online_Sales,0)as BV_Directed_Strategic_Online_Sales,  
 isnull(CV_Finance_Budget,0)as CV_Finance_Budget,  
 isnull(CV_Project_Budget,0) as CV_Project_Budget,  
 isnull( CV_Drop_Volume,0)as  CV_Drop_Volume,  
 isnull(CV_Calls,0)as CV_Calls,  
 isnull(CV_Clicks,0)as CV_Clicks,  
 isnull(CV_Call_TV_Sales,0) as CV_Call_TV_Sales,   
 isnull(CV_Call_HSIA_Sales,0)as CV_Call_HSIA_Sales,  
 isnull(CV_Online_TV_Sales,0)as CV_Online_TV_Sales,  
 isnull(CV_Online_HSIA_Sales,0)as CV_Online_HSIA_Sales,  
 isnull(CV_Call_VOIP_Sales,0)as CV_Call_VOIP_Sales,  
 isnull(CV_Online_VOIP_Sales,0)as CV_Online_VOIP_Sales,  
 isnull(CV_Directed_Strategic_Call_Sales,0)as CV_Directed_Strategic_Call_Sales,  
 isnull(CV_Directed_Strategic_Online_Sales,0)as CV_Directed_Strategic_Online_Sales,  
   
 --amy add  
 isnull(CV_Call_DSL_Reg_Sales,0) as CV_Call_DSL_Reg_Sales,  
 isnull(CV_Online_DSL_Reg_Sales,0) as CV_Online_DSL_Reg_Sales,  
 isnull(CV_Call_DSL_Dry_Sales,0) as CV_Call_DSL_Dry_Sales,  
 isnull(CV_Online_DSL_Dry_Sales,0) as CV_Online_DSL_Dry_Sales,  
 isnull(CV_Call_access_Sales,0) as CV_Call_access_Sales,  
 isnull(CV_online_access_Sales,0) as CV_online_access_Sales,  
 isnull(CV_Call_Wrls_Voice_Sales,0) as CV_Call_Wrls_Voice_Sales,  
 isnull(CV_Online_Wrls_Voice_Sales,0) as CV_Online_Wrls_Voice_Sales,  
 isnull(CV_Call_Wrls_Family_Sales,0) as CV_Call_Wrls_Family_Sales,  
 isnull(CV_online_Wrls_Family_Sales,0) as CV_online_Wrls_Family_Sales,  
 isnull(CV_call_Wrls_data_Sales,0) as CV_call_Wrls_data_Sales,  
 isnull(CV_online_Wrls_data_Sales,0) as CV_online_Wrls_data_Sales,  
 isnull(CV_Call_IPDSL_Sales,0) as CV_Call_IPDSL_Sales,  
 isnull(CV_Online_IPDSL_Sales,0) as CV_Online_IPDSL_Sales,  
 isnull(CV_call_DISH_Sales,0) as CV_call_DISH_Sales,  
 isnull(CV_Online_DISH_Sales,0) as CV_Online_DISH_Sales  
    --end amy add  
   
   
---------------------Join Forecast with Touch Identifiers  
FROM  
  
(SELECT  
    (flight_plan_record.Touch_Name + ' ' + flight_plan_record.Touch_Name_2) as Project,  
 flight_plan_record.Media_Type as Media_Type,  
 flight_plan_record.Touch_Type_FK as Touch_Type_FK,  
 flight_plan_record.Audience as Audience,  
 flight_plan_record.Program_Owner as Program_Owner,  
 campaign_query.Media_week as Media_Week,  
 flight_plan_record.InHome_Date,  
 isnull(round(sum(Budget),2),0) as BV_Finance_Budget,  
 isnull(round(sum(Project_Budget),2),0) as BV_Project_Budget,  
 isnull(round(sum(Volume),0),0) as BV_Drop_Volume,  
 isnull(round(sum(Calls),2),0) as BV_Calls,  
 isnull(round(sum(Clicks),2),0) as BV_Clicks,  
 isnull(round(sum(Call_TV_Sales),2),0) as BV_Call_TV_Sales,  
 isnull(round(sum(Online_TV_Sales),2),0) as BV_Online_TV_Sales,  
 isnull(round(sum(Call_HSIA_Sales),2),0) as BV_Call_HSIA_Sales,  
 isnull(round(sum(Online_HSIA_Sales),2),0) as BV_Online_HSIA_Sales,  
 isnull(round(sum(Call_VOIP_Sales),2),0) as BV_Call_VOIP_Sales,  
 isnull(round(sum(Online_VOIP_Sales),2),0) as BV_Online_VOIP_Sales,  
 isnull(round(sum(Call_DSL_Reg_Sales),2),0) as BV_Call_DSL_Reg_Sales,  
 isnull(round(sum(Call_DSL_Dry_Sales),2),0) as BV_Call_DSL_Dry_Sales,  
 isnull(round(sum(Call_Access_Sales),2),0) as BV_Call_Access_Sales,  
 isnull(round(sum(Call_Wrls_Voice_Sales),2),0) as BV_Call_Wrls_Voice_Sales,  
 isnull(round(sum(Call_Dish_Sales),2),0) as BV_Call_Dish_Sales,  
 isnull(round(sum(Call_WRLS_Family_Sales),2),0) as BV_Call_WRLS_Family_Sales,  
 isnull(round(sum(Call_WRLS_Data_Sales),2),0) as BV_Call_WRLS_Data_Sales,  
 isnull(round(sum(Call_IPDSL_Sales),2),0) as BV_Call_IPDSL_Sales,  
   
 isnull(round(sum(Online_DSL_Reg_Sales),2),0) as BV_Online_DSL_Reg_Sales,  
 isnull(round(sum(Online_DSL_Dry_Sales),2),0) as BV_Online_DSL_Dry_Sales,  
 isnull(round(sum(Online_Access_Sales),2),0) as BV_Online_Access_Sales,  
 isnull(round(sum(Online_Wrls_Voice_Sales),2),0) as BV_Online_Wrls_Voice_Sales,  
 isnull(round(sum(Online_Dish_Sales),2),0) as BV_Online_Dish_Sales,  
 isnull(round(sum(Online_WRLS_Family_Sales),2),0) as BV_Online_WRLS_Family_Sales,  
 isnull(round(sum(Online_WRLS_Data_Sales),2),0) as BV_Online_WRLS_Data_Sales,  
 isnull(round(sum(Online_IPDSL_Sales),2),0) as BV_Online_IPDSL_Sales,  
 isnull(round(sum(Directed_Strategic_Call_Sales),2),0) as BV_Directed_Strategic_Call_Sales,  
 isnull(round(sum(Directed_Strategic_Online_Sales),2),0) as BV_Directed_Strategic_Online_Sales  
  
  
from   
  
  
-----------------------JOIN FORECASTED Sales, Response, Volume and Finance Budget  
(select   
 COALESCE(volume_response_sales_query.Flight_Plan_Record_FK, budget_query.Flight_Plan_Record_FK, bv_project_budget_query.Flight_Plan_Record_FK) as Flight_Plan_Record_FK,   
 COALESCE(volume_response_sales_query.Media_Week, budget_query.Media_Week, bv_project_budget_query.Media_Week) as Media_Week,  
 Budget,  
 Project_Budget,  
 Volume,  
 Calls,  
 Clicks,   
 Call_TV_Sales,  
 Online_TV_Sales,  
 Call_HSIA_Sales,  
 Online_HSIA_Sales,  
 Call_VOIP_Sales,  
 Online_VOIP_Sales,  
 Call_DSL_Reg_Sales,  
 Call_DSL_Dry_Sales,  
 Call_Access_Sales,  
 Call_Wrls_Voice_Sales,  
 Call_Dish_Sales,  
 Call_WRLS_Family_Sales,  
 Call_WRLS_Data_Sales,  
 Call_IPDSL_Sales,  
   
 Online_DSL_Reg_Sales,  
 Online_DSL_Dry_Sales,  
 Online_Access_Sales,  
 Online_Wrls_Voice_Sales,  
 Online_Dish_Sales,  
 Online_WRLS_Family_Sales,  
 Online_WRLS_Data_Sales,  
 Online_IPDSL_Sales,  
 Directed_Strategic_Call_Sales,  
 Directed_Strategic_Online_Sales  
  
from   
  
----------------------JOIN FORECASTED SALES RESPONSE AND VOLUME   
(select   
 COALESCE(subquery_sales.Flight_Plan_Record_ID,subquery_response.Flight_Plan_Record_ID, subquery_volume.Flight_Plan_Record_ID) as Flight_Plan_Record_FK,   
 COALESCE(subquery_sales.Media_Week, subquery_response.Media_Week, subquery_volume.Media_Week) as Media_Week,  
 subquery_volume.Volume_Forecast as Volume,  
 Wk_Call_Forecast as Calls,  
 Wk_Click_Forecast as Clicks,   
 Call_TV_Sales,  
 Online_TV_Sales,  
 Call_HSIA_Sales,  
 Online_HSIA_Sales,  
 Call_VOIP_Sales,  
 Online_VOIP_Sales,  
   
 Call_DSL_Reg_Sales,  
 Call_DSL_Dry_Sales,  
 Call_Access_Sales,  
 Call_Wrls_Voice_Sales,  
 Call_Dish_Sales,  
 Call_WRLS_Family_Sales,  
 Call_WRLS_Data_Sales,  
 Call_IPDSL_Sales,  
   
 Online_DSL_Reg_Sales,  
 Online_DSL_Dry_Sales,  
 Online_Access_Sales,  
 Online_Wrls_Voice_Sales,  
 Online_Dish_Sales,  
 Online_WRLS_Family_Sales,  
 Online_WRLS_Data_Sales,  
 Online_IPDSL_Sales,  
    
 Directed_Strategic_Call_Sales,  
 Directed_Strategic_Online_Sales  
   
from    
----Subquery to Pull Sales------------------------------------------------------------------------------   
(SELECT Flight_Plan_Record_ID, [ISO_Week] as Media_Week,   
 SUM(CASE WHEN Product_FK=1 then day_call_sales ELSE 0 END) as Call_TV_Sales,  
 SUM(CASE WHEN Product_FK=1 then day_click_sales ELSE 0 END) as Online_TV_Sales,  
 SUM(CASE WHEN Product_FK=3 then day_call_sales ELSE 0 END) as Call_HSIA_Sales,  
 SUM(CASE WHEN Product_FK=3 then day_click_sales ELSE 0 END) as Online_HSIA_Sales,  
 SUM(CASE WHEN Product_FK=9 then day_call_sales ELSE 0 END) as Call_VOIP_Sales,  
 SUM(CASE WHEN Product_FK=9 then day_click_sales ELSE 0 END) as Online_VOIP_Sales,  
   
   
 SUM(CASE WHEN Product_FK=4 then day_call_sales ELSE 0 END) as Call_DSL_Reg_Sales,  
 SUM(CASE WHEN Product_FK=5 then day_call_sales ELSE 0 END) as Call_DSL_Dry_Sales,  
 SUM(CASE WHEN Product_FK=6 then day_call_sales ELSE 0 END) as Call_Access_Sales,  
 SUM(CASE WHEN Product_FK=8 then day_call_sales ELSE 0 END) as Call_Wrls_Voice_Sales,  
 SUM(CASE WHEN Product_FK=10 then day_call_sales ELSE 0 END) as Call_Dish_Sales,  
 SUM(CASE WHEN Product_FK=12 then day_call_sales ELSE 0 END) as Call_WRLS_Family_Sales,  
 SUM(CASE WHEN Product_FK=13 then day_call_sales ELSE 0 END) as Call_WRLS_Data_Sales,  
 SUM(CASE WHEN Product_FK=14 then day_call_sales ELSE 0 END) as Call_IPDSL_Sales,  
   
   
 SUM(CASE WHEN Product_FK=4 then day_click_sales ELSE 0 END) as Online_DSL_Reg_Sales,  
 SUM(CASE WHEN Product_FK=5 then day_click_sales ELSE 0 END) as Online_DSL_Dry_Sales,  
 SUM(CASE WHEN Product_FK=6 then day_click_sales ELSE 0 END) as Online_Access_Sales,  
 SUM(CASE WHEN Product_FK=8 then day_click_sales ELSE 0 END) as Online_Wrls_Voice_Sales,  
 SUM(CASE WHEN Product_FK=10 then day_click_sales ELSE 0 END) as Online_Dish_Sales,  
 SUM(CASE WHEN Product_FK=12 then day_click_sales ELSE 0 END) as Online_WRLS_Family_Sales,  
 SUM(CASE WHEN Product_FK=13 then day_click_sales ELSE 0 END) as Online_WRLS_Data_Sales,  
 SUM(CASE WHEN Product_FK=14 then day_click_sales ELSE 0 END) as Online_IPDSL_Sales,  
    
 SUM(day_call_sales) as Directed_Strategic_Call_Sales,  
 SUM(day_click_sales) as Directed_Strategic_Online_Sales FROM  
 Forecasting.Current_UVAQ_Flightplan_Forecast_Sales_ByDay   
 LEFT JOIN DIM.Media_Calendar_Daily  
 ON Forecast_DayDate=DIM.Media_Calendar_Daily.[Date]
 where MediaMonth_Year=2013  
GROUP BY Flight_Plan_Record_ID, [ISO_Week]) as subquery_sales  
-------------------------------------------------------------------------------------------------------  
  
FULL JOIN  
  
----Subquery to Pull Calls and Clicks------------------------------------------------------------------  
(select Flight_Plan_Record_ID, sum(Day_Call_Forecast) as Wk_Call_Forecast, sum(Day_Click_Forecast) as Wk_Click_Forecast, [ISO_Week] as Media_Week   
 from Forecasting.Current_UVAQ_Flightplan_Forecast_ByDay LEFT JOIN  
  DIM.Media_Calendar_Daily  
 ON Forecasting.Current_UVAQ_Flightplan_Forecast_ByDay.Forecast_DayDate=DIM.Media_Calendar_Daily.[Date]  
 where MediaMonth_Year=2013  
 Group by Flight_Plan_Record_ID,[ISO_Week]) as subquery_response  
  
ON subquery_sales.Flight_Plan_Record_ID=subquery_response.Flight_Plan_Record_ID and subquery_sales.Media_Week=subquery_response.Media_Week  
  
FULL JOIN  
----Subquery to Pull Volume  
(select Flight_Plan_Record_ID, Volume_Forecast, [ISO_Week] as Media_Week   
 from Forecasting.Current_UVAQ_Flightplan_Forecast_View  
  left join DIM.Media_Calendar_Daily  
 ON Drop_Date=DIM.Media_Calendar_Daily.[Date]  
 where MediaMonth_Year=2013) as subquery_volume  
   
ON subquery_sales.Flight_Plan_Record_ID=subquery_volume.Flight_Plan_Record_ID and subquery_sales.Media_Week=subquery_volume.Media_Week)  
  
as  volume_response_sales_query  
----------------------------------------------------------------------------------------------------------  
  
FULL JOIN  
  
----Subquery to pull Forecasted Finance Budget--------------------------------------------------------------------------  
(select Flight_Plan_Record_ID as Flight_Plan_Record_FK, [ISO_Week] as Media_Week, SUM(Bill_Amount) as Budget  
 from Forecasting.Current_UVAQ_Flightplan_Billing_View  
  INNER JOIN DIM.Media_Calendar_Daily ON Bill_Date=DIM.Media_Calendar_Daily.[Date]  
  where MediaMonth_Year=2013  
  group by Flight_Plan_Record_ID, [ISO_Week]) as budget_query  
    
ON volume_response_sales_query.Flight_Plan_Record_FK=budget_query.Flight_Plan_Record_FK and volume_response_sales_query.Media_Week=budget_query.Media_Week  
  
FULL JOIN  
  
------Subquery to pull Forecasted Project Budget  
(select Flight_Plan_Record_ID as Flight_Plan_Record_FK, [ISO_Week] as Media_Week, Budget_Forecast as Project_Budget  
 from Forecasting.Current_UVAQ_Flightplan_Forecast_View  
  INNER JOIN DIM.Media_Calendar_Daily ON InHome_Date=DIM.Media_Calendar_Daily.[Date]  
  where ISO_Week_Year=2013  
  ) as bv_project_budget_query  
  
ON volume_response_sales_query.Flight_Plan_Record_FK=bv_project_budget_query.Flight_Plan_Record_FK and volume_response_sales_query.Media_Week=bv_project_budget_query.Media_Week  
  
) as campaign_query  
-------------------------------------------------------------------------------------------------------  
  
  
INNER JOIN   
   
---Subquery to pull in the necessary information about the touch type----------------------------------  
  (SELECT Flight_Plan_Record_ID, Media_Type, Touch_Type_FK, Touch_Name, Touch_Name_2, Audience_Type_Name as Audience, Program_Owner, InHome_Date   
    from Forecasting.Flight_Plan_Records AS A, Forecasting.Touch_Type as B, Forecasting.Media_Type as C, Forecasting.Audience as D,   
     Forecasting.Program_Owners as E  
    Where A.Touch_Type_FK=B.Touch_Type_ID and B.Media_Type_FK=C.Media_Type_ID and B.Audience_FK=D.Audience_ID   
     and B.Program_Owner_FK=E.Program_Owner_ID) as flight_plan_record  
  
ON campaign_query.Flight_Plan_Record_FK=flight_plan_record.Flight_Plan_Record_ID  
  
GROUP BY    
 (flight_plan_record.Touch_Name + ' ' + flight_plan_record.Touch_Name_2),  
 flight_plan_record.Media_Type,  
 flight_plan_record.Touch_Type_FK,  
 flight_plan_record.Audience,  
 flight_plan_record.Program_Owner,  
 campaign_query.Media_Week,   
 flight_plan_record.InHome_Date)   
   
as forecast_query  
-------------------------------------------------------------------------------------------------------  
  
FULL JOIN  
  
  
----Subquery to pull CV Budget, Volume, Calls, Clicks, Sales  
  
(select   
   Touch_Type_FK,
   Audience,
   Project,
   Media_Type,
   Program_Owner,
   Media_Week,
   InHome_Date,
  sum(CV_Finance_Budget) as CV_Finance_Budget,
sum(  CV_Project_Budget) as   CV_Project_Budget,
sum(  CV_Drop_Volume) as   CV_Drop_Volume,
sum(  CV_Calls) as   CV_Calls,
sum(  CV_Clicks) as   CV_Clicks,
sum(  CV_Call_TV_Sales) as   CV_Call_TV_Sales,
sum(  CV_Online_TV_Sales) as   CV_Online_TV_Sales,
sum(  CV_Call_HSIA_Sales) as   CV_Call_HSIA_Sales,
sum(  CV_Online_HSIA_Sales) as   CV_Online_HSIA_Sales,
sum(  CV_Call_VOIP_Sales) as   CV_Call_VOIP_Sales,
sum(  CV_Online_VOIP_Sales) as   CV_Online_VOIP_Sales,
sum(  CV_Call_DSL_Reg_Sales) as   CV_Call_DSL_Reg_Sales,
sum(  CV_Call_DSL_Dry_Sales) as   CV_Call_DSL_Dry_Sales,
sum(  CV_Call_Access_Sales ) as   CV_Call_Access_Sales ,
sum(  CV_Call_Wrls_Voice_Sales) as   CV_Call_Wrls_Voice_Sales,
sum(  CV_Call_Dish_Sales) as   CV_Call_Dish_Sales,
sum(  CV_Call_WRLS_Family_Sales) as   CV_Call_WRLS_Family_Sales,
sum(  CV_Call_WRLS_Data_Sales) as   CV_Call_WRLS_Data_Sales,
sum(  CV_Call_IPDSL_Sales) as   CV_Call_IPDSL_Sales,
sum(  CV_Online_DSL_Reg_Sales) as   CV_Online_DSL_Reg_Sales,
sum(  CV_Online_DSL_Dry_Sales) as   CV_Online_DSL_Dry_Sales,
sum(  CV_Online_Access_Sales) as   CV_Online_Access_Sales,
sum(  CV_Online_Wrls_Voice_Sales) as   CV_Online_Wrls_Voice_Sales,
sum(  CV_Online_Dish_Sales) as   CV_Online_Dish_Sales,
sum(  CV_Online_WRLS_Family_Sales) as   CV_Online_WRLS_Family_Sales,
sum(  CV_Online_WRLS_Data_Sales) as   CV_Online_WRLS_Data_Sales,
sum(  CV_Online_IPDSL_Sales) as   CV_Online_IPDSL_Sales,
sum(  CV_Directed_Strategic_Call_Sales) as   CV_Directed_Strategic_Call_Sales,
sum(  CV_Directed_Strategic_Online_Sales) as   CV_Directed_Strategic_Online_Sales

  
 FROM  
  
 Commitment_Versions.CV_2013_February_Submission_Budget_Volume_Calls_Clicks_Sales_v2
    as cv_bill_resp  
   
/*   
 INNER JOIN   
---Subquery to pull in the necessary information about the touch type----------------------------------  
  (SELECT Flight_Plan_Record_ID, Touch_Type_FK, Media_Type, Touch_Name, Touch_Name_2, Touch_Type_ID, Audience_Type_Name as Audience, Program_Owner, InHome_Date   
    from Forecasting.Flight_Plan_Records AS A, Forecasting.Touch_Type as B, Forecasting.Media_Type as C, Forecasting.Audience as D,   
     Forecasting.Program_Owners as E  
    Where A.Touch_Type_FK=B.Touch_Type_ID and B.Media_Type_FK=C.Media_Type_ID and B.Audience_FK=D.Audience_ID   
     and B.Program_Owner_FK=E.Program_Owner_ID) as flight_plan_record   
 on cv_bill_resp.Flight_Plan_Record_FK=flight_plan_record.Flight_Plan_Record_ID  
   
 LEFT JOIN  
-----Subquery to pull commitment project billing view  
  (select Commitment_Versions.CV_2012_Final_Billing_View.Flight_Plan_Record_ID as Flight_Plan_Record_FK, [ISO_Week] as Media_Week,  
   isnull(sum(Commitment_Versions.CV_2012_Final_Billing_View.Bill_Amount),0) as Project_Budget  
  from Commitment_Versions.CV_2012_Final_Billing_View   
   left join Forecasting.Flight_Plan_Records on Commitment_Versions.CV_2012_Final_Billing_View.Flight_Plan_Record_ID=Forecasting.Flight_Plan_Records.Flight_Plan_Record_ID  
   left join DIM.Media_Calendar_Daily on Forecasting.Flight_Plan_Records.InHome_Date=DIM.Media_Calendar_Daily.[Date]  
   group by Commitment_Versions.CV_2012_Final_Billing_View.Flight_Plan_Record_ID, [ISO_Week]) as cv_project_bill_query  
 ON cv_project_bill_query.Flight_Plan_Record_FK=cv_bill_resp.Flight_Plan_Record_FK and cv_project_bill_query.Media_Week=cv_bill_resp.Media_Week  
   
---Note the limitation Here only for CV purposes ---- Getting Rid of Bad Info   
 where InHome_date>'2013-3-31'  
*/   
 GROUP BY   
   Touch_Type_FK,
   Audience,
   Project,
   Media_Type,
   Program_Owner,
   Media_Week,
   InHome_Date
  
   
) as cv_query  
----------------------------------------------------------------------------------------------------------------------------  
ON cv_query.Project=forecast_query.Project and cv_query.Media_Type=forecast_query.Media_Type and cv_query.Media_Week=forecast_query.Media_Week  
and cv_query.Program_Owner=forecast_query.Program_Owner and cv_query.InHome_Date=forecast_query.InHome_Date   
and forecast_query.Audience=cv_query.Audience and cv_query.Touch_Type_FK=forecast_query.Touch_Type_FK
  
GROUP BY   
 COALESCE(cv_query.Project,forecast_query.Project) ,  
 COALESCE(cv_query.Touch_Type_FK,forecast_query.Touch_Type_FK) ,  
 COALESCE(cv_query.Audience,forecast_query.Audience) ,   
 COALESCE(cv_query.Media_Type,forecast_query.Media_Type) ,  
 COALESCE(cv_query.Program_Owner,forecast_query.Program_Owner),  
 COALESCE(cv_query.Media_Week,forecast_query.Media_week) ,  
 COALESCE(forecast_query.InHome_Date, cv_query.InHome_Date),  
 BV_Finance_Budget,  
 BV_Project_Budget,  
 BV_Drop_Volume,  
 BV_Calls,  
 BV_Clicks,  
 BV_Call_TV_Sales,  
 BV_Online_TV_Sales,  
 BV_Call_HSIA_Sales,  
 BV_Online_HSIA_Sales,  
 BV_Call_VOIP_Sales,  
 BV_Online_VOIP_Sales,  
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
 BV_Directed_Strategic_Call_Sales,  
 BV_Directed_Strategic_Online_Sales,  
   
 CV_Finance_Budget,
  CV_Project_Budget,
  CV_Drop_Volume,
  CV_Calls,
  CV_Clicks,
  CV_Call_TV_Sales,
  CV_Online_TV_Sales,
  CV_Call_HSIA_Sales,
  CV_Online_HSIA_Sales,
  CV_Call_VOIP_Sales,
  CV_Online_VOIP_Sales,
  CV_Call_DSL_Reg_Sales,
  CV_Call_DSL_Dry_Sales,
  CV_Call_Access_Sales ,
  CV_Call_Wrls_Voice_Sales, 
  CV_Call_Dish_Sales,
  CV_Call_WRLS_Family_Sales,
  CV_Call_WRLS_Data_Sales,
  CV_Call_IPDSL_Sales,
  CV_Online_DSL_Reg_Sales,
  CV_Online_DSL_Dry_Sales,
  CV_Online_Access_Sales,
  CV_Online_Wrls_Voice_Sales,
  CV_Online_Dish_Sales,
  CV_Online_WRLS_Family_Sales,
  CV_Online_WRLS_Data_Sales,
  CV_Online_IPDSL_Sales,
  CV_Directed_Strategic_Call_Sales,
  CV_Directed_Strategic_Online_Sales  
  
 --end amy add  
 ) as cv_bv_combo  
   
FULL JOIN  
-------------------*************************--------------------********************-----------------***************-------------*********  
(SELECT A.Touch_type_FK,  
  E.Audience_Type_Name as Audience,  
     Case When touch_type_fk=0 then ('2012 Unaccounted Overflow' + ' ' + A.Media_Type)  
  ELSE isnull((Touch_Name + ' ' + Touch_Name_2),'Unplanned')  
  END as Project,  
 COALESCE(C.Media_Type,A.Media_Type) as Media_Type,   
 isnull(Program_Owner,'2012 Flowover') as Program_Owner,  
 A.Report_Week as Media_Week, 
	case when   COALESCE(C.Media_Type,A.Media_Type) = 'CA' then Dateadd(day,14,A.[Start_Date]) 
         when  COALESCE(C.Media_Type,A.Media_Type) = 'DM'  then Dateadd(day,11,A.[Start_Date])
         when  COALESCE(C.Media_Type,A.Media_Type) = 'EM'  then [Start_Date]
         else Dateadd(day,7,A.[Start_Date])
 End as InHome_Date,  
 --amy add  
 isnull(round(sum(Wireless_Voice_Call_Sales), 0), 0) as Actual_Call_Wrls_Voice_Sales,  
 isnull(round(sum(Wireless_Voice_Click_Sales), 0), 0) as Actual_Online_Wrls_Voice_Sales,  
 isnull(round(sum(Wireless_Family_Call_Sales), 0), 0) as Actual_Call_WRLS_Family_Sales,  
 isnull(round(sum(Wireless_Family_Click_Sales), 0), 0) as Actual_Online_WRLS_Family_Sales,  
 isnull(round(sum(Wireless_Data_Call_Sales), 0), 0) as Actual_Call_WRLS_Data_Sales,  
 isnull(round(sum(Wireless_Data_Click_Sales), 0), 0) as Actual_Online_WRLS_Data_Sales,  
 isnull(round(sum(DirectTV_Call_Sales), 0), 0) as Actual_Call_Dish_Sales,  
 isnull(round(sum(DirectTV_Click_Sales), 0), 0) as Actual_Online_Dish_Sales,  
 isnull(round(sum(DSL_Direct_Call_Sales), 0), 0) as Actual_Call_DSL_Reg_Sales,  
 isnull(round(sum(DSL_Direct_Click_Sales), 0), 0) as Actual_Online_DSL_Reg_Sales,  
 isnull(round(sum(DSL_Dry_Loop_Call_Sales), 0), 0) as Actual_Call_DSL_Dry_Sales,  
 isnull(round(sum(DSL_Dry_Loop_Click_Sales), 0), 0) as Actual_Online_DSL_Dry_Sales,  
 isnull(round(sum(IPDSLAM_Call_Sales), 0), 0) as Actual_Call_IPDSL_Sales,  
 isnull(round(sum(IPDSLAM_Click_Sales), 0), 0) as Actual_Online_IPDSL_Sales,  
 isnull(round(sum(Local_Call_Sales), 0), 0) as Actual_Call_Access_Sales,  
 isnull(round(sum(Local_Click_Sales), 0), 0) as Actual_Online_Access_Sales,  
 --end amy add  
 isnull(round(sum(A.Budget),0),0) as Actual_Apportioned_Budget,  
 isnull(round(sum(A.Actual_Budget),0),0) as Actual_Budget, 
 isnull(round(sum(A.Volume),0),0) as Actual_Apportioned_Volume, 
 isnull(round(sum(A.Actual_Volume),0),0) as Actual_Volume, 
 
 isnull(round(sum(Calls),0),0) as Actual_Calls,  
 isnull(round(sum(Clicks),0),0) as Actual_Clicks,  
 isnull(round(sum(UVERSE_TV_Call_Sales),0),0) as Actual_Call_TV,  
 isnull(round(sum(UVERSE_TV_Click_Sales),0),0) as Actual_Online_TV_Sales,  
 isnull(round(sum(HSIA_Call_Sales),0),0) as Actual_Call_HSIA_Sales,  
 isnull(round(sum(HSIA_Click_Sales),0),0) as Actual_Online_HSIA_Sales,  
 isnull(round(sum(VOIP_Call_Sales),0),0) as Actual_Call_VOIP_Sales,  
 isnull(round(sum(VOIP_Click_Sales),0),0) as Actual_Online_VOIP_Sales,  
 isnull(round((sum(Wireless_Call_Sales)+sum(DirectTV_Call_Sales)+sum(DSL_Direct_Call_Sales)  
  +sum(DSL_Dry_Loop_Call_Sales)+sum(HSIA_Call_Sales)+sum(VOIP_Call_Sales)+sum(UVERSE_TV_Call_Sales)),0),0)   
  as Actual_Directed_Strategic_Call_Sales,  
 isnull(round((sum(Wireless_Click_Sales)+sum(DirectTV_Click_Sales)+sum(DSL_Direct_Click_Sales)+sum(DSL_Dry_Loop_Click_Sales)  
  +sum(HSIA_Click_Sales)+sum(VOIP_Click_Sales)+sum(UVERSE_TV_Click_Sales)),0),0) as Actual_Directed_Strategic_Online_Sales  
  
  
   
    
FROM Results.UVAQ_LB_2013_Response_Sales_Volume_Budget_Apprtnd as A  
 LEFT JOIN Forecasting.Touch_Type as B on A.Touch_Type_FK=B.Touch_Type_ID  
 LEFT JOIN Forecasting.Media_Type as C on B.Media_Type_FK=C.Media_Type_ID  
 LEFT JOIN Forecasting.Program_Owners as D on B.Program_Owner_FK=D.Program_Owner_ID  
 LEFT JOIN Forecasting.Audience as E on B.Audience_FK=E.Audience_ID  

----------------------------------------------------------------------------------------------------------------  
WHERE A.Report_Year=2013   
--Commented out for end of year!
 --and A.Report_Week <= (select [ISO_Week]-2 from DIM.Media_Calendar_Daily   
 --    where CONVERT(VARCHAR(10),DIM.Media_Calendar_Daily.[Date],111)=CONVERT(VARCHAR(10),GETDATE(),111))  
GROUP BY A.touch_type_fk,  
 E.Audience_Type_Name,  
 Case When touch_type_fk=0 then ('2012 Unaccounted Overflow' + ' ' + A.Media_Type)  
  ELSE isnull((Touch_Name + ' ' + Touch_Name_2),'Unplanned')  
  END,  
 COALESCE(C.Media_Type,A.Media_Type),  
 isnull(Program_Owner,'2012 Flowover'),  
 A.Report_Week,  
 A.[Start_Date]) as actual  
  
ON actual.project=cv_bv_combo.project and actual.media_type=cv_bv_combo.media_type and actual.Program_Owner=cv_bv_combo.Program_Owner  
and actual.Media_Week=cv_bv_combo.Media_Week and actual.InHome_Date=cv_bv_combo.InHome_Date  AND actual.audience=cv_bv_combo.audience
and actual.touch_type_fk=cv_bv_combo.touch_type_fk
   
GROUP BY   
 COALESCE(cv_bv_combo.Touch_type_FK, actual.Touch_type_FK),  
 COALESCE(cv_bv_combo.Audience, actual.Audience),  
 COALESCE(cv_bv_combo.Project, actual.Project),  
 COALESCE(cv_bv_combo.Media_Type, actual.Media_Type),  
 COALESCE(cv_bv_combo.Program_Owner, actual.Program_Owner),  
 COALESCE(cv_BV_combo.Media_Week, actual.Media_Week),  
 COALESCE(cv_bv_combo.InHome_Date, actual.InHome_Date),  
--Actuals  
 Actual_Apportioned_Budget,  
 Actual_Apportioned_Volume,
 Actual_Budget,
 Actual_Volume,  
 Actual_Calls,  
 Actual_Clicks,  
 Actual_Call_TV,  
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
   
--Best View   
 BV_Finance_Budget,  
 BV_Project_Budget,  
 BV_Drop_Volume,  
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
   
--Commitment View  
 CV_Finance_Budget,  
 CV_Project_Budget,  
  CV_Drop_Volume,  
 CV_Calls,  
 CV_Clicks,  
 CV_Call_TV_Sales,   
 CV_Call_HSIA_Sales,  
 CV_Online_TV_Sales,  
 CV_Online_HSIA_Sales,  
 CV_Call_VOIP_Sales,  
 CV_Online_VOIP_Sales,  
 CV_Directed_Strategic_Call_Sales,  
 CV_Directed_Strategic_Online_Sales,  
   
 --amy add  
 CV_Call_DSL_Reg_Sales,  
 CV_Online_DSL_Reg_Sales,  
 CV_Call_dsl_dry_Sales,  
 CV_Online_DSL_Dry_Sales,  
 CV_Call_access_Sales,  
 CV_online_access_Sales,  
 CV_Call_Wrls_Voice_Sales,  
 CV_Online_Wrls_Voice_Sales,  
 CV_Call_Wrls_Family_Sales,  
 CV_online_Wrls_Family_Sales,  
 CV_call_Wrls_data_Sales,  
 CV_online_Wrls_data_Sales,  
 CV_Call_IPDSL_Sales,  
 CV_Online_IPDSL_Sales,  
 CV_call_DISH_Sales,  
 CV_Online_DISH_Sales  

