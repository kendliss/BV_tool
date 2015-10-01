
create proc [bvt_processed].[UCLM_GP_Best_View_Forecast_PR]
as
declare @lst_load datetime
select @lst_load = (select MAX(load_dt) from bvt_processed.UCLM_GP_Best_View_Forecast)
select * from bvt_processed.UCLM_GP_Best_View_Forecast
where load_dt= @lst_load

