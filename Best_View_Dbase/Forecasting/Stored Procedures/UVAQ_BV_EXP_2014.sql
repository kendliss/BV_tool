

create procedure forecasting.UVAQ_BV_EXP_2014

as

insert into forecasting.UVAQ_Weekly_BV_2014
select *, GETDATE() from Forecasting.Current_UVAQ_Best_View_Weekly_2014

