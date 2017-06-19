ALTER PROCEDURE [bvt_prod].[Best_View_PR]
@PROG int	
AS
BEGIN 
SET NOCOUNT ON
--Temporary Declarations for Testing
/*DECLARE @PROG INT
set @PROG = 6 
--*/
------Section 1 Subselecting Tables - into temps---------

-------Section 1.1 - Flightplan Selection	
--Select the appropriate Flight Plan
--Check and delete temp	
IF OBJECT_ID('tempdb.dbo.#flightplan', 'U') IS NOT NULL
  DROP TABLE #flightplan; 

	SELECT * INTO #flightplan
	from bvt_prod.Flightplan_FUN(@prog);

create CLUSTERED index idx_c_flightplan_flightplanid ON #flightplan([idFlight_Plan_Records]);
---End Flightplan selection

-------Section 1.2 - Touch Definition View
IF OBJECT_ID('tempdb.dbo.#touchdef', 'U') IS NOT NULL
  DROP TABLE #touchdef; 

SELECT *
INTO #touchdef
from[bvt_prod].[Touchdef_FUN](@prog);

create clustered index IDX_C_touchdef_id ON #touchdef(idProgram_Touch_Definitions_TBL);
----------End Touch Def-----------------------------

------Section 1.3 - creating metrics end dates
--/*Inserting the start/end procs until triggers are fixed
--leaving CPP as function since it is only called twice. KL 6/16/17
--Using Target Adjustment from view not function. KL 6/16/17
--KPI Start End
delete [bvt_processed].[KPI_Rate_Start_End]
where [idProgram_Touch_Definitions_TBL_FK] in 
(select idProgram_Touch_Definitions_TBL from #touchdef);
insert into bvt_processed.KPI_Rate_Start_End
select * from bvt_prod.KPI_Rate_Start_End_VW
where idProgram_Touch_Definitions_TBL_FK in (select idProgram_Touch_Definitions_TBL from #touchdef);
--Response Curve Start End
delete [bvt_processed].[Response_Curve_Start_End]
where [idProgram_Touch_Definitions_TBL_FK] in 
(select idProgram_Touch_Definitions_TBL from #touchdef);
insert into [bvt_processed].[Response_Curve_Start_End]
select * from [bvt_prod].[Response_Curve_Start_End_VW]
where idProgram_Touch_Definitions_TBL_FK in (select idProgram_Touch_Definitions_TBL from #touchdef);
--Response Daily Start End
delete [bvt_processed].[Response_Daily_Start_End]
where [idProgram_Touch_Definitions_TBL_FK] in 
(select idProgram_Touch_Definitions_TBL from #touchdef);
insert into [bvt_processed].[Response_Daily_Start_End]
select * from [bvt_prod].[Response_Daily_Start_End_VW]
where idProgram_Touch_Definitions_TBL_FK in (select idProgram_Touch_Definitions_TBL from #touchdef);
--Sales Curve Start End
delete [bvt_processed].[Sales_Curve_Start_End]
where [idProgram_Touch_Definitions_TBL_FK] in 
(select idProgram_Touch_Definitions_TBL from #touchdef);
insert into [bvt_processed].[Sales_Curve_Start_End]
select * from [bvt_prod].[Sales_Curve_Start_End_VW]
where idProgram_Touch_Definitions_TBL_FK in (select idProgram_Touch_Definitions_TBL from #touchdef);
--Sales Rates Start End
delete [bvt_processed].[Sales_Rates_Start_End]
where [idProgram_Touch_Definitions_TBL_FK] in 
(select idProgram_Touch_Definitions_TBL from #touchdef);
insert into [bvt_processed].[Sales_Rates_Start_End]
select * from [bvt_prod].[Sales_Rates_Start_End_VW]
where idProgram_Touch_Definitions_TBL_FK in (select idProgram_Touch_Definitions_TBL from #touchdef);
--Target Adjustment Start End
delete [bvt_processed].[Target_Adjustment_Start_End]
where [idProgram_Touch_Definitions_TBL_FK] in 
(select idProgram_Touch_Definitions_TBL from #touchdef);
insert into [bvt_processed].[Target_Adjustment_Start_End]
select * from [bvt_prod].[Target_Adjustment_Start_End_VW]
where idProgram_Touch_Definitions_TBL_FK in (select idProgram_Touch_Definitions_TBL from #touchdef);
--*/
------- End Metrics End Dates--------------

----Section 1.4 - Volumes
---Could likely simplify this given current sett where only volume type 2 is being used?
IF OBJECT_ID('tempdb.dbo.#volumes', 'U') IS NOT NULL
  DROP TABLE #volumes;

select idFlight_Plan_Records
	--------------Logic to determine where to get volume
	, Case when idVolume_Type_LU_TBL_FK=1 then Lead_Volumes.Volume* Target_adjustment_start_end.Volume_Adjustment
		when idVolume_Type_LU_TBL_FK=2 then	Flight_Plan_Records_Volume.Volume 
		when idVolume_Type_LU_TBL_FK=3 then sum(Flight_Plan_Record_Budgets.Budget)/sum(CPP_Start_End.CPP)
		end as Volume
	,InHome_Date as Drop_Date
into #volumes
	from 
		(select idFlight_Plan_Records, idProgram_Touch_Definitions_TBL_FK, idVolume_Type_LU_TBL_FK, idTarget_Rate_Reasons_LU_TBL_FK, 
			inhome_date, ISO_Week_Year , MediaMonth 
			from #flightplan left join dim.Media_Calendar_Daily on InHome_Date=Media_Calendar_Daily.Date) as flighting
		
		left join bvt_prod.Flight_Plan_Records_Volume on idFlight_Plan_Records=Flight_Plan_Records_Volume.idFlight_Plan_Records_FK
		left join bvt_prod.Lead_Volumes on flighting.idProgram_Touch_Definitions_TBL_FK=Lead_Volumes.idProgram_Touch_Definitions_TBL_FK
			and ISO_Week_Year=Media_Year and MediaMonth=Media_Month
		left join bvt_prod.Flight_Plan_Record_Budgets on idFlight_Plan_Records=Flight_Plan_Record_Budgets.idFlight_Plan_Records_FK
		left join bvt_processed.Target_Adjustment_Start_End as Target_adjustment_start_end
			on flighting.idTarget_Rate_Reasons_LU_TBL_FK=Target_adjustment_start_end.idTarget_Rate_Reasons_LU_TBL_FK 
			and flighting.idProgram_Touch_Definitions_TBL_FK=Target_adjustment_start_end.idProgram_Touch_Definitions_TBL_FK
			and flighting.inhome_date between Adj_Start_Date and Target_adjustment_start_end.end_date
		left join (SELECT * FROM [bvt_prod].[CPP_Start_End_FUN](@PROG)) AS CPP_Start_End on flighting.idProgram_Touch_Definitions_TBL_FK=CPP_Start_End.idProgram_Touch_Definitions_TBL_FK
			and InHome_Date between Cpp_start_date and CPP_Start_End.end_date
Group by idFlight_Plan_Records, idVolume_Type_LU_TBL_FK, Lead_Volumes.Volume, Target_adjustment_start_end.Volume_Adjustment
	 , Flight_Plan_Records_Volume.Volume, InHome_Date;

CREATE CLUSTERED INDEX IDX_C_volumes_flightplanid ON #volumes(idFlight_Plan_Records);
--------End Volumes-------------

-----Section 1.5 - budgets
-----Only a few programs use this portion of the tool. Use CPP and Manual entry
--Added budget to forecast KL 6/15/17. Forced Forecast day to be the 1st of the bill month/year

IF OBJECT_ID('tempdb.dbo.#budgets', 'U') IS NOT NULL
  DROP TABLE #budgets;

select 
	#flightplan.idFlight_Plan_Records
	, #flightplan.InHome_Date
	, CPP_Start_End.idCPP_Category_FK
	, case when Budget_Type_LU_TBL_idBudget_Type_LU_TBL=2 then Bill_Month
		else month(DATEADD(month,bill_timing,#flightplan.InHome_Date)) 
		end as bill_month
	, case when Budget_Type_LU_TBL_idBudget_Type_LU_TBL=2 then Bill_Year
		else year(DATEADD(month,bill_timing,#flightplan.InHome_Date)) 
		end as bill_year
	, case when Budget_Type_LU_TBL_idBudget_Type_LU_TBL=2 then Budget
		else CPP*Volume end as budget
	, (CAST(case when Budget_Type_LU_TBL_idBudget_Type_LU_TBL=2 then Bill_Month
		else month(DATEADD(month,bill_timing,#flightplan.InHome_Date)) END AS VARCHAR) + '/1/' +
CAST(case when Budget_Type_LU_TBL_idBudget_Type_LU_TBL=2 then Bill_Year
		else year(DATEADD(month,bill_timing,#flightplan.InHome_Date)) END AS VARCHAR)) AS Forecast_DayDate
INTO #budgets
	from #flightplan
		left join bvt_prod.Flight_Plan_Record_Budgets
			on #flightplan.idFlight_Plan_Records=idFlight_Plan_Records_FK
		LEFT join (SELECT * FROM [bvt_prod].[CPP_Start_End_FUN](@PROG)) AS CPP_Start_End
			on #flightplan.idProgram_Touch_Definitions_TBL_FK=CPP_Start_End.idProgram_Touch_Definitions_TBL_FK
			and #flightplan.InHome_Date between CPP_Start_End.CPP_Start_Date and CPP_Start_End.END_DATE
		LEFT join #volumes as FPV
			on #flightplan.idFlight_Plan_Records=FPV.idFlight_Plan_Records
Where case when Budget_Type_LU_TBL_idBudget_Type_LU_TBL=2 then Budget
		else CPP*Volume end  is not null;

CREATE CLUSTERED INDEX IDX_C_budgets_flightplanid ON #budgets(idFlight_Plan_Records);
----------End Budget-------------
--End Section 1

---------------------Section 2 FORECAST -----------------------------------
IF OBJECT_ID('tempdb.dbo.#forecast', 'U') IS NOT NULL
  DROP TABLE #forecast; 

select #flightplan.idFlight_Plan_Records
	, #flightplan.Campaign_Name
	, #flightplan.InHome_Date
	, #flightplan.Strategy_Eligibility
	, #flightplan.Lead_Offer

---Media_Calendar_Info
	, Media_Calendar_Daily.ISO_Week_Year as Media_Year
	, Media_Calendar_Daily.ISO_Week as Media_Week
	, Media_Calendar_Daily.MediaMonth as Media_Month
	, Media_Calendar_Daily.ISO_Week_YYYYWW as Media_YYYYWW
	, YEAR(metrics.Forecast_DayDate) as Calendar_Year
	, MONTH(metrics.Forecast_DayDate) as Calendar_Month

---Touch Lookup Tables
	, idProgram_Touch_Definitions_TBL_FK
	, Touch_Name
	, Program_Name
	, Tactic
	, Media
	, Campaign_Type
	, Audience
	, Creative_Name
	, Goal
	, Offer
	, [owner_type_matrix_id_FK]
	, channel
	, Scorecard_Group
	, Scorecard_Program_Channel

----Metrics
	, KPI_Type
	, Product_Code
	, Forecast_DayDate
	, [Forecast]

INTO #forecast
from #flightplan 
left join
-------------Bring in the Metrics----------------------------------------------------------------------
(select * from 
---
((select idFlight_Plan_Records
	, 'Response' as KPI_Type
	, KPI_Type as Product_Code
	, Forecast_DayDate
	, KPI_Forecast as Forecast

from

--KPI daily Calculations of Response
(select kpi.idFlight_Plan_Records
,kpi.idProgram_Touch_Definitions_TBL_FK
,idkpi_types_FK
,Forecast_DayDate
,KPI_Daily*Volume as KPI_Forecast

from
---KPI daily Rates
(select idFlight_Plan_Records
	, responsebyday.idProgram_Touch_Definitions_TBL_FK
	, ResponseByDay.idkpi_types_FK
	, case when ResponseByDay.idTarget_Rate_Reasons_LU_TBL_FK is null then KPI_Daily*isnull(Seasonality_Adj,1)
		else KPI_Daily*isnull(Seasonality_Adj,1)*Rate_Adjustment_Factor end as KPI_Daily
	, Forecast_DayDate
from
----Join Weekly Response Curve and Media Calendar
(select Daily_Join.idFlight_Plan_Records
	, Daily_Join.idProgram_Touch_Definitions_TBL_FK
	, Daily_Join.idkpi_types_FK
	, KPI_Daily*week_percent as KPI_Daily
--	, DATEADD(week,c.Week_ID,InHome_Date) as Forecast_Week_Date
	, case when Media='EM' then
		case when day_of_week=1 then DATEADD(week,c.Week_ID,InHome_Date)
			else DATEADD(day,day_of_week-1,DATEADD(week,c.Week_ID,Inhome_Date))
			end
	  else 
	    case when day_of_week=datepart(WEEKDAY,inhome_date) then DATEADD(week,c.Week_ID,InHome_Date)
			when day_of_week<datepart(WEEKDAY,inhome_date) then DATEADD(day,7-datepart(WEEKDAY,inhome_date)+Day_of_Week,DATEADD(week,c.Week_ID,InHome_Date))
			else DATEADD(day,Day_of_Week-datepart(WEEKDAY,inhome_date),DATEADD(week,c.Week_ID,InHome_Date))
			end 
	  end as Forecast_DayDate
	, ISO_WEEK
	, ISO_Week_Year
	, MediaMonth
	, idTarget_Rate_Reasons_LU_TBL_FK
	, InHome_Date 

from 
----Join Daily Percentages
(select KPI_Join.idFlight_Plan_Records
	, KPI_Join.idProgram_Touch_Definitions_TBL_FK
	, KPI_Join.idkpi_types_FK
	, Day_of_Week
	, KPI_Daily = KPI_Rate*Day_Percent
	, inhome_date
	, idTarget_Rate_Reasons_LU_TBL_FK

from	
--Join Flight Plan with KPIs and KPI Manual Adjustments
(select 
	a.idFlight_Plan_Records
	, a.idProgram_Touch_Definitions_TBL_FK
	, b.idkpi_types_FK
	
  --Code to account for having a TFN or URL or not in flightplan entry and a manual adjustment or not
	,case 
		when TFN_ind=0 and b.idkpi_types_FK=1 then 0
		when URL_ind=0 and b.idkpi_types_FK=2 then 0
		else KPI_Rate*isnull(adjustment,1)
		end as KPI_Rate
	, InHome_Date
	, idTarget_Rate_Reasons_LU_TBL_FK
from #flightplan as A
	
	left join [bvt_processed].[KPI_Rate_Start_End] as B 
		on A.idProgram_Touch_Definitions_TBL_FK=B.idProgram_Touch_Definitions_TBL_FK
			AND InHome_Date between Rate_Start_Date and b.END_DATE
	left join bvt_prod.Target_Rate_Adjustment_Manual_TBL
		on idFlight_Plan_Records=idFlight_Plan_Records_FK and B.idkpi_types_FK=Target_Rate_Adjustment_Manual_TBL.idkpi_types_FK) as KPI_Join
---End Join KPI and Flight Plan	and Manual Adjustments

	left join  [bvt_processed].[Response_Daily_Start_End] as B 
		on KPI_Join.idProgram_Touch_Definitions_TBL_FK=b.idProgram_Touch_Definitions_TBL_FK and KPI_Join.idkpi_types_FK=b.idkpi_type_FK
		and InHome_Date between daily_Start_Date and b.END_DATE) as Daily_Join
	
---End Join Daily Percentages

	left join [bvt_processed].[Response_Curve_Start_End] as C
		on Daily_Join.idProgram_Touch_Definitions_TBL_FK=c.idProgram_Touch_Definitions_TBL_FK and Daily_Join.idkpi_types_FK=c.idkpi_type_FK
		and inhome_date between Curve_Start_Date and c.END_DATE
	left join dim.Media_Calendar_Daily 
		on Daily_Join.InHome_Date=Media_Calendar_Daily.Date
	left join #touchdef
		on Daily_Join.idProgram_Touch_Definitions_TBL_FK=#touchdef.idProgram_Touch_Definitions_TBL) as ResponseByDay
----------End  Weekly Response Curve and Media Calendar	
/*Code for seasonality adjustments broken out for response and sales
	left join bvt_prod.Response_Seasonality as E
		on ResponseByDay.idProgram_Touch_Definitions_TBL_FK=E.idProgram_Touch_Definitions_TBL_FK 
		  and ResponseByDay.idkpi_types_FK=E.idkpi_types_FK
		  and iso_week_year=Media_Year 
		  and mediamonth=Media_Month 
		  AND ISO_Week=Media_Week
*/
	left join bvt_prod.Seasonality_Adjustements as E
		on ResponseByDay.idProgram_Touch_Definitions_TBL_FK=E.idProgram_Touch_Definitions_TBL_FK and iso_week_year=Media_Year and mediamonth=Media_Month AND ISO_Week=Media_Week
	left join bvt_processed.Target_Adjustment_Start_End as Target_adjustment_start_end
		on ResponseByDay.idTarget_Rate_Reasons_LU_TBL_FK=Target_adjustment_start_end.idTarget_Rate_Reasons_LU_TBL_FK 
		and ResponseByDay.idProgram_Touch_Definitions_TBL_FK=Target_adjustment_start_end.idProgram_Touch_Definitions_TBL_FK
		and responsebyday.inhome_date between Adj_Start_Date and end_date) as kpi
inner join #volumes
		on kpi.idFlight_Plan_Records=#volumes.idFlight_Plan_Records) kpiforecast
left join bvt_prod.KPI_Types
		on kpiforecast.idkpi_types_FK=KPI_Types.idKPI_Types)
---------End Section KPI Rates--------------------------------------------------
---------Begin Section Sales Rates
union 

(select idFlight_Plan_Records
	, case when idkpi_type_FK=1 then 'Telesales'
		when idkpi_type_FK=2 then 'Online_sales'
		else 'CHECK' end as KPI_Type 
	, Product_Code
	, Forecast_DayDate
	, Sales_Forecast as Forecast

from

(select sales.idFlight_Plan_Records
	, sales.idProgram_Touch_Definitions_TBL_FK
	, sales.idkpi_type_FK
	, sales.idProduct_LU_TBL_FK
	, sales.Forecast_DayDate
	, Sales_rate_Daily*Volume as Sales_Forecast

from

(select idFlight_Plan_Records
	, responsebyday.idProgram_Touch_Definitions_TBL_FK
	, ResponseByDay.idkpi_type_FK
	, ResponseByDay.idProduct_LU_TBL_FK
	, Day_of_Week
	, case when ResponseByDay.idTarget_Rate_Reasons_LU_TBL_FK is null then Sales_rate_Daily*isnull(Seasonality_Adj,1)
		else Sales_rate_Daily*isnull(Seasonality_Adj,1)*Rate_Adjustment_Factor end as Sales_rate_Daily
	, Forecast_DayDate

from
----Join Weekly Response Curve and Media Calendar
(select Daily_Join.idFlight_Plan_Records
	, Daily_Join.idProgram_Touch_Definitions_TBL_FK
	, Daily_Join.idkpi_type_FK
	, Daily_Join.idProduct_LU_TBL_FK
	, Daily_Join.Day_of_Week
	, Salesrate_Daily*week_percent as Sales_Rate_Daily
--	, DATEADD(week,c.Week_ID,InHome_Date) as Forecast_Week_Date
	, case when Media='EM' then
		case when day_of_week=1 then DATEADD(week,c.Week_ID,InHome_Date)
			else DATEADD(day,day_of_week-1,DATEADD(week,c.Week_ID,Inhome_Date))
			end
	  else 
	    case when day_of_week=datepart(WEEKDAY,inhome_date) then DATEADD(week,c.Week_ID,InHome_Date)
			when day_of_week<datepart(WEEKDAY,inhome_date) then DATEADD(day,7-datepart(WEEKDAY,inhome_date)+Day_of_Week,DATEADD(week,c.Week_ID,InHome_Date))
			else DATEADD(day,Day_of_Week-datepart(WEEKDAY,inhome_date),DATEADD(week,c.Week_ID,InHome_Date))
			end 
	  end as Forecast_DayDate
	, ISO_week
	, ISO_Week_Year
	, MediaMonth
	, idTarget_Rate_Reasons_LU_TBL_FK
	, InHome_Date 

from 
----Join Daily Percentages
(select SalesRate_Join.idFlight_Plan_Records
	, SalesRate_Join.idProgram_Touch_Definitions_TBL_FK
	, SalesRate_Join.idkpi_type_FK
	, idProduct_LU_TBL_FK
	, Day_of_Week
	, salesrate_Daily = Sales_Rate*Day_Percent
	, inhome_date
	, idTarget_Rate_Reasons_LU_TBL_FK

from	
--Join Flight Plan with KPIs
(select 
	a.idFlight_Plan_Records
	, a.idProgram_Touch_Definitions_TBL_FK
	, B.idkpi_type_FK
	, B.idProduct_LU_TBL_FK
	, case 
		when TFN_ind=0 and b.idkpi_type_FK=1 then 0
		when URL_ind=0 and b.idkpi_type_FK=2 then 0
		else Sales_Rate*isnull(adjustment,1)*isnull(Sales_Adjustment,1)
	end as Sales_Rate
	, InHome_Date
	, idTarget_Rate_Reasons_LU_TBL_FK
from #flightplan as A
	
	left join [bvt_processed].[Sales_Rates_Start_End] as B
		on A.idProgram_Touch_Definitions_TBL_FK=B.idProgram_Touch_Definitions_TBL_FK
			and InHome_Date between Sales_Rate_Start_Date and b.END_DATE
	--Adds Manual Rate/Sales Adjustment by KPI type		
	left join bvt_prod.Target_Rate_Adjustment_Manual_TBL
		on idFlight_Plan_Records=idFlight_Plan_Records_FK and B.idkpi_type_FK=Target_Rate_Adjustment_Manual_TBL.idkpi_types_FK
	--Adds Manual Sales Adjustment by KPI Type and Product Code
	left join bvt_prod.Target_Sales_Rate_Adjustment_Manual_TBL
		on idFlight_Plan_Records = Target_Sales_Rate_Adjustment_Manual_TBL.idFlight_Plan_Records_FK 
		and B.idkpi_type_FK=Target_Sales_Rate_Adjustment_Manual_TBL.idKPI_Types_FK
		and B.idProduct_LU_TBL_FK = Target_Sales_Rate_Adjustment_Manual_TBL.idProduct_LU_TBL_FK) as SalesRate_Join
---End Join KPI and Flight Plan	

	left join [bvt_processed].[Response_Daily_Start_End] as B 
		on SalesRate_Join.idProgram_Touch_Definitions_TBL_FK=b.idProgram_Touch_Definitions_TBL_FK 
			and SalesRate_Join.idkpi_type_FK=b.idkpi_type_FK
		and InHome_Date between daily_Start_Date and b.END_DATE) as Daily_Join
	
---End Join Daily Percentages

	left join [bvt_processed].[Sales_Curve_Start_End] as C
		on Daily_Join.idProgram_Touch_Definitions_TBL_FK=c.idProgram_Touch_Definitions_TBL_FK
		 and Daily_Join.idkpi_type_FK=c.idkpi_type_FK
		 and inhome_date between Curve_Start_Date and c.END_DATE
		 and Case when c.idProduct_LU_TBL_FK is not null 
		       then c.idProduct_LU_TBL_FK
			   else Daily_Join.idProduct_LU_TBL_FK
			   end = Daily_Join.idProduct_LU_TBL_FK
		    		 
	--left join (SELECT * FROM [bvt_prod].[Dropdate_Start_End_FUN](@PROG)) as D
	--	on Daily_Join.idProgram_Touch_Definitions_TBL_FK=d.idProgram_Touch_Definitions_TBL_FK
	--	and inhome_date between drop_start_date and d.end_date
	left join  dim.Media_Calendar_Daily 
		on Daily_Join.InHome_Date=Media_Calendar_Daily.Date
	left join #touchdef
		on Daily_Join.idProgram_Touch_Definitions_TBL_FK=#touchdef.idProgram_Touch_Definitions_TBL) as ResponseByDay
----------End  Weekly Response Curve and Media Calendar	
/*Code for seasonality adjustments broken out for response and sales
	left join bvt_prod.Sales_Seasonality as E
		on ResponseByDay.idProgram_Touch_Definitions_TBL_FK=E.idProgram_Touch_Definitions_TBL_FK 
		  and ResponseByDay.idkpi_types_FK=E.idkpi_types_FK
		  and ResponseByDay.idProduct_LU_TBL_FK=E.idProduct_LU_TBL_FK
		  and iso_week_year=Media_Year 
		  and mediamonth=Media_Month 
		  AND ISO_Week=Media_Week
*/	
	left join bvt_prod.Seasonality_Adjustements as E
		on ResponseByDay.idProgram_Touch_Definitions_TBL_FK=E.idProgram_Touch_Definitions_TBL_FK and iso_week_year=Media_Year and mediamonth=Media_Month and ISO_Week = Media_Week
	left join bvt_processed.Target_Adjustment_Start_End  as Target_adjustment_start_end
		on ResponseByDay.idTarget_Rate_Reasons_LU_TBL_FK=Target_adjustment_start_end.idTarget_Rate_Reasons_LU_TBL_FK 
		and ResponseByDay.idProgram_Touch_Definitions_TBL_FK=Target_adjustment_start_end.idProgram_Touch_Definitions_TBL_FK
		and responsebyday.inhome_date between Adj_Start_Date and end_date) sales
inner join #volumes
on sales.idFlight_Plan_Records=#volumes.idFlight_Plan_Records) salesforecast
left join bvt_prod.Product_LU_TBL
		on salesforecast.idProduct_LU_TBL_FK=Product_LU_TBL.idProduct_LU_TBL)
UNION
(select idFlight_Plan_Records
	, 'Volume' as KPI_Type
	, 'Volume' as Product_Code
	, Drop_Date as Forecast_DayDate
	, Volume as Forecast
from #volumes)
UNION
(Select idFlight_Plan_Records
	, 'Budget' as KPI_Type
	, 'Budget' as Product_Code
	, Forecast_DayDate
	, SUM(Budget) as Forecast
from #budgets
	GROUP BY idFlight_Plan_Records, Forecast_DayDate)) as metricsa) as metrics
on #flightplan.idFlight_Plan_Records=metrics.idFlight_Plan_Records
-----------------------------------------------------------------	
--Media Calendar Information-------------------------------------
left join Dim.Media_Calendar_Daily
		on metrics.Forecast_DayDate=Media_Calendar_Daily.Date
-----------------------------------------------------------------

left join
-----Bring in touch definition labels 
#touchdef as touchdef
		on #flightplan.idProgram_Touch_Definitions_TBL_FK=idProgram_Touch_Definitions_TBL
--where Tactic <> 'Cost'	
;

create index IDX_NC_FORECASTTEMP
 ON #FORECAST([idFlight_Plan_Records], [Calendar_Year], [Calendar_Month]
  , [media_year] ,[Media_Week] ,[kpi_type] ,[product_code])  ;
-------------END SECTION SALES-----------------------------------------------------
-----END SECTION Forecasting-------------------------------------------------------

-------------------Begin Section Actuals-------------------------------------------
IF OBJECT_ID('tempdb.dbo.#actuals', 'U') IS NOT NULL
  DROP TABLE #actuals; 
----------Initial View---------------
select IR_Campaign_Data_Weekly_MAIN_2012_Sbset.Parentid, idFlight_Plan_Records_FK, [Report_Year], [Report_Week], IR_Campaign_Data_Weekly_MAIN_2012_Sbset.[Calendar_Year]
		, IR_Campaign_Data_Weekly_MAIN_2012_Sbset.[Calendar_Month], [Start_Date], [End_Date_Traditional], IR_Campaign_Data_Weekly_MAIN_2012_Sbset.[Campaign_Name], [eCRW_Project_Name]
	    , [media_code], [Toll_Free_Numbers], [URL_List], [ITP_Quantity_Unapp], [ITP_Budget_Unapp]
		, isnull([ITP_Dir_Calls],0) as [ITP_Dir_Calls], isnull([ITP_Dir_Calls_BH],0) as [ITP_Dir_Calls_BH], isnull([ITP_Dir_Clicks],0) as [ITP_Dir_Clicks]
		, isnull([ITP_Dir_Sales_TS_CING_N],0) as [ITP_Dir_Sales_TS_CING_N], isnull([ITP_Dir_Sales_TS_CING_VOICE_N],0) as [ITP_Dir_Sales_TS_CING_VOICE_N]
		, isnull([ITP_Dir_Sales_TS_CING_FAMILY_N],0) as [ITP_Dir_Sales_TS_CING_FAMILY_N], isnull([ITP_Dir_Sales_TS_CING_DATA_N],0) as [ITP_Dir_Sales_TS_CING_DATA_N]
		, isnull([ITP_Dir_Sales_TS_DISH_N],0) as [Itp_Dir_Sales_TS_DISH_N], isnull([ITP_Dir_Sales_TS_LD_N],0) as [ITP_Dir_Sales_TS_LD_N]
		, isnull([ITP_Dir_Sales_TS_DSL_REG_N],0) as [ITP_Dir_Sales_TS_DSL_REG_N], isnull([ITP_Dir_Sales_TS_DSL_DRY_N],0) as [ITP_Dir_Sales_TS_DSL_DRY_N]
		, isnull([ITP_Dir_Sales_TS_DSL_IP_N],0) as [ITP_Dir_Sales_TS_DSL_IP_N], isnull([ITP_Dir_Sales_TS_UVRS_HSIA_N],0) as [ITP_Dir_Sales_TS_UVRS_HSIA_N]
		, isnull([ITP_Dir_Sales_TS_UVRS_HSIAG_N],0) as [ITP_Dir_Sales_TS_UVRS_HSIAG_N]
		, isnull([ITP_Dir_Sales_TS_UVRS_TV_N],0) as [ITP_Dir_Sales_TS_UVRS_TV_N], isnull([ITP_Dir_Sales_TS_UVRS_BOLT_N],0) as [ITP_Dir_Sales_TS_UVRS_BOLT_N]
		, isnull([ITP_Dir_Sales_TS_LOCAL_ACCL_N],0) as [ITP_Dir_Sales_TS_LOCAL_ACCL_N], isnull([ITP_Dir_Sales_TS_UVRS_VOIP_N],0) as [ITP_Dir_Sales_TS_UVRS_VOIP_N]
		, isnull([ITP_Dir_Sales_TS_CTECH_N],0) as [ITP_Dir_Sales_TS_CTECH_N], isnull([ITP_Dir_Sales_TS_DLIFE_N],0) as [ITP_Dir_Sales_TS_DLIFE_N]
		, isnull([ITP_Dir_sales_TS_CING_WHP_N],0) as [ITP_Dir_sales_TS_CING_WHP_N], isnull([ITP_Dir_Sales_TS_Migrations],0) as [ITP_Dir_Sales_TS_Migrations]
		, isnull([ITP_Dir_Sales_ON_CING_N],0) as [ITP_Dir_Sales_ON_CING_N], isnull([ITP_Dir_Sales_ON_CING_VOICE_N],0) as [ITP_Dir_Sales_ON_CING_VOICE_N]
		, isnull([ITP_Dir_Sales_ON_CING_FAMILY_N],0) as [ITP_Dir_Sales_ON_CING_FAMILY_N], isnull([ITP_Dir_Sales_ON_CING_DATA_N],0) as [ITP_Dir_Sales_ON_CING_DATA_N]
		, isnull([ITP_Dir_Sales_ON_DISH_N],0) as [ITP_Dir_Sales_ON_DISH_N], isnull([ITP_Dir_Sales_ON_LD_N],0) as [ITP_Dir_Sales_ON_LD_N]
		, isnull([ITP_Dir_Sales_ON_DSL_REG_N],0) as [ITP_Dir_Sales_ON_DSL_REG_N], isnull([ITP_Dir_Sales_ON_DSL_DRY_N],0) as [ITP_Dir_Sales_ON_DSL_DRY_N]
		, isnull([ITP_Dir_Sales_ON_DSL_IP_N],0) as [ITP_Dir_Sales_ON_DSL_IP_N], isnull([ITP_Dir_Sales_ON_UVRS_HSIA_N],0) as [ITP_Dir_Sales_ON_UVRS_HSIA_N]
		, isnull([ITP_Dir_Sales_ON_UVRS_HSIAG_N],0) as [ITP_Dir_Sales_ON_UVRS_HSIAG_N]
		, isnull([ITP_Dir_Sales_ON_UVRS_TV_N],0) as [ITP_Dir_Sales_ON_UVRS_TV_N], isnull([ITP_Dir_Sales_ON_UVRS_BOLT_N],0) as [ITP_Dir_Sales_ON_UVRS_BOLT_N]
		, isnull([ITP_Dir_Sales_ON_LOCAL_ACCL_N],0) as [ITP_Dir_Sales_ON_LOCAL_ACCL_N], isnull([ITP_Dir_Sales_ON_UVRS_VOIP_N],0) as [ITP_Dir_Sales_ON_UVRS_VOIP_N]
		, isnull([ITP_Dir_Sales_ON_DLIFE_N],0) as [ITP_Dir_Sales_ON_DLIFE_N], isnull([ITP_Dir_Sales_ON_CING_WHP_N],0) as [ITP_Dir_Sales_ON_CING_WHP_N]
		, isnull([ITP_Dir_Sales_ON_Migrations],0) as [ITP_Dir_Sales_ON_Migrations], ISNULL(DTV_Now_Sales,0) as ITP_Dir_Sales_ON_DTVNOW_N
		into #actuals
		from from_javdb.IR_Campaign_Data_Weekly_MAIN_2012_Sbset
				inner join #flightplan
		on IR_Campaign_Data_Weekly_MAIN_2012_Sbset.idFlight_Plan_Records_FK= #flightplan.idFlight_Plan_Records
		LEFT JOIN 
		
		(Select parentID, SUM(Daily_Sales) as DTV_Now_Sales, b.ISO_Week, ISO_Week_Year, MONTH(a.Date) as Calendar_Month, YEAR(a.Date) as Calendar_Year
			from (
			Select a.eCRW_Project_Name, b.parentID, a.Date, a.[Online Sales]*b.Cell_Percent as Daily_Sales 
			from bvt_processed.DTV_Now_Sales_by_day a
			JOIN  bvt_prod.DTV_Now_Sales_App_VW b
				on a.eCRW_Cell_ID = b.ecrw_Cell_ID
			UNION ALL
			Select a.eCRW_Project_Name, b.parentID, a.Date, a.[Online Sales]*b.Cell_Percent as Daily_Sales from 
				(Select * from bvt_processed.DTV_Now_Sales_by_day
				where eCRW_Cell_ID is null) a
				JOIN  (Select * from bvt_prod.DTV_Now_Sales_App_VW
				where Cell_percent <> 1) b
				on a.eCRW_Project_Name = b.eCRW_Project_Name
				where a.eCRW_Cell_ID is null) a
				JOIN dim.Media_Calendar_Daily b
				on a.Date = b.Date
			GROUP BY parentID,  ISO_Week, ISO_Week_Year, MONTH(a.Date), YEAR(a.Date)) DTV_Now
			ON IR_Campaign_Data_Weekly_MAIN_2012_Sbset.Parentid = DTV_Now.parentID
				and IR_Campaign_Data_Weekly_MAIN_2012_Sbset.Report_Week = DTV_Now.ISO_Week
				and IR_Campaign_Data_Weekly_MAIN_2012_Sbset.Calendar_Month = DTV_Now.Calendar_Month
				and IR_Campaign_Data_Weekly_MAIN_2012_Sbset.Report_Year = DTV_Now.ISO_Week_Year
						
		where ExcludefromScorecard = 'N';

create index IDX_NC_actuals_idflightplan_strtdt ON #actuals([idFlight_Plan_Records_FK], [start_date]);
----------End Initial View--------------------------

--------Actuals Pivoted--------------------
--Added Volume and Budget to response and Sales also changed to ITP instead of CTD
IF OBJECT_ID('tempdb.dbo.#PivotActuals', 'U') IS NOT NULL
  DROP TABLE #PivotActuals; 
--
select [idFlight_Plan_Records_FK], [Media_Year], [Media_Week],  [MediaMonth] as Media_Month,
	[inhome_date], [Touch_Name], [Program_Name], [Tactic], [Media], [Campaign_Name],
	[Campaign_Type], [Audience], [Creative_Name], [Goal], [Offer], [Channel],
	[Scorecard_Group], [Scorecard_Program_Channel], [Calendar_Year], [Calendar_Month],
	[KPI_TYPE], [Product_Code], Actual
into #PivotActuals
from
	(select [idFlight_Plan_Records_FK], [Report_Year] as Media_Year, [Report_Week] as Media_Week,  [Calendar_Year], [Calendar_Month]
	, case 
		when kpiproduct='ITP_Dir_Calls' then 'Response'
		when kpiproduct='ITP_Dir_Clicks' then 'Response'
		when kpiproduct like '%Sales_TS%' then 'Telesales'
		when kpiproduct like '%Sales_ON%' then 'Online_sales'
		when kpiproduct = 'ITP_Quantity_Unapp' then'Volume'
		when kpiproduct = 'ITP_Budget_Unapp' then 'Budget'
		end as KPI_type
	, case
		when kpiproduct='ITP_Dir_Calls' then 'Call'
		when kpiproduct='ITP_Dir_Clicks' then 'Online'
		when kpiproduct like '%CING_VOICE%' then 'WRLS Voice'
		when kpiproduct like '%CING_FAMILY%' then 'WRLS Family'
		when kpiproduct like '%CING_DATA%' then 'WRLS Data'
		when kpiproduct like '%DISH%' then 'DirecTV'
		when kpiproduct like '%DSL_DRY%' then 'DSL Direct'
		when kpiproduct like '%DSL_REG%' then 'DSL'
		when kpiproduct like '%HSIAG%' then 'Fiber'
		when kpiproduct like '%HSIA%' then 'HSIA'
		when kpiproduct like '%DSL_IP%' then 'IPDSL'
		when kpiproduct like '%UVRS_TV%' then 'UVTV'
		when kpiproduct like '%VOIP%' then 'VoIP' 
		when kpiproduct like '%ACCL%' then 'Access Line'
		when kpiproduct like '%BOLT%' then 'Bolt ons'
		when kpiproduct like '%Migrations%' then 'Upgrades'
		when kpiproduct like '%CTECH%' then 'ConnecTech'
		when kpiproduct like '%DLIFE%' then 'Digital Life'
		when kpiproduct like '%WHP%' then 'WRLS Home'
		when kpiproduct like '%DTVNow%' then 'DTV Now'
		when kpiproduct = 'ITP_Quantity_Unapp' then'Volume'
		when kpiproduct = 'ITP_Budget_Unapp' then 'Budget'
		end as Product_Code
, sum(Actuals.[Actual]) as Actual

from #actuals

UNPIVOT (Actual for kpiproduct in 
			([ITP_Dir_Calls], [ITP_Dir_Clicks], [ITP_Quantity_Unapp], [ITP_Budget_Unapp],
			[ITP_Dir_Sales_TS_CING_VOICE_N], [ITP_Dir_Sales_TS_CING_FAMILY_N], 
			[ITP_Dir_Sales_TS_CING_DATA_N], [ITP_Dir_Sales_TS_DISH_N], [ITP_Dir_Sales_TS_DSL_REG_N], 
			[ITP_Dir_Sales_TS_DSL_DRY_N], [ITP_Dir_Sales_TS_DSL_IP_N], [ITP_Dir_Sales_TS_UVRS_HSIAG_N], [ITP_Dir_Sales_TS_UVRS_HSIA_N], [ITP_Dir_Sales_TS_UVRS_TV_N], 
			[ITP_Dir_Sales_TS_UVRS_BOLT_N], [ITP_Dir_Sales_TS_LOCAL_ACCL_N], [ITP_Dir_Sales_TS_UVRS_VOIP_N], [ITP_Dir_Sales_TS_CTECH_N], 
			[ITP_Dir_Sales_TS_DLIFE_N], [ITP_Dir_sales_TS_CING_WHP_N], [ITP_Dir_Sales_TS_Migrations], 
			[ITP_Dir_Sales_ON_CING_VOICE_N], [ITP_Dir_Sales_ON_CING_FAMILY_N], [ITP_Dir_Sales_ON_CING_DATA_N], [ITP_Dir_Sales_ON_DISH_N], 
			[ITP_Dir_Sales_ON_DSL_REG_N], [ITP_Dir_Sales_ON_DSL_DRY_N], [ITP_Dir_Sales_ON_DSL_IP_N], [ITP_Dir_Sales_ON_UVRS_HSIAG_N],
			[ITP_Dir_Sales_ON_UVRS_HSIA_N], [ITP_Dir_Sales_ON_UVRS_TV_N], [ITP_Dir_Sales_ON_UVRS_BOLT_N], [ITP_Dir_Sales_ON_LOCAL_ACCL_N], 
			[ITP_Dir_Sales_ON_UVRS_VOIP_N], [ITP_Dir_Sales_ON_DLIFE_N], [ITP_Dir_Sales_ON_CING_WHP_N], [ITP_Dir_Sales_ON_Migrations], [ITP_Dir_Sales_ON_DTVNOW_N])) as Actuals

GROUP BY [idFlight_Plan_Records_FK], [Report_Year], [Report_Week], [Calendar_Year], [Calendar_Month]

, case
	when kpiproduct='ITP_Dir_Calls' then 'Response'
	when kpiproduct='ITP_Dir_Clicks' then 'Response'
	when kpiproduct like '%Sales_TS%' then 'Telesales'
	when kpiproduct like '%Sales_ON%' then 'Online_sales'
	when kpiproduct = 'ITP_Quantity_Unapp' then'Volume'
	when kpiproduct = 'ITP_Budget_Unapp' then 'Budget'
	end 

, case 
	when kpiproduct='ITP_Dir_Calls' then 'Call'
	when kpiproduct='ITP_Dir_Clicks' then 'Online'
	when kpiproduct like '%CING_VOICE%' then 'WRLS Voice'
	when kpiproduct like '%CING_FAMILY%' then 'WRLS Family'
	when kpiproduct like '%CING_DATA%' then 'WRLS Data'
	when kpiproduct like '%DISH%' then 'DirecTV'
	when kpiproduct like '%DSL_DRY%' then 'DSL Direct'
	when kpiproduct like '%DSL_REG%' then 'DSL'
	when kpiproduct like '%HSIAG%' then 'Fiber'
	when kpiproduct like '%HSIA%' then 'HSIA'
	when kpiproduct like '%DSL_IP%' then 'IPDSL'
	when kpiproduct like '%UVRS_TV%' then 'UVTV'
	when kpiproduct like '%VOIP%' then 'VoIP' 
	when kpiproduct like '%ACCL%' then 'Access Line'
	when kpiproduct like '%BOLT%' then 'Bolt ons'
	when kpiproduct like '%Migrations%' then 'Upgrades'
	when kpiproduct like '%CTECH%' then 'ConnecTech'
	when kpiproduct like '%DLIFE%' then 'Digital Life'
	when kpiproduct like '%WHP%' then 'WRLS Home'
	when kpiproduct like '%DTVNow%' then 'DTV Now'
	when kpiproduct = 'ITP_Quantity_Unapp' then'Volume'
	when kpiproduct = 'ITP_Budget_Unapp' then 'Budget'
	end 
	) as actuals 
	inner join #flightplan on [idFlight_Plan_Records_FK] = [idFlight_Plan_Records]
	inner join #touchdef on [idProgram_Touch_Definitions_TBL] = [idProgram_Touch_Definitions_TBL_FK]
	inner join (Select distinct [ISO_week], [ISO_Week_Year], [MediaMonth] from DIM.Media_Calendar_Daily) d
on [Media_week] = d.[ISO_Week] and [Media_Year] = d.[ISO_Week_Year];

create index IDX_NC_PivotActuals
 ON #PivotActuals([idFlight_Plan_Records_FK], [Calendar_Year], [Calendar_Month]
  , [media_year] ,[Media_Week] ,[kpi_type] ,[product_code]);
----------------End Actual Response Sales--------------


-----------End Section Actuals-------------------------

--------------CV Section--------------------------------
IF OBJECT_ID('tempdb.dbo.#cv', 'U') IS NOT NULL
  DROP TABLE #cv; 
--
select [idFlight_Plan_Records]
  , [idProgram_Touch_Definitions_TBL_FK]
  , CV_Combined.[Campaign_Name]
  , CV_Combined.[InHome_Date]
  , CV_Combined.[Media_Year]
  , [Media_Month]
  , [Media_Week]
  , [Media_YYYYWW]
  , [Calendar_Year], [Calendar_Month]
  , [KPI_TYPE]
  , [Forecast_DayDate]
  , CV_Combined.[Product_Code]
  ,  SUM([forecast]) as Forecast
  ,	CV_Combined.[Touch_Name]
  , CV_Combined.[Program_Name]
  , CV_Combined.[Tactic]
  , CV_Combined.[Media]
  , CV_Combined.[Audience]
  , CV_Combined.[Creative_Name]
  , CV_Combined.[Goal]
  , CV_Combined.[Offer]
  , CV_Combined.[Campaign_Type]
  , CV_Combined.[Channel]
  ,	#touchdef.[Scorecard_Group]
  , #touchdef.[Scorecard_Program_Channel]
into #cv
from bvt_cv.CV_Combined
left join [bvt_prod].#touchdef
	on CV_Combined.[idProgram_Touch_Definitions_TBL_FK]=#touchdef.[idProgram_Touch_Definitions_TBL]
where CV_Combined.[Program_Name]=(select program_name from bvt_prod.program_LU_TBL where idProgram_LU_TBL=@prog)
GROUP BY [idFlight_Plan_Records], [idProgram_Touch_Definitions_TBL_FK], CV_Combined.[Campaign_Name], [InHome_Date], 
	[Media_Year], [Media_Month], [Media_Week], [Media_YYYYWW], [KPI_TYPE], [Product_Code],
	CV_Combined.[Touch_Name], CV_Combined.[Program_Name], CV_Combined.[Tactic], CV_Combined.[Media]
	, CV_Combined.[Audience], CV_Combined.[Creative_Name], CV_Combined.[Goal]
	, CV_Combined.[Offer], CV_Combined.[Campaign_Type], CV_Combined.[Channel],
	#touchdef.[Scorecard_Group], #touchdef.[Scorecard_Program_Channel], [Calendar_Year], [Calendar_Month], [Forecast_DayDate];
create index IDX_NC_CV
 ON #cv([idFlight_Plan_Records], [Calendar_Year], [Calendar_Month]
  , [media_year] ,[Media_Week] ,[kpi_type] ,[product_code]);
----------------END CV Section-----------------------------------------
-----------------Blending Section--------------------------------------
/*Combine the Forecast, Actuals, and CV into a single Best View of the
program selected for output*/
-----------------------------------------------------------------------




select
coalesce(forecast_cv.[idFlight_Plan_Records_FK], #PivotActuals.[idFlight_Plan_Records_FK]) as idFlight_Plan_Records_FK,
		coalesce(forecast_cv.[Campaign_Name], #PivotActuals.[Campaign_Name]) as Campaign_Name,
		coalesce(forecast_cv.[InHome_Date],	#PivotActuals.[InHome_Date]) as InHome_Date,
		coalesce(forecast_cv.[Media_Year], #PivotActuals.[Media_Year]) as Media_Year,
		coalesce(forecast_cv.[Media_Week], #PivotActuals.[Media_Week]) as Media_Week,
		coalesce(forecast_cv.[Media_Month], #PivotActuals.Media_Month) as Media_Month,
		coalesce(forecast_cv.[Calendar_Year], #PivotActuals.[Calendar_Year]) as Calendar_Year,
		coalesce(forecast_cv.[Calendar_Month], #PivotActuals.[Calendar_Month]) as Calendar_Month,
		coalesce(forecast_cv.[Touch_Name], #PivotActuals.[Touch_Name]) as Touch_Name, 
		coalesce(forecast_cv.[Program_Name], #PivotActuals.[Program_Name]) as Program_Name, 
		coalesce(forecast_cv.[Tactic], #PivotActuals.[Tactic]) as Tactic, 
		coalesce(forecast_cv.[Media], #PivotActuals.[Media]) as Media,
		coalesce(forecast_cv.[Campaign_Type], #PivotActuals.[Campaign_Type]) as Campaign_Type,
		coalesce(forecast_cv.[Audience], #PivotActuals.[Audience]) as Audience,
		coalesce(forecast_cv.[Creative_Name], #PivotActuals.[Creative_Name]) as Creative_Name,
		coalesce(forecast_cv.[Goal], #PivotActuals.[Goal]) as Goal,
		coalesce(forecast_cv.[Offer], #PivotActuals.[Offer]) as Offer,
		coalesce(forecast_cv.[Channel],	#PivotActuals.[Channel]) as Channel,
		coalesce(forecast_cv.[Scorecard_Group],	#PivotActuals.[Scorecard_Group]) as Scorecard_Group,
		coalesce(forecast_cv.[Scorecard_Program_Channel], #PivotActuals.[Scorecard_Program_Channel]) as Scorecard_Program_Channel,
		coalesce(forecast_cv.[KPI_Type], #PivotActuals.[KPI_Type]) as KPI_Type,
		coalesce(forecast_cv.[Product_Code], #PivotActuals.[Product_Code]) as Product_Code
		,strategy_eligibility
		,lead_offer
		,isnull([Forecast],0) as Forecast
		,isnull([Commitment],0) as Commitment
		,isnull(#PivotActuals.[Actual],0) as Actual
-- complex case statement to determine if you should be using forecast or actuals for the best view

--First are these telesales or other metrics as telesales require a lagging
		,case when coalesce(forecast_cv.[KPI_Type], #PivotActuals.[KPI_Type]) = 'Telesales'
		--IS the forecast YYYYWW two weeks less than the current report week available 
			then (case when forecast_cv.[media_YYYYWW] <= (case when DATEPART(weekday,getdate()) <= 5 
						then (select [ISO_Week_YYYYWW] from dim.media_calendar_daily where [date] = cast(dateadd(wk,-4,getdate()) as date)) 
						else (select [ISO_Week_YYYYWW] from dim.media_calendar_daily where [date] = cast(dateadd(wk,-3,getdate()) as date)) end)
					then #PivotActuals.[Actual]
					when forecast_cv.[media_YYYYWW] is null then #PivotActuals.[Actual]
					else isnull([Forecast],0)
					end)
----END OF TELESALES LAG CONCERNS
--Non telesale report through current available week
		when forecast_cv.[media_YYYYWW] <= (case when DATEPART(weekday,getdate()) <= 5 
						then (select [ISO_Week_YYYYWW] from dim.media_calendar_daily where [date] = cast(dateadd(wk,-2,getdate()) as date)) 
						else (select [ISO_Week_YYYYWW] from dim.media_calendar_daily where [date] = cast(dateadd(wk,-1,getdate()) as date)) end)
			then #PivotActuals.[Actual]

		when forecast_cv.[media_YYYYWW] is null then #PivotActuals.[Actual]
		else isnull([Forecast],0)

		end as Best_View
----END OF COMPLEX Best View case statement-------------------------------------------------------------
		
FROM	

(SELECT 
	   Coalesce(#flightplan.idFlight_Plan_Records, forecast.[idFlight_Plan_Records], cv.[idFlight_Plan_Records]) as idFlight_Plan_Records_FK
      ,Coalesce(#flightplan.Campaign_Name, forecast.[Campaign_Name], cv.[Campaign_Name]) as Campaign_Name
      ,coalesce(#flightplan.InHome_Date, forecast.[InHome_Date], cv.[InHome_Date]) as InHome_Date
      ,coalesce(#touchdef.Touch_Name, forecast.[Touch_Name], cv.[Touch_Name]) as Touch_Name
      ,coalesce(#touchdef.Program_Name, forecast.[Program_Name], cv.[Program_Name]) as Program_Name
      ,coalesce(#touchdef.Tactic, forecast.[Tactic], cv.[Tactic]) as Tactic
      ,coalesce(#touchdef.Media, forecast.[Media], cv.[Media]) as Media
      ,coalesce(#touchdef.Campaign_Type, forecast.[Campaign_Type], cv.[Campaign_Type]) as Campaign_Type
      ,coalesce(#touchdef.Audience, forecast.[Audience], cv.[Audience]) as Audience
      ,coalesce(#touchdef.Creative_Name, forecast.[Creative_Name], cv.[Creative_Name]) as Creative_Name
      ,coalesce(#touchdef.Goal, forecast.[Goal], cv.[Goal]) as Goal
      ,coalesce(#touchdef.Offer, forecast.[Offer], cv.[Offer]) as Offer
      ,coalesce(#touchdef.Channel, forecast.[Channel], cv.[Channel]) as Channel
      ,coalesce(#touchdef.Scorecard_Group, forecast.[Scorecard_Group], cv.[Scorecard_Group]) as Scorecard_Group
      ,coalesce(#touchdef.Scorecard_Program_Channel, forecast.[Scorecard_Program_Channel], cv.[Scorecard_Program_Channel]) as Scorecard_Program_Channel
      ,coalesce(forecast.[KPI_Type], cv.[KPI_Type]) as KPI_Type
      ,coalesce(forecast.[Product_Code], cv.[Product_Code]) as Product_Code
	  ,coalesce(forecast.[media_year], cv.[media_year]) as media_year
	  ,coalesce(forecast.[media_month], cv.[media_month]) as media_month
	  ,coalesce(forecast.[media_week], cv.[media_week]) as media_week
	  ,coalesce(forecast.[Media_YYYYWW], cv.[Media_YYYYWW]) as Media_YYYYWW
	  ,coalesce(forecast.[Calendar_Year], cv.[Calendar_Year]) as Calendar_Year
	  ,coalesce(forecast.[Calendar_Month], cv.[Calendar_Month]) as Calendar_Month
      ,sum(isnull(forecast.[Forecast],0)) as Forecast
	  ,sum(isnull(CV.forecast,0)) as Commitment 
FROM #forecast as forecast
	FULL JOIN
	#cv as CV
	ON forecast.[idFlight_Plan_Records] = cv.[idFlight_Plan_Records] 
			and forecast.[media_year] = cv.[Media_Year]
			and forecast.[media_week] = cv.[Media_Week]
			and forecast.[kpi_type] = cv.[kpi_type]
			and forecast.[product_code] = cv.[product_code]
			and forecast.[Calendar_Year] = cv.[Calendar_Year]
			and forecast.[Calendar_Month] = cv.[Calendar_Month]
			and forecast.[Forecast_DayDate] = cv.Forecast_DayDate
	LEFT JOIN #flightplan
	on Coalesce(forecast.idFlight_Plan_Records, cv.idFLight_Plan_Records) = #flightplan.idFlight_Plan_Records
	LEFT JOIN #touchdef
	on #flightplan.idProgram_Touch_Definitions_TBL_FK = #touchdef.idProgram_Touch_Definitions_TBL

group by 	   Coalesce(#flightplan.idFlight_Plan_Records, forecast.[idFlight_Plan_Records], cv.[idFlight_Plan_Records])
      ,Coalesce(#flightplan.Campaign_Name, forecast.[Campaign_Name], cv.[Campaign_Name])
      ,coalesce(#flightplan.InHome_Date, forecast.[InHome_Date], cv.[InHome_Date])
      ,coalesce(#touchdef.Touch_Name, forecast.[Touch_Name], cv.[Touch_Name])
      ,coalesce(#touchdef.Program_Name, forecast.[Program_Name], cv.[Program_Name])
      ,coalesce(#touchdef.Tactic, forecast.[Tactic], cv.[Tactic])
      ,coalesce(#touchdef.Media, forecast.[Media], cv.[Media])
      ,coalesce(#touchdef.Campaign_Type, forecast.[Campaign_Type], cv.[Campaign_Type])
      ,coalesce(#touchdef.Audience, forecast.[Audience], cv.[Audience])
      ,coalesce(#touchdef.Creative_Name, forecast.[Creative_Name], cv.[Creative_Name])
      ,coalesce(#touchdef.Goal, forecast.[Goal], cv.[Goal])
      ,coalesce(#touchdef.Offer, forecast.[Offer], cv.[Offer])
      ,coalesce(#touchdef.Channel, forecast.[Channel], cv.[Channel])
      ,coalesce(#touchdef.Scorecard_Group, forecast.[Scorecard_Group], cv.[Scorecard_Group])
      ,coalesce(#touchdef.Scorecard_Program_Channel, forecast.[Scorecard_Program_Channel], cv.[Scorecard_Program_Channel])
      ,coalesce(forecast.[KPI_Type], cv.[KPI_Type])
      ,coalesce(forecast.[Product_Code], cv.[Product_Code])
	  ,coalesce(forecast.[media_year], cv.[media_year])
	  ,coalesce(forecast.[media_month], cv.[media_month])
	  ,coalesce(forecast.[media_week], cv.[media_week])
	  ,coalesce(forecast.[Media_YYYYWW], cv.[Media_YYYYWW])
	  ,coalesce(forecast.[Calendar_Year], cv.[Calendar_Year])
	  ,coalesce(forecast.[Calendar_Month], cv.[Calendar_Month])
	  ) as forecast_cv

FULL JOIN #PivotActuals
	on forecast_cv.[idFlight_Plan_Records_FK] = #PivotActuals.[idFlight_Plan_Records_FK] 
	 and forecast_cv.[media_year] = #PivotActuals.[media_year]
	 and forecast_cv.[media_week] = #PivotActuals.[media_week]
	 and forecast_cv.[KPI_Type] =#PivotActuals.[KPI_Type]
	 and forecast_cv.[Product_Code] = #PivotActuals.[product_code]
	 and forecast_cv.[Calendar_Year] = #PivotActuals.[Calendar_Year]
	 and forecast_cv.[Calendar_Month] = #PivotActuals.[Calendar_Month]
	 
	LEFT JOIN #flightplan
    ON Coalesce(forecast_cv.[idFlight_Plan_Records_FK], #PivotActuals.[idFlight_Plan_Records_FK]) = #flightplan.idFlight_Plan_Records
;
------------END OF BLENDING BEST VIEW!-----------------------------------


SET NOCOUNT OFF
END
