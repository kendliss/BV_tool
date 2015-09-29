drop procedure [bvt_prod].[Movers_Best_View_Forecast_PR]
GO

CREATE procedure [bvt_prod].[Movers_Best_View_Forecast_PR]
as
set nocount on
EXEC bvt_processed.CPP_Start_End_PR
EXEC bvt_processed.Dropdate_Start_End_PR
EXEC bvt_processed.KPI_Rate_Start_End_PR
EXEC bvt_processed.Response_Curve_Start_End_PR
EXEC bvt_processed.Response_Daily_Start_End_PR
EXEC bvt_processed.Sales_Curve_Start_End_PR
EXEC bvt_processed.Sales_Rates_Start_End_PR
EXEC bvt_processed.Target_Adjustment_Start_End_PR
EXEC bvt_processed.Movers_Flight_Plan_PR
declare @ts datetime
set @ts = GETDATE()
insert into bvt_processed.Movers_Best_View_Forecast
select [idFlight_Plan_Records], [Campaign_Name], [InHome_Date], [Media_Year], [Media_Week], [Media_Month], 
[Touch_Name], [Program_Name], [Tactic], [Media], [Campaign_Type], [Audience], [Creative_Name], [Goal], 
[Offer], [KPI_Type], [Product_Code], [Forecast_DayDate], 
/*ADDING A CASE STATEMENT TO ONLY OUTPUT ONE VOLUME FOR MOVE ATT TO PREVENT DOUBLE COUNTING*/
	case when kpi_type='Volume' and touch_name='MoveATT' and campaign_name like '%TFN%' then 0
	else [Forecast]
	end as [Forecast], 
@ts, [owner_type_matrix_id_FK] 
from bvt_prod.Movers_Best_View_Forecast_VW
set nocount off

GO