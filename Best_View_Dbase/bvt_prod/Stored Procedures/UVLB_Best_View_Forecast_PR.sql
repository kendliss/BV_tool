




CREATE procedure [bvt_prod].[UVLB_Best_View_Forecast_PR]
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
EXEC bvt_processed.UVLB_Flight_Plan_PR
declare @ts datetime
set @ts = GETDATE()
insert into bvt_processed.UVLB_Best_View_Forecast
select *, @ts from bvt_prod.UVLB_Best_View_Forecast_VW

insert into bvt_processed.UVLB_Best_View_Forecast_WKLY
select idFlight_Plan_Records,
Campaign_Name,
InHome_Date,
Media_Year,
Media_Week,
Media_Month,
Touch_Name,
Program_Name,
Tactic,
Media,
Campaign_Type,
Audience,
Creative_Name,
Goal,
Offer,
KPI_Type,
Product_Code,
sum(forecast) as Forecast,
load_dt from bvt_processed.UVLB_Best_View_Forecast
GROUP BY idFlight_Plan_Records,
Campaign_Name,
InHome_Date,
Media_Year,
Media_Week,
Media_Month,
Touch_Name,
Program_Name,
Tactic,
Media,
Campaign_Type,
Audience,
Creative_Name,
Goal,
Offer,
KPI_Type,
Product_Code,
load_dt

set nocount off


