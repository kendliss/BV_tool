CREATE PROCEDURE [bvt_prod].[UCLM_GP_Best_View_Forecast_WKLY_PR]
as
declare @lst_load datetime
select @lst_load = (select MAX(load_dt) from bvt_processed.UCLM_GP_Best_View_Forecast)
select [idFlight_Plan_Records], [Campaign_Name], [InHome_Date], [Media_Year], [Media_Week], [Media_Month], 
[Touch_Name], [Program_Name], [Tactic], [Media], [Campaign_Type], [Audience], [Creative_Name], 
[Goal], [Offer], [KPI_Type], [Product_Code], sum([Forecast]) as Forecast, load_dt

from bvt_processed.UCLM_GP_Best_View_Forecast
where load_dt= @lst_load
group by [idFlight_Plan_Records], [Campaign_Name], [InHome_Date], [Media_Year], [Media_Week], [Media_Month], 
[Touch_Name], [Program_Name], [Tactic], [Media], [Campaign_Type], [Audience], [Creative_Name], 
[Goal], [Offer], [KPI_Type], [Product_Code], load_dt
RETURN 0
