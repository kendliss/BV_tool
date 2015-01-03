

CREATE VIEW [Forecasting].[Current_AdHoc_Flightplan] WITH SCHEMABINDING
AS SELECT     Ad_Hoc_Flightplan_ID, InHome_Date, 
	CASE WHEN Media_Type='CA' then DATEADD(month,-2,InHome_date)
		WHEN Media_Type in ('DM','EM') and Audience_Type_Name not like '%NG%' then DATEADD(month,-1,InHome_date)
		ELSE InHome_Date
		END AS Volume_Date,
	Touch_Type_FK, Media_Type_FK, Target_Type_Name, Target_Value, Touch_Name, Touch_Name_2, Media_Type, 
	Audience_Type_Name, Decile_Targeted, Budget_Given, MediaMonth as Inhome_MediaMonth, MediaMonth_Year as InHome_MediaMonth_Year, prj450_job_cd
FROM         Forecasting.Ad_Hoc_Flightplan INNER JOIN
                      Forecasting.Touch_Type ON Forecasting.Ad_Hoc_Flightplan.Touch_Type_FK = Forecasting.Touch_Type.Touch_Type_id INNER JOIN
                      Forecasting.Media_Type ON Forecasting.Touch_Type.Media_Type_FK = Forecasting.Media_Type.Media_Type_ID INNER JOIN
                      Forecasting.Target_Type ON Forecasting.Ad_Hoc_Flightplan.Target_Type_FK = Forecasting.Target_Type.Target_Type_ID INNER JOIN    
                      Forecasting.Audience ON Forecasting.Touch_Type.Audience_FK=Forecasting.Audience.Audience_ID 
                      LEFT JOIN DIM.Media_Calendar_Daily
                       ON DIM.Media_Calendar_Daily.[Date]=Forecasting.Ad_Hoc_Flightplan.Inhome_Date
