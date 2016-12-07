

create procedure [bvt_staging].[sp_FlightPlanImportProcessing]

as
---Transform the raw import into id standards
select idProgram_LU_TBL, CampaignName, CampaignDate, tfn, url, idProgram_Touch_Definitions_TBL
	, idBudget_Type_LU_TBL, idVolume_Type_LU_TBL, idTarget_Rate_Reasons_LU_TBL, budget
	, budgetMonth, bill_year, volume

into #flightplan

from bvt_staging.FlightPlanImports
	
	left join UVAQ.bvt_prod.Program_LU_TBL as plu
		on program=plu.Program_Name
	left join UVAQ.bvt_prod.Program_Touch_Definitions_TBL as ptdt
		on touchtype=ptdt.Touch_Name
	left join UVAQ.bvt_prod.Budget_Type_LU_TBL as btlu
		on budgettype=btlu.Budget_Calculation
	left join UVAQ.bvt_prod.Volume_Type_LU_TBL as vtlu
		on volumetype=vtlu.Volume_Type
	left join UVAQ.bvt_prod.Target_Rate_Reasons_LU_TBL as trrlu
		on target_adj=trrlu.Adjustment_Reason
		
--insert bad transformations into an error table
insert into bvt_staging.FlightPlanImports_TransformErrors
(idProgram_LU_TBL, CampaignName, CampaignDate, tfn, url, idProgram_Touch_Definitions_TBL
	, idBudget_Type_LU_TBL, idVolume_Type_LU_TBL, idTarget_Rate_Reasons_LU_TBL, budget
	, budgetMonth, bill_year, volume)
select * from #flightplan where idVolume_Type_LU_TBL is null or idProgram_Touch_Definitions_TBL is null or idBudget_Type_LU_TBL is null 
		
		
		
--insert campaigns into the flight plan records table
insert into UVAQ.bvt_prod.Flight_Plan_Records
(idVolume_Type_LU_TBL_FK, idProgram_Touch_Definitions_TBL_FK, Budget_Type_LU_TBL_idBudget_Type_LU_TBL, Campaign_Name
	, InHome_Date, TFN_ind, URL_ind, idTarget_Rate_Reasons_LU_TBL_FK)
select idVolume_Type_LU_TBL, idProgram_Touch_Definitions_TBL, idBudget_Type_LU_TBL, CampaignName,
	 CampaignDate, tfn, url, idTarget_Rate_Reasons_LU_TBL
	from #flightplan
--the where statement below only inserts valid transformations
where idVolume_Type_LU_TBL is not null and idProgram_Touch_Definitions_TBL is not null and idBudget_Type_LU_TBL is not null 
group by idVolume_Type_LU_TBL, idProgram_Touch_Definitions_TBL, idBudget_Type_LU_TBL, CampaignName,
	 CampaignDate, tfn, url, idTarget_Rate_Reasons_LU_TBL
	
--insert volumes into the volumes table for manual entry volumes
insert into UVAQ.bvt_prod.Flight_Plan_Records_Volume
(idVolume_Status_LU_FK, Volume, idFlight_Plan_Records_FK)
select 1, volume, idFlight_Plan_Records
	from 
		(select idVolume_Type_LU_TBL, idProgram_Touch_Definitions_TBL, idBudget_Type_LU_TBL, CampaignName,
			CampaignDate, volume
		from #flightplan
		group by idVolume_Type_LU_TBL, idProgram_Touch_Definitions_TBL, idBudget_Type_LU_TBL, CampaignName,
			CampaignDate, volume) as import
			
		inner join UVAQ.bvt_prod.Flight_Plan_Records
		
		on import.idVolume_Type_LU_TBL=Flight_Plan_Records.idVolume_Type_LU_TBL_FK
		and import.idProgram_Touch_Definitions_TBL=Flight_Plan_Records.idProgram_Touch_Definitions_TBL_FK
		and import.idBudget_Type_LU_TBL=Flight_Plan_Records.Budget_Type_LU_TBL_idBudget_Type_LU_TBL
		and import.CampaignName=Flight_Plan_Records.Campaign_Name
		and import.CampaignDate=Flight_Plan_Records.InHome_Date
	
	where idVolume_Type_LU_TBL=2
		
--insert budgets into budgets table for manual budgets
insert into UVAQ.bvt_prod.Flight_Plan_Record_Budgets
(idBudget_Status_LU_FK, Budget, Bill_Year, Bill_Month, idFlight_Plan_Records_FK)
select 1, budget, bill_year, BudgetMonth, idFlight_Plan_Records
	from (select idVolume_Type_LU_TBL, idProgram_Touch_Definitions_TBL, idBudget_Type_LU_TBL, CampaignName,
			CampaignDate, BudgetMonth, bill_year, budget
		from #flightplan
		group by idVolume_Type_LU_TBL, idProgram_Touch_Definitions_TBL, idBudget_Type_LU_TBL, CampaignName,
			CampaignDate, BudgetMonth, bill_year, budget) as import
			
	inner join UVAQ.bvt_prod.Flight_Plan_Records
		
		on import.idVolume_Type_LU_TBL=Flight_Plan_Records.idVolume_Type_LU_TBL_FK
		and import.idProgram_Touch_Definitions_TBL=Flight_Plan_Records.idProgram_Touch_Definitions_TBL_FK
		and import.idBudget_Type_LU_TBL=Flight_Plan_Records.Budget_Type_LU_TBL_idBudget_Type_LU_TBL
		and import.CampaignName=Flight_Plan_Records.Campaign_Name
		and import.CampaignDate=Flight_Plan_Records.InHome_Date
	
	where idBudget_Type_LU_TBL=2
GO


