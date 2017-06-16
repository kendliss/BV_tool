alter PROCEDURE [bvt_prod].[Forecasting_Calculations_PR]
	@PROG int	
AS
BEGIN 
SET NOCOUNT ON
/*Temporary Declarations for Testing
DECLARE @PROG INT
set @PROG = 11
--*/
------Section 1 Subselecting Tables - into temps---------

-------Section 1.1 - Flightplan Selection	
--Select the appropriate Flight Plan
--Check and delete temp	
IF OBJECT_ID('tempdb.dbo.#flightplan', 'U') IS NOT NULL
  DROP TABLE #flightplan; 

	SELECT * INTO #flightplan
	from bvt_prod.Flightplan_FUN(@PROG);

create CLUSTERED index idx_c_flightplan_flightplanid ON #flightplan([idFlight_Plan_Records]);
---End Flightplan selection

-------Section 1.2 - Touch Definition View
IF OBJECT_ID('tempdb.dbo.#touchdef', 'U') IS NOT NULL
  DROP TABLE #touchdef; 

SELECT *
INTO #touchdef
from[bvt_prod].[Touchdef_FUN](@PROG);

create clustered index IDX_C_touchdef_id ON #touchdef(idProgram_Touch_Definitions_TBL);
----------End Touch Def-----------------------------

------Section 1.3 - Creating metrics end dates
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
------End Volumes----------

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
--------End Budget------------
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
		else KPI_Daily*isnull(Seasonality_Adj,1)*isnull(Rate_Adjustment_Factor,1) end as KPI_Daily
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
		else Sales_rate_Daily*isnull(Seasonality_Adj,1)*isnull(Rate_Adjustment_Factor,1) end as Sales_rate_Daily
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

SET NOCOUNT OFF
END