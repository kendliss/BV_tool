
CREATE VIEW Forecasting.Current_UVAQ_Flightplan WITH SCHEMABINDING
AS SELECT     Flight_Plan_Record_ID, InHome_Date, 
	CASE WHEN Media_Type='CA' then DATEADD(month,-2,InHome_date)
		WHEN Media_Type in ('DM','EM') and Audience_Type_Name not like '%NG%' then DATEADD(month,-1,InHome_date)
		ELSE InHome_Date
		END AS Volume_Date,
	Touch_Type_FK, Media_Type_FK, Target_Type_Name, Target_Value, Touch_Name, Touch_Name_2, Media_Type, 
	Audience_Type_Name, Decile_Targeted, Budget_Given, MediaMonth as Inhome_MediaMonth, MediaMonth_Year as InHome_MediaMonth_Year, prj450_job_cd
FROM         Forecasting.Flight_Plan_Records INNER JOIN
                      Forecasting.Touch_Type ON Forecasting.Flight_Plan_Records.Touch_Type_FK = Forecasting.Touch_Type.Touch_Type_id INNER JOIN
                      Forecasting.Media_Type ON Forecasting.Touch_Type.Media_Type_FK = Forecasting.Media_Type.Media_Type_ID INNER JOIN
                      Forecasting.Target_Type ON Forecasting.Flight_Plan_Records.Target_Type_FK = Forecasting.Target_Type.Target_Type_ID INNER JOIN    
                      Forecasting.Audience ON Forecasting.Touch_Type.Audience_FK=Forecasting.Audience.Audience_ID INNER JOIN
                      Forecasting.Most_Recent_FlightPlan_View ON Forecasting.Most_Recent_FlightPlan_View.Flight_Plan_ID=Forecasting.Flight_Plan_Records.Flight_Plan_FK 
                      LEFT JOIN DIM.Media_Calendar_Daily
                       ON DIM.Media_Calendar_Daily.[Date]=Forecasting.Flight_Plan_Records.Inhome_Date
WHERE Program='UVAQ'
