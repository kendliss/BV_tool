
---------------------------------------------------------------------------------------------------------------------------------------------------------

/*Create the Monthly Budget View*/
CREATE VIEW Forecasting.Current_UVAQ_Monthly_Budget_View
AS SELECT 
	(CASE WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name like 'Touch%' and Audience not like '%BL%' then 'Launch DM'
	WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name like 'Touch%' and Audience like '%BL%' then 'Hispanic Launch DM'
	WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name like 'Core' and Audience like '%BL%' then 'Hispanic Core DM'
	WHEN Subquery1.Media_Type='EM' and Subquery1.Touch_Name like 'Touch%' then 'Launch EM'
	WHEN Subquery1.Media_Type='CA' then 'Catalog'
	WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name in ('Core','Testing') and Audience not like '%BL%' then 'Core DM'
	WHEN Subquery1.Media_Type='EM' and Subquery1.Touch_Name like 'Core' then 'Core EM'
	WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name like '%Trigger%' then 'Trigger DM'
	WHEN Subquery1.Media_Type='EM' and Subquery1.Touch_Name like '%Trigger%' then 'Trigger EM'
	WHEN Subquery1.Media_Type='BI' then 'Bill Inserts'
	WHEN Subquery1.Media_Type='SMS' then 'COR SMS'
	WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name like '%DTR%' then 'Drive to Retail DM'
	WHEN Subquery1.Media_Type like 'FYI' then 'Bill Message'
	WHEN Subquery1.Media_Type='EM' and Subquery1.Touch_Name like '%Trigger%' then 'Trigger EM'
	WHEN Subquery1.Media_Type='SharedM' then 'Shared Mail'
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

GROUP BY (CASE WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name like 'Touch%' and Audience not like '%BL%' then 'Launch DM'
	WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name like 'Touch%' and Audience like '%BL%' then 'Hispanic Launch DM'
	WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name like 'Core' and Audience like '%BL%' then 'Hispanic Core DM'
	WHEN Subquery1.Media_Type='EM' and Subquery1.Touch_Name like 'Touch%' then 'Launch EM'
	WHEN Subquery1.Media_Type='CA' then 'Catalog'
	WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name in ('Core','Testing') and Audience not like '%BL%' then 'Core DM'
	WHEN Subquery1.Media_Type='EM' and Subquery1.Touch_Name like 'Core' then 'Core EM'
	WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name like '%Trigger%' then 'Trigger DM'
	WHEN Subquery1.Media_Type='EM' and Subquery1.Touch_Name like '%Trigger%' then 'Trigger EM'
	WHEN Subquery1.Media_Type='BI' then 'Bill Inserts'
	WHEN Subquery1.Media_Type='SMS' then 'COR SMS'
	WHEN Subquery1.Media_Type='DM' and Subquery1.Touch_Name like '%DTR%' then 'Drive to Retail DM'
	WHEN Subquery1.Media_Type like 'FYI' then 'Bill Message'
	WHEN Subquery1.Media_Type='EM' and Subquery1.Touch_Name like '%Trigger%' then 'Trigger EM'
	WHEN Subquery1.Media_Type='SharedM' then 'Shared Mail'
	ELSE 'UNKNOWN'
	END) ,
	datepart(month, Bill_Date),
	datepart(year, Bill_Date) 

