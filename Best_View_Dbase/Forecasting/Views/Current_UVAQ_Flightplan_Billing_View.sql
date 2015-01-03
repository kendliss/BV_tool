


CREATE VIEW [Forecasting].[Current_UVAQ_Flightplan_Billing_View] WITH SCHEMABINDING

AS SELECT Forecasting.Current_UVAQ_Flightplan_Forecast_View.Flight_Plan_Record_ID, prj450_job_cd,

---Hard Code Billing Timing Exceptions along with standard logic
	
	
	Case 
	--EOY S.O.X. requirements
	--when month_difference>0 and media_type='BI' and month(drop_date)=12 then dateadd(month,1,inhome_date)
	when month_difference>0 and month(InHome_Date)=12 then Drop_Date
	when Month_Difference<=0 and 
		month(inhome_date)=1 and year(inhome_date)=2014 and InHome_Date>'2014-01-06' and Media_Type='DM' then inhome_date
	when month_difference<0 and InHome_Date IN ('2014-02-27','2014-03-04') 
		and Current_UVAQ_Flightplan_Forecast_View.Touch_Type_FK in (84,7) then  InHome_Date
	
	
	---2012 exceptions
	--when Media_Type='CA' and datepart(month,InHome_Date)=2 and datepart(year,inhome_date)=2012 and Month_Difference=-2 then DATEADD(Month,-1,Drop_Date)	
	when  Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=2 and InHome_Date<'2012-10-30' THEN DATEADD(month,Month_Difference-1,InHome_Date)
  	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk = 1 and InHome_Date = '2012-12-10'   and Month_Difference=3 then '3/15/2013'	
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=62 and month(drop_date)=5 then dateadd(week,-1,Drop_Date)
	when media_type='DM' and InHome_Date between '2012-06-01' and '2012-06-05' then dateadd(month,month_difference,InHome_date)
	when media_type='CA' and InHome_Date = '2012-12-10' and month_difference = 0 then dateadd(month,-1,InHome_date)
	when media_type='DM' and Touch_Name_2 = 'TV Upsell' and InHome_Date = '2012-12-4' and month_difference = 0 then dateadd(month,-1,InHome_date)
	when media_type='DM' and Touch_Name_2 = 'TV Upsell' and InHome_Date = '2012-11-22' and month_difference = 1 then InHome_date
	when media_type='DM' and InHome_Date = '2012-12-27'  then dateadd(month,-1,Drop_Date)
	
    when month(InHome_Date)=10 and year(InHome_date)=2012 and month_difference=0 and media_type='CA' then dateadd(month,-1,InHome_date)
	when inhome_date='2012-11-01' and media_type='DM' and touch_name='Core' then drop_date
	when inhome_date='2012-11-10' and media_type='DM' and touch_name='Core' and month_difference in (0,1) then dateadd(month,-1,inhome_date)
	when inhome_date='2012-11-10' and media_type='DM' and touch_name='Core' and month_difference=-1 then inhome_date
	when inhome_date='2012-10-05' and media_type='DM' and touch_name='Core' and month_difference=1 then inhome_date
	when inhome_date='2012-10-19' and media_type='DM' and touch_name='Core' and month_difference=1 then inhome_date
	when inhome_date='2012-11-26' and media_type='DM' and touch_name='Core' then drop_date
	when inhome_date='2012-9-24' and media_type='DM' and touch_name='Core' and month_difference=0 then dateadd(month,1,inhome_date)
	when inhome_date='2012-10-22' and media_type='DM'  and Touch_Name_2 = 'TV Upsell' and  month_difference=1 then inhome_date
	when inhome_date='2012-11-06' and media_type='DM'  and Touch_Name_2 = 'TV Upsell' and  month_difference=1 then dateadd(month,-1,inhome_date)
	when inhome_date='2012-11-06' and media_type='DM'  and Touch_Name_2 = 'TV Upsell' and  month_difference=0 then dateadd(month,-1,inhome_date)
	when inhome_date='2012-10-09' and media_type='DM'  and Touch_Name_2 = 'TV Upsell' and  month_difference=1 then dateadd(month,-1,inhome_date)	
	when media_type='EM' and InHome_Date < '2012-12-31'  and Month_Difference=1 then DATEADD(Month,-1,Drop_Date)
	when media_type='BI' and InHome_Date < '2012-12-31'  and Month_Difference=1 then inhome_date
	when media_type='SharedM' and InHome_Date < '2012-12-31'  and Month_Difference=1 then DATEADD(Month,-1,Drop_Date)
	
	---2013 exceptions
	
	
	

--Aug early month
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=72 and InHome_Date > '2013-08-01' and Month_Difference=0 then dateadd(month,-1,inhome_date)
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=73 and InHome_Date > '2013-08-01' and Month_Difference=0 then dateadd(month,-1,inhome_date)
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=74 and InHome_Date > '2013-08-01' and Month_Difference=0 then dateadd(month,-1,inhome_date)
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=75 and InHome_Date > '2013-08-01' and Month_Difference=0 then dateadd(month,-1,inhome_date)

	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=72 and InHome_Date > '2013-08-01' and Month_Difference=1 then DATEADD(Month,1,inhome_date)
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=73 and InHome_Date > '2013-08-01' and Month_Difference=1 then DATEADD(Month,1,inhome_date)
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=74 and InHome_Date > '2013-08-01' and Month_Difference=1 then DATEADD(Month,1,inhome_date)
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=75 and InHome_Date > '2013-08-01' and Month_Difference=1 then DATEADD(Month,1,inhome_date)
	
	--mar early month exception
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=72 and InHome_Date = '2013-03-08' and Month_Difference=1 then '4/15/2013'
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=73 and InHome_Date = '2013-03-08' and Month_Difference=1 then '4/15/2013'
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=74 and InHome_Date = '2013-03-08' and Month_Difference=1 then '4/15/2013'
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=75 and InHome_Date = '2013-03-08' and Month_Difference=1 then '4/15/2013'
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=73 and InHome_Date = '2013-03-08' and Month_Difference=0 then '4/15/2013'
	
	--feb early month exception
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=72 and InHome_Date = '2013-02-06' and Month_Difference=0 then dateadd(month,-1,inhome_date)
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=73 and InHome_Date = '2013-02-06' and Month_Difference=0 then dateadd(month,-1,inhome_date)
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=74 and InHome_Date = '2013-02-06' and Month_Difference=0 then dateadd(month,-1,inhome_date)
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=75 and InHome_Date = '2013-02-06' and Month_Difference=0 then dateadd(month,-1,inhome_date)
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=72 and InHome_Date = '2013-02-06' and Month_Difference=1 then DATEADD(Month,2,Drop_Date)
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=73 and InHome_Date = '2013-02-06' and Month_Difference=1 then DATEADD(Month,2,Drop_Date)
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=74 and InHome_Date = '2013-02-06' and Month_Difference=1 then DATEADD(Month,2,Drop_Date)
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=75 and InHome_Date = '2013-02-06' and Month_Difference=1 then DATEADD(Month,2,Drop_Date)
	
		--June early month exception
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=72 and InHome_Date = '2013-06-03' and Month_Difference=0 then dateadd(month,-1,inhome_date)
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=73 and InHome_Date = '2013-06-03' and Month_Difference=0 then dateadd(month,-1,inhome_date)
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=74 and InHome_Date = '2013-06-03' and Month_Difference=0 then dateadd(month,-1,inhome_date)
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=75 and InHome_Date = '2013-06-03' and Month_Difference=0 then dateadd(month,-1,inhome_date)
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=72 and InHome_Date = '2013-06-03' and Month_Difference=1 then DATEADD(Month,2,Drop_Date)
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=73 and InHome_Date = '2013-06-03' and Month_Difference=1 then DATEADD(Month,2,Drop_Date)
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=74 and InHome_Date = '2013-06-03' and Month_Difference=1 then DATEADD(Month,2,Drop_Date)
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=75 and InHome_Date = '2013-06-03' and Month_Difference=1 then DATEADD(Month,2,Drop_Date)
	

	
	--DTV crosssell April
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=140 and InHome_Date = '2013-04-17' then '2/15/2013'
	
	when Media_Type='SharedM' and MONTH(InHome_Date)=12 then InHome_Date
	when media_type in ('sharedm') and year(Drop_Date)>2012 and Month_Difference=1 then DATEADD(Month,1,inhome_date)
	
	
	--hispanic exception 
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk in (84) and InHome_Date = '6-26-2013' then '4/15/2013'
    when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk in (84) and InHome_Date = '7-12-2013' and Month_Difference=-1 then '3/15/2013'
    when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk in (84) and InHome_Date = '7-12-2013' and Month_Difference=1 then '7/15/2013'
    when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk in (84) and InHome_Date = '7-12-2013' and Month_Difference=-2 then '7/15/2013'
    when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk in (84) and InHome_Date = '6-3-2013' and Month_Difference=-2 then '4/15/2013'
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk in (84) and InHome_Date = '6-3-2013' and Month_Difference=-1 then '6/15/2013'
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk in (84) and InHome_Date = '6-3-2013' and Month_Difference=1 then '6/15/2013'
	
	--hispanic exception 
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk in (84,7) and InHome_Date > '2013-01-30' and InHome_Date < '2013-04-4' then '2/15/2013'
	
    --bill insert exceptions added 7/17/2013
    when media_type = 'BI' and InHome_Date = '2013-12-01' and Month_Difference=1 then '12/15/2013'
    when media_type = 'BI' and Inhome_date = '2014-01-01' then '2/14/2014'
    when media_type = 'BI' and Month_Difference=1 then DATEADD(Month,1,inhome_date)

-----------------------2014 Billing Exceptions -----------------------------------------------
-------March Catalog Remail----------
	when Current_UVAQ_Flightplan_Forecast_View.Touch_Type_FK=32 and InHome_Date='2014-03-14' and Month_Difference<>0 then '2013-12-15'
	
	
	
	
	
	--Code all 2013 and later aspen projects in to use simple logic rather than billing rules 
when media_type in ('DM','EM') and year(drop_date)>2012 and audience_type_name not like '%BL%' and month_difference<>0 and month(InHome_Date)<12 and (month(InHome_Date)-month(Drop_Date)) = 0
                  then cast((cast(year(drop_date) as varchar)+'-'+cast(month(InHome_Date)+1 as varchar)+'-15') as datetime) 
             when media_type in ('DM','EM') and year(drop_date)>2012 and audience_type_name not like '%BL%' and month_difference<>0 and month(InHome_Date)<12 and (month(InHome_Date)-month(Drop_Date)) <> 0
                  then cast((cast(year(inhome_Date) as varchar)+'-'+cast(month(InHome_Date)+1 as varchar)+'-15') as datetime)

	

	--Code Catalog projects
	when Media_Type = 'CA' and InHome_Date>'2013-12-31' and Month_Difference<0 then DATEADD(month,Month_Difference,InHome_Date)
		
	---Standard Assumption
		ELSE DATEADD(month,Month_Difference,Drop_Date) end as Bill_Date, 
---Billing Amount-------------
	--exception for feb 2013 catalog billing	
		CASE 
		WHEN  Media_Type='CA' and inhome_date='2013-2-15' and Current_UVAQ_Flightplan_Forecast_View.touch_type_fk = 68 and Month_Difference=-2 then 40612
		WHEN  Media_Type='CA' and inhome_date='2013-2-15' and Current_UVAQ_Flightplan_Forecast_View.touch_type_fk = 69 and Month_Difference=-2 then 4571
		WHEN  Media_Type='CA' and inhome_date='2013-2-15' and Current_UVAQ_Flightplan_Forecast_View.touch_type_fk = 70 and Month_Difference=-2 then 65526
		WHEN  Media_Type='CA' and inhome_date='2013-2-15' and Current_UVAQ_Flightplan_Forecast_View.touch_type_fk = 71 and Month_Difference=-2 then 1048
		
		WHEN  Media_Type='CA' and inhome_date='2013-2-15' and Current_UVAQ_Flightplan_Forecast_View.touch_type_fk = 68 and Month_Difference=0 then Budget_Forecast*0.55-40612
		WHEN  Media_Type='CA' and inhome_date='2013-2-15' and Current_UVAQ_Flightplan_Forecast_View.touch_type_fk = 69 and Month_Difference=0 then Budget_Forecast*0.55-4571
		WHEN  Media_Type='CA' and inhome_date='2013-2-15' and Current_UVAQ_Flightplan_Forecast_View.touch_type_fk = 70 and Month_Difference=0 then Budget_Forecast*0.55-65526
		WHEN  Media_Type='CA' and inhome_date='2013-2-15' and Current_UVAQ_Flightplan_Forecast_View.touch_type_fk = 71 and Month_Difference=0 then Budget_Forecast*0.55-1048
		WHEN  Media_Type='CA' and inhome_date='2013-2-15' and Current_UVAQ_Flightplan_Forecast_View.touch_type_fk = 68 and Month_Difference=-1 then Budget_Forecast*0.45
		WHEN  Media_Type='CA' and inhome_date='2013-2-15' and Current_UVAQ_Flightplan_Forecast_View.touch_type_fk = 69 and Month_Difference=-1 then Budget_Forecast*0.45
		WHEN  Media_Type='CA' and inhome_date='2013-2-15' and Current_UVAQ_Flightplan_Forecast_View.touch_type_fk = 70 and Month_Difference=-1 then Budget_Forecast*0.45
		WHEN  Media_Type='CA' and inhome_date='2013-2-15' and Current_UVAQ_Flightplan_Forecast_View.touch_type_fk = 71 and Month_Difference=-1 then Budget_Forecast*0.45
		
		--march early month 
	   when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=72 and InHome_Date = '2013-03-08' and Month_Difference=0 then Budget_Forecast*0.65
	   when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=73 and InHome_Date = '2013-03-08' and Month_Difference=0 then Budget_Forecast*0.65
	   when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=74 and InHome_Date = '2013-03-08' and Month_Difference=0 then Budget_Forecast*0.65
	   when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=75 and InHome_Date = '2013-03-08' and Month_Difference=0 then Budget_Forecast*0.65
			
	   when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=72 and InHome_Date = '2013-03-08' and Month_Difference=1 then Budget_Forecast*0.35
	   when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=73 and InHome_Date = '2013-03-08' and Month_Difference=1 then Budget_Forecast*0.35
	   when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=74 and InHome_Date = '2013-03-08' and Month_Difference=1 then Budget_Forecast*0.35
	   when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk=75 and InHome_Date = '2013-03-08' and Month_Difference=1 then Budget_Forecast*0.35
		
	
-----------------------2014 Billing Exceptions ------------------------------------------------------------------------------
------------Aspen Paper Buy------------------
	when Current_UVAQ_Flightplan_Forecast_View.Touch_Type_FK in (30, 63, 72, 73, 74, 75, 76, 77, 78, 79, 85, 86, 87, 88, 89, 90, 137, 138, 139, 140,175,176) 
		and InHome_Date between '2014-01-05' and '2014-01-31' and Month_Difference=1 
			then  Budget_Forecast*Billing_Percent-Budget_Forecast*0.0925
--------------Ryan Paper Buy-----------------
	when Current_UVAQ_Flightplan_Forecast_View.Touch_Type_FK in (69,68,163,70,71) and InHome_Date='2014-04-21' and Month_Difference=-2 
			then Budget_Forecast*Billing_Percent-Budget_Forecast*0.18335
	
-----------------------------------------------------------------------------------------------------------------------------	
	
		  --catalog March refund excpetion for a refund from Dec 2012 (raising Aug volume fore this refund)
	when Current_UVAQ_Flightplan_Forecast_View.touch_type_fk = 1 and InHome_Date = '2012-12-10'   and Month_Difference=3 then -40272.45	
		
		
		
		else
		Budget_Forecast*Billing_Percent end as Bill_Amount
	
FROM Forecasting.Current_UVAQ_Flightplan_Forecast_View 
	LEFT OUTER JOIN	Forecasting.Most_Recent_Billing_Rules_View 
		ON Forecasting.Current_UVAQ_Flightplan_Forecast_View.Touch_Type_FK=Forecasting.Most_Recent_Billing_Rules_View.Touch_Type_FK	














