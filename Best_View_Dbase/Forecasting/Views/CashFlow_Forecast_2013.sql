


create view [Forecasting].[CashFlow_Forecast_2013] as
select  
case when c.Agency like 'Dieste' then 'Hispanic'
	when c.touch_name like 'DTR' then 'DTR'
	else 'GM'
	end as program,
	

month(bill_date) as Bill_month,
sum(Bill_Amount) as  Bill_Amt,
	
		Media_Type,
		Touch_Name+' '+touch_name_2 as project,
		Audience_Type_Name,
		InHome_Date,
		Flight_Plan_FK
	
    
	from Forecasting.Current_UVAQ_Flightplan_Billing_View as A
		LEFT JOIN Forecasting.Flight_Plan_Records as B on A.Flight_Plan_Record_ID=B.Flight_Plan_Record_ID
		LEFT JOIN Forecasting.Touch_Type as C on B.Touch_Type_FK=C.Touch_Type_ID
		LEFT JOIN Forecasting.Media_Type as D on C.Media_Type_FK=D.Media_Type_ID
		Left join Forecasting.Audience as E on C.Audience_FK=E.Audience_ID
	where 
	bill_date >= '1/1/2013' and bill_date <= '12/31/2013'
	group by c.Agency,
	c.touch_name,
	c.Touch_Name_2,
	month(bill_date),
	Media_Type,
	Audience_Type_Name,
	Inhome_date,
	Flight_Plan_FK
	

