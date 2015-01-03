


---Rebuilds "Current_UVAQ" Forecasting and Summary Views


/*Create the Flightplan_Forecast View*/
CREATE VIEW [Forecasting].[UVAQ_ad_hoc_Flightplan_Forecast_View] WITH SCHEMABINDING

AS SELECT DISTINCT  Current_AdHoc_Flightplan.ad_hoc_flightplan_id, prj450_job_cd, Current_AdHoc_Flightplan.InHome_Date, 
	Current_AdHoc_Flightplan.Volume_Date, Current_AdHoc_Flightplan.Touch_Type_FK, Current_AdHoc_Flightplan.Media_Type, Current_AdHoc_Flightplan.Target_Type_Name, 
	Current_AdHoc_Flightplan.Touch_Name, Current_AdHoc_Flightplan.Touch_Name_2,Current_AdHoc_Flightplan.Audience_Type_Name,
---Calculate Drop Date based on Expected In Home
	CASE WHEN Media_Type in ('EM','SMS','BI','FYI') then InHome_Date 
	when media_type in ('CA') then DATEADD(week,-2,InHome_Date) 
	when media_type in ('DM') and touch_name not like '%Touch%' then dateadd(day,-10,InHome_Date) 
	else dateadd(week,-1,InHome_Date) END as Drop_Date, 
	
---Volume Calculations   
   CASE WHEN Target_Type_Name = 'VOLUME' THEN Target_Value 
   WHEN Target_Type_Name = 'BUDGET' THEN Target_Value/Cost_Per_Piece
	----TV UPSELL SpecifiC   
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='DM' and Touch_Name_2 IN ('TV Upsell') AND inhome_date>'2012-12-30' THEN Forecasting.[2013_Lead_Forecast].TV_Upsell_Leads*Target_Value
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='DM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.027) * Target_Value
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='DM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.027)  * Target_Value
   
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 in ('TV Upsell initials') AND inhome_date>'2012-12-30' THEN Forecasting.[2013_Lead_Forecast].TV_Upsell_Leads*Target_Value*0.45
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.027) * Target_Value*0.4
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.027)  * Target_Value*0.4
   
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 like '%TV Upsell Engagement%' AND inhome_date>'2012-12-30' THEN (52000.0 * (month(inhome_date)+12.0) + 640285.0) * Target_Value*0.4*.12
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell Engagement') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.027) * Target_Value*0.40*.12
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell Engagement') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.027)  * Target_Value*0.4*0.1
   
   WHEN Target_Type_Name = 'PERCENT' AND Touch_Name IN ('Wireline') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 4) + 0.1807)  * Target_Value
   WHEN Target_Type_Name = 'PERCENT' AND Touch_Name IN ('Wireline') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month + 8) + 0.1807)  * Target_Value
   WHEN Target_Type_Name = 'PERCENT' AND Touch_Name IN ('Wireline') AND Date_Year = 2013 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month + 20) + 0.1807)  * Target_Value
   
   WHEN Target_Type_Name = 'PERCENT' AND INHome_date<'2012-12-31' and Audience_Type_Name like '%NG%' THEN Forecasting.Current_MLP_New_Green.New_Green_ELU*Volume_Assumption/4  * Target_Value
   WHEN Target_Type_Name = 'PERCENT' and INHome_date<'2012-12-31' THEN Forecasting.Current_MLP_Summary_View.Expr1 * Volume_Assumption * Target_Value
----2013 Specific Forecasting---- 
	-----Launch------
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_NG_leads*Target_Value
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_NG_leads*Target_Value
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='Wln Mix' THEN Forecasting.[2013_Lead_Forecast].LT_NG_leads*Target_Value
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='NG BL LB' THEN Forecasting.[2013_Lead_Forecast].SPANISH_NG_leads*Target_Value
	
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_NG_leads*Target_Value*0.22
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name in ('Wrls IRU','LT IRU') THEN Forecasting.[2013_Lead_Forecast].IRU_NG_leads*Target_Value*0.22
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name='Wln Mix' THEN Forecasting.[2013_Lead_Forecast].LT_NG_leads*Target_Value*0.22
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name='NG BL LB' THEN Forecasting.[2013_Lead_Forecast].SPANISH_NG_leads*Target_Value*0.22
	
	-----Recurring------  
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_leads*Target_Value
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='Wln Mix' THEN Forecasting.[2013_Lead_Forecast].LT_leads*Target_Value
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='PL BL LB' THEN Forecasting.[2013_Lead_Forecast].Spanish_leads*Target_Value
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='Wln NG' THEN Forecasting.[2013_Lead_Forecast].Recur_NG_leads*Target_Value
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA') and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_leads*Target_Value
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='Span_Tag' THEN Forecasting.[2013_Lead_Forecast].Spanish_2_3*Target_Value
   
  
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Initial%' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value*0.23
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Initial%' and Audience_Type_Name='Wln Mix' THEN (Forecasting.[2013_Lead_Forecast].LT_leads+Forecasting.[2013_Lead_Forecast].DMDR_leads+Forecasting.[2013_Lead_Forecast].Spanish_leads+Forecasting.[2013_Lead_Forecast].Recur_NG_leads)*Target_Value*0.23
   
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Reblast%' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value*0.23*.9
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Reblast%' and Audience_Type_Name='Wln Mix' THEN (Forecasting.[2013_Lead_Forecast].LT_leads+Forecasting.[2013_Lead_Forecast].DMDR_leads+Forecasting.[2013_Lead_Forecast].Spanish_leads+Forecasting.[2013_Lead_Forecast].Recur_NG_leads)*Target_Value*0.23*.9

   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Engage%' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value*0.23*0.1
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Engage%' and Audience_Type_Name='Wln Mix' THEN (Forecasting.[2013_Lead_Forecast].LT_leads+Forecasting.[2013_Lead_Forecast].DMDR_leads+Forecasting.[2013_Lead_Forecast].Spanish_leads+Forecasting.[2013_Lead_Forecast].Recur_NG_leads)*Target_Value*0.23*0.1

   
   
   END AS Volume_Forecast,
---Budget Calculations
   CASE WHEN Target_Type_Name = 'VOLUME' and Budget_Given is not null THEN Budget_Given
   WHEN Target_Type_Name = 'VOLUME' and Budget_Given is null THEN Target_Value*Cost_Per_Piece
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='DM' and Touch_Name_2 IN ('TV Upsell') AND inhome_date>'2012-12-30' THEN Forecasting.[2013_Lead_Forecast].TV_Upsell_Leads*Target_Value * Cost_Per_Piece
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='DM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.027) * Target_Value * Cost_Per_Piece 
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='DM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.027)  * Target_Value * Cost_Per_Piece 
   
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 in ('TV Upsell initials') AND inhome_date>'2012-12-30' THEN Forecasting.[2013_Lead_Forecast].TV_Upsell_Leads*Target_Value*0.45* Cost_Per_Piece 
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.027) * Target_Value*0.4* Cost_Per_Piece 
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.027)  * Target_Value*0.4* Cost_Per_Piece 
   
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 like '%TV Upsell Engagement%' AND inhome_date>'2012-12-30' THEN (52000.0 * (month(inhome_date)+12.0) + 640285.0) * Target_Value*0.4*.12 * Cost_Per_Piece 
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell Engagement') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.027) * Target_Value*0.40 * Cost_Per_Piece 
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell Engagement') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.027)  * Target_Value*0.4*0.1 * Cost_Per_Piece 
   
   WHEN Target_Type_Name = 'PERCENT' AND Touch_Name IN ('Wireline') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 4) + 0.1807)  * Target_Value * Cost_Per_Piece 
   WHEN Target_Type_Name = 'PERCENT' AND Touch_Name IN ('Wireline') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month + 8) + 0.1807) * Target_Value * Cost_Per_Piece
   WHEN Target_Type_Name = 'PERCENT' AND Touch_Name IN ('Wireline') AND Date_Year = 2013 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month + 20) + 0.1807) * Target_Value * Cost_Per_Piece  
   
   WHEN Target_Type_Name = 'PERCENT' AND INHome_date<'2012-12-31' and Audience_Type_Name like '%NG%' THEN Forecasting.Current_MLP_New_Green.New_Green_ELU*Volume_Assumption/4  * Target_Value * Cost_Per_Piece
   WHEN Target_Type_Name = 'PERCENT' and INHome_date<'2012-12-31' THEN Forecasting.Current_MLP_Summary_View.Expr1 * Volume_Assumption * Target_Value * Cost_Per_Piece
----2013 Specific Forecasting---- 
	-----Launch------
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='DM' and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_NG_leads*Target_Value * Cost_Per_Piece
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='DM' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_NG_leads*Target_Value * Cost_Per_Piece
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='DM' and Audience_Type_Name='Wln Mix' THEN Forecasting.[2013_Lead_Forecast].LT_NG_leads*Target_Value * Cost_Per_Piece
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='DM' and Audience_Type_Name='NG BL LB' THEN Forecasting.[2013_Lead_Forecast].SPANISH_NG_leads*Target_Value * Cost_Per_Piece
	
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_NG_leads*Target_Value*0.22 * Cost_Per_Piece
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name in ('Wrls IRU','LT IRU') THEN Forecasting.[2013_Lead_Forecast].IRU_NG_leads*Target_Value*0.22 * Cost_Per_Piece
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name='Wln Mix' THEN Forecasting.[2013_Lead_Forecast].LT_NG_leads*Target_Value*0.22 * Cost_Per_Piece
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name='NG BL LB' THEN Forecasting.[2013_Lead_Forecast].SPANISH_NG_leads*Target_Value*0.22 * Cost_Per_Piece
	-----Recurring------  
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_leads*Target_Value * Cost_Per_Piece
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value * Cost_Per_Piece
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='Wln Mix' THEN Forecasting.[2013_Lead_Forecast].LT_leads*Target_Value * Cost_Per_Piece
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='PL BL LB' THEN Forecasting.[2013_Lead_Forecast].Spanish_leads*Target_Value * Cost_Per_Piece
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='Wln NG' THEN Forecasting.[2013_Lead_Forecast].Recur_NG_leads*Target_Value * Cost_Per_Piece
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA') and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_leads *Target_Value * Cost_Per_Piece
      WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='Span_Tag' THEN Forecasting.[2013_Lead_Forecast].Spanish_2_3*Target_Value * Cost_Per_Piece
    
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Initial%' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value*0.23* Cost_Per_Piece
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Initial%' and Audience_Type_Name='Wln Mix' THEN (Forecasting.[2013_Lead_Forecast].LT_leads+Forecasting.[2013_Lead_Forecast].DMDR_leads+Forecasting.[2013_Lead_Forecast].Spanish_leads+Forecasting.[2013_Lead_Forecast].Recur_NG_leads)*Target_Value*0.23* Cost_Per_Piece
   
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Reblast%' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value*0.23*.9* Cost_Per_Piece
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Reblast%' and Audience_Type_Name='Wln Mix' THEN (Forecasting.[2013_Lead_Forecast].LT_leads+Forecasting.[2013_Lead_Forecast].DMDR_leads+Forecasting.[2013_Lead_Forecast].Spanish_leads+Forecasting.[2013_Lead_Forecast].Recur_NG_leads)*Target_Value*0.23*0.9* Cost_Per_Piece

   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Engage%' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value*0.23*0.1* Cost_Per_Piece
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Engage%' and Audience_Type_Name='Wln Mix' THEN (Forecasting.[2013_Lead_Forecast].LT_leads+Forecasting.[2013_Lead_Forecast].DMDR_leads+Forecasting.[2013_Lead_Forecast].Spanish_leads+Forecasting.[2013_Lead_Forecast].Recur_NG_leads)*Target_Value*0.23*0.1* Cost_Per_Piece

   WHEN Target_Type_Name = 'BUDGET' THEN Target_Value
   END AS Budget_Forecast,
---Call Response Calculations
   CASE WHEN Target_Type_Name = 'VOLUME' THEN Target_Value * Call_RR.Response_Rate * Adjustment_Factor*Seasonality_Index
   
   
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='DM' and Touch_Name_2 IN ('TV Upsell') AND inhome_date>'2012-12-30' THEN Forecasting.[2013_Lead_Forecast].TV_Upsell_Leads*Target_Value * Call_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='DM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.027) * Target_Value * Call_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='DM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.027)  * Target_Value * Call_RR.Response_Rate*Seasonality_Index
   
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 in ('TV Upsell initials') AND inhome_date>'2012-12-30' THEN Forecasting.[2013_Lead_Forecast].TV_Upsell_Leads*Target_Value*0.45 * Call_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.027) * Target_Value*0.4 * Call_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.027)  * Target_Value*0.4 * Call_RR.Response_Rate*Seasonality_Index
   
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 like '%TV Upsell Engagement%' AND inhome_date>'2012-12-30' THEN (52000.0 * (month(inhome_date)+12.0) + 640285.0) * Target_Value*0.4*.12 * Call_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell Engagement') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.027) * Target_Value*0.40*0.1 * Call_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell Engagement') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.027)  * Target_Value*0.4*0.1 * Call_RR.Response_Rate*Seasonality_Index
 
   WHEN Target_Type_Name = 'PERCENT' AND Touch_Name IN ('Wireline') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 4) + 0.1807) * Target_Value * Call_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Touch_Name IN ('Wireline') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month + 8) + 0.1807) * Target_Value * Call_RR.Response_Rate*Seasonality_Index
   
   WHEN Target_Type_Name = 'PERCENT' AND INHome_date<'2012-12-31' and Audience_Type_Name like '%NG%' THEN Forecasting.Current_MLP_New_Green.New_Green_ELU*Volume_Assumption/4  * Target_Value * Call_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date<'2012-12-31' THEN Forecasting.Current_MLP_Summary_View.Expr1 * Volume_Assumption * Target_Value * Call_RR.Response_Rate* Adjustment_Factor*Seasonality_Index
----2013 Specific Forecasting---- 
	-----Launch------
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='DM' and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_NG_leads*Target_Value * Call_RR.Response_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='DM' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_NG_leads*Target_Value * Call_RR.Response_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='DM' and Audience_Type_Name='Wln Mix' THEN Forecasting.[2013_Lead_Forecast].LT_NG_leads*Target_Value * Call_RR.Response_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='DM' and Audience_Type_Name='NG BL LB' THEN Forecasting.[2013_Lead_Forecast].SPANISH_NG_leads*Target_Value * Call_RR.Response_Rate*Seasonality_Index
	
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_NG_leads*Target_Value*0.22 * Call_RR.Response_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name in ('Wrls IRU','LT IRU') THEN Forecasting.[2013_Lead_Forecast].IRU_NG_leads*Target_Value*0.22 * Call_RR.Response_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name='Wln Mix' THEN Forecasting.[2013_Lead_Forecast].LT_NG_leads*Target_Value*0.22 * Call_RR.Response_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name='NG BL LB' THEN Forecasting.[2013_Lead_Forecast].SPANISH_NG_leads*Target_Value*0.22 * Call_RR.Response_Rate*Seasonality_Index
	-----Recurring------  
   
            ------ADDED -10% Adjustment for Months Following a Catalog-----
   WHEN Target_Type_Name = 'PERCENT' and INHome_date in ('2013-08-27', '2013-10-28', '2013-02-25') and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_leads*Target_Value * Call_RR.Response_Rate * 0.875 * Adjustment_Factor*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date in ('2013-08-27', '2013-10-28', '2013-02-25') and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value * Call_RR.Response_Rate * 0.875 * Adjustment_Factor*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date in ('2013-08-27', '2013-10-28', '2013-02-25') and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='Wln Mix' THEN Forecasting.[2013_Lead_Forecast].LT_leads*Target_Value * Call_RR.Response_Rate * 0.875 * Adjustment_Factor*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date in ('2013-08-27', '2013-10-28', '2013-02-25') and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='PL BL LB' THEN Forecasting.[2013_Lead_Forecast].Spanish_leads*Target_Value * Call_RR.Response_Rate * 0.875 * Adjustment_Factor*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date in ('2013-08-27', '2013-10-28', '2013-02-25') and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='Wln NG' THEN Forecasting.[2013_Lead_Forecast].Recur_NG_leads*Target_Value * Call_RR.Response_Rate * 0.875 * Adjustment_Factor*Seasonality_Index
   
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_leads*Target_Value * Call_RR.Response_Rate * Adjustment_Factor*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value * Call_RR.Response_Rate * Adjustment_Factor*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='Wln Mix' THEN Forecasting.[2013_Lead_Forecast].LT_leads*Target_Value * Call_RR.Response_Rate * Adjustment_Factor*Seasonality_Index
      WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='Span_Tag' THEN Forecasting.[2013_Lead_Forecast].Spanish_2_3*Target_Value * Call_RR.Response_Rate * Adjustment_Factor*Seasonality_Index
   --------Added for Hispanic in 2014 to smooth seasonality-----------
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2013-12-31' and touch_name not like '%Touch%' and media_Type in ('CA') and Audience_Type_Name='PL BL LB' THEN Forecasting.[2013_Lead_Forecast].Spanish_leads*Target_Value * Call_RR.Response_Rate * Adjustment_Factor*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2013-12-31' and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='PL BL LB' and Seasonality_Index>1 THEN Forecasting.[2013_Lead_Forecast].Spanish_leads*Target_Value * Call_RR.Response_Rate * Adjustment_Factor*Seasonality_Index*0.95
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2013-12-31' and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='PL BL LB' and Seasonality_Index<1 THEN Forecasting.[2013_Lead_Forecast].Spanish_leads*Target_Value * Call_RR.Response_Rate * Adjustment_Factor*Seasonality_Index/0.95
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2013-12-31' and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='PL BL LB' and Seasonality_Index=1 THEN Forecasting.[2013_Lead_Forecast].Spanish_leads*Target_Value * Call_RR.Response_Rate * Adjustment_Factor
   ----------End Addition-----------------------------------------------------
   
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='PL BL LB' THEN Forecasting.[2013_Lead_Forecast].Spanish_leads*Target_Value * Call_RR.Response_Rate * Adjustment_Factor*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='Wln NG' THEN Forecasting.[2013_Lead_Forecast].Recur_NG_leads*Target_Value * Call_RR.Response_Rate * Adjustment_Factor*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA') and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_leads *Target_Value * Call_RR.Response_Rate * Adjustment_Factor*Seasonality_Index
   
    
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Initial%' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value*0.23 * Call_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Initial%' and Audience_Type_Name='Wln Mix' THEN (Forecasting.[2013_Lead_Forecast].LT_leads+Forecasting.[2013_Lead_Forecast].DMDR_leads+Forecasting.[2013_Lead_Forecast].Spanish_leads+Forecasting.[2013_Lead_Forecast].Recur_NG_leads)*Target_Value*0.23 * Call_RR.Response_Rate*Seasonality_Index
   
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Reblast%' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value*0.23*.9 * Call_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Reblast%' and Audience_Type_Name='Wln Mix' THEN (Forecasting.[2013_Lead_Forecast].LT_leads+Forecasting.[2013_Lead_Forecast].DMDR_leads+Forecasting.[2013_Lead_Forecast].Spanish_leads+Forecasting.[2013_Lead_Forecast].Recur_NG_leads)*Target_Value*0.23*.9 * Call_RR.Response_Rate*Seasonality_Index

   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Engage%' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value*0.23*0.1 * Call_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Engage%' and Audience_Type_Name='Wln Mix' THEN (Forecasting.[2013_Lead_Forecast].LT_leads+Forecasting.[2013_Lead_Forecast].DMDR_leads+Forecasting.[2013_Lead_Forecast].Spanish_leads+Forecasting.[2013_Lead_Forecast].Recur_NG_leads)*Target_Value*0.23*0.1 * Call_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'BUDGET' THEN Target_Value/Cost_Per_Piece * Call_RR.Response_Rate*Seasonality_Index
   END AS Call_Forecast,
---Click Response Calculations
   CASE WHEN Target_Type_Name = 'VOLUME' THEN Target_Value * Adjustment_Factor * Click_RR.Response_Rate*Seasonality_Index
   
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='DM' and Touch_Name_2 IN ('TV Upsell') AND inhome_date>'2012-12-30' THEN Forecasting.[2013_Lead_Forecast].TV_Upsell_Leads*Target_Value * Click_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='DM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.027) * Target_Value * Click_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='DM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.027)  * Target_Value * Click_RR.Response_Rate*Seasonality_Index
   
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 in ('TV Upsell initials') AND inhome_date>'2012-12-30' THEN Forecasting.[2013_Lead_Forecast].TV_Upsell_Leads*Target_Value*0.45* Click_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.027) * Target_Value*0.4 * Click_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.027)  * Target_Value*0.4 * Click_RR.Response_Rate*Seasonality_Index
   
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 like '%TV Upsell Engagement%' AND inhome_date>'2012-12-30' THEN (52000.0 * (month(inhome_date)+12.0) + 640285.0) * Target_Value*0.4*.12 * Click_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell Engagement') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.027) * Target_Value*0.40*0.1 * Click_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell Engagement') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.027)  * Target_Value*0.4*0.1 * Click_RR.Response_Rate*Seasonality_Index
  
   WHEN Target_Type_Name = 'PERCENT' AND Touch_Name IN ('Wireline') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 4) + 0.1807) * Target_Value * Click_RR.Response_Rate *Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Touch_Name IN ('Wireline') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month + 8) + 0.1807) * Target_Value * Click_RR.Response_Rate *Seasonality_Index
   
   --2012 recurring and new green
   WHEN Target_Type_Name = 'PERCENT' AND INHome_date<'2012-12-31' and Audience_Type_Name like '%NG%' THEN Forecasting.Current_MLP_New_Green.New_Green_ELU*Volume_Assumption/4  * Target_Value* Click_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date<'2012-12-31' THEN Forecasting.Current_MLP_Summary_View.Expr1 * Volume_Assumption * Target_Value* Click_RR.Response_Rate* Adjustment_Factor*Seasonality_Index
----2013 Specific Forecasting---- 
	-----Launch------
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='DM' and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_NG_leads*Target_Value* Click_RR.Response_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='DM' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_NG_leads*Target_Value* Click_RR.Response_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='DM' and Audience_Type_Name='Wln Mix' THEN Forecasting.[2013_Lead_Forecast].LT_NG_leads*Target_Value* Click_RR.Response_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='DM' and Audience_Type_Name='NG BL LB' THEN Forecasting.[2013_Lead_Forecast].SPANISH_NG_leads*Target_Value* Click_RR.Response_Rate*Seasonality_Index
	
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_NG_leads*Target_Value*0.22* Click_RR.Response_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name in ('Wrls IRU','LT IRU') THEN Forecasting.[2013_Lead_Forecast].IRU_NG_leads*Target_Value*0.22* Click_RR.Response_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name='Wln Mix' THEN Forecasting.[2013_Lead_Forecast].LT_NG_leads*Target_Value*0.22* Click_RR.Response_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name='NG BL LB' THEN Forecasting.[2013_Lead_Forecast].SPANISH_NG_leads*Target_Value*0.22* Click_RR.Response_Rate*Seasonality_Index
	-----Recurring------  
               ------ADDED -10% Adjustment for Months Following a Catalog-----
   WHEN Target_Type_Name = 'PERCENT' and INHome_date in ('2013-08-27', '2013-10-28', '2013-02-25') and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_leads*Target_Value* Click_RR.Response_Rate* 0.875 * Adjustment_Factor*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date in ('2013-08-27', '2013-10-28', '2013-02-25') and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value* Click_RR.Response_Rate* 0.875 * Adjustment_Factor*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date in ('2013-08-27', '2013-10-28', '2013-02-25') and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='Wln Mix' THEN Forecasting.[2013_Lead_Forecast].LT_leads*Target_Value* Click_RR.Response_Rate* 0.875 * Adjustment_Factor*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date in ('2013-08-27', '2013-10-28', '2013-02-25') and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='PL BL LB' THEN Forecasting.[2013_Lead_Forecast].Spanish_leads*Target_Value* Click_RR.Response_Rate* 0.875 * Adjustment_Factor*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date in ('2013-08-27', '2013-10-28', '2013-02-25') and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='Wln NG' THEN Forecasting.[2013_Lead_Forecast].Recur_NG_leads*Target_Value* Click_RR.Response_Rate* 0.875 * Adjustment_Factor*Seasonality_Index


   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_leads*Target_Value* Click_RR.Response_Rate* Adjustment_Factor*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value* Click_RR.Response_Rate* Adjustment_Factor*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='Wln Mix' THEN Forecasting.[2013_Lead_Forecast].LT_leads*Target_Value* Click_RR.Response_Rate* Adjustment_Factor*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='PL BL LB' THEN Forecasting.[2013_Lead_Forecast].Spanish_leads*Target_Value* Click_RR.Response_Rate* Adjustment_Factor*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='Wln NG' THEN Forecasting.[2013_Lead_Forecast].Recur_NG_leads*Target_Value* Click_RR.Response_Rate* Adjustment_Factor*Seasonality_Index
    WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA') and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_leads *Target_Value* Click_RR.Response_Rate* Adjustment_Factor*Seasonality_Index
    WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='Span_Tag' THEN Forecasting.[2013_Lead_Forecast].Spanish_2_3*Target_Value * Click_RR.Response_Rate * Adjustment_Factor*Seasonality_Index
        
    
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Initial%' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value*0.23* Click_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Initial%' and Audience_Type_Name='Wln Mix' THEN (Forecasting.[2013_Lead_Forecast].LT_leads+Forecasting.[2013_Lead_Forecast].DMDR_leads+Forecasting.[2013_Lead_Forecast].Spanish_leads+Forecasting.[2013_Lead_Forecast].Recur_NG_leads)*Target_Value*0.23* Click_RR.Response_Rate*Seasonality_Index
   
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Reblast%' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value*0.23*.9* Click_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Reblast%' and Audience_Type_Name='Wln Mix' THEN (Forecasting.[2013_Lead_Forecast].LT_leads+Forecasting.[2013_Lead_Forecast].DMDR_leads+Forecasting.[2013_Lead_Forecast].Spanish_leads+Forecasting.[2013_Lead_Forecast].Recur_NG_leads)*Target_Value*0.23*.9* Click_RR.Response_Rate*Seasonality_Index

   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Engage%' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value*0.23*0.1* Click_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Engage%' and Audience_Type_Name='Wln Mix' THEN (Forecasting.[2013_Lead_Forecast].LT_leads+Forecasting.[2013_Lead_Forecast].DMDR_leads+Forecasting.[2013_Lead_Forecast].Spanish_leads+Forecasting.[2013_Lead_Forecast].Recur_NG_leads)*Target_Value*0.23*0.1* Click_RR.Response_Rate*Seasonality_Index

   WHEN Target_Type_Name = 'BUDGET' THEN Target_Value/Cost_Per_Piece * Click_RR.Response_Rate*Seasonality_Index
   END AS Click_Forecast,
---Call Sales Calculations 
   CASE WHEN Target_Type_Name = 'VOLUME' THEN Target_Value * Call_RR.Response_Rate * Adjustment_Factor  * Call_CR.Conversion_Rate*Seasonality_Index
   
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='DM' and Touch_Name_2 IN ('TV Upsell') AND inhome_date>'2012-12-30' THEN Forecasting.[2013_Lead_Forecast].TV_Upsell_Leads*Target_Value * Call_RR.Response_Rate  * Call_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='DM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.027) * Target_Value * Call_RR.Response_Rate  * Call_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='DM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.027)  * Target_Value * Call_RR.Response_Rate  * Call_CR.Conversion_Rate*Seasonality_Index
   
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 in ('TV Upsell initials') AND inhome_date>'2012-12-30' THEN Forecasting.[2013_Lead_Forecast].TV_Upsell_Leads*Target_Value*0.45 * Call_RR.Response_Rate * Call_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.027) * Target_Value*0.4 * Call_RR.Response_Rate * Call_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.027)  * Target_Value*0.4 * Call_RR.Response_Rate * Call_CR.Conversion_Rate*Seasonality_Index
   
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 like '%TV Upsell Engagement%' AND inhome_date>'2012-12-30' THEN (52000.0 * (month(inhome_date)+12.0) + 640285.0) * Target_Value*0.4*.12 * Call_RR.Response_Rate * Call_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell Engagement') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.027) * Target_Value*0.40*0.1 * Call_CR.Conversion_Rate * Call_RR.Response_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell Engagement') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.027)  * Target_Value*0.4*0.1 * Call_CR.Conversion_Rate * Call_RR.Response_Rate*Seasonality_Index
 
   WHEN Target_Type_Name = 'PERCENT' AND Touch_Name IN ('Wireline') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 4) + 0.1807) * Target_Value * Call_RR.Response_Rate  * Call_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Touch_Name IN ('Wireline') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month + 8) + 0.1807) * Target_Value * Call_RR.Response_Rate  * Call_CR.Conversion_Rate*Seasonality_Index
  
   WHEN Target_Type_Name = 'PERCENT' AND INHome_date<'2012-12-31' and Audience_Type_Name like '%NG%' THEN Forecasting.Current_MLP_New_Green.New_Green_ELU*Volume_Assumption/4  * Target_Value * Call_RR.Response_Rate  * Call_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date<'2012-12-31' THEN Forecasting.Current_MLP_Summary_View.Expr1 * Volume_Assumption * Target_Value * Call_RR.Response_Rate* Adjustment_Factor  * Call_CR.Conversion_Rate*Seasonality_Index
----2013 Specific Forecasting---- 
	-----Launch------
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='DM' and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_NG_leads*Target_Value * Call_RR.Response_Rate  * Call_CR.Conversion_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='DM' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_NG_leads*Target_Value * Call_RR.Response_Rate  * Call_CR.Conversion_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='DM' and Audience_Type_Name='Wln Mix' THEN Forecasting.[2013_Lead_Forecast].LT_NG_leads*Target_Value * Call_RR.Response_Rate  * Call_CR.Conversion_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='DM' and Audience_Type_Name='NG BL LB' THEN Forecasting.[2013_Lead_Forecast].SPANISH_NG_leads*Target_Value * Call_RR.Response_Rate  * Call_CR.Conversion_Rate*Seasonality_Index
	
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_NG_leads*Target_Value*0.22 * Call_RR.Response_Rate  * Call_CR.Conversion_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name in ('Wrls IRU','LT IRU') THEN Forecasting.[2013_Lead_Forecast].IRU_NG_leads*Target_Value*0.22 * Call_RR.Response_Rate  * Call_CR.Conversion_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name='Wln Mix' THEN Forecasting.[2013_Lead_Forecast].LT_NG_leads*Target_Value*0.22 * Call_RR.Response_Rate  * Call_CR.Conversion_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name='NG BL LB' THEN Forecasting.[2013_Lead_Forecast].SPANISH_NG_leads*Target_Value*0.22 * Call_RR.Response_Rate  * Call_CR.Conversion_Rate*Seasonality_Index
	-----Recurring------  
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_leads*Target_Value * Call_RR.Response_Rate * Adjustment_Factor  * Call_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value * Call_RR.Response_Rate * Adjustment_Factor  * Call_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='Wln Mix' THEN Forecasting.[2013_Lead_Forecast].LT_leads*Target_Value * Call_RR.Response_Rate * Adjustment_Factor  * Call_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='PL BL LB' THEN Forecasting.[2013_Lead_Forecast].Spanish_leads*Target_Value * Call_RR.Response_Rate * Adjustment_Factor  * Call_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='Wln NG' THEN Forecasting.[2013_Lead_Forecast].Recur_NG_leads*Target_Value * Call_RR.Response_Rate * Adjustment_Factor  * Call_CR.Conversion_Rate*Seasonality_Index
    WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA') and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_leads* Target_Value * Call_RR.Response_Rate * Adjustment_Factor  * Call_CR.Conversion_Rate*Seasonality_Index
     WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='Span_Tag' THEN Forecasting.[2013_Lead_Forecast].Spanish_2_3*Target_Value * Call_RR.Response_Rate * Adjustment_Factor  * Call_CR.Conversion_Rate*Seasonality_Index
   
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Initial%' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value*0.23* Call_RR.Response_Rate* Call_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Initial%' and Audience_Type_Name='Wln Mix' THEN (Forecasting.[2013_Lead_Forecast].LT_leads+Forecasting.[2013_Lead_Forecast].DMDR_leads+Forecasting.[2013_Lead_Forecast].Spanish_leads+Forecasting.[2013_Lead_Forecast].Recur_NG_leads)*Target_Value*0.23* Call_RR.Response_Rate* Call_CR.Conversion_Rate*Seasonality_Index
   
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Reblast%' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value*0.23*.9* Call_RR.Response_Rate* Call_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Reblast%' and Audience_Type_Name='Wln Mix' THEN (Forecasting.[2013_Lead_Forecast].LT_leads+Forecasting.[2013_Lead_Forecast].DMDR_leads+Forecasting.[2013_Lead_Forecast].Spanish_leads+Forecasting.[2013_Lead_Forecast].Recur_NG_leads)*Target_Value*0.23*.9* Call_RR.Response_Rate* Call_CR.Conversion_Rate*Seasonality_Index

   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Engage%' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value*0.23*0.1* Call_RR.Response_Rate* Call_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Engage%' and Audience_Type_Name='Wln Mix' THEN (Forecasting.[2013_Lead_Forecast].LT_leads+Forecasting.[2013_Lead_Forecast].DMDR_leads+Forecasting.[2013_Lead_Forecast].Spanish_leads+Forecasting.[2013_Lead_Forecast].Recur_NG_leads)*Target_Value*0.23*0.1* Call_RR.Response_Rate* Call_CR.Conversion_Rate*Seasonality_Index

   WHEN Target_Type_Name = 'BUDGET' THEN Target_Value/Cost_Per_Piece * Call_RR.Response_Rate * Call_CR.Conversion_Rate*Seasonality_Index
   END AS Call_Sales_Forecast,
---Click Sales Calculations 
   CASE WHEN Target_Type_Name = 'VOLUME' THEN Target_Value * Click_RR.Response_Rate * Click_CR.Conversion_Rate * Adjustment_Factor*Seasonality_Index
   
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='DM' and Touch_Name_2 IN ('TV Upsell') AND inhome_date>'2012-12-30' THEN Forecasting.[2013_Lead_Forecast].TV_Upsell_Leads*Target_Value * Click_RR.Response_Rate * Click_CR.Conversion_Rate* Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='DM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.027) * Click_RR.Response_Rate * Click_CR.Conversion_Rate* Target_Value*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='DM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.027)  * Click_RR.Response_Rate * Click_CR.Conversion_Rate* Target_Value*Seasonality_Index
   
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 in ('TV Upsell initials') AND inhome_date>'2012-12-30' THEN Forecasting.[2013_Lead_Forecast].TV_Upsell_Leads*Target_Value*0.45* Click_RR.Response_Rate * Click_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.027) * 0.4 * Click_RR.Response_Rate * Click_CR.Conversion_Rate* Target_Value*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.027)  * 0.4 * Click_RR.Response_Rate * Click_CR.Conversion_Rate* Target_Value*Seasonality_Index
   
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 like '%TV Upsell Engagement%' AND inhome_date>'2012-12-30' THEN (52000.0 * (month(inhome_date)+12.0) + 640285.0) * Target_Value*0.4*.12* Click_RR.Response_Rate * Click_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell Engagement') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.027) * Target_Value*0.40*0.1 * Click_RR.Response_Rate * Click_CR.Conversion_Rate* Target_Value*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell Engagement') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.027)  * Target_Value*0.4*0.1 * Click_RR.Response_Rate * Click_CR.Conversion_Rate* Target_Value*Seasonality_Index
 
   WHEN Target_Type_Name = 'PERCENT' AND Touch_Name IN ('Wireline') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 4) + 0.1807) * Click_RR.Response_Rate * Click_CR.Conversion_Rate* Target_Value*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' AND Touch_Name IN ('Wireline') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month + 8) + 0.1807) * Click_RR.Response_Rate * Click_CR.Conversion_Rate* Target_Value*Seasonality_Index
   
 --2012 recurring and new green
   WHEN Target_Type_Name = 'PERCENT' AND INHome_date<'2012-12-31' and Audience_Type_Name like '%NG%' THEN Forecasting.Current_MLP_New_Green.New_Green_ELU*Volume_Assumption/4  * Target_Value* Click_RR.Response_Rate * Click_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date<'2012-12-31' THEN Forecasting.Current_MLP_Summary_View.Expr1 * Volume_Assumption * Target_Value* Click_RR.Response_Rate* Adjustment_Factor * Click_CR.Conversion_Rate*Seasonality_Index
----2013 Specific Forecasting---- 
	-----Launch------
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='DM' and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_NG_leads*Target_Value* Click_RR.Response_Rate * Click_CR.Conversion_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='DM' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_NG_leads*Target_Value* Click_RR.Response_Rate * Click_CR.Conversion_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='DM' and Audience_Type_Name='Wln Mix' THEN Forecasting.[2013_Lead_Forecast].LT_NG_leads*Target_Value* Click_RR.Response_Rate * Click_CR.Conversion_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='DM' and Audience_Type_Name='NG BL LB' THEN Forecasting.[2013_Lead_Forecast].SPANISH_NG_leads*Target_Value* Click_RR.Response_Rate * Click_CR.Conversion_Rate*Seasonality_Index
	
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_NG_leads*Target_Value*0.22* Click_RR.Response_Rate * Click_CR.Conversion_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name in ('Wrls IRU','LT IRU') THEN Forecasting.[2013_Lead_Forecast].IRU_NG_leads*Target_Value*0.22* Click_RR.Response_Rate * Click_CR.Conversion_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name='Wln Mix' THEN Forecasting.[2013_Lead_Forecast].LT_NG_leads*Target_Value*0.22* Click_RR.Response_Rate * Click_CR.Conversion_Rate*Seasonality_Index
	WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name like '%Touch%' and media_Type='EM' and Audience_Type_Name='NG BL LB' THEN Forecasting.[2013_Lead_Forecast].SPANISH_NG_leads*Target_Value*0.22* Click_RR.Response_Rate * Click_CR.Conversion_Rate*Seasonality_Index
	-----Recurring------  
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_leads*Target_Value* Click_RR.Response_Rate* Adjustment_Factor * Click_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value* Click_RR.Response_Rate* Adjustment_Factor * Click_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='Wln Mix' THEN Forecasting.[2013_Lead_Forecast].LT_leads*Target_Value* Click_RR.Response_Rate* Adjustment_Factor * Click_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='PL BL LB' THEN Forecasting.[2013_Lead_Forecast].Spanish_leads*Target_Value* Click_RR.Response_Rate* Adjustment_Factor * Click_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA','DM') and Audience_Type_Name='Wln NG' THEN Forecasting.[2013_Lead_Forecast].Recur_NG_leads*Target_Value* Click_RR.Response_Rate* Adjustment_Factor * Click_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('CA') and Audience_Type_Name='Wrls Oly' THEN Forecasting.[2013_Lead_Forecast].DMDR_leads *Target_Value* Click_RR.Response_Rate* Adjustment_Factor * Click_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type in ('DM') and Audience_Type_Name='Span_Tag' THEN Forecasting.[2013_Lead_Forecast].Spanish_2_3*Target_Value * Call_RR.Response_Rate * Adjustment_Factor  * Click_CR.Conversion_Rate*Seasonality_Index
   
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Initial%' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value*0.23 * Click_RR.Response_Rate * Click_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Initial%' and Audience_Type_Name='Wln Mix' THEN (Forecasting.[2013_Lead_Forecast].LT_leads+Forecasting.[2013_Lead_Forecast].DMDR_leads+Forecasting.[2013_Lead_Forecast].Spanish_leads+Forecasting.[2013_Lead_Forecast].Recur_NG_leads)*Target_Value*0.23 * Click_RR.Response_Rate * Click_CR.Conversion_Rate*Seasonality_Index
   
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Reblast%' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value*0.23*.9 * Click_RR.Response_Rate * Click_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Reblast%' and Audience_Type_Name='Wln Mix' THEN (Forecasting.[2013_Lead_Forecast].LT_leads+Forecasting.[2013_Lead_Forecast].DMDR_leads+Forecasting.[2013_Lead_Forecast].Spanish_leads+Forecasting.[2013_Lead_Forecast].Recur_NG_leads)*Target_Value*0.23*.9 * Click_RR.Response_Rate * Click_CR.Conversion_Rate*Seasonality_Index

   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Engage%' and Audience_Type_Name='Wrls IRU' THEN Forecasting.[2013_Lead_Forecast].IRU_leads*Target_Value*0.23*0.1 * Click_RR.Response_Rate * Click_CR.Conversion_Rate*Seasonality_Index
   WHEN Target_Type_Name = 'PERCENT' and INHome_date>='2012-12-31' and touch_name not like '%Touch%' and media_Type='EM' and touch_name_2 like '%Engage%' and Audience_Type_Name='Wln Mix' THEN (Forecasting.[2013_Lead_Forecast].LT_leads+Forecasting.[2013_Lead_Forecast].DMDR_leads+Forecasting.[2013_Lead_Forecast].Spanish_leads+Forecasting.[2013_Lead_Forecast].Recur_NG_leads)*Target_Value*0.23*0.1 * Click_RR.Response_Rate * Click_CR.Conversion_Rate*Seasonality_Index

  ---Budget Defined---
   WHEN Target_Type_Name = 'BUDGET' THEN Target_Value/Cost_Per_Piece * Click_RR.Response_Rate * Click_CR.Conversion_Rate*Seasonality_Index
   END AS Click_Sales_Forecast,

/*
---Confidence Interval Calculations - For 95% Interval
	---Calls
   CASE WHEN Target_Value=0 then 0
   ELSE	CASE WHEN Target_Type_Name = 'VOLUME' THEN Target_Value*1.96*sqrt(((Call_RR.Response_Rate*Adjustment_Factor)*(1-(Call_RR.Response_Rate*Adjustment_Factor)))/Target_Value) 
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='DM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.027) * Target_Value * 1.96*sqrt((Call_RR.Response_Rate*(1-Call_RR.Response_Rate))/(Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.022) * Target_Value))
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='DM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.027)  * Target_Value * 1.96*sqrt((Call_RR.Response_Rate*(1-Call_RR.Response_Rate))/(Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.022) * Target_Value))
   
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.027) * Target_Value*0.4 * 1.96*sqrt((Call_RR.Response_Rate*(1-Call_RR.Response_Rate))/(Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.022) * Target_Value*0.4))
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.027)  * Target_Value*0.4 * 1.96*sqrt((Call_RR.Response_Rate*(1-Call_RR.Response_Rate))/(Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.022) * Target_Value*0.4))
   
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell Engagement') AND Date_Year = 2012 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.027) * Target_Value*0.40*0.1 * 1.96*sqrt((Call_RR.Response_Rate*(1-Call_RR.Response_Rate))/(Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * Date_Month + 0.022) * Target_Value*0.4*0.1))
   WHEN Target_Type_Name = 'PERCENT' AND Media_Type='EM' and Touch_Name_2 IN ('TV Upsell Engagement') AND Date_Year = 2011 THEN Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.027)  * Target_Value*0.4*0.1 * 1.96*sqrt((Call_RR.Response_Rate*(1-Call_RR.Response_Rate))/(Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 12) + 0.022) * Target_Value*0.4*0.1))
 
   WHEN Target_Type_Name = 'PERCENT' AND Touch_Name IN ('Wireline') AND Date_Year = 2011 THEN (Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 4) + 0.1807) * Target_Value) * 1.96*sqrt((Call_RR.Response_Rate*(1-Call_RR.Response_Rate))/(Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month - 4) + 0.1807) * Target_Value))
   WHEN Target_Type_Name = 'PERCENT' AND Touch_Name IN ('Wireline') AND Date_Year = 2012 THEN (Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month + 8) + 0.1807) * Target_Value) * 1.96*sqrt((Call_RR.Response_Rate*(1-Call_RR.Response_Rate))/(Forecasting.Current_MLP_Summary_View.Expr1 * (Volume_Assumption * (Date_Month + 8) + 0.1807) * Target_Value))
   WHEN Target_Type_Name = 'PERCENT' AND Audience_Type_Name like '%NG%' THEN (Forecasting.Current_MLP_New_Green.New_Green_ELU*Volume_Assumption/4 * Target_Value) * 1.96*sqrt((Call_RR.Response_Rate*(1-Call_RR.Response_Rate))/(Forecasting.Current_MLP_New_Green.New_Green_ELU*Volume_Assumption/4 * Target_Value))
   WHEN Target_Type_Name = 'PERCENT' THEN (Forecasting.Current_MLP_Summary_View.Expr1 * Volume_Assumption * Target_Value) *1.96*sqrt(((Call_RR.Response_Rate*Adjustment_Factor)*(1-(Call_RR.Response_Rate*Adjustment_Factor)))/(Forecasting.Current_MLP_Summary_View.Expr1 * Volume_Assumption * Target_Value))
   WHEN Target_Type_Name = 'BUDGET' THEN (Target_Value/Cost_Per_Piece) * 1.96*sqrt((Call_RR.Response_Rate*(1-Call_RR.Response_Rate))/(Target_Value/Cost_Per_Piece))
   END 
   END AS Call_Forecast_Interval,
*/
---General Error Check Information
   DIM.Media_Calendar_Daily.Date_Month AS Volume_Month, 
   Forecasting.Most_Recent_Volume_Assumptions.Volume_Assumption, 
   Call_RR.Response_Rate as Call_Response_Rate,
   Click_RR.Response_Rate as Click_Response_Rate,
   Call_CR.Conversion_Rate as Call_Conv_Rate,
   Click_CR.Conversion_Rate as Click_Conv_Rate,
   Adjustment_Factor AS Decile_Adjustment
      
 FROM          Forecasting.Current_AdHoc_Flightplan LEFT JOIN
 
 ---Volume Linkages
              DIM.Media_Calendar_Daily 
					ON Forecasting.Current_AdHoc_Flightplan.Volume_Date = DIM.Media_Calendar_Daily.[Date] LEFT OUTER JOIN
              Forecasting.Current_MLP_Summary_View 
					ON datepart(year,Forecasting.Current_AdHoc_Flightplan.Volume_Date) = Forecasting.Current_MLP_Summary_View.MLP_Year AND 
					datepart(month,Forecasting.Current_AdHoc_Flightplan.Volume_Date) = Forecasting.Current_MLP_Summary_View.MLP_Month LEFT OUTER JOIN
              Forecasting.Most_Recent_Volume_Assumptions 
					ON Forecasting.Current_AdHoc_Flightplan.Touch_Type_FK = Forecasting.Most_Recent_Volume_Assumptions.Touch_Type_FK LEFT OUTER JOIN
              Forecasting.Current_MLP_New_Green
					ON datepart(month,InHome_Date)= Forecasting.Current_MLP_New_Green.MLP_Month AND 
					datepart(year,InHome_Date)=Forecasting.Current_MLP_New_Green.MLP_Year LEFT OUTER JOIN
			  Forecasting.[2013_Lead_Forecast]
					ON  Forecasting.Current_AdHoc_Flightplan.Inhome_MediaMonth= Forecasting.[2013_Lead_Forecast].Month_Leads AND
					Forecasting.Current_AdHoc_Flightplan.Inhome_MediaMonth_Year=Forecasting.[2013_Lead_Forecast].Year_Leads LEFT OUTER JOIN
			  
---Budget and CPP Linkage
			  Forecasting.Most_Recent_CPP_Assumptions
					ON Forecasting.Current_AdHoc_Flightplan.Touch_Type_FK = Forecasting.Most_Recent_CPP_Assumptions.Touch_Type_FK LEFT OUTER JOIN
					
---Response Rate Linkage
			  Forecasting.Most_Recent_RR_Assumptions AS Call_RR
					ON Forecasting.Current_AdHoc_Flightplan.Touch_Type_FK = Call_RR.Touch_Type_FK and Call_RR.Response_Channel_FK=1 LEFT OUTER JOIN
			  Forecasting.Most_Recent_RR_Assumptions AS Click_RR
					ON Forecasting.Current_AdHoc_Flightplan.Touch_Type_FK = Click_RR.Touch_Type_FK and Click_RR.Response_Channel_FK=2 LEFT OUTER JOIN
			  Forecasting.Most_Recent_Decile_Adjustments
					ON Forecasting.Current_AdHoc_Flightplan.Touch_Type_FK = Forecasting.Most_Recent_Decile_Adjustments.Touch_Type_FK 
					and ROUND(Forecasting.Current_AdHoc_Flightplan.Decile_Targeted,1)=ROUND(ROUND(Forecasting.Most_Recent_Decile_Adjustments.Percent_Target,1)*10,1) LEFT OUTER JOIN

---Conversion Rate Linkage
			  Forecasting.Most_Recent_Conversions_View AS Call_CR
					ON Forecasting.Current_AdHoc_Flightplan.Touch_Type_FK = Call_CR.Touch_Type_FK and Call_CR.Response_Channel_FK=1 LEFT OUTER JOIN
			  Forecasting.Most_Recent_Conversions_View AS Click_CR
					ON Forecasting.Current_AdHoc_Flightplan.Touch_Type_FK = Click_CR.Touch_Type_FK and Click_CR.Response_Channel_FK=2 LEFT OUTER JOIN

---Seasonality Linkage
			  Forecasting.Seasonality as Seasonality
					ON Forecasting.Current_AdHoc_Flightplan.Media_Type_FK=Seasonality.Media_Type_FK and month(Forecasting.Current_AdHoc_Flightplan.inhome_date)=Seasonality.Seasonality_Month






