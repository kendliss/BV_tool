drop view  [bvt_prod].[Movers_Financial_Budget_Forecast]
go

create view [bvt_prod].[Movers_Financial_Budget_Forecast]
as select 
	flight_plan_records.idFlight_Plan_Records
	, flight_plan_records.Campaign_Name
	, flight_plan_records.InHome_Date
	, idCPP_Category_FK
	
	, Touch_Name
	, Program_Name
	, Tactic
	, Media
	, Campaign_Type
	, Audience
	, Creative_Name
	, Goal
	, Offer
	, [owner_type_matrix_id_FK]
	
	, case when Budget_Type_LU_TBL_idBudget_Type_LU_TBL=2 then Bill_Month
		when [idCPP_Category_FK]=5 then month(DATEADD(month,bill_timing,dateadd(day,[Days_Before_Inhome],Flight_Plan_Records.InHome_Date))) 
		when MONTH(Flight_Plan_Records.InHome_Date)=12 then 12
		else month(DATEADD(month,bill_timing,dateadd(day,[Days_Before_Inhome],Flight_Plan_Records.InHome_Date))) 
		end as bill_month
	, case when Budget_Type_LU_TBL_idBudget_Type_LU_TBL=2 then Bill_Year
		when [idCPP_Category_FK]=5 then year(DATEADD(month,bill_timing,dateadd(day,[Days_Before_Inhome],Flight_Plan_Records.InHome_Date))) 
		when MONTH(Flight_Plan_Records.InHome_Date)=12 then year(Flight_Plan_Records.InHome_Date)
		else year(DATEADD(month,bill_timing,dateadd(day,[Days_Before_Inhome],Flight_Plan_Records.InHome_Date))) 
		end as bill_year
	, case when Budget_Type_LU_TBL_idBudget_Type_LU_TBL=2 then Budget
		else CPP*Volume end as budget
	, ISO_Week as mediaweek
	
	from bvt_prod.Movers_Flight_Plan_VW as flight_plan_records
		left join bvt_prod.Flight_Plan_Record_Budgets
			on flight_plan_records.idFlight_Plan_Records=idFlight_Plan_Records_FK
		LEFT join (SELECT * FROM [bvt_prod].[CPP_Start_End_FUN]('MOVERS')) AS CPP_Start_End
			on flight_plan_records.idProgram_Touch_Definitions_TBL_FK=CPP_Start_End.idProgram_Touch_Definitions_TBL_FK
			and flight_plan_records.InHome_Date between CPP_Start_End.CPP_Start_Date and CPP_Start_End.END_DATE
		LEFT join bvt_prod.Movers_Flightplan_Volume_Forecast_VW as FPV
			on flight_plan_records.idFlight_Plan_Records=FPV.idFlight_Plan_Records
		left join (SELECT * FROM [bvt_prod].[Dropdate_Start_End_FUN]('MOVERS')) AS dropdate_start_end
			on flight_plan_records.idProgram_Touch_Definitions_TBL_FK=dropdate_start_end.[idProgram_Touch_Definitions_TBL_FK]
				and inhome_date between [drop_start_date] and dropdate_start_end.end_date

		left join dim.Media_Calendar_Daily as A
			on dateadd(DAY,days_before_inhome,Flight_Plan_Records.InHome_Date)=a.[date]
		left join
		-----Bring in touch definition labels 
(select idProgram_Touch_Definitions_TBL, Touch_Name, Program_Name, Tactic, Media, Audience, Creative_Name, Goal, Offer, Campaign_Type, [owner_type_matrix_id_FK]
		 from bvt_prod.Program_Touch_Definitions_TBL
			left join bvt_prod.Audience_LU_TBL on idAudience_LU_TBL_FK=idAudience_LU_TBL
			left join bvt_prod.Campaign_Type_LU_TBL on idCampaign_Type_LU_TBL_FK=idCampaign_Type_LU_TBL
			left join bvt_prod.Creative_LU_TBL on idCreative_LU_TBL_fk=idCreative_LU_TBL
			left join bvt_prod.Goal_LU_TBL on idGoal_LU_TBL_fk=idGoal_LU_TBL
			left join bvt_prod.Media_LU_TBL on idMedia_LU_TBL_fk=idMedia_LU_TBL
			left join bvt_prod.Offer_LU_TBL on idOffer_LU_TBL_fk=idOffer_LU_TBL
			left join bvt_prod.Program_LU_TBL on idProgram_LU_TBL_fk=idProgram_LU_TBL
			left join bvt_prod.Tactic_LU_TBL on idTactic_LU_TBL_fk=idTactic_LU_TBL) as touchdef
		on Flight_Plan_Records.idProgram_Touch_Definitions_TBL_FK=idProgram_Touch_Definitions_TBL 

