


CREATE procedure [bvt_prod].[UCLM_Best_View_Forecast_PR]
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
EXEC bvt_processed.UCLM_Flight_Plan_PR
declare @ts datetime
set @ts = GETDATE()
insert into bvt_processed.UCLM_Best_View_Forecast
select *, @ts from bvt_prod.Movers_Best_View_Forecast_VW
set nocount off
