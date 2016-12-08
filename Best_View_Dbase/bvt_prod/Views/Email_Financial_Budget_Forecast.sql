drop view [bvt_prod].[Email_Financial_Budget_Forecast]
GO

create view [bvt_prod].[Email_Financial_Budget_Forecast]
as select 
	flight_plan_records.idFlight_Plan_Records
	, flight_plan_records.Campaign_Name
	, flight_plan_records.InHome_Date
	, CPP_Start_End.idCPP_Category_FK
	
	, Touch_Name
	, Program_Name
	, Tactic
	, Media
	, Campaign_Type
	, Audience
	, Creative_Name
	, Goal
	, Offer
	
	, case when Budget_Type_LU_TBL_idBudget_Type_LU_TBL=2 then Bill_Month
		when CPP_Start_End.[idCPP_Category_FK]=5 then month(DATEADD(month,bill_timing,Flight_Plan_Records.InHome_Date)) 
		when MONTH(Flight_Plan_Records.InHome_Date)=12 then 12
		else month(DATEADD(month,bill_timing,Flight_Plan_Records.InHome_Date)) 
		end as bill_month
	, case when Budget_Type_LU_TBL_idBudget_Type_LU_TBL=2 then Bill_Year
		when CPP_Start_End.[idCPP_Category_FK]=5 then year(DATEADD(month,bill_timing,Flight_Plan_Records.InHome_Date)) 
		when MONTH(Flight_Plan_Records.InHome_Date)=12 then year(Flight_Plan_Records.InHome_Date)
		else year(DATEADD(month,bill_timing,Flight_Plan_Records.InHome_Date)) 
		end as bill_year
	, case when Budget_Type_LU_TBL_idBudget_Type_LU_TBL=2 then Budget
		else CPP*Volume end as budget
	, mediaweek
	
	from [bvt_prod].[Email_Flight_Plan_VW] as flight_plan_records
		left join bvt_prod.Flight_Plan_Record_Budgets
			on flight_plan_records.idFlight_Plan_Records=idFlight_Plan_Records_FK
		LEFT join (SELECT * FROM [bvt_prod].[CPP_Start_End_FUN](11)) AS CPP_Start_End
			on flight_plan_records.idProgram_Touch_Definitions_TBL_FK=CPP_Start_End.idProgram_Touch_Definitions_TBL_FK
			and flight_plan_records.InHome_Date between CPP_Start_End.CPP_Start_Date and CPP_Start_End.END_DATE
		LEFT join bvt_prod.Email_Flightplan_Volume_Forecast_VW as FPV
			on flight_plan_records.idFlight_Plan_Records=FPV.idFlight_Plan_Records
		
		right join (select min(iso_week) as mediaweek, MediaMonth, MediaMonth_year from dim.Media_Calendar_Daily group by MediaMonth, MediaMonth_year) as A
			on (case when Budget_Type_LU_TBL_idBudget_Type_LU_TBL=2 then Bill_Month
		when MONTH(Flight_Plan_Records.InHome_Date)=12 then 12
		else month(DATEADD(month,bill_timing,Flight_Plan_Records.InHome_Date)) 
		end)= A.MediaMonth and (case when Budget_Type_LU_TBL_idBudget_Type_LU_TBL=2 then Bill_Year
		when month(Flight_Plan_Records.InHome_Date)=12 then YEAR(Flight_Plan_Records.inhome_date)
		else year(DATEADD(month,bill_timing,Flight_Plan_Records.InHome_Date)) 
		end)=A.MediaMonth_Year
		-----Bring in touch definition labels 
		left join [bvt_prod].[Touch_Definition_VW]
			on Flight_Plan_Records.idProgram_Touch_Definitions_TBL_FK=[Touch_Definition_VW].idProgram_Touch_Definitions_TBL 

