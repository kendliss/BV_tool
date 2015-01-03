

CREATE proc [bvt_processed].[Mover_CV_Lockdown_PR]
as
declare @lst_load datetime
declare @extract_date datetime
declare @cv_submission varchar(255)

set @extract_date=GETDATE()
set @cv_submission = 'Movers CV'
select @lst_load = (select MAX(load_dt) from bvt_processed.Movers_Best_View_Forecast)

insert into bvt_processed.Commitment_Views
(id_Flight_Plan_Records_FK,
idProgram_Touch_Definitions_TBL_FK,
Campaign_Name,
InHome_Date,
Media_Year,
Media_Month,
Media_Week,
KPI_TYPE,
Product_Code,
Forecast_DayDate,
Forecast,
CV_Submission,
Extract_Date)
select a.idFlight_Plan_Records,
idProgram_Touch_Definitions_TBL_FK,
a.Campaign_Name,
a.InHome_Date,
Media_Year,
Media_Month,
Media_Week,
KPI_TYPE,
Product_Code,
Forecast_DayDate,
Forecast,
@cv_submission,
@extract_date
from bvt_processed.Movers_Best_View_Forecast as a inner join bvt_prod.Flight_Plan_Records as b
	 on a.idFlight_Plan_Records=b.idFlight_Plan_Records
where load_dt= @lst_load


insert into bvt_processed.Commitment_Views_Financial
(idFlight_Plan_Records_FK,
idProgram_Touch_Definitions_TBL_FK,
Campaign_Name,
InHome_Date,
idCPP_Category_FK,
bill_month,
bill_year,
budget,
CV_Submission,
Extract_Date)
select 
	a.idFlight_Plan_Records,
	b.idProgram_Touch_Definitions_TBL_FK,
	a.Campaign_Name,
	a.inhome_date,
	idCPP_Category_FK,
bill_month,
bill_year,
budget,
@cv_submission,
@extract_date
	
from bvt_prod.Financial_Budget_Forecast as a inner join bvt_prod.Flight_Plan_Records as b
	 on a.idFlight_Plan_Records=b.idFlight_Plan_Records
where PROGRAM_NAME='MOVERS'


