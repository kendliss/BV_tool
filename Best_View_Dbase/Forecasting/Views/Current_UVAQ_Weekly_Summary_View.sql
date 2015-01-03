
CREATE VIEW Forecasting.Current_UVAQ_Weekly_Summary_View


AS SELECT MasterQuery1.Category, MasterQuery1.[ISO_Week], Volume, Calls, Clicks, 
	Call_UV_TV_Sales,
	Call_DIRECTV_Sales,
	Call_HSIA_Sales,
	Call_DSL_LS_Sales,
	Call_DSL_Direct_Sales,
	Call_VOIP_Sales,
	Call_Access_Line_Sales,
	Call_Wireless_Voice_Sales,
	Call_Wireless_Family_Sales,
	Call_Wireless_Data_Sales,
	Call_IPDSL_Sales,
	
	
	Click_UV_TV_Sales,
	Click_DIRECTV_Sales,
	Click_HSIA_Sales,
	Click_DSL_LS_Sales,
	Click_DSL_Direct_Sales,
	Click_VOIP_Sales,
	Click_Access_Line_Sales,
	Click_Wireless_Voice_Sales,
	Click_Wireless_Family_Sales,
	Click_Wireless_Data_Sales,
	Click_IPDSL_Sales
	
FROM
----Pull the Weekly Information (Calls, Clicks, Sales) 
(SELECT 
	(CASE WHEN Subquery1.Media_Type='DM' and (Subquery1.Touch_Name like '%Touch%' or Subquery1.Touch_Name like '%Testing%') and Audience not like '%BL%' then 'DM'
	WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name like '%Touch%' and Audience like '%BL%' then 'Hispanic DM'
	WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name like 'Recurring' and Audience like '%BL%' then 'Hispanic DM'
	WHEN Subquery1.Media_Type='EM' then 'EM'
	WHEN Subquery1.Media_Type='CA' then 'Catalog'
	WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name like 'Recurring' and Audience not like '%BL%' then 'Recurring DM'
	WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name like '%Trigger%' then 'DM'
	WHEN Subquery1.Media_Type='BI' and Subquery1.Touch_Name like 'Wireless' then 'Wireless Bill Inserts'
	WHEN Subquery1.Media_Type='BI' and Subquery1.Touch_Name like 'Wireline' then 'Wireline Bill Inserts'
	WHEN Subquery1.Media_Type='SMS' then 'COR SMS'
	WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name like '%COR%' then 'Drive to Retail DM'
	WHEN Subquery1.Media_Type like 'FYI' and Subquery1.Audience not like '%BL%' and Subquery1.Touch_Name 
		like 'Wireless' then 'Wireless Bill Message'
	WHEN Subquery1.Media_Type like 'FYI' and Subquery1.Audience not like '%BL%' and Subquery1.Touch_Name 
		like 'Wireline' then 'Wireline Bill Message'
	WHEN Subquery1.Media_Type like 'FYI' and Subquery1.Audience like '%BL%' then 'Hispanic Bill Message'
	WHEN Subquery1.Media_Type like 'SharedM' then 'Shared Mail'
	ELSE 'UNKNOWN'
	END) AS Category,
	DIM.Media_Calendar_Daily.[ISO_Week],
	ROUND(SUM(Wk_Call_Forecast),0) as Calls,
	ROUND(SUM(Wk_Click_Forecast),0) as Clicks,
	ROUND(SUM(Call_UV_TV_Sales),0) as Call_UV_TV_Sales,
	ROUND(SUM(Call_DIRECTV_Sales),0) as Call_DIRECTV_Sales,
	ROUND(SUM(Call_HSIA_Sales),0) as Call_HSIA_Sales,
	ROUND(SUM(Call_DSL_LS_Sales),0) as Call_DSL_LS_Sales,
	ROUND(SUM(Call_DSL_Direct_Sales),0) as Call_DSL_Direct_Sales,
	ROUND(SUM(Call_VOIP_Sales),0) as Call_VOIP_Sales,
	ROUND(SUM(Call_Access_Line_Sales),0) as Call_Access_Line_Sales,
	ROUND(SUM(Call_Wireless_Voice_Sales),0) as Call_Wireless_Voice_Sales,
	ROUND(SUM(Call_Wireless_Family_Sales),0) as Call_Wireless_Family_Sales,
	ROUND(SUM(Call_Wireless_Data_Sales),0) as Call_Wireless_Data_Sales,
	ROUND(SUM(Call_IPDSL_Sales),0) as Call_IPDSL_Sales,
	
	ROUND(SUM(Click_UV_TV_Sales),0) as Click_UV_TV_Sales,
	ROUND(SUM(Click_DIRECTV_Sales),0) as Click_DIRECTV_Sales,
	ROUND(SUM(Click_HSIA_Sales),0) as Click_HSIA_Sales,
	ROUND(SUM(Click_DSL_LS_Sales),0) as Click_DSL_LS_Sales,
	ROUND(SUM(Click_DSL_Direct_Sales),0) as Click_DSL_Direct_Sales,
	ROUND(SUM(Click_VOIP_Sales),0) as Click_VOIP_Sales,
	ROUND(SUM(Click_Access_Line_Sales),0) as Click_Access_Line_Sales,
	ROUND(SUM(Click_Wireless_Voice_Sales),0) as Click_Wireless_Voice_Sales,
	ROUND(SUM(Click_Wireless_Family_Sales),0) as Click_Wireless_Family_Sales,
	ROUND(SUM(Click_Wireless_Data_Sales),0) as Click_Wireless_Data_Sales,
	ROUND(SUM(Click_IPDSL_Sales),0) as Click_IPDSL_Sales
	
	
	
FROM Forecasting.Current_UVAQ_Flightplan_Forecast_ByWeek LEFT JOIN
	---Subquery to pull in the necessary information about the touch type
		(SELECT Flight_Plan_Record_ID, Media_Type, Touch_Name, Audience_Type_Name as Audience 
				from Forecasting.Flight_Plan_Records AS A, Forecasting.Touch_Type as B, Forecasting.Media_Type as C, Forecasting.Audience as D
				Where A.Touch_Type_FK=B.Touch_Type_ID and B.Media_Type_FK=C.Media_Type_ID and B.Audience_FK=D.Audience_ID) as Subquery1
			ON Current_UVAQ_Flightplan_Forecast_ByWeek.Flight_Plan_Record_ID=SubQuery1.Flight_Plan_Record_ID
		LEFT JOIN
	---Subquery to summarize sales by flight plan record and forecast_date		
		(SELECT Flight_Plan_Record_ID, Forecast_Date, 
	--Get the sales by product	
	SUM(CASE WHEN Product_FK=1 then Wk_Call_Sales ELSE 0 END) as Call_UV_TV_Sales,
	SUM(CASE WHEN Product_FK=10 then Wk_Call_Sales ELSE 0 END) as Call_DIRECTV_Sales,
	SUM(CASE WHEN Product_FK=3 then Wk_Call_Sales ELSE 0 END) as Call_HSIA_Sales,
	SUM(CASE WHEN Product_FK=4 then Wk_Call_Sales ELSE 0 END) as Call_DSL_LS_Sales,
	SUM(CASE WHEN Product_FK=5 then Wk_Call_Sales ELSE 0 END) as Call_DSL_Direct_Sales,
	SUM(CASE WHEN Product_FK=9 then Wk_Call_Sales ELSE 0 END) as Call_VOIP_Sales,
	SUM(CASE WHEN Product_FK=6 then Wk_Call_Sales ELSE 0 END) as Call_Access_Line_Sales,
	SUM(CASE WHEN Product_FK=8 then Wk_Call_Sales ELSE 0 END) as Call_Wireless_Voice_Sales,
	SUM(CASE WHEN Product_FK=12 then Wk_Call_Sales ELSE 0 END) as Call_Wireless_Family_Sales,
	SUM(CASE WHEN Product_FK=13 then Wk_Call_Sales ELSE 0 END) as Call_Wireless_Data_Sales,
	SUM(CASE WHEN Product_FK=14 then Wk_Call_Sales ELSE 0 END) as Call_IPDSL_Sales,
	
	SUM(CASE WHEN Product_FK=1 then Wk_Click_Sales ELSE 0 END) as Click_UV_TV_Sales,
	SUM(CASE WHEN Product_FK=10 then Wk_Click_Sales ELSE 0 END) as Click_DIRECTV_Sales,
	SUM(CASE WHEN Product_FK=3 then Wk_Click_Sales ELSE 0 END) as Click_HSIA_Sales,
	SUM(CASE WHEN Product_FK=4 then Wk_Click_Sales ELSE 0 END) as Click_DSL_LS_Sales,
	SUM(CASE WHEN Product_FK=5 then Wk_Click_Sales ELSE 0 END) as Click_DSL_Direct_Sales,
	SUM(CASE WHEN Product_FK=9 then Wk_Click_Sales ELSE 0 END) as Click_VOIP_Sales,
	SUM(CASE WHEN Product_FK=6 then Wk_Click_Sales ELSE 0 END) as Click_Access_Line_Sales,
	SUM(CASE WHEN Product_FK=8 then Wk_Click_Sales ELSE 0 END) as Click_Wireless_Voice_Sales,
	SUM(CASE WHEN Product_FK=12 then Wk_Click_Sales ELSE 0 END) as Click_Wireless_Family_Sales,
	SUM(CASE WHEN Product_FK=13 then Wk_Click_Sales ELSE 0 END) as Click_Wireless_Data_Sales,
	SUM(CASE WHEN Product_FK=14 then Wk_Click_Sales ELSE 0 END) as Click_IPDSL_Sales
	
	 FROM
		Forecasting.Current_UVAQ_Flightplan_Forecast_Sales_Byweek GROUP BY Flight_Plan_Record_ID, Forecast_Date) as Subquery3
			ON Subquery3.Flight_Plan_Record_ID=Subquery1.Flight_Plan_Record_ID 
			
	---Join the Calendar to get the Media Month	
		INNER JOIN DIM.Media_Calendar_Daily 
			ON Forecasting.Current_UVAQ_Flightplan_Forecast_ByWeek.Forecast_Date=DIM.Media_Calendar_Daily.[Date]
			 and Subquery3.Forecast_Date=DIM.Media_Calendar_Daily.[Date]
			 
WHERE MediaMonth_Year=2012
GROUP BY (CASE WHEN Subquery1.Media_Type='DM' and (Subquery1.Touch_Name like '%Touch%' or Subquery1.Touch_Name like '%Testing%') and Audience not like '%BL%' then 'DM'
	WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name like '%Touch%' and Audience like '%BL%' then 'Hispanic DM'
	WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name like 'Recurring' and Audience like '%BL%' then 'Hispanic DM'
	WHEN Subquery1.Media_Type='EM' then 'EM'
	WHEN Subquery1.Media_Type='CA' then 'Catalog'
	WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name like 'Recurring' and Audience not like '%BL%' then 'Recurring DM'
	WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name like '%Trigger%' then 'DM'
	WHEN Subquery1.Media_Type='BI' and Subquery1.Touch_Name like 'Wireless' then 'Wireless Bill Inserts'
	WHEN Subquery1.Media_Type='BI' and Subquery1.Touch_Name like 'Wireline' then 'Wireline Bill Inserts'
	WHEN Subquery1.Media_Type='SMS' then 'COR SMS'
	WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name like '%COR%' then 'Drive to Retail DM'
	WHEN Subquery1.Media_Type like 'FYI' and Subquery1.Audience not like '%BL%' and Subquery1.Touch_Name 
		like 'Wireless' then 'Wireless Bill Message'
	WHEN Subquery1.Media_Type like 'FYI' and Subquery1.Audience not like '%BL%' and Subquery1.Touch_Name 
		like 'Wireline' then 'Wireline Bill Message'
	WHEN Subquery1.Media_Type like 'FYI' and Subquery1.Audience like '%BL%' then 'Hispanic Bill Message'
	WHEN Subquery1.Media_Type like 'SharedM' then 'Shared Mail'
	ELSE 'UNKNOWN'
	END), DIM.Media_Calendar_Daily.[ISO_Week]) as MasterQuery1

LEFT JOIN 

----Summarize the Volume Information	
	(SELECT 
(CASE WHEN Subquery2.Media_Type='DM' and (Subquery2.Touch_Name like '%Touch%' or Subquery2.Touch_Name like '%Testing%') and Audience not like '%BL%' then 'DM'
	WHEN Subquery2.Media_Type='DM' and Subquery2.Touch_Name like '%Touch%' and Audience like '%BL%' then 'Hispanic DM'
	WHEN Subquery2.Media_Type='DM' and Subquery2.Touch_Name like 'Recurring' and Audience like '%BL%' then 'Hispanic DM'
	WHEN Subquery2.Media_Type='EM' then 'EM'
	WHEN Subquery2.Media_Type='CA' then 'Catalog'
	WHEN Subquery2.Media_Type='DM' and Subquery2.Touch_Name like 'Recurring' and Audience not like '%BL%' then 'Recurring DM'
	WHEN Subquery2.Media_Type='DM' and Subquery2.Touch_Name like '%Trigger%' then 'DM'
	WHEN Subquery2.Media_Type='BI' and Subquery2.Touch_Name like 'Wireless' then 'Wireless Bill Inserts'
	WHEN Subquery2.Media_Type='BI' and Subquery2.Touch_Name like 'Wireline' then 'Wireline Bill Inserts'
	WHEN Subquery2.Media_Type='SMS' then 'COR SMS'
	WHEN Subquery2.Media_Type='DM' and Subquery2.Touch_Name like '%COR%' then 'Drive to Retail DM'
	WHEN Subquery2.Media_Type like 'FYI' and Subquery2.Audience not like '%BL%' and Subquery2.Touch_Name 
		like 'Wireless' then 'Wireless Bill Message'
	WHEN Subquery2.Media_Type like 'FYI' and Subquery2.Audience not like '%BL%' and Subquery2.Touch_Name 
		like 'Wireline' then 'Wireline Bill Message'
	WHEN Subquery2.Media_Type like 'FYI' and Subquery2.Audience like '%BL%' then 'Hispanic Bill Message'
	WHEN Subquery2.Media_Type like 'SharedM' then 'Shared Mail'
	ELSE 'UNKNOWN'
	END) AS Category,
	DIM.Media_Calendar_Daily.[ISO_Week],	
	ROUND(SUM(Volume_Forecast),0) as Volume


FROM Forecasting.Current_UVAQ_Flightplan_Forecast_View LEFT JOIN
	---Subquery to pull in the necessary information about the touch type
		(SELECT Flight_Plan_Record_ID, Media_Type, Touch_Name, Audience_Type_Name as Audience 
				from Forecasting.Flight_Plan_Records AS A, Forecasting.Touch_Type as B, Forecasting.Media_Type as C, Forecasting.Audience as D
				Where A.Touch_Type_FK=B.Touch_Type_ID and B.Media_Type_FK=C.Media_Type_ID and B.Audience_FK=D.Audience_ID) as Subquery2
			ON Current_UVAQ_Flightplan_Forecast_View.Flight_Plan_Record_ID=Subquery2.Flight_Plan_Record_ID 
	---Join to Calendar to get the ISO_Week
	INNER JOIN DIM.Media_Calendar_Daily ON
	Forecasting.Current_UVAQ_Flightplan_Forecast_View.Drop_Date=DIM.Media_Calendar_Daily.[Date]
WHERE MediaMonth_Year=2012
GROUP BY (CASE WHEN Subquery2.Media_Type='DM' and (Subquery2.Touch_Name like '%Touch%' or Subquery2.Touch_Name like '%Testing%') and Audience not like '%BL%' then 'DM'
	WHEN Subquery2.Media_Type='DM' and Subquery2.Touch_Name like '%Touch%' and Audience like '%BL%' then 'Hispanic DM'
	WHEN Subquery2.Media_Type='DM' and Subquery2.Touch_Name like 'Recurring' and Audience like '%BL%' then 'Hispanic DM'
	WHEN Subquery2.Media_Type='EM' then 'EM'
	WHEN Subquery2.Media_Type='CA' then 'Catalog'
	WHEN Subquery2.Media_Type='DM' and Subquery2.Touch_Name like 'Recurring' and Audience not like '%BL%' then 'Recurring DM'
	WHEN Subquery2.Media_Type='DM' and Subquery2.Touch_Name like '%Trigger%' then 'DM'
	WHEN Subquery2.Media_Type='BI' and Subquery2.Touch_Name like 'Wireless' then 'Wireless Bill Inserts'
	WHEN Subquery2.Media_Type='BI' and Subquery2.Touch_Name like 'Wireline' then 'Wireline Bill Inserts'
	WHEN Subquery2.Media_Type='SMS' then 'COR SMS'
	WHEN Subquery2.Media_Type='DM' and Subquery2.Touch_Name like '%COR%' then 'Drive to Retail DM'
	WHEN Subquery2.Media_Type like 'FYI' and Subquery2.Audience not like '%BL%' and Subquery2.Touch_Name 
		like 'Wireless' then 'Wireless Bill Message'
	WHEN Subquery2.Media_Type like 'FYI' and Subquery2.Audience not like '%BL%' and Subquery2.Touch_Name 
		like 'Wireline' then 'Wireline Bill Message'
	WHEN Subquery2.Media_Type like 'FYI' and Subquery2.Audience like '%BL%' then 'Hispanic Bill Message'
	WHEN Subquery2.Media_Type like 'SharedM' then 'Shared Mail'
	ELSE 'UNKNOWN'
	END),
	DIM.Media_Calendar_Daily.[ISO_Week]) as MasterQuery2
----Join ON the appropriate Variables
ON MasterQuery1.Category=MasterQuery2.Category and MasterQuery1.[ISO_Week]=MasterQuery2.[ISO_Week]
---ORDER BY 
 ---MasterQuery1.Category, MasterQuery1.ISO_Week, Volume, Calls, Clicks, 
 ---Call_TV_Sales, Online_TV_Sales, Directed_Strategic_Call_Sales, Directed_Strategic_Online_Sales
