USE UVAQ

GO

DROP VIEW [bvt_prod].[UCLM_Financial_Budget_Forecast]

Go


CREATE VIEW [bvt_prod].[UCLM_Financial_Budget_Forecast]
as

 select 
	FP.idFlight_Plan_Records
	, FP.Campaign_Name
	, FP.InHome_Date
	, FP.idCPP_Category_FK
	, touchdef.Touch_Name
	, touchdef.Program_Name
	, touchdef.Tactic
	, touchdef.Media
	, touchdef.Campaign_Type
	, touchdef.Audience
	, touchdef.Creative_Name
	, touchdef.Goal
	, touchdef.Offer
	, FP.bill_month
	, FP.bill_year
	, FP.budget
	, A.mediaweek
	

	from 
	(select min(iso_week) as mediaweek, MediaMonth, MediaMonth_year from dim.Media_Calendar_Daily group by MediaMonth, MediaMonth_year) A
	JOIN (Select flight_plan_records.idFlight_Plan_Records
			, flight_plan_records.Campaign_Name
			, flight_plan_records.InHome_Date
			, flight_plan_records.idProgram_Touch_Definitions_TBL_FK
			, idCPP_Category_FK
			, Bill_Month
			, Bill_Year
			, Budget

		from bvt_prod.UCLM_Flight_Plan_VW as flight_plan_records
			left join bvt_prod.Flight_Plan_Record_Budgets
				on flight_plan_records.idFlight_Plan_Records=idFlight_Plan_Records_FK
		where Budget_Type_LU_TBL_idBudget_Type_LU_TBL = 2
		
		UNION Select flight_plan_records.idFlight_Plan_Records
			, flight_plan_records.Campaign_Name
			, flight_plan_records.InHome_Date
			, flight_plan_records.idProgram_Touch_Definitions_TBL_FK
			, idCPP_Category_FK
			, month(DATEADD(month,bill_timing,Flight_Plan_Records.InHome_Date)) as Bill_Month
			, year(DATEADD(month,bill_timing,Flight_Plan_Records.InHome_Date)) as Bill_Year
			, case when idCPP_Category_FK=16 then CPP
				else CPP*Volume end as Budget

		from bvt_prod.UCLM_Flight_Plan_VW as flight_plan_records
			LEFT join (select * from bvt_prod.CPP_Start_End_FUN('UVCLM')) cpp
				on flight_plan_records.idProgram_Touch_Definitions_TBL_FK=CPP.idProgram_Touch_Definitions_TBL_FK
					and flight_plan_records.InHome_Date between CPP.CPP_Start_Date and CPP.END_DATE
			LEFT join bvt_prod.UCLM_Flightplan_Volume_Forecast_VW as FPV
				on flight_plan_records.idFlight_Plan_Records=FPV.idFlight_Plan_Records
		where Budget_Type_LU_TBL_idBudget_Type_LU_TBL = 1) FP
			on FP.Bill_Month =A.MediaMonth and FP.Bill_Year=A.MediaMonth_Year
		left join
		-----Bring in touch definition labels 
(select idProgram_Touch_Definitions_TBL, Touch_Name, Program_Name, Tactic, Media, Audience, Creative_Name, Goal, Offer, Campaign_Type
		 from bvt_prod.Program_Touch_Definitions_TBL
			left join bvt_prod.Audience_LU_TBL on idAudience_LU_TBL_FK=idAudience_LU_TBL
			left join bvt_prod.Campaign_Type_LU_TBL on idCampaign_Type_LU_TBL_FK=idCampaign_Type_LU_TBL
			left join bvt_prod.Creative_LU_TBL on idCreative_LU_TBL_fk=idCreative_LU_TBL
			left join bvt_prod.Goal_LU_TBL on idGoal_LU_TBL_fk=idGoal_LU_TBL
			left join bvt_prod.Media_LU_TBL on idMedia_LU_TBL_fk=idMedia_LU_TBL
			left join bvt_prod.Offer_LU_TBL on idOffer_LU_TBL_fk=idOffer_LU_TBL
			left join bvt_prod.Program_LU_TBL on idProgram_LU_TBL_fk=idProgram_LU_TBL
			left join bvt_prod.Tactic_LU_TBL on idTactic_LU_TBL_fk=idTactic_LU_TBL) as touchdef
		on FP.idProgram_Touch_Definitions_TBL_FK=idProgram_Touch_Definitions_TBL 

GO