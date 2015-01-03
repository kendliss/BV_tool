

create view [Forecasting].[Multi_Sourced_CashFlow_ViewV2_2014]
AS 

select 



--program
case when product like 'HSVA' then 'Hispanic'
when [project name] like '%DTR%' then 'DTR'
else 'GM'
end as program,


---Bill Month transition from text to integer
case when Bill_Month='jan' then 1
when Bill_Month='feb' then 2
when Bill_Month='mar' then 3
when Bill_Month='apr' then 4
when Bill_Month='may' then 5
when Bill_Month='jun' then 6
when Bill_Month='jul' then 7
when Bill_Month='aug' then 8
when Bill_Month='sep' then 9
when Bill_Month='oct' then 10
when Bill_Month='nov' then 11
when Bill_Month='dec' then 12
end as Bill_month ,
 Bill_Amt,
 
 --media type
case when tactic ='Map' then 'Fixed Cost'
when tactic ='Taxes' then 'Fixed Cost'
when format = 'Catalog' then 'CA'
when tactic = 'Direct Mail' then 'DM'
else tactic
end as Media_Type ,

 
 --source
  'Project450' as source
  
from (select [project name] , [job code], product, tactic, format, jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
	from Forecasting.project450_UVLB_2013) p
UNPIVOT (Bill_Amt for Bill_Month in 
		(jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec)
		) as unpvt
		
UNION all

select  
case when c.Agency like 'Dieste' then 'Hispanic'
	when c.touch_name like 'DTR' then 'DTR'
	else 'GM'
	end as program,
	

month(bill_date) as Bill_month,
sum(Bill_Amount) as  Bill_Amt,
	
		Media_Type, 
	
  'Best_View' as source
  
	from Forecasting.Current_UVAQ_Flightplan_Billing_View as A
		LEFT JOIN Forecasting.Flight_Plan_Records as B on A.Flight_Plan_Record_ID=B.Flight_Plan_Record_ID
		LEFT JOIN Forecasting.Touch_Type as C on B.Touch_Type_FK=C.Touch_Type_ID
		LEFT JOIN Forecasting.Media_Type as D on C.Media_Type_FK=D.Media_Type_ID
	where 
	bill_date >= '1/1/2014' and bill_date <= '12/31/2014'
	group by c.Agency,
	c.touch_name,
	month(bill_date),
	C.Touch_Type_ID,
	Media_Type
	






	
	

