CREATE VIEW Forecasting.CV_Budget_View
AS SELECT 
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
	datepart(month, Bill_Date) as Finance_Budget_Month,
	datepart(year, Bill_Date) as Finance_Budget_Year,
	ROUND(SUM(Bill_Amount),0) as Budget
FROM 
	Forecasting.Current_UVAQ_Flightplan_Billing_View LEFT JOIN
	---Subquery to pull in the necessary information about the touch type
		(SELECT Flight_Plan_Record_ID, Media_Type, Touch_Name, Audience_Type_Name as Audience 
				from Forecasting.Flight_Plan_Records AS A, Forecasting.Touch_Type as B, Forecasting.Media_Type as C, Forecasting.Audience as D
				Where A.Touch_Type_FK=B.Touch_Type_ID and B.Media_Type_FK=C.Media_Type_ID and B.Audience_FK=D.Audience_ID) as Subquery1
			ON Forecasting.Current_UVAQ_Flightplan_Billing_View.Flight_Plan_Record_ID=SubQuery1.Flight_Plan_Record_ID

----Limit to 2012 Billings
-- Commented out to get all years WHERE datepart(year, Bill_Date)=2012

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
	END) ,
	datepart(month, Bill_Date),
	datepart(year, Bill_Date) 

