create procedure [Forecasting].[cv_actual_ytd_2014]
as 
Select 
--facts
Project, Media_Type, Program_Owner, MediaMonth_Long,

--Actuals
SUM(Actual_Budget) as Actual_Budget,
SUM(Actual_Volume) as Actual_Volume,
SUM(Actual_Calls) as Actual_Calls,
SUM(Actual_Clicks) as Actual_Clicks,
SUM(Actual_Call_TV) as Actual_UVTV_Call_Sales,
SUM(Actual_Online_TV_Sales) as Actual_UVTV_Online_Sales,
SUM(Actual_Call_HSIA_Sales) as Actual_HSIA_Call_Sales,
SUM(Actual_Online_HSIA_Sales) as Actual_HSIA_Online_Sales,
SUM(Actual_Call_VOIP_Sales) as Actual_VOIP_Call_Sales,
SUM(Actual_Online_VOIP_Sales) as Actual_VOIP_Online_Sales,

--Commitments
SUM(CV_Project_Budget) as CV_Budget,
SUM(CV_Drop_Volume) as CV_Volume,
SUM(CV_Calls) as CV_Calls,
SUM(CV_Clicks) as CV_Clicks,
SUM(CV_Call_TV_Sales) as CV_UVTV_Call_Sales,
SUM(CV_Online_TV_Sales) as CV_UVTV_Online_Sales,
SUM(CV_Call_HSIA_Sales) as CV_HSIA_Call_Sales,
SUM(CV_Online_HSIA_Sales) as CV_HSIA_Online_Sales,
SUM(CV_Call_VOIP_Sales) as CV_VOIP_Call_Sales,
SUM(CV_Online_VOIP_Sales) as CV_VOIP_Online_Sales

from Forecasting.Current_UVAQ_Best_View_Weekly_2014

where Media_Week<=datepart(wk,GETDATE())-2
group by Project, Program_Owner, Media_Type, MediaMonth_Long

