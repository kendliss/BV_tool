
CREATE VIEW Forecasting.[Best_View_Monthly_Aspen_2012]

AS SELECT Project, Media_Type, Program_Owner, [Month], 
	InHome_Date,
	isnull(sum(Actual_Apportioned_Budget),0) as Actual_Apportioned_Budget,
	isnull(sum(Actual_Apportioned_Volume),0) as Actual_Apportioned_Volume,
	isnull(sum(Actual_Project_Budget),0) as Actual_Project_Budget,
	isnull(sum(Actual_Calls),0) as Actual_Calls,
	isnull(sum(Actual_Clicks),0) as Actual_Clicks,
	isnull(sum(Actual_Call_TV),0) as Actual_Call_TV_Sales,
	isnull(sum(Actual_Online_TV_Sales),0) as Actual_Online_TV_Sales,
	isnull(sum(Actual_Call_HSIA_Sales),0) as Actual_Call_HSIA_Sales,
	isnull(sum(Actual_Online_HSIA_Sales),0) as Actual_Online_HSIA_Sales,
	isnull(sum(Actual_Call_VOIP_Sales),0) as Actual_Call_VOIP_Sales,
	isnull(sum(Actual_Online_VOIP_Sales),0) as Actual_Online_VOIP_Sales,
	isnull(sum(Actual_Directed_Strategic_Call_Sales),0) as Actual_Directed_Strategic_Call_Sales,
	isnull(sum(Actual_Directed_Strategic_Online_Sales),0) as Actual_Directed_Strategic_Online_Sales,
	
--Best View, Combineds actual and forecast data
	isnull(sum(BV_Finance_Budget),0) as BV_Finance_Budget,
	isnull(sum(BV_Drop_Volume),0) as BV_Drop_Volume,
	isnull(sum(BV_Project_Budget),0) as BV_Project_Budget,
	
	sum(case when Media_Week > DATEPART(wk,getdate())-2 then BV_Calls 
		else Actual_Calls end) as BV_Calls,
	sum(case when Media_Week > DATEPART(wk,getdate())-2 then BV_Clicks 
		else Actual_Clicks end) as BV_Clicks,
	sum(case when Media_Week > DATEPART(wk,getdate())-2 then BV_Call_TV_Sales
	    else Actual_Call_TV end) as BV_Call_TV_Sales,	
	sum(case when Media_Week > DATEPART(wk,getdate())-2 then BV_Online_TV_Sales
	    else Actual_Online_TV_Sales end) as BV_Online_TV_Sales,
	sum(case when Media_Week > DATEPART(wk,getdate())-2 then BV_Call_HSIA_Sales
	    else Actual_Call_HSIA_Sales end) as BV_Call_HSIA_Sales,
	sum(case when Media_Week > DATEPART(wk,getdate())-2 then BV_Online_HSIA_Sales
	    else Actual_Online_HSIA_Sales end) as BV_Online_HSIA_Sales,
	sum(case when Media_Week > DATEPART(wk,getdate())-2 then BV_Call_VOIP_Sales
	    else Actual_Call_VOIP_Sales end) as BV_Call_VOIP_Sales,
	sum(case when Media_Week > DATEPART(wk,getdate())-2 then BV_Online_VOIP_Sales
	    else Actual_Online_VOIP_Sales end) as BV_Online_VOIP_Sales,
	sum(case when Media_Week > DATEPART(wk,getdate())-2 then BV_Directed_Strategic_Call_Sales
	    else Actual_Directed_Strategic_Call_Sales end) as BV_Directed_Strategic_Call_Sales,
	sum(case when Media_Week > DATEPART(wk,getdate())-2 then BV_Directed_Strategic_Online_Sales
	    else Actual_Directed_Strategic_Online_Sales end) as BV_Directed_Strategic_Online_Sales, 
	
	
	isnull(sum(CV_Budget),0)as CV_Budget,
	isnull(sum(CV_Project_Budget),0) as CV_Project_Budget,
	isnull(sum(CV_Volume),0)as CV_Volume,
	isnull(sum(CV_Clicks),0)as CV_Clicks,
	isnull(sum(CV_Calls),0)as CV_Calls,
	isnull(sum(CV_Call_TV_Sales),0) as CV_Call_TV_Sales, 
	isnull(sum(CV_Call_HSIA_Sales),0)as CV_Call_HSIA_Sales,
	isnull(sum(CV_Online_TV_Sales),0)as CV_Online_TV_Sales,
	isnull(sum(CV_Online_HSIA_Sales),0)as CV_Online_HSIA_Sales,
	isnull(sum(CV_Call_VOIP_Sales),0)as CV_Call_VOIP_Sales,
	isnull(sum(CV_Online_VOIP_Sales),0)as CV_Online_VOIP_Sales,
	isnull(sum(CV_Directed_Strategic_Call_Sales),0)as CV_Directed_Strategic_Call_Sales,
	isnull(sum(CV_Directed_Strategic_Online_Sales),0)as CV_Directed_Strategic_Online_Sales
FROM Forecasting.Best_View_Weekly_Agency
	INNER JOIN DIM.Media_Calendar ON Forecasting.Best_View_Weekly_Agency.Media_Week=DIM.Media_Calendar.[ISO_Week]
	
	WHERE ISO_Week_YYYYWW>201153 and iso_week_yyyyWW< 201301 and Media_Type not in ('SharedM','SMS') and agency='Aspen'
	GROUP BY Project, Media_Type, Program_Owner, [Month], 
	--Agency,
	InHome_Date