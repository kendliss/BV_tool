CREATE procedure [Forecasting].[cv_actual_ytd_2014_flat]
as select 
Project, Media_Type, Program_Owner, Source_Data, Metric, SUM(value) as Value
from Forecasting.Weekly_Best_View_Flat
where Metric in ('Budget', 'Volume', 'Calls', 'Clicks', 'Call_TV_Sales', 'Call_HSIA_Sales', 'Call_VOIP_Sales',
 'Online_TV_Sales', 'Online_HSIA_Sales', 'Online_VOIP_Sales')
 and Media_Week <= (case when datepart(weekday,getdate()) <= 3 then datepart(wk,GETDATE())-2
	else datepart(wk,GETDATE())-1 end)
GROUP BY Project, Media_Type, Program_Owner, Source_Data, Metric
