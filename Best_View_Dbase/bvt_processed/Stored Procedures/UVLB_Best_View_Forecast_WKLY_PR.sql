

create proc [bvt_processed].[UVLB_Best_View_Forecast_WKLY_PR]
as
declare @lst_load datetime
select @lst_load = (select MAX(load_dt) from bvt_processed.UVLB_Best_View_Forecast_WKLY)
select * from bvt_processed.UVLB_Best_View_Forecast_WKLY
where load_dt= @lst_load


