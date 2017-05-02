ALTER PROCEDURE [bvt_prod].[Best_View_Pivoted_PR]
@PROG int	
AS
BEGIN 
SET NOCOUNT ON
/*Temporary Declarations for Testing
DECLARE @PROG INT
set @PROG = 4
--*/
------Section 1 Subselecting Tables - into temps---------

-------Section 1.1 - Flightplan Selection	
--Select the appropriate Flight Plan
--Check and delete temp	
IF OBJECT_ID('tempdb.dbo.#flightplan', 'U') IS NOT NULL
  DROP TABLE #flightplan; 

	SELECT * INTO #flightplan
	from bvt_prod.Flight_Plan_Records
	where idProgram_Touch_Definitions_TBL_FK 
		in (select idProgram_Touch_Definitions_TBL 
			from bvt_prod.Program_Touch_Definitions_TBL
			WHERE idProgram_LU_TBL_FK=@PROG)
-------In Home date limitation to prevent excess calculations on old flight plan records
	and inhome_date>='2016-01-01';

create CLUSTERED index idx_c_flightplan_flightplanid ON #flightplan([idFlight_Plan_Records]);

---End Flightplan selection
-------Touch Definition View--------------------------
IF OBJECT_ID('tempdb.dbo.#touchdef', 'U') IS NOT NULL
  DROP TABLE #touchdef; 

SELECT idProgram_Touch_Definitions_TBL
	, Touch_Name, Program_Name, Tactic, Media, Audience
	, Creative_Name, Goal, Offer, Campaign_Type, Channel
	, owner_type_matrix_id_FK, 
	SC.Scorecard_group, Scorecard_program_Channel
INTO #touchdef
from bvt_prod.Program_Touch_Definitions_TBL
	left join bvt_prod.Audience_LU_TBL on idAudience_LU_TBL_FK=idAudience_LU_TBL
	left join bvt_prod.Campaign_Type_LU_TBL on idCampaign_Type_LU_TBL_FK=idCampaign_Type_LU_TBL
	left join bvt_prod.Creative_LU_TBL on idCreative_LU_TBL_fk=idCreative_LU_TBL
	left join bvt_prod.Goal_LU_TBL on idGoal_LU_TBL_fk=idGoal_LU_TBL
	left join bvt_prod.Media_LU_TBL on idMedia_LU_TBL_fk=idMedia_LU_TBL
	left join bvt_prod.Offer_LU_TBL on idOffer_LU_TBL_fk=idOffer_LU_TBL
	left join bvt_prod.Program_LU_TBL on idProgram_LU_TBL_fk=idProgram_LU_TBL
	left join bvt_prod.Tactic_LU_TBL on idTactic_LU_TBL_fk=idTactic_LU_TBL
	left join bvt_prod.Channel_LU_TBL on idChanel_LU_TBL_FK=idChanel_LU_TBL
	left Join (Select Distinct ID, scorecard_group, scorecard_program_channel from JAVDB.IREPORT_2015.dbo.WB_00_Reporting_Hierarchy) sc on sc.ID =  owner_type_matrix_id_FK
WHERE idProgram_LU_TBL_fk=@PROG;

create clustered index IDX_C_touchdef_id ON #touchdef(idProgram_Touch_Definitions_TBL);

----------End Touch Def-----------------------------
--/*Inserting the start/end procs until triggers are fixed
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

----Section 1.3 - Target Adjustments
IF OBJECT_ID('tempdb.dbo.#Trgt_adj', 'U') IS NOT NULL
  DROP TABLE #Trgt_adj;
SELECT * into #Trgt_adj FROM [bvt_prod].[Target_adjustment_start_end_FUN](@PROG);
------------------
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
		left join (SELECT * FROM [bvt_prod].[Target_adjustment_start_end_FUN](4)) as Target_adjustment_start_end
			on flighting.idTarget_Rate_Reasons_LU_TBL_FK=Target_adjustment_start_end.idTarget_Rate_Reasons_LU_TBL_FK 
			and flighting.idProgram_Touch_Definitions_TBL_FK=Target_adjustment_start_end.idProgram_Touch_Definitions_TBL_FK
			and flighting.inhome_date between Adj_Start_Date and Target_adjustment_start_end.end_date
		left join (SELECT * FROM [bvt_prod].[CPP_Start_End_FUN](4)) AS CPP_Start_End on flighting.idProgram_Touch_Definitions_TBL_FK=CPP_Start_End.idProgram_Touch_Definitions_TBL_FK
			and InHome_Date between Cpp_start_date and CPP_Start_End.end_date
Group by idFlight_Plan_Records, idVolume_Type_LU_TBL_FK, Lead_Volumes.Volume, Target_adjustment_start_end.Volume_Adjustment
	 , Flight_Plan_Records_Volume.Volume, InHome_Date;

CREATE CLUSTERED INDEX IDX_C_volumes_flightplanid ON #volumes(idFlight_Plan_Records);
---------------------------------------------------------------------------------
--End Section 1

---------------------Section 2 FORECAST -----------------------------------
IF OBJECT_ID('tempdb.dbo.#forecast', 'U') IS NOT NULL
  DROP TABLE #forecast; 

select #flightplan.idFlight_Plan_Records
	, #flightplan.Campaign_Name
	, #flightplan.InHome_Date
	
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
	, responsebyday.idkpi_types_FK
	, case when ResponseByDay.idTarget_Rate_Reasons_LU_TBL_FK is null then KPI_Daily*Seasonality_Adj
		else KPI_Daily*Seasonality_Adj*Rate_Adjustment_Factor end as KPI_Daily
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
	, ISO_week
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
	,case when tfn_ind=1 and b.idkpi_types_FK=1 then KPI_Rate*isnull(adjustment,1)
		when TFN_ind=0 and b.idkpi_types_FK=1 then 0
		when URL_ind=1 and b.idkpi_types_FK=2 then KPI_Rate*isnull(adjustment,1)
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
	left join  dim.Media_Calendar_Daily 
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
	left join #Trgt_adj as Target_adjustment_start_end
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
	, case when ResponseByDay.idTarget_Rate_Reasons_LU_TBL_FK is null then Sales_rate_Daily*Seasonality_Adj
		else Sales_rate_Daily*Seasonality_Adj*Rate_Adjustment_Factor end as Sales_rate_Daily
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
	, case when tfn_ind=1 and b.idkpi_type_FK=1 then Sales_Rate*isnull(adjustment,1)*isnull(Sales_Adjustment,1)
		when TFN_ind=0 and b.idkpi_type_FK=1 then 0
		when URL_ind=1 and b.idkpi_type_FK=2 then Sales_Rate*isnull(adjustment,1)*isnull(Sales_Adjustment,1)
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
		on Daily_Join.idProgram_Touch_Definitions_TBL_FK=c.idProgram_Touch_Definitions_TBL_FK and Daily_Join.idkpi_type_FK=c.idkpi_type_FK
		and inhome_date between Curve_Start_Date and c.END_DATE
		and Case when c.idProduct_LU_TBL_FK is not null 
		       then c.idProduct_LU_TBL_FK
			   else Daily_Join.idProduct_LU_TBL_FK
			   end = Daily_Join.idProduct_LU_TBL_FK
	left join (SELECT * FROM [bvt_prod].[Dropdate_Start_End_FUN](@PROG)) as D
		on Daily_Join.idProgram_Touch_Definitions_TBL_FK=d.idProgram_Touch_Definitions_TBL_FK
		and inhome_date between drop_start_date and d.end_date
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
	left join #Trgt_adj  as Target_adjustment_start_end
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
from #volumes)) as metricsa) as metrics
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
where Tactic <> 'Cost'	
;

create index IDX_NC_FORECASTTEMP
 ON #FORECAST([idFlight_Plan_Records], [Calendar_Year], [Calendar_Month]
  , [media_year] ,[Media_Week] ,[kpi_type] ,[product_code]);
-------------END SECTION SALES-----------------------------------------------------
-----END SECTION Forecasting-------------------------------------------------------

-------------------Begin Section Actuals-------------------------------------------
IF OBJECT_ID('tempdb.dbo.#actuals', 'U') IS NOT NULL
  DROP TABLE #actuals; 
----------Initial View---------------
select IR_Campaign_Data_Weekly_MAIN_2012_Sbset.Parentid, idFlight_Plan_Records_FK, [Report_Year], [Report_Week], IR_Campaign_Data_Weekly_MAIN_2012_Sbset.[Calendar_Year]
		, IR_Campaign_Data_Weekly_MAIN_2012_Sbset.[Calendar_Month], [Start_Date], [End_Date_Traditional], IR_Campaign_Data_Weekly_MAIN_2012_Sbset.[Campaign_Name], [eCRW_Project_Name]
	    , [media_code], [Toll_Free_Numbers] , [URL_List] , [CTD_Quantity], [ITP_Quantity], [ITP_Quantity_Unapp] ,[CTD_Budget], [ITP_Budget]
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
			UNION
			Select a.eCRW_Project_Name, b.parentID, a.Date, a.[Online Sales]*b.Cell_Percent as Daily_Sales from 
				(Select * from bvt_processed.DTV_Now_Sales_by_day
				where eCRW_Cell_ID is null) a
				JOIN  (Select * from bvt_prod.DTV_Now_Sales_App_VW
				where Cell_percent <> 1) b
				on a.eCRW_Project_Name = b.eCRW_Project_Name
				where a.eCRW_Cell_ID is null) a
				JOIN dim.Media_Calendar_Daily b
				on a.Date = b.Date
			GROUP BY parentID, ISO_Week, ISO_Week_Year, MONTH(a.Date), YEAR(a.Date)) DTV_Now
			ON IR_Campaign_Data_Weekly_MAIN_2012_Sbset.Parentid = DTV_Now.parentID
				and IR_Campaign_Data_Weekly_MAIN_2012_Sbset.Report_Week = DTV_Now.ISO_Week
				and IR_Campaign_Data_Weekly_MAIN_2012_Sbset.Calendar_Month = DTV_Now.Calendar_Month
				and IR_Campaign_Data_Weekly_MAIN_2012_Sbset.Report_Year = DTV_Now.ISO_Week_Year
						
		where ExcludefromScorecard = 'N';

create index IDX_NC_actuals_idflightplan_strtdt ON #actuals([idFlight_Plan_Records_FK], [start_date]);
----------End Initial View--------------------------
---------------Volume and Budget-------------------
IF OBJECT_ID('tempdb.dbo.#volumebudget', 'U') IS NOT NULL
  DROP TABLE #volumebudget; 
--
select [idFlight_Plan_Records_FK], [Campaign_Name], [iso_week_year] as Media_Year
	, [mediamonth] as Media_Month, [iso_week] as Media_Week
	,YEAR([Start_Date]) as Calendar_Year
	,MONTH([Start_Date]) as Calendar_Month
	,[inhome_date], [Touch_Name], [Program_Name], [Tactic], [Media], 
	[Campaign_Type], [Audience], [Creative_Name], [Goal], [Offer], [Channel], [Scorecard_Group], [Scorecard_Program_Channel],
	[KPI_TYPE], [Product_Code], Actual
into #volumebudget
from 
	(select [idFlight_Plan_Records_FK], [Start_Date]
	, case when kpiproduct='CTD_Quantity' then 'Volume'
		when kpiproduct='CTD_Budget' then 'Budget'
		end as KPI_type
	, case when kpiproduct='CTD_Quantity' then 'Volume'
		when kpiproduct='CTD_Budget' then 'Budget'
		end as Product_Code
	, sum(Actuals.[Actual]) as Actual
	from (select [idFlight_Plan_Records_FK], [Start_Date], [CTD_Quantity], [CTD_Budget]
			from #actuals 
			group by [idFlight_Plan_Records_FK], [Start_Date], [CTD_Quantity], [CTD_Budget]) as actual_query

	UNPIVOT (Actual for kpiproduct in 
			([CTD_Quantity], [CTD_Budget])) as Actuals
	GROUP BY idFlight_Plan_Records_FK, Start_Date
	, case when kpiproduct='CTD_Quantity' then 'Volume'
		when kpiproduct='CTD_Budget' then 'Budget'
		end 
	, case when kpiproduct='CTD_Quantity' then 'Volume'
		when kpiproduct='CTD_Budget' then 'Budget'
		end) as pivotmetrics
	inner join dim.media_calendar_daily on [Start_Date] = [date]
	inner join #flightplan on [idFlight_Plan_Records_FK] = [idFlight_Plan_Records]
	inner join #touchdef on [idProgram_Touch_Definitions_TBL] = [idProgram_Touch_Definitions_TBL_FK]
create index IDX_NC_VOLUMEBUDGET
 ON #volumebudget([idFlight_Plan_Records_FK], [Calendar_Year], [Calendar_Month]
  , [media_year] ,[Media_Week] ,[kpi_type] ,[product_code]);
---------End Volume Budget-----------------------------
---------Response and Sales Actuals--------------------
IF OBJECT_ID('tempdb.dbo.#ResponseSales', 'U') IS NOT NULL
  DROP TABLE #ResponseSales; 
--
select [idFlight_Plan_Records_FK], [Media_Year], [Media_Week],  [MediaMonth] as Media_Month,
	[inhome_date], [Touch_Name], [Program_Name], [Tactic], [Media], [Campaign_Name],
	[Campaign_Type], [Audience], [Creative_Name], [Goal], [Offer], [Channel],
	[Scorecard_Group], [Scorecard_Program_Channel], [Calendar_Year], [Calendar_Month],
	[KPI_TYPE], [Product_Code], Actual
into #ResponseSales
from
	(select [idFlight_Plan_Records_FK], [Report_Year] as Media_Year, [Report_Week] as Media_Week,  [Calendar_Year], [Calendar_Month]
	, case 
		when kpiproduct='ITP_Dir_Calls' then 'Response'
		when kpiproduct='ITP_Dir_Clicks' then 'Response'
		when kpiproduct like '%Sales_TS%' then 'Telesales'
		when kpiproduct like '%Sales_ON%' then 'Online_sales'
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
		end as Product_Code
, sum(Actuals.[Actual]) as Actual

from #actuals

UNPIVOT (Actual for kpiproduct in 
			([ITP_Dir_Calls], [ITP_Dir_Clicks], 
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
	end 
	) as actuals 
	inner join #flightplan on [idFlight_Plan_Records_FK] = [idFlight_Plan_Records]
	inner join #touchdef on [idProgram_Touch_Definitions_TBL] = [idProgram_Touch_Definitions_TBL_FK]
	inner join (Select distinct [ISO_week], [ISO_Week_Year], [MediaMonth] from DIM.Media_Calendar_Daily) d
on [Media_week] = d.[ISO_Week] and [Media_Year] = d.[ISO_Week_Year];

create index IDX_NC_ResponseSales
 ON #ResponseSales([idFlight_Plan_Records_FK], [Calendar_Year], [Calendar_Month]
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
IF OBJECT_ID('tempdb.dbo.#bestview', 'U') IS NOT NULL
  DROP TABLE #bestview; 


select
coalesce(forecast_cv.[idFlight_Plan_Records_FK], #volumebudget.[idFlight_Plan_Records_FK], #ResponseSales.[idFlight_Plan_Records_FK]) as idFlight_Plan_Records_FK,
		coalesce(forecast_cv.[Campaign_Name], #volumebudget.[Campaign_Name], #ResponseSales.[Campaign_Name]) as Campaign_Name,
		coalesce(forecast_cv.[InHome_Date], #volumebudget.[InHome_Date], #ResponseSales.[InHome_Date]) as InHome_Date,
		coalesce(forecast_cv.[Media_Year], #volumebudget.[Media_Year], #ResponseSales.[Media_Year]) as Media_Year,
		coalesce(forecast_cv.[Media_Week], #volumebudget.[Media_Week], #ResponseSales.[Media_Week]) as Media_Week,
		coalesce(forecast_cv.[Media_Month], #volumebudget.[Media_Month], #ResponseSales.Media_Month) as Media_Month,
		coalesce(forecast_cv.[Calendar_Year], #volumebudget.[Calendar_Year], #ResponseSales.[Calendar_Year]) as Calendar_Year,
		coalesce(forecast_cv.[Calendar_Month], #volumebudget.[Calendar_Month], #ResponseSales.[Calendar_Month]) as Calendar_Month,
		coalesce(forecast_cv.[Touch_Name], #volumebudget.[Touch_Name], #ResponseSales.[Touch_Name]) as Touch_Name, 
		coalesce(forecast_cv.[Program_Name], #volumebudget.[Program_Name], #ResponseSales.[Program_Name]) as Program_Name, 
		coalesce(forecast_cv.[Tactic], #volumebudget.[Tactic], #ResponseSales.[Tactic]) as Tactic, 
		coalesce(forecast_cv.[Media], #volumebudget.[Media], #ResponseSales.[Media]) as Media,
		coalesce(forecast_cv.[Campaign_Type], #volumebudget.[Campaign_Type], #ResponseSales.[Campaign_Type]) as Campaign_Type,
		coalesce(forecast_cv.[Audience], #volumebudget.[Audience], #ResponseSales.[Audience]) as Audience,
		coalesce(forecast_cv.[Creative_Name], #volumebudget.[Creative_Name], #ResponseSales.[Creative_Name]) as Creative_Name,
		coalesce(forecast_cv.[Goal], #volumebudget.[Goal],#ResponseSales.[Goal]) as Goal,
		coalesce(forecast_cv.[Offer], #volumebudget.[Offer], #ResponseSales.[Offer]) as Offer,
		coalesce(forecast_cv.[Channel], #volumebudget.[Channel], #ResponseSales.[Channel]) as Channel,
		coalesce(forecast_cv.[Scorecard_Group], #volumebudget.[Scorecard_Group], #ResponseSales.[Scorecard_Group]) as Scorecard_Group,
		coalesce(forecast_cv.[Scorecard_Program_Channel], #volumebudget.[Scorecard_Program_Channel], #ResponseSales.[Scorecard_Program_Channel]) as Scorecard_Program_Channel,
		coalesce(forecast_cv.[KPI_Type], #volumebudget.[KPI_Type], #ResponseSales.[KPI_Type]) as KPI_Type,
		coalesce(forecast_cv.[Product_Code], #volumebudget.[Product_Code],  #ResponseSales.[Product_Code]) as Product_Code
		,strategy_eligibility
		,lead_offer
		,isnull([Forecast],0) as Forecast
		,isnull([Commitment],0) as Commitment
		,isnull(coalesce(#volumebudget.[Actual], #ResponseSales.[Actual]),0) as Actual
-- complex case statement to determine if you should be using forecast or actuals for the best view

--First are these telesales or other metrics as telesales require a lagging
		,case when coalesce(forecast_cv.[KPI_Type], #volumebudget.[KPI_Type], #ResponseSales.[KPI_Type]) = 'Telesales'
		--IS the forecast YYYYWW two weeks less than the current report week available 
			then (case when forecast_cv.[media_YYYYWW] <= (case when DATEPART(weekday,getdate()) <= 5 
						then (select [ISO_Week_YYYYWW] from dim.media_calendar_daily where [date] = cast(dateadd(wk,-4,getdate()) as date)) 
						else (select [ISO_Week_YYYYWW] from dim.media_calendar_daily where [date] = cast(dateadd(wk,-3,getdate()) as date)) end)
					then #ResponseSales.[Actual]
					when forecast_cv.[media_YYYYWW] is null then #ResponseSales.[Actual]
					else isnull([Forecast],0)
					end)
----END OF TELESALES LAG CONCERNS
--Non telesale report through current available week
		when forecast_cv.[media_YYYYWW] <= (case when DATEPART(weekday,getdate()) <= 5 
						then (select [ISO_Week_YYYYWW] from dim.media_calendar_daily where [date] = cast(dateadd(wk,-2,getdate()) as date)) 
						else (select [ISO_Week_YYYYWW] from dim.media_calendar_daily where [date] = cast(dateadd(wk,-1,getdate()) as date)) end)
			then coalesce(#volumebudget.[Actual], #ResponseSales.[Actual])

		when forecast_cv.[media_YYYYWW] is null then coalesce(#volumebudget.[Actual], #ResponseSales.[Actual])
		else isnull([Forecast],0)

		end as Best_View
----END OF COMPLEX Best View case statement-------------------------------------------------------------
into #bestview	
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
	  ,strategy_eligibility
	  ,lead_offer
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
	left join
	bvt_prod.Strategy_Eligibility_LU_TBL strat
	on #flightplan.Strategy_Eligibility_LU_TBL_FK = strat.idStrategy_Eligibility_LU_TBL
	left join
	bvt_prod.Lead_Offer_LU_TBL lead
	on #flightplan.Lead_Offer_LU_TBL_FK = lead.idLead_Offer_LU_TBL
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
	  ,strategy_eligibility
	  ,lead_offer
	  ) as forecast_cv

FULL JOIN #volumebudget
	on forecast_cv.[idFlight_Plan_Records_FK] = #volumebudget.[idFlight_plan_records_FK] 
	 and forecast_cv.[media_year] = #volumebudget.[media_year]
	 and forecast_cv.[media_week] = #volumebudget.[media_week] 
	 and forecast_cv.[KPI_Type] = #volumebudget.[KPI_Type]
	 and forecast_cv.[Product_Code] = #volumebudget.[Product_Code]
	 and forecast_cv.[Calendar_Year] = #volumebudget.[Calendar_Year]
	and forecast_cv.[Calendar_Month] = #volumebudget.[Calendar_Month]
FULL JOIN #ResponseSales
	on forecast_cv.[idFlight_Plan_Records_FK] = #ResponseSales.[idFlight_Plan_Records_FK] 
	 and forecast_cv.[media_year] = #ResponseSales.[media_year]
	 and forecast_cv.[media_week] = #ResponseSales.[media_week]
	 and forecast_cv.[KPI_Type] =#ResponseSales.[KPI_Type]
	 and forecast_cv.[Product_Code] = #ResponseSales.[product_code]
	 and forecast_cv.[Calendar_Year] = #ResponseSales.[Calendar_Year]
	 and forecast_cv.[Calendar_Month] = #ResponseSales.[Calendar_Month];
------------END OF BLENDING BEST VIEW!-----------------------------------


-----------Pivot the Data Into Analyst Familiar Format-------------------
Select
	[idFlight_Plan_Records_FK], [Campaign_Name], [InHome_Date], [Strategy_Eligibility], [Lead_Offer], [Media_Year], [Media_Week], [Media_Month], [Touch_Name]
	, [Program_Name], [Tactic], [Media], [Campaign_Type], [Audience], [Creative_Name], [Goal], [Offer], [Channel], [Scorecard_Group], [Scorecard_Program_Channel]
	, CONVERT(VARCHAR(6),InHome_Date,112) AS Start_Month, M_Schedule, [Calendar_Year], [Calendar_Month],
sum(isnull([Call_CV], 0)) as [Call_CV], 
sum(isnull([Online_CV], 0)) as [Online_CV], 
sum(isnull([Online_sales_Access Line_CV], 0)) as [Online_sales_Access Line_CV], 
sum(isnull([Online_sales_DSL_CV], 0)) as [Online_sales_DSL_CV], 
sum(isnull([Online_sales_DSL Direct_CV], 0)) as [Online_sales_DSL Direct_CV], 
sum(isnull([Online_sales_HSIA_CV], 0)) as [Online_sales_HSIA_CV],
sum(isnull([Online_sales_Fiber_CV], 0)) as [Online_sales_Fiber_CV], 
sum(isnull([Online_sales_IPDSL_CV], 0)) as [Online_sales_IPDSL_CV], 
sum(isnull([Online_sales_DirecTV_CV], 0)) as [Online_sales_DirecTV_CV], 
sum(isnull([Online_sales_UVTV_CV], 0)) as [Online_sales_UVTV_CV], 
sum(isnull([Online_sales_VoIP_CV], 0)) as [Online_sales_VoIP_CV], 
sum(isnull([Online_sales_WRLS Data_CV], 0)) as [Online_sales_WRLS Data_CV], 
sum(isnull([Online_sales_WRLS Family_CV], 0)) as [Online_sales_WRLS Family_CV], 
sum(isnull([Online_sales_WRLS Voice_CV], 0)) as [Online_sales_WRLS Voice_CV],
sum(isnull([Online_sales_WRLS Home_CV], 0)) as [Online_sales_WRLS Home_CV], 
sum(isnull([Online_sales_Digital Life_CV], 0)) as [Online_sales_Digital Life_CV], 
sum(isnull([Telesales_Access Line_CV], 0)) as [Telesales_Access Line_CV], 
sum(isnull([Telesales_DSL_CV], 0)) as [Telesales_DSL_CV], 
sum(isnull([Telesales_DSL Direct_CV], 0)) as [Telesales_DSL Direct_CV], 
sum(isnull([Telesales_HSIA_CV], 0)) as [Telesales_HSIA_CV], 
sum(isnull([Telesales_Fiber_CV], 0)) as [Telesales_Fiber_CV], 
sum(isnull([Telesales_IPDSL_CV], 0)) as [Telesales_IPDSL_CV], 
sum(isnull([Telesales_DirecTV_CV], 0)) as [Telesales_DirecTV_CV], 
sum(isnull([Telesales_UVTV_CV], 0)) as [Telesales_UVTV_CV], 
sum(isnull([Telesales_VoIP_CV], 0)) as [Telesales_VoIP_CV], 
sum(isnull([Telesales_WRLS Data_CV], 0)) as [Telesales_WRLS Data_CV], 
sum(isnull([Telesales_WRLS Family_CV], 0)) as [Telesales_WRLS Family_CV], 
sum(isnull([Telesales_WRLS Voice_CV], 0)) as [Telesales_WRLS Voice_CV],
sum(isnull([Telesales_WRLS Home_CV], 0)) as [Telesales_WRLS Home_CV], 
sum(isnull([Telesales_Digital Life_CV], 0)) as [Telesales_Digital Life_CV],
sum(isnull([Volume_CV],0)) as [Volume_CV],
sum(isnull([Call_FV], 0)) as [Call_FV], 
sum(isnull([Online_FV], 0)) as [Online_FV], 
sum(isnull([Online_sales_Access Line_FV], 0)) as [Online_sales_Access Line_FV], 
sum(isnull([Online_sales_DSL_FV], 0)) as [Online_sales_DSL_FV], 
sum(isnull([Online_sales_DSL Direct_FV], 0)) as [Online_sales_DSL Direct_FV], 
sum(isnull([Online_sales_HSIA_FV], 0)) as [Online_sales_HSIA_FV],
sum(isnull([Online_sales_Fiber_FV], 0)) as [Online_sales_Fiber_FV], 
sum(isnull([Online_sales_IPDSL_FV], 0)) as [Online_sales_IPDSL_FV], 
sum(isnull([Online_sales_DirecTV_FV], 0)) as [Online_sales_DirecTV_FV], 
sum(isnull([Online_sales_UVTV_FV], 0)) as [Online_sales_UVTV_FV], 
sum(isnull([Online_sales_VoIP_FV], 0)) as [Online_sales_VoIP_FV], 
sum(isnull([Online_sales_WRLS Data_FV], 0)) as [Online_sales_WRLS Data_FV], 
sum(isnull([Online_sales_WRLS Family_FV], 0)) as [Online_sales_WRLS Family_FV], 
sum(isnull([Online_sales_WRLS Voice_FV], 0)) as [Online_sales_WRLS Voice_FV],
sum(isnull([Online_sales_WRLS Home_FV], 0)) as [Online_sales_WRLS Home_FV], 
sum(isnull([Online_sales_Digital Life_FV], 0)) as [Online_sales_Digital Life_FV],
sum(isnull([Telesales_Access Line_FV], 0)) as [Telesales_Access Line_FV], 
sum(isnull([Telesales_DSL_FV], 0)) as [Telesales_DSL_FV], 
sum(isnull([Telesales_DSL Direct_FV], 0)) as [Telesales_DSL Direct_FV], 
sum(isnull([Telesales_HSIA_FV], 0)) as [Telesales_HSIA_FV], 
sum(isnull([Telesales_Fiber_FV], 0)) as [Telesales_Fiber_FV],
sum(isnull([Telesales_IPDSL_FV], 0)) as [Telesales_IPDSL_FV], 
sum(isnull([Telesales_DirecTV_FV], 0)) as [Telesales_DirecTV_FV], 
sum(isnull([Telesales_UVTV_FV], 0)) as [Telesales_UVTV_FV], 
sum(isnull([Telesales_VoIP_FV], 0)) as [Telesales_VoIP_FV], 
sum(isnull([Telesales_WRLS Data_FV], 0)) as [Telesales_WRLS Data_FV], 
sum(isnull([Telesales_WRLS Family_FV], 0)) as [Telesales_WRLS Family_FV], 
sum(isnull([Telesales_WRLS Voice_FV], 0)) as [Telesales_WRLS Voice_FV],
sum(isnull([Telesales_WRLS Home_FV], 0)) as [Telesales_WRLS Home_FV], 
sum(isnull([Telesales_Digital Life_FV], 0)) as [Telesales_Digital Life_FV],
sum(isnull([Volume_FV],0)) as [Volume_FV],
sum(isnull([Call_AV], 0)) as [Call_AV], 
sum(isnull([Online_AV], 0)) as [Online_AV], 
sum(isnull([Online_sales_Access Line_AV], 0)) as [Online_sales_Access Line_AV], 
sum(isnull([Online_sales_DSL_AV], 0)) as [Online_sales_DSL_AV], 
sum(isnull([Online_sales_DSL Direct_AV], 0)) as [Online_sales_DSL Direct_AV], 
sum(isnull([Online_sales_HSIA_AV], 0)) as [Online_sales_HSIA_AV], 
sum(isnull([Online_sales_Fiber_AV], 0)) as [Online_sales_Fiber_AV], 
sum(isnull([Online_sales_IPDSL_AV], 0)) as [Online_sales_IPDSL_AV], 
sum(isnull([Online_sales_DirecTV_AV], 0)) as [Online_sales_DirecTV_AV], 
sum(isnull([Online_sales_UVTV_AV], 0)) as [Online_sales_UVTV_AV], 
sum(isnull([Online_sales_VoIP_AV], 0)) as [Online_sales_VoIP_AV], 
sum(isnull([Online_sales_WRLS Data_AV], 0)) as [Online_sales_WRLS Data_AV], 
sum(isnull([Online_sales_WRLS Family_AV], 0)) as [Online_sales_WRLS Family_AV], 
sum(isnull([Online_sales_WRLS Voice_AV], 0)) as [Online_sales_WRLS Voice_AV],
sum(isnull([Online_sales_WRLS Home_AV], 0)) as [Online_sales_WRLS Home_AV], 
sum(isnull([Online_sales_Digital Life_AV], 0)) as [Online_sales_Digital Life_AV],
sum(isnull([Online_Sales_DTV Now_AV],0)) as [Online_sales_DTV Now_AV],
sum(isnull([Telesales_Access Line_AV], 0)) as [Telesales_Access Line_AV], 
sum(isnull([Telesales_DSL_AV], 0)) as [Telesales_DSL_AV], 
sum(isnull([Telesales_DSL Direct_AV], 0)) as [Telesales_DSL Direct_AV], 
sum(isnull([Telesales_HSIA_AV], 0)) as [Telesales_HSIA_AV], 
sum(isnull([Telesales_Fiber_AV], 0)) as [Telesales_Fiber_AV], 
sum(isnull([Telesales_IPDSL_AV], 0)) as [Telesales_IPDSL_AV], 
sum(isnull([Telesales_DirecTV_AV], 0)) as [Telesales_DirecTV_AV], 
sum(isnull([Telesales_UVTV_AV], 0)) as [Telesales_UVTV_AV], 
sum(isnull([Telesales_VoIP_AV], 0)) as [Telesales_VoIP_AV], 
sum(isnull([Telesales_WRLS Data_AV], 0)) as [Telesales_WRLS Data_AV], 
sum(isnull([Telesales_WRLS Family_AV], 0)) as [Telesales_WRLS Family_AV], 
sum(isnull([Telesales_WRLS Voice_AV], 0)) as [Telesales_WRLS Voice_AV], 
sum(isnull([Telesales_WRLS Home_AV], 0)) as [Telesales_WRLS Home_AV], 
sum(isnull([Telesales_Digital Life_AV], 0)) as [Telesales_Digital Life_AV], 
sum(isnull([Volume_AV],0)) as [Volume_AV],
sum(isnull([Call_BV], 0)) as [Call_BV], 
sum(isnull([Online_BV], 0)) as [Online_BV], 
sum(isnull([Online_sales_Access Line_BV], 0)) as [Online_sales_Access Line_BV], 
sum(isnull([Online_sales_DSL_BV], 0)) as [Online_sales_DSL_BV], 
sum(isnull([Online_sales_DSL Direct_BV], 0)) as [Online_sales_DSL Direct_BV], 
sum(isnull([Online_sales_HSIA_BV], 0)) as [Online_sales_HSIA_BV], 
sum(isnull([Online_sales_Fiber_BV], 0)) as [Online_sales_Fiber_BV], 
sum(isnull([Online_sales_IPDSL_BV], 0)) as [Online_sales_IPDSL_BV], 
sum(isnull([Online_sales_DirecTV_BV], 0)) as [Online_sales_DirecTV_BV], 
sum(isnull([Online_sales_UVTV_BV], 0)) as [Online_sales_UVTV_BV], 
sum(isnull([Online_sales_VoIP_BV], 0)) as [Online_sales_VoIP_BV], 
sum(isnull([Online_sales_WRLS Data_BV], 0)) as [Online_sales_WRLS Data_BV], 
sum(isnull([Online_sales_WRLS Family_BV], 0)) as [Online_sales_WRLS Family_BV], 
sum(isnull([Online_sales_WRLS Voice_BV], 0)) as [Online_sales_WRLS Voice_BV], 
sum(isnull([Online_sales_WRLS Home_BV], 0)) as [Online_sales_WRLS Home_BV], 
sum(isnull([Online_sales_Digital Life_BV], 0)) as [Online_sales_Digital Life_BV], 
sum(isnull([Telesales_Access Line_BV], 0)) as [Telesales_Access Line_BV], 
sum(isnull([Telesales_DSL_BV], 0)) as [Telesales_DSL_BV], 
sum(isnull([Telesales_DSL Direct_BV], 0)) as [Telesales_DSL Direct_BV], 
sum(isnull([Telesales_HSIA_BV], 0)) as [Telesales_HSIA_BV], 
sum(isnull([Telesales_Fiber_BV], 0)) as [Telesales_Fiber_BV], 
sum(isnull([Telesales_IPDSL_BV], 0)) as [Telesales_IPDSL_BV], 
sum(isnull([Telesales_DirecTV_BV], 0)) as [Telesales_DirecTV_BV], 
sum(isnull([Telesales_UVTV_BV], 0)) as [Telesales_UVTV_BV], 
sum(isnull([Telesales_VoIP_BV], 0)) as [Telesales_VoIP_BV], 
sum(isnull([Telesales_WRLS Data_BV], 0)) as [Telesales_WRLS Data_BV], 
sum(isnull([Telesales_WRLS Family_BV], 0)) as [Telesales_WRLS Family_BV], 
sum(isnull([Telesales_WRLS Voice_BV], 0)) as [Telesales_WRLS Voice_BV], 
sum(isnull([Telesales_WRLS Home_BV], 0)) as [Telesales_WRLS Home_BV], 
sum(isnull([Telesales_Digital Life_BV], 0)) as [Telesales_Digital Life_BV], 
sum(isnull([Volume_BV], 0)) as [Volume_BV],
sum(isnull([Online_sales_Access Line_CV], 0))+ sum(isnull([Online_sales_DSL_CV], 0))+ sum(isnull([Online_sales_DSL Direct_CV], 0))+ sum(isnull([Online_sales_HSIA_CV], 0))+ sum(isnull([Online_sales_Fiber_CV], 0))+ sum(isnull([Online_sales_IPDSL_CV], 0))+ sum(isnull([Online_sales_DirecTV_CV], 0))+ sum(isnull([Online_sales_UVTV_CV], 0))+ sum(isnull([Online_sales_VoIP_CV], 0))+ sum(isnull([Online_sales_WRLS Data_CV], 0))+ sum(isnull([Online_sales_WRLS Family_CV], 0))+ sum(isnull([Online_sales_WRLS Voice_CV], 0))+ sum(isnull([Online_sales_WRLS Home_CV], 0))+ sum(isnull([Online_sales_Digital Life_CV], 0)) as Online_Total_CV,
sum(isnull([Online_sales_Access Line_BV], 0))+ sum(isnull([Online_sales_DSL_BV], 0))+ sum(isnull([Online_sales_DSL Direct_BV], 0))+ sum(isnull([Online_sales_HSIA_BV], 0))+ sum(isnull([Online_sales_Fiber_BV], 0))+ sum(isnull([Online_sales_IPDSL_BV], 0))+ sum(isnull([Online_sales_DirecTV_BV], 0))+ sum(isnull([Online_sales_UVTV_BV], 0))+ sum(isnull([Online_sales_VoIP_BV], 0))+ sum(isnull([Online_sales_WRLS Data_BV], 0))+ sum(isnull([Online_sales_WRLS Family_BV], 0))+ sum(isnull([Online_sales_WRLS Voice_BV], 0))+ sum(isnull([Online_sales_WRLS Home_BV], 0))+ sum(isnull([Online_sales_Digital Life_BV], 0)) as Online_Total_BV,
sum(isnull([Online_sales_Access Line_FV], 0))+ sum(isnull([Online_sales_DSL_FV], 0))+ sum(isnull([Online_sales_DSL Direct_FV], 0))+ sum(isnull([Online_sales_HSIA_FV], 0))+ sum(isnull([Online_sales_Fiber_FV], 0))+ sum(isnull([Online_sales_IPDSL_FV], 0))+ sum(isnull([Online_sales_DirecTV_FV], 0))+ sum(isnull([Online_sales_UVTV_FV], 0))+ sum(isnull([Online_sales_VoIP_FV], 0))+ sum(isnull([Online_sales_WRLS Data_FV], 0))+ sum(isnull([Online_sales_WRLS Family_FV], 0))+ sum(isnull([Online_sales_WRLS Voice_FV], 0))+ sum(isnull([Online_sales_WRLS Home_FV], 0))+ sum(isnull([Online_sales_Digital Life_FV], 0)) as Online_Total_FV,
sum(isnull([Online_sales_Access Line_AV], 0))+ sum(isnull([Online_sales_DSL_AV], 0))+ sum(isnull([Online_sales_DSL Direct_AV], 0))+ sum(isnull([Online_sales_HSIA_AV], 0))+ sum(isnull([Online_sales_Fiber_AV], 0))+ sum(isnull([Online_sales_IPDSL_AV], 0))+ sum(isnull([Online_sales_DirecTV_AV], 0))+ sum(isnull([Online_sales_UVTV_AV], 0))+ sum(isnull([Online_sales_VoIP_AV], 0))+ sum(isnull([Online_sales_WRLS Data_AV], 0))+ sum(isnull([Online_sales_WRLS Family_AV], 0))+ sum(isnull([Online_sales_WRLS Voice_AV], 0))+ sum(isnull([Online_sales_WRLS Home_AV], 0))+ sum(isnull([Online_sales_Digital Life_BV], 0))+ sum(isnull([Online_Sales_DTV Now_AV],0)) as Online_Total_AV,
sum(isnull([Telesales_Access Line_CV], 0))+ sum(isnull([Telesales_DSL_CV], 0))+ sum(isnull([Telesales_DSL Direct_CV], 0))+ sum(isnull([Telesales_HSIA_CV], 0))+ sum(isnull([Telesales_Fiber_CV], 0))+ sum(isnull([Telesales_IPDSL_CV], 0))+ sum(isnull([Telesales_DirecTV_CV], 0))+ sum(isnull([Telesales_UVTV_CV], 0))+ sum(isnull([Telesales_VoIP_CV], 0))+ sum(isnull([Telesales_WRLS Data_CV], 0))+ sum(isnull([Telesales_WRLS Family_CV], 0))+ sum(isnull([Telesales_WRLS Voice_CV], 0))+ sum(isnull([Telesales_WRLS Home_CV], 0))+ sum(isnull([Telesales_Digital Life_CV], 0)) as Telesales_Total_CV,
sum(isnull([Telesales_Access Line_BV], 0))+ sum(isnull([Telesales_DSL_BV], 0))+ sum(isnull([Telesales_DSL Direct_BV], 0))+ sum(isnull([Telesales_HSIA_BV], 0))+ sum(isnull([Telesales_Fiber_BV], 0))+ sum(isnull([Telesales_IPDSL_BV], 0))+ sum(isnull([Telesales_DirecTV_BV], 0))+ sum(isnull([Telesales_UVTV_BV], 0))+ sum(isnull([Telesales_VoIP_BV], 0))+ sum(isnull([Telesales_WRLS Data_BV], 0))+ sum(isnull([Telesales_WRLS Family_BV], 0))+ sum(isnull([Telesales_WRLS Voice_BV], 0))+ sum(isnull([Telesales_WRLS Home_BV], 0))+ sum(isnull([Telesales_Digital Life_BV], 0)) as Telesales_Total_BV,
sum(isnull([Telesales_Access Line_FV], 0))+ sum(isnull([Telesales_DSL_FV], 0))+ sum(isnull([Telesales_DSL Direct_FV], 0))+ sum(isnull([Telesales_HSIA_FV], 0))+ sum(isnull([Telesales_Fiber_FV], 0))+ sum(isnull([Telesales_IPDSL_FV], 0))+ sum(isnull([Telesales_DirecTV_FV], 0))+ sum(isnull([Telesales_UVTV_FV], 0))+ sum(isnull([Telesales_VoIP_FV], 0))+ sum(isnull([Telesales_WRLS Data_FV], 0))+ sum(isnull([Telesales_WRLS Family_FV], 0))+ sum(isnull([Telesales_WRLS Voice_FV], 0))+ sum(isnull([Telesales_WRLS Home_FV], 0))+ sum(isnull([Telesales_Digital Life_FV], 0)) as Telesales_Total_FV,
sum(isnull([Telesales_Access Line_AV], 0))+ sum(isnull([Telesales_DSL_AV], 0))+ sum(isnull([Telesales_DSL Direct_AV], 0))+ sum(isnull([Telesales_HSIA_AV], 0))+ sum(isnull([Telesales_Fiber_AV], 0))+ sum(isnull([Telesales_IPDSL_AV], 0))+ sum(isnull([Telesales_DirecTV_AV], 0))+ sum(isnull([Telesales_UVTV_AV], 0))+ sum(isnull([Telesales_VoIP_AV], 0))+ sum(isnull([Telesales_WRLS Data_AV], 0))+ sum(isnull([Telesales_WRLS Family_AV], 0))+ sum(isnull([Telesales_WRLS Voice_AV], 0))+ sum(isnull([Telesales_WRLS Home_AV], 0))+ sum(isnull([Telesales_Digital Life_AV], 0)) as Telesales_Total_AV,
sum(isnull([Online_sales_HSIA_CV], 0))+ sum(isnull([Online_sales_Fiber_CV], 0))+ sum(isnull([Online_sales_IPDSL_CV], 0))+ sum(isnull([Online_sales_DirecTV_CV], 0))+ sum(isnull([Online_sales_UVTV_CV], 0))+ sum(isnull([Online_sales_VoIP_CV], 0))+ sum(isnull([Online_sales_WRLS Data_CV], 0))+ sum(isnull([Online_sales_WRLS Family_CV], 0))+ sum(isnull([Online_sales_WRLS Voice_CV], 0)) as Online_SC_Strat_CV,
sum(isnull([Online_sales_HSIA_BV], 0))+ sum(isnull([Online_sales_Fiber_BV], 0))+ sum(isnull([Online_sales_IPDSL_BV], 0))+ sum(isnull([Online_sales_DirecTV_BV], 0))+ sum(isnull([Online_sales_UVTV_BV], 0))+ sum(isnull([Online_sales_VoIP_BV], 0))+ sum(isnull([Online_sales_WRLS Data_BV], 0))+ sum(isnull([Online_sales_WRLS Family_BV], 0))+ sum(isnull([Online_sales_WRLS Voice_BV], 0)) as Online_SC_Strat_BV,
sum(isnull([Online_sales_HSIA_FV], 0))+ sum(isnull([Online_sales_Fiber_FV], 0))+ sum(isnull([Online_sales_IPDSL_FV], 0))+ sum(isnull([Online_sales_DirecTV_FV], 0))+ sum(isnull([Online_sales_UVTV_FV], 0))+ sum(isnull([Online_sales_VoIP_FV], 0))+ sum(isnull([Online_sales_WRLS Data_FV], 0))+ sum(isnull([Online_sales_WRLS Family_FV], 0))+ sum(isnull([Online_sales_WRLS Voice_FV], 0)) as Online_SC_Strat_FV,
sum(isnull([Online_sales_HSIA_AV], 0))+ sum(isnull([Online_sales_Fiber_AV], 0))+ sum(isnull([Online_sales_IPDSL_AV], 0))+ sum(isnull([Online_sales_DirecTV_AV], 0))+ sum(isnull([Online_sales_UVTV_AV], 0))+ sum(isnull([Online_sales_VoIP_AV], 0))+ sum(isnull([Online_sales_WRLS Data_AV], 0))+ sum(isnull([Online_sales_WRLS Family_AV], 0))+ sum(isnull([Online_sales_WRLS Voice_AV], 0)) as Online_SC_Strat_AV,
sum(isnull([Telesales_HSIA_CV], 0))+ sum(isnull([Telesales_Fiber_CV], 0))+ sum(isnull([Telesales_IPDSL_CV], 0))+ sum(isnull([Telesales_DirecTV_CV], 0))+ sum(isnull([Telesales_UVTV_CV], 0))+ sum(isnull([Telesales_VoIP_CV], 0))+ sum(isnull([Telesales_WRLS Data_CV], 0))+ sum(isnull([Telesales_WRLS Family_CV], 0))+ sum(isnull([Telesales_WRLS Voice_CV], 0)) as Telesales_SC_Strat_CV,
sum(isnull([Telesales_HSIA_BV], 0))+ sum(isnull([Telesales_Fiber_BV], 0))+ sum(isnull([Telesales_IPDSL_BV], 0))+ sum(isnull([Telesales_DirecTV_BV], 0))+ sum(isnull([Telesales_UVTV_BV], 0))+ sum(isnull([Telesales_VoIP_BV], 0))+ sum(isnull([Telesales_WRLS Data_BV], 0))+ sum(isnull([Telesales_WRLS Family_BV], 0))+ sum(isnull([Telesales_WRLS Voice_BV], 0)) as Telesales_SC_Strat_BV,
sum(isnull([Telesales_HSIA_FV], 0))+ sum(isnull([Telesales_Fiber_FV], 0))+ sum(isnull([Telesales_IPDSL_FV], 0))+ sum(isnull([Telesales_DirecTV_FV], 0))+ sum(isnull([Telesales_UVTV_FV], 0))+ sum(isnull([Telesales_VoIP_FV], 0))+ sum(isnull([Telesales_WRLS Data_FV], 0))+ sum(isnull([Telesales_WRLS Family_FV], 0))+ sum(isnull([Telesales_WRLS Voice_FV], 0)) as Telesales_SC_Strat_FV,
sum(isnull([Telesales_HSIA_AV], 0))+ sum(isnull([Telesales_Fiber_AV], 0))+ sum(isnull([Telesales_IPDSL_AV], 0))+ sum(isnull([Telesales_DirecTV_AV], 0))+ sum(isnull([Telesales_UVTV_AV], 0))+ sum(isnull([Telesales_VoIP_AV], 0))+ sum(isnull([Telesales_WRLS Data_AV], 0))+ sum(isnull([Telesales_WRLS Family_AV], 0))+ sum(isnull([Telesales_WRLS Voice_AV], 0)) as Telesales_SC_Strat_AV,

------------------------------BEGINS EDITS---------------------------------------------------------------
--Total Sales
sum(isnull([Online_sales_Access Line_CV], 0))+ sum(isnull([Online_sales_DSL_CV], 0))+ sum(isnull([Online_sales_DSL Direct_CV], 0))+ sum(isnull([Online_sales_HSIA_CV], 0))+ sum(isnull([Online_sales_Fiber_CV], 0))+ sum(isnull([Online_sales_IPDSL_CV], 0))+ sum(isnull([Online_sales_DirecTV_CV], 0))+ sum(isnull([Online_sales_UVTV_CV], 0))+ sum(isnull([Online_sales_VoIP_CV], 0))+ sum(isnull([Online_sales_WRLS Data_CV], 0))+ sum(isnull([Online_sales_WRLS Family_CV], 0))+ sum(isnull([Online_sales_WRLS Voice_CV], 0))+ sum(isnull([Online_sales_WRLS Home_CV], 0))+ sum(isnull([Online_sales_Digital Life_CV], 0))+
sum(isnull([Telesales_Access Line_CV], 0))+ sum(isnull([Telesales_DSL_CV], 0))+ sum(isnull([Telesales_DSL Direct_CV], 0))+ sum(isnull([Telesales_HSIA_CV], 0))+ sum(isnull([Telesales_Fiber_CV], 0))+ sum(isnull([Telesales_IPDSL_CV], 0))+ sum(isnull([Telesales_DirecTV_CV], 0))+ sum(isnull([Telesales_UVTV_CV], 0))+ sum(isnull([Telesales_VoIP_CV], 0))+ sum(isnull([Telesales_WRLS Data_CV], 0))+ sum(isnull([Telesales_WRLS Family_CV], 0))+ sum(isnull([Telesales_WRLS Voice_CV], 0))+ sum(isnull([Telesales_WRLS Home_CV], 0))+ sum(isnull([Telesales_Digital Life_CV], 0)) as Total_Sales_CV,

sum(isnull([Online_sales_Access Line_BV], 0))+ sum(isnull([Online_sales_DSL_BV], 0))+ sum(isnull([Online_sales_DSL Direct_BV], 0))+ sum(isnull([Online_sales_HSIA_BV], 0))+ sum(isnull([Online_sales_Fiber_BV], 0))+ sum(isnull([Online_sales_IPDSL_BV], 0))+ sum(isnull([Online_sales_DirecTV_BV], 0))+ sum(isnull([Online_sales_UVTV_BV], 0))+ sum(isnull([Online_sales_VoIP_BV], 0))+ sum(isnull([Online_sales_WRLS Data_BV], 0))+ sum(isnull([Online_sales_WRLS Family_BV], 0))+ sum(isnull([Online_sales_WRLS Voice_BV], 0))+ sum(isnull([Online_sales_WRLS Home_BV], 0))+ sum(isnull([Online_sales_Digital Life_BV], 0))+
sum(isnull([Telesales_Access Line_BV], 0))+ sum(isnull([Telesales_DSL_BV], 0))+ sum(isnull([Telesales_DSL Direct_BV], 0))+ sum(isnull([Telesales_HSIA_BV], 0))+ sum(isnull([Telesales_Fiber_BV], 0))+ sum(isnull([Telesales_IPDSL_BV], 0))+ sum(isnull([Telesales_DirecTV_BV], 0))+ sum(isnull([Telesales_UVTV_BV], 0))+ sum(isnull([Telesales_VoIP_BV], 0))+ sum(isnull([Telesales_WRLS Data_BV], 0))+ sum(isnull([Telesales_WRLS Family_BV], 0))+ sum(isnull([Telesales_WRLS Voice_BV], 0))+ sum(isnull([Telesales_WRLS Home_BV], 0))+ sum(isnull([Telesales_Digital Life_BV], 0)) as Total_Sales_BV,

sum(isnull([Online_sales_Access Line_FV], 0))+ sum(isnull([Online_sales_DSL_FV], 0))+ sum(isnull([Online_sales_DSL Direct_FV], 0))+ sum(isnull([Online_sales_HSIA_FV], 0))+ sum(isnull([Online_sales_Fiber_FV], 0))+ sum(isnull([Online_sales_IPDSL_FV], 0))+ sum(isnull([Online_sales_DirecTV_FV], 0))+ sum(isnull([Online_sales_UVTV_FV], 0))+ sum(isnull([Online_sales_VoIP_FV], 0))+ sum(isnull([Online_sales_WRLS Data_FV], 0))+ sum(isnull([Online_sales_WRLS Family_FV], 0))+ sum(isnull([Online_sales_WRLS Voice_FV], 0))+ sum(isnull([Online_sales_WRLS Home_FV], 0))+ sum(isnull([Online_sales_Digital Life_FV], 0))+
sum(isnull([Telesales_Access Line_FV], 0))+ sum(isnull([Telesales_DSL_FV], 0))+ sum(isnull([Telesales_DSL Direct_FV], 0))+ sum(isnull([Telesales_HSIA_FV], 0))+ sum(isnull([Telesales_Fiber_FV], 0))+ sum(isnull([Telesales_IPDSL_FV], 0))+ sum(isnull([Telesales_DirecTV_FV], 0))+ sum(isnull([Telesales_UVTV_FV], 0))+ sum(isnull([Telesales_VoIP_FV], 0))+ sum(isnull([Telesales_WRLS Data_FV], 0))+ sum(isnull([Telesales_WRLS Family_FV], 0))+ sum(isnull([Telesales_WRLS Voice_FV], 0))+ sum(isnull([Telesales_WRLS Home_FV], 0))+ sum(isnull([Telesales_Digital Life_FV], 0)) as Total_Sales_FV,

sum(isnull([Online_sales_Access Line_AV], 0))+ sum(isnull([Online_sales_DSL_AV], 0))+ sum(isnull([Online_sales_DSL Direct_AV], 0))+ sum(isnull([Online_sales_HSIA_AV], 0))+ sum(isnull([Online_sales_Fiber_AV], 0))+ sum(isnull([Online_sales_IPDSL_AV], 0))+ sum(isnull([Online_sales_DirecTV_AV], 0))+ sum(isnull([Online_sales_UVTV_AV], 0))+ sum(isnull([Online_sales_VoIP_AV], 0))+ sum(isnull([Online_sales_WRLS Data_AV], 0))+ sum(isnull([Online_sales_WRLS Family_AV], 0))+ sum(isnull([Online_sales_WRLS Voice_AV], 0))+ sum(isnull([Online_sales_WRLS Home_AV], 0))+ sum(isnull([Online_sales_Digital Life_AV], 0))+
sum(isnull([Telesales_Access Line_AV], 0))+ sum(isnull([Telesales_DSL_AV], 0))+ sum(isnull([Telesales_DSL Direct_AV], 0))+ sum(isnull([Telesales_HSIA_AV], 0))+ sum(isnull([Telesales_Fiber_AV], 0))+ sum(isnull([Telesales_IPDSL_AV], 0))+ sum(isnull([Telesales_DirecTV_AV], 0))+ sum(isnull([Telesales_UVTV_AV], 0))+ sum(isnull([Telesales_VoIP_AV], 0))+ sum(isnull([Telesales_WRLS Data_AV], 0))+ sum(isnull([Telesales_WRLS Family_AV], 0))+ sum(isnull([Telesales_WRLS Voice_AV], 0))+ sum(isnull([Telesales_WRLS Home_AV], 0))+ sum(isnull([Telesales_Digital Life_AV], 0))+ sum(isnull([Online_Sales_DTV Now_AV],0)) as Total_Sales_AV,

sum(isnull([Online_sales_HSIA_CV], 0))+ sum(isnull([Online_sales_Fiber_CV], 0))+ sum(isnull([Online_sales_IPDSL_CV], 0))+ sum(isnull([Online_sales_DirecTV_CV], 0))+ sum(isnull([Online_sales_UVTV_CV], 0))+ sum(isnull([Online_sales_VoIP_CV], 0))+ sum(isnull([Online_sales_WRLS Data_CV], 0))+ sum(isnull([Online_sales_WRLS Family_CV], 0))+ sum(isnull([Online_sales_WRLS Voice_CV], 0))+
sum(isnull([Telesales_HSIA_CV], 0))+ sum(isnull([Telesales_Fiber_CV], 0))+ sum(isnull([Telesales_IPDSL_CV], 0))+ sum(isnull([Telesales_DirecTV_CV], 0))+ sum(isnull([Telesales_UVTV_CV], 0))+ sum(isnull([Telesales_VoIP_CV], 0))+ sum(isnull([Telesales_WRLS Data_CV], 0))+ sum(isnull([Telesales_WRLS Family_CV], 0))+ sum(isnull([Telesales_WRLS Voice_CV], 0)) as Total_SC_Strat_Sales_CV,

sum(isnull([Online_sales_HSIA_BV], 0))+ sum(isnull([Online_sales_Fiber_BV], 0))+ sum(isnull([Online_sales_IPDSL_BV], 0))+ sum(isnull([Online_sales_DirecTV_BV], 0))+ sum(isnull([Online_sales_UVTV_BV], 0))+ sum(isnull([Online_sales_VoIP_BV], 0))+ sum(isnull([Online_sales_WRLS Data_BV], 0))+ sum(isnull([Online_sales_WRLS Family_BV], 0))+ sum(isnull([Online_sales_WRLS Voice_BV], 0))+
sum(isnull([Telesales_HSIA_BV], 0))+ sum(isnull([Telesales_Fiber_BV], 0))+ sum(isnull([Telesales_IPDSL_BV], 0))+ sum(isnull([Telesales_DirecTV_BV], 0))+ sum(isnull([Telesales_UVTV_BV], 0))+ sum(isnull([Telesales_VoIP_BV], 0))+ sum(isnull([Telesales_WRLS Data_BV], 0))+ sum(isnull([Telesales_WRLS Family_BV], 0))+ sum(isnull([Telesales_WRLS Voice_BV], 0)) as Total_SC_Strat_Sales_BV,

sum(isnull([Online_sales_HSIA_FV], 0))+ sum(isnull([Online_sales_Fiber_FV], 0))+ sum(isnull([Online_sales_IPDSL_FV], 0))+ sum(isnull([Online_sales_DirecTV_FV], 0))+ sum(isnull([Online_sales_UVTV_FV], 0))+ sum(isnull([Online_sales_VoIP_FV], 0))+ sum(isnull([Online_sales_WRLS Data_FV], 0))+ sum(isnull([Online_sales_WRLS Family_FV], 0))+ sum(isnull([Online_sales_WRLS Voice_FV], 0))+
sum(isnull([Telesales_HSIA_FV], 0))+ sum(isnull([Telesales_Fiber_FV], 0))+ sum(isnull([Telesales_IPDSL_FV], 0))+ sum(isnull([Telesales_DirecTV_FV], 0))+ sum(isnull([Telesales_UVTV_FV], 0))+ sum(isnull([Telesales_VoIP_FV], 0))+ sum(isnull([Telesales_WRLS Data_FV], 0))+ sum(isnull([Telesales_WRLS Family_FV], 0))+ sum(isnull([Telesales_WRLS Voice_FV], 0)) as Total_SC_Strat_Sales_FV,

sum(isnull([Online_sales_HSIA_AV], 0))+ sum(isnull([Online_sales_Fiber_AV], 0))+ sum(isnull([Online_sales_IPDSL_AV], 0))+ sum(isnull([Online_sales_DirecTV_AV], 0))+ sum(isnull([Online_sales_UVTV_AV], 0))+ sum(isnull([Online_sales_VoIP_AV], 0))+ sum(isnull([Online_sales_WRLS Data_AV], 0))+ sum(isnull([Online_sales_WRLS Family_AV], 0))+ sum(isnull([Online_sales_WRLS Voice_AV], 0))+
sum(isnull([Telesales_HSIA_AV], 0))+ sum(isnull([Telesales_Fiber_AV], 0))+ sum(isnull([Telesales_IPDSL_AV], 0))+ sum(isnull([Telesales_DirecTV_AV], 0))+ sum(isnull([Telesales_UVTV_AV], 0))+ sum(isnull([Telesales_VoIP_AV], 0))+ sum(isnull([Telesales_WRLS Data_AV], 0))+ sum(isnull([Telesales_WRLS Family_AV], 0))+ sum(isnull([Telesales_WRLS Voice_AV], 0)) as Total_SC_Strat_Sales_AV,

--Total Sales by Product (AV)
SUM(ISNULL([Telesales_Access Line_AV], 0))+ SUM(ISNULL([Online_Sales_Access Line_AV], 0)) AS Total_Sales_Access_Line_AV,
SUM(ISNULL([Telesales_DSL_AV], 0))+ SUM(ISNULL([Online_Sales_DSL_AV], 0)) AS Total_Sales_DSL_AV,
SUM(ISNULL([Telesales_DSL Direct_AV], 0))+ SUM(ISNULL([Online_Sales_DSL Direct_AV], 0)) AS Total_Sales_DSL_Direct_AV,
SUM(ISNULL([Telesales_HSIA_AV], 0))+ SUM(ISNULL([Online_Sales_HSIA_AV], 0)) AS Total_Sales_HSIA_AV,
SUM(ISNULL([Telesales_Fiber_AV], 0))+ SUM(ISNULL([Online_Sales_Fiber_AV], 0)) AS Total_Sales_Fiber_AV,
SUM(ISNULL([Telesales_IPDSL_AV], 0))+ SUM(ISNULL([Online_Sales_IPDSL_AV], 0)) AS Total_Sales_IPDSL_AV,
SUM(ISNULL([Telesales_DirecTV_AV], 0))+ SUM(ISNULL([Online_Sales_DirecTV_AV], 0)) AS Total_Sales_DirecTV_AV,
SUM(ISNULL([Telesales_UVTV_AV], 0))+ SUM(ISNULL([Online_Sales_UVTV_AV], 0)) AS Total_Sales_UVTV_AV,
SUM(ISNULL([Telesales_VoIP_AV], 0))+ SUM(ISNULL([Online_Sales_VoIP_AV], 0)) AS Total_Sales_VoIP_AV,
SUM(ISNULL([Telesales_WRLS Data_AV], 0))+ SUM(ISNULL([Online_Sales_WRLS Data_AV], 0)) AS Total_Sales_WRLS_Data_AV,
SUM(ISNULL([Telesales_WRLS Family_AV], 0))+ SUM(ISNULL([Online_Sales_WRLS Family_AV], 0)) AS Total_Sales_WRLS_Family_AV,
SUM(ISNULL([Telesales_WRLS Voice_AV], 0))+ SUM(ISNULL([Online_Sales_WRLS Voice_AV], 0)) AS Total_Sales_WRLS_Voice_AV,
SUM(ISNULL([Telesales_WRLS Home_AV], 0))+ SUM(ISNULL([Online_Sales_WRLS Home_AV], 0)) AS Total_Sales_WRLS_Home_AV,
SUM(ISNULL([Telesales_Digital Life_AV], 0))+ SUM(ISNULL([Online_Sales_Digital Life_AV], 0)) AS Total_Sales_Digital_Life_AV,

--Total Sales by Product (BV)
SUM(ISNULL([Telesales_Access Line_BV], 0))+ SUM(ISNULL([Online_Sales_Access Line_BV], 0)) AS Total_Sales_Access_Line_BV,
SUM(ISNULL([Telesales_DSL_BV], 0))+ SUM(ISNULL([Online_Sales_DSL_BV], 0)) AS Total_Sales_DSL_BV,
SUM(ISNULL([Telesales_DSL Direct_BV], 0))+ SUM(ISNULL([Online_Sales_DSL Direct_BV], 0)) AS Total_Sales_DSL_Direct_BV,
SUM(ISNULL([Telesales_HSIA_BV], 0))+ SUM(ISNULL([Online_Sales_HSIA_BV], 0)) AS Total_Sales_HSIA_BV,
SUM(ISNULL([Telesales_Fiber_BV], 0))+ SUM(ISNULL([Online_Sales_Fiber_BV], 0)) AS Total_Sales_Fiber_BV,
SUM(ISNULL([Telesales_IPDSL_BV], 0))+ SUM(ISNULL([Online_Sales_IPDSL_BV], 0)) AS Total_Sales_IPDSL_BV,
SUM(ISNULL([Telesales_DirecTV_BV], 0))+ SUM(ISNULL([Online_Sales_DirecTV_BV], 0)) AS Total_Sales_DirecTV_BV,
SUM(ISNULL([Telesales_UVTV_BV], 0))+ SUM(ISNULL([Online_Sales_UVTV_BV], 0)) AS Total_Sales_UVTV_BV,
SUM(ISNULL([Telesales_VoIP_BV], 0))+ SUM(ISNULL([Online_Sales_VoIP_BV], 0)) AS Total_Sales_VoIP_BV,
SUM(ISNULL([Telesales_WRLS Data_BV], 0))+ SUM(ISNULL([Online_Sales_WRLS Data_BV], 0)) AS Total_Sales_WRLS_Data_BV,
SUM(ISNULL([Telesales_WRLS Family_BV], 0))+ SUM(ISNULL([Online_Sales_WRLS Family_BV], 0)) AS Total_Sales_WRLS_Family_BV,
SUM(ISNULL([Telesales_WRLS Voice_BV], 0))+ SUM(ISNULL([Online_Sales_WRLS Voice_BV], 0)) AS Total_Sales_WRLS_Voice_BV,
SUM(ISNULL([Telesales_WRLS Home_BV], 0))+ SUM(ISNULL([Online_Sales_WRLS Home_BV], 0)) AS Total_Sales_WRLS_Home_BV,
SUM(ISNULL([Telesales_Digital Life_BV], 0))+ SUM(ISNULL([Online_Sales_Digital Life_BV], 0)) AS Total_Sales_Digital_Life_BV,

--Total Sales by Product (CV)
SUM(ISNULL([Telesales_Access Line_CV], 0))+ SUM(ISNULL([Online_Sales_Access Line_CV], 0)) AS Total_Sales_Access_Line_CV,
SUM(ISNULL([Telesales_DSL_CV], 0))+ SUM(ISNULL([Online_Sales_DSL_CV], 0)) AS Total_Sales_DSL_CV,
SUM(ISNULL([Telesales_DSL Direct_CV], 0))+ SUM(ISNULL([Online_Sales_DSL Direct_CV], 0)) AS Total_Sales_DSL_Direct_CV,
SUM(ISNULL([Telesales_HSIA_CV], 0))+ SUM(ISNULL([Online_Sales_HSIA_CV], 0)) AS Total_Sales_HSIA_CV,
SUM(ISNULL([Telesales_Fiber_CV], 0))+ SUM(ISNULL([Online_Sales_Fiber_CV], 0)) AS Total_Sales_Fiber_CV,
SUM(ISNULL([Telesales_IPDSL_CV], 0))+ SUM(ISNULL([Online_Sales_IPDSL_CV], 0)) AS Total_Sales_IPDSL_CV,
SUM(ISNULL([Telesales_DirecTV_CV], 0))+ SUM(ISNULL([Online_Sales_DirecTV_CV], 0)) AS Total_Sales_DirecTV_CV,
SUM(ISNULL([Telesales_UVTV_CV], 0))+ SUM(ISNULL([Online_Sales_UVTV_CV], 0)) AS Total_Sales_UVTV_CV,
SUM(ISNULL([Telesales_VoIP_CV], 0))+ SUM(ISNULL([Online_Sales_VoIP_CV], 0)) AS Total_Sales_VoIP_CV,
SUM(ISNULL([Telesales_WRLS Data_CV], 0))+ SUM(ISNULL([Online_Sales_WRLS Data_CV], 0)) AS Total_Sales_WRLS_Data_CV,
SUM(ISNULL([Telesales_WRLS Family_CV], 0))+ SUM(ISNULL([Online_Sales_WRLS Family_CV], 0)) AS Total_Sales_WRLS_Family_CV,
SUM(ISNULL([Telesales_WRLS Voice_CV], 0))+ SUM(ISNULL([Online_Sales_WRLS Voice_CV], 0)) AS Total_Sales_WRLS_Voice_CV,
SUM(ISNULL([Telesales_WRLS Home_CV], 0))+ SUM(ISNULL([Online_Sales_WRLS Home_CV], 0)) AS Total_Sales_WRLS_Home_CV,
SUM(ISNULL([Telesales_Digital Life_CV], 0))+ SUM(ISNULL([Online_Sales_Digital Life_CV], 0)) AS Total_Sales_Digital_Life_CV,

--Total Sales by Product (FV)
SUM(ISNULL([Telesales_Access Line_FV], 0))+ SUM(ISNULL([Online_Sales_Access Line_FV], 0)) AS Total_Sales_Access_Line_FV,
SUM(ISNULL([Telesales_DSL_FV], 0))+ SUM(ISNULL([Online_Sales_DSL_FV], 0)) AS Total_Sales_DSL_FV,
SUM(ISNULL([Telesales_DSL Direct_FV], 0))+ SUM(ISNULL([Online_Sales_DSL Direct_FV], 0)) AS Total_Sales_DSL_Direct_FV,
SUM(ISNULL([Telesales_HSIA_FV], 0))+ SUM(ISNULL([Online_Sales_HSIA_FV], 0)) AS Total_Sales_HSIA_FV,
SUM(ISNULL([Telesales_Fiber_FV], 0))+ SUM(ISNULL([Online_Sales_Fiber_FV], 0)) AS Total_Sales_Fiber_FV,
SUM(ISNULL([Telesales_IPDSL_FV], 0))+ SUM(ISNULL([Online_Sales_IPDSL_FV], 0)) AS Total_Sales_IPDSL_FV,
SUM(ISNULL([Telesales_DirecTV_FV], 0))+ SUM(ISNULL([Online_Sales_DirecTV_FV], 0)) AS Total_Sales_DirecTV_FV,
SUM(ISNULL([Telesales_UVTV_FV], 0))+ SUM(ISNULL([Online_Sales_UVTV_FV], 0)) AS Total_Sales_UVTV_FV,
SUM(ISNULL([Telesales_VoIP_FV], 0))+ SUM(ISNULL([Online_Sales_VoIP_FV], 0)) AS Total_Sales_VoIP_FV,
SUM(ISNULL([Telesales_WRLS Data_FV], 0))+ SUM(ISNULL([Online_Sales_WRLS Data_FV], 0)) AS Total_Sales_WRLS_Data_FV,
SUM(ISNULL([Telesales_WRLS Family_FV], 0))+ SUM(ISNULL([Online_Sales_WRLS Family_FV], 0)) AS Total_Sales_WRLS_Family_FV,
SUM(ISNULL([Telesales_WRLS Voice_FV], 0))+ SUM(ISNULL([Online_Sales_WRLS Voice_FV], 0)) AS Total_Sales_WRLS_Voice_FV,
SUM(ISNULL([Telesales_WRLS Home_FV], 0))+ SUM(ISNULL([Online_Sales_WRLS Home_FV], 0)) AS Total_Sales_WRLS_Home_FV,
SUM(ISNULL([Telesales_Digital Life_FV], 0))+ SUM(ISNULL([Online_Sales_Digital Life_FV], 0)) AS Total_Sales_Digital_Life_FV,



--TV Sales
SUM(ISNULL([Telesales_DirecTV_AV],0))+SUM(ISNULL([Telesales_UVTV_AV],0)) AS Telesales_Comb_TV_AV,
SUM(ISNULL([Online_Sales_DirecTV_AV],0))+SUM(ISNULL([Online_Sales_UVTV_AV],0)) AS Online_Sales_Comb_TV_AV,
SUM(ISNULL([Telesales_DirecTV_AV],0))+SUM(ISNULL([Telesales_UVTV_AV],0))+SUM(ISNULL([Online_Sales_DirecTV_AV],0))+SUM(ISNULL([Online_Sales_UVTV_AV],0)) AS Total_Sales_Comb_TV_AV,
SUM(ISNULL([Telesales_DirecTV_BV],0))+SUM(ISNULL([Telesales_UVTV_BV],0)) AS Telesales_Comb_TV_BV,
SUM(ISNULL([Online_Sales_DirecTV_BV],0))+SUM(ISNULL([Online_Sales_UVTV_BV],0)) AS Online_Sales_Comb_TV_BV,
SUM(ISNULL([Telesales_DirecTV_BV],0))+SUM(ISNULL([Telesales_UVTV_BV],0))+SUM(ISNULL([Online_Sales_DirecTV_BV],0))+SUM(ISNULL([Online_Sales_UVTV_BV],0)) AS Total_Sales_Comb_TV_BV,    
SUM(ISNULL([Telesales_DirecTV_CV],0))+SUM(ISNULL([Telesales_UVTV_CV],0)) AS Telesales_Comb_TV_CV,
SUM(ISNULL([Online_Sales_DirecTV_CV],0))+SUM(ISNULL([Online_Sales_UVTV_CV],0)) AS Online_Sales_Comb_TV_CV,
SUM(ISNULL([Telesales_DirecTV_CV],0))+SUM(ISNULL([Telesales_UVTV_CV],0))+SUM(ISNULL([Online_Sales_DirecTV_CV],0))+SUM(ISNULL([Online_Sales_UVTV_CV],0)) AS Total_Sales_Comb_TV_CV,
SUM(ISNULL([Telesales_DirecTV_FV],0))+SUM(ISNULL([Telesales_UVTV_FV],0)) AS Telesales_Comb_TV_FV,
SUM(ISNULL([Online_Sales_DirecTV_FV],0))+SUM(ISNULL([Online_Sales_UVTV_FV],0)) AS Online_Sales_Comb_TV_FV,
SUM(ISNULL([Telesales_DirecTV_FV],0))+SUM(ISNULL([Telesales_UVTV_FV],0))+SUM(ISNULL([Online_Sales_DirecTV_FV],0))+SUM(ISNULL([Online_Sales_UVTV_FV],0)) AS Total_Sales_Comb_TV_FV,

--BB Sales
SUM(ISNULL([Telesales_Fiber_AV],0))+SUM(ISNULL([Telesales_IPDSL_AV],0))+SUM(ISNULL([Telesales_HSIA_AV],0)) AS Telesales_Comb_BB_AV,
SUM(ISNULL([Online_Sales_Fiber_AV],0))+SUM(ISNULL([Online_Sales_IPDSL_AV],0))+SUM(ISNULL([Online_Sales_HSIA_AV],0)) AS Online_Sales_Comb_BB_AV,
SUM(ISNULL([Telesales_Fiber_AV],0))+SUM(ISNULL([Telesales_IPDSL_AV],0))+SUM(ISNULL([Telesales_HSIA_AV],0))+SUM(ISNULL([Online_Sales_Fiber_AV],0))+SUM(ISNULL([Online_Sales_IPDSL_AV],0))+SUM(ISNULL([Online_Sales_HSIA_AV],0)) AS Total_Sales_Comb_BB_AV,
SUM(ISNULL([Telesales_Fiber_BV],0))+SUM(ISNULL([Telesales_IPDSL_BV],0))+SUM(ISNULL([Telesales_HSIA_BV],0)) AS Telesales_Comb_BB_BV,
SUM(ISNULL([Online_Sales_Fiber_BV],0))+SUM(ISNULL([Online_Sales_IPDSL_BV],0))+SUM(ISNULL([Online_Sales_HSIA_BV],0)) AS Online_Sales_Comb_BB_BV,
SUM(ISNULL([Telesales_Fiber_BV],0))+SUM(ISNULL([Telesales_IPDSL_BV],0))+SUM(ISNULL([Telesales_HSIA_BV],0))+SUM(ISNULL([Online_Sales_Fiber_BV],0))+SUM(ISNULL([Online_Sales_IPDSL_BV],0))+SUM(ISNULL([Online_Sales_HSIA_BV],0)) AS Total_Sales_Comb_BB_BV,
SUM(ISNULL([Telesales_Fiber_CV],0))+SUM(ISNULL([Telesales_IPDSL_CV],0))+SUM(ISNULL([Telesales_HSIA_CV],0)) AS Telesales_Comb_BB_CV,
SUM(ISNULL([Online_Sales_Fiber_CV],0))+SUM(ISNULL([Online_Sales_IPDSL_CV],0))+SUM(ISNULL([Online_Sales_HSIA_CV],0)) AS Online_Sales_Comb_BB_CV,
SUM(ISNULL([Telesales_Fiber_CV],0))+SUM(ISNULL([Telesales_IPDSL_CV],0))+SUM(ISNULL([Telesales_HSIA_CV],0))+SUM(ISNULL([Online_Sales_Fiber_CV],0))+SUM(ISNULL([Online_Sales_IPDSL_CV],0))+SUM(ISNULL([Online_Sales_HSIA_CV],0)) AS Total_Sales_Comb_BB_CV,
SUM(ISNULL([Telesales_Fiber_FV],0))+SUM(ISNULL([Telesales_IPDSL_FV],0))+SUM(ISNULL([Telesales_HSIA_FV],0)) AS Telesales_Comb_BB_FV,
SUM(ISNULL([Online_Sales_Fiber_FV],0))+SUM(ISNULL([Online_Sales_IPDSL_FV],0))+SUM(ISNULL([Online_Sales_HSIA_FV],0)) AS Online_Sales_Comb_BB_FV,
SUM(ISNULL([Telesales_Fiber_FV],0))+SUM(ISNULL([Telesales_IPDSL_FV],0))+SUM(ISNULL([Telesales_HSIA_FV],0))+SUM(ISNULL([Online_Sales_Fiber_FV],0))+SUM(ISNULL([Online_Sales_IPDSL_FV],0))+SUM(ISNULL([Online_Sales_HSIA_FV],0)) AS Total_Sales_Comb_BB_FV,

--WRLS Sales
SUM(ISNULL([Telesales_WRLS Voice_AV],0))+SUM(ISNULL([Telesales_WRLS Data_AV],0))+SUM(ISNULL([Telesales_WRLS Family_AV],0)) AS Telesales_Comb_WRLS_AV,
SUM(ISNULL([Online_Sales_WRLS Voice_AV],0))+SUM(ISNULL([Online_Sales_WRLS Data_AV],0))+SUM(ISNULL([Online_Sales_WRLS Family_AV],0)) AS Online_Sales_Comb_WRLS_AV,
SUM(ISNULL([Telesales_WRLS Voice_AV],0))+SUM(ISNULL([Telesales_WRLS Data_AV],0))+SUM(ISNULL([Telesales_WRLS Family_AV],0))+SUM(ISNULL([Online_Sales_WRLS Voice_AV],0))+SUM(ISNULL([Online_Sales_WRLS Data_AV],0))+SUM(ISNULL([Online_Sales_WRLS Family_AV],0)) AS Total_Sales_Comb_WRLS_AV,
SUM(ISNULL([Telesales_WRLS Voice_BV],0))+SUM(ISNULL([Telesales_WRLS Data_BV],0))+SUM(ISNULL([Telesales_WRLS Family_BV],0)) AS Telesales_Comb_WRLS_BV,
SUM(ISNULL([Online_Sales_WRLS Voice_BV],0))+SUM(ISNULL([Online_Sales_WRLS Data_BV],0))+SUM(ISNULL([Online_Sales_WRLS Family_BV],0)) AS Online_Sales_Comb_WRLS_BV,
SUM(ISNULL([Telesales_WRLS Voice_BV],0))+SUM(ISNULL([Telesales_WRLS Data_BV],0))+SUM(ISNULL([Telesales_WRLS Family_BV],0))+SUM(ISNULL([Online_Sales_WRLS Voice_BV],0))+SUM(ISNULL([Online_Sales_WRLS Data_BV],0))+SUM(ISNULL([Online_Sales_WRLS Family_BV],0)) AS Total_Sales_Comb_WRLS_BV,
SUM(ISNULL([Telesales_WRLS Voice_CV],0))+SUM(ISNULL([Telesales_WRLS Data_CV],0))+SUM(ISNULL([Telesales_WRLS Family_CV],0)) AS Telesales_Comb_WRLS_CV,
SUM(ISNULL([Online_Sales_WRLS Voice_CV],0))+SUM(ISNULL([Online_Sales_WRLS Data_CV],0))+SUM(ISNULL([Online_Sales_WRLS Family_CV],0)) AS Online_Sales_Comb_WRLS_CV,
SUM(ISNULL([Telesales_WRLS Voice_CV],0))+SUM(ISNULL([Telesales_WRLS Data_CV],0))+SUM(ISNULL([Telesales_WRLS Family_CV],0))+SUM(ISNULL([Online_Sales_WRLS Voice_CV],0))+SUM(ISNULL([Online_Sales_WRLS Data_CV],0))+SUM(ISNULL([Online_Sales_WRLS Family_CV],0)) AS Total_Sales_Comb_WRLS_CV,
SUM(ISNULL([Telesales_WRLS Voice_FV],0))+SUM(ISNULL([Telesales_WRLS Data_FV],0))+SUM(ISNULL([Telesales_WRLS Family_FV],0)) AS Telesales_Comb_WRLS_FV,
SUM(ISNULL([Online_Sales_WRLS Voice_FV],0))+SUM(ISNULL([Online_Sales_WRLS Data_FV],0))+SUM(ISNULL([Online_Sales_WRLS Family_FV],0)) AS Online_Sales_Comb_WRLS_FV,
SUM(ISNULL([Telesales_WRLS Voice_FV],0))+SUM(ISNULL([Telesales_WRLS Data_FV],0))+SUM(ISNULL([Telesales_WRLS Family_FV],0))+SUM(ISNULL([Online_Sales_WRLS Voice_FV],0))+SUM(ISNULL([Online_Sales_WRLS Data_FV],0))+SUM(ISNULL([Online_Sales_WRLS Family_FV],0)) AS Total_Sales_Comb_WRLS_FV,

--Voice Sales
SUM(ISNULL([Telesales_VoIP_AV],0))+SUM(ISNULL([Telesales_Access Line_AV],0)) AS Telesales_Comb_Voice_AV,
SUM(ISNULL([Online_Sales_VoIP_AV],0))+SUM(ISNULL([Online_Sales_Access Line_AV],0)) AS Online_Sales_Comb_Voice_AV,
SUM(ISNULL([Telesales_VoIP_AV],0))+SUM(ISNULL([Telesales_Access Line_AV],0))+SUM(ISNULL([Online_Sales_VoIP_AV],0))+SUM(ISNULL([Online_Sales_Access Line_AV],0)) AS Total_Sales_Comb_Voice_AV,
SUM(ISNULL([Telesales_VoIP_BV],0))+SUM(ISNULL([Telesales_Access Line_BV],0)) AS Telesales_Comb_Voice_BV,
SUM(ISNULL([Online_Sales_VoIP_BV],0))+SUM(ISNULL([Online_Sales_Access Line_BV],0)) AS Online_Sales_Comb_Voice_BV,
SUM(ISNULL([Telesales_VoIP_BV],0))+SUM(ISNULL([Telesales_Access Line_BV],0))+SUM(ISNULL([Online_Sales_VoIP_BV],0))+SUM(ISNULL([Online_Sales_Access Line_BV],0)) AS Total_Sales_Comb_Voice_BV,      
SUM(ISNULL([Telesales_VoIP_CV],0))+SUM(ISNULL([Telesales_Access Line_CV],0)) AS Telesales_Comb_Voice_CV,
SUM(ISNULL([Online_Sales_VoIP_CV],0))+SUM(ISNULL([Online_Sales_Access Line_CV],0)) AS Online_Sales_Comb_Voice_CV,
SUM(ISNULL([Telesales_VoIP_CV],0))+SUM(ISNULL([Telesales_Access Line_CV],0))+SUM(ISNULL([Online_Sales_VoIP_CV],0))+SUM(ISNULL([Online_Sales_Access Line_CV],0)) AS Total_Sales_Comb_Voice_CV,
SUM(ISNULL([Telesales_VoIP_FV],0))+SUM(ISNULL([Telesales_Access Line_FV],0)) AS Telesales_Comb_Voice_FV,
SUM(ISNULL([Online_Sales_VoIP_FV],0))+SUM(ISNULL([Online_Sales_Access Line_FV],0)) AS Online_Sales_Comb_Voice_FV,
SUM(ISNULL([Telesales_VoIP_FV],0))+SUM(ISNULL([Telesales_Access Line_FV],0))+SUM(ISNULL([Online_Sales_VoIP_FV],0))+SUM(ISNULL([Online_Sales_Access Line_FV],0)) AS Total_Sales_Comb_Voice_FV,

--DSL Sales
SUM(ISNULL([Telesales_DSL_AV],0))+SUM(ISNULL([Telesales_DSL Direct_AV],0)) AS Telesales_Comb_DSL_AV,
SUM(ISNULL([Online_Sales_DSL_AV],0))+SUM(ISNULL([Online_Sales_DSL Direct_AV],0)) AS Online_Sales_Comb_DSL_AV,
SUM(ISNULL([Telesales_DSL_AV],0))+SUM(ISNULL([Telesales_DSL Direct_AV],0))+SUM(ISNULL([Online_Sales_DSL_AV],0))+SUM(ISNULL([Online_Sales_DSL Direct_AV],0)) AS Total_Sales_Comb_DSL_AV,
SUM(ISNULL([Telesales_DSL_BV],0))+SUM(ISNULL([Telesales_DSL Direct_BV],0)) AS Telesales_Comb_DSL_BV,
SUM(ISNULL([Online_Sales_DSL_BV],0))+SUM(ISNULL([Online_Sales_DSL Direct_BV],0)) AS Online_Sales_Comb_DSL_BV,
SUM(ISNULL([Telesales_DSL_BV],0))+SUM(ISNULL([Telesales_DSL Direct_BV],0))+SUM(ISNULL([Online_Sales_DSL_BV],0))+SUM(ISNULL([Online_Sales_DSL Direct_BV],0)) AS Total_Sales_Comb_DSL_BV,      
SUM(ISNULL([Telesales_DSL_CV],0))+SUM(ISNULL([Telesales_DSL Direct_CV],0)) AS Telesales_Comb_DSL_CV,
SUM(ISNULL([Online_Sales_DSL_CV],0))+SUM(ISNULL([Online_Sales_DSL Direct_CV],0)) AS Online_Sales_Comb_DSL_CV,
SUM(ISNULL([Telesales_DSL_CV],0))+SUM(ISNULL([Telesales_DSL Direct_CV],0))+SUM(ISNULL([Online_Sales_DSL_CV],0))+SUM(ISNULL([Online_Sales_DSL Direct_CV],0)) AS Total_Sales_Comb_DSL_CV,
SUM(ISNULL([Telesales_DSL_FV],0))+SUM(ISNULL([Telesales_DSL Direct_FV],0)) AS Telesales_Comb_DSL_FV,
SUM(ISNULL([Online_Sales_DSL_FV],0))+SUM(ISNULL([Online_Sales_DSL Direct_FV],0)) AS Online_Sales_Comb_DSL_FV,
SUM(ISNULL([Telesales_DSL_FV],0))+SUM(ISNULL([Telesales_DSL Direct_FV],0))+SUM(ISNULL([Online_Sales_DSL_FV],0))+SUM(ISNULL([Online_Sales_DSL Direct_FV],0)) AS Total_Sales_Comb_DSL_FV,

--Other Sales
SUM(ISNULL([Telesales_Access Line_AV],0))+SUM(ISNULL([Telesales_DSL_AV],0))+SUM(ISNULL([Telesales_DSL Direct_AV],0))+SUM(ISNULL([Telesales_Digital Life_AV],0)) AS Telesales_Comb_Other_AV,
SUM(ISNULL([Online_sales_Access Line_AV],0))+SUM(ISNULL([Online_sales_DSL_AV],0))+SUM(ISNULL([Online_sales_DSL Direct_AV],0))+SUM(ISNULL([Online_sales_Digital Life_AV],0)) AS Online_Sales_Comb_Other_AV,
SUM(ISNULL([Telesales_Access Line_AV],0))+SUM(ISNULL([Telesales_DSL_AV],0))+SUM(ISNULL([Telesales_DSL Direct_AV],0))+SUM(ISNULL([Telesales_Digital Life_AV],0))+SUM(ISNULL([Online_sales_Access Line_AV],0))+SUM(ISNULL([Online_sales_DSL_AV],0))+SUM(ISNULL([Online_sales_DSL Direct_AV],0))+SUM(ISNULL([Online_sales_Digital Life_AV],0)) AS Total_Sales_Comb_Other_AV,
SUM(ISNULL([Telesales_Access Line_BV],0))+SUM(ISNULL([Telesales_DSL_BV],0))+SUM(ISNULL([Telesales_DSL Direct_BV],0))+SUM(ISNULL([Telesales_Digital Life_BV],0)) AS Telesales_Comb_Other_BV,
SUM(ISNULL([Online_sales_Access Line_BV],0))+SUM(ISNULL([Online_sales_DSL_BV],0))+SUM(ISNULL([Online_sales_DSL Direct_BV],0))+SUM(ISNULL([Online_sales_Digital Life_BV],0)) AS Online_Sales_Comb_Other_BV,
SUM(ISNULL([Telesales_Access Line_BV],0))+SUM(ISNULL([Telesales_DSL_BV],0))+SUM(ISNULL([Telesales_DSL Direct_BV],0))+SUM(ISNULL([Telesales_Digital Life_BV],0))+SUM(ISNULL([Online_sales_Access Line_BV],0))+SUM(ISNULL([Online_sales_DSL_BV],0))+SUM(ISNULL([Online_sales_DSL Direct_BV],0))+SUM(ISNULL([Online_sales_Digital Life_BV],0)) AS Total_Sales_Comb_Other_BV,
SUM(ISNULL([Telesales_Access Line_CV],0))+SUM(ISNULL([Telesales_DSL_CV],0))+SUM(ISNULL([Telesales_DSL Direct_CV],0))+SUM(ISNULL([Telesales_Digital Life_CV],0)) AS Telesales_Comb_Other_CV,
SUM(ISNULL([Online_sales_Access Line_CV],0))+SUM(ISNULL([Online_sales_DSL_CV],0))+SUM(ISNULL([Online_sales_DSL Direct_CV],0))+SUM(ISNULL([Online_sales_Digital Life_CV],0)) AS Online_Sales_Comb_Other_CV,
SUM(ISNULL([Telesales_Access Line_CV],0))+SUM(ISNULL([Telesales_DSL_CV],0))+SUM(ISNULL([Telesales_DSL Direct_CV],0))+SUM(ISNULL([Telesales_Digital Life_CV],0))+SUM(ISNULL([Online_sales_Access Line_CV],0))+SUM(ISNULL([Online_sales_DSL_CV],0))+SUM(ISNULL([Online_sales_DSL Direct_CV],0))+SUM(ISNULL([Online_sales_Digital Life_CV],0)) AS Total_Sales_Comb_Other_CV,
SUM(ISNULL([Telesales_Access Line_FV],0))+SUM(ISNULL([Telesales_DSL_FV],0))+SUM(ISNULL([Telesales_DSL Direct_FV],0))+SUM(ISNULL([Telesales_Digital Life_FV],0)) AS Telesales_Comb_Other_FV,
SUM(ISNULL([Online_sales_Access Line_FV],0))+SUM(ISNULL([Online_sales_DSL_FV],0))+SUM(ISNULL([Online_sales_DSL Direct_FV],0))+SUM(ISNULL([Online_sales_Digital Life_FV],0)) AS Online_Sales_Comb_Other_FV,
SUM(ISNULL([Telesales_Access Line_FV],0))+SUM(ISNULL([Telesales_DSL_FV],0))+SUM(ISNULL([Telesales_DSL Direct_FV],0))+SUM(ISNULL([Telesales_Digital Life_FV],0))+SUM(ISNULL([Online_sales_Access Line_FV],0))+SUM(ISNULL([Online_sales_DSL_FV],0))+SUM(ISNULL([Online_sales_DSL Direct_FV],0))+SUM(ISNULL([Online_sales_Digital Life_FV],0)) AS Total_Sales_Comb_Other_FV

----------------------------END New Edits--------------------------------
	FROM
		(SELECT  
	[idFlight_Plan_Records_FK], [Campaign_Name], [InHome_Date], [Strategy_Eligibility], [Lead_Offer], [Media_Year], [Media_Week], [Media_Month], [Calendar_Month], [Calendar_Year], [Touch_Name]
	, [Program_Name], [Tactic], [Media], [Campaign_Type], [Audience], [Creative_Name], [Goal], [Offer], [Channel], [Scorecard_Group], [Scorecard_Program_Channel]
	, [Forecast], [Commitment], [Actual], [Best_View]
	,Case when kpi_type in ('Response','Volume','Budget') then Product_Code+'_CV'
		Else [KPI_Type]+'_'+[Product_Code]+'_CV' end as CV_metric 
	,Case when kpi_type in ('Response','Volume','Budget') then Product_Code+'_FV'
		Else [KPI_Type]+'_'+[Product_Code]+'_FV' end as FV_metric
	,Case when kpi_type in ('Response','Volume','Budget') then Product_Code+'_AV'
		Else [KPI_Type]+'_'+[Product_Code]+'_AV' end as AV_metric 
		,Case when kpi_type in ('Response','Volume','Budget') then Product_Code+'_BV'
		Else [KPI_Type]+'_'+[Product_Code]+'_BV' end as BV_metric 

	FROM #bestview) as transform
	JOIN dim.Media_Calendar_Daily as cal
	on transform.InHome_Date = cal.Date

	pivot 
	(SUM(Commitment) for CV_METRIC IN ([Call_CV], 
[Online_CV], 
[Online_sales_Access Line_CV], 
[Online_sales_DSL_CV], 
[Online_sales_DSL Direct_CV], 
[Online_sales_HSIA_CV], 
[Online_sales_Fiber_CV], 
[Online_sales_IPDSL_CV], 
[Online_sales_DirecTV_CV], 
[Online_sales_UVTV_CV], 
[Online_sales_VoIP_CV], 
[Online_sales_WRLS Data_CV], 
[Online_sales_WRLS Family_CV], 
[Online_sales_WRLS Voice_CV],
[Online_sales_WRLS Home_CV],
[Online_sales_Digital Life_CV], 
[Telesales_Access Line_CV], 
[Telesales_DSL_CV], 
[Telesales_DSL Direct_CV], 
[Telesales_HSIA_CV], 
[Telesales_Fiber_CV], 
[Telesales_IPDSL_CV], 
[Telesales_DirecTV_CV], 
[Telesales_UVTV_CV], 
[Telesales_VoIP_CV], 
[Telesales_WRLS Data_CV], 
[Telesales_WRLS Family_CV], 
[Telesales_WRLS Voice_CV],
[Telesales_WRLS Home_CV],
[Telesales_Digital Life_CV], 
[Volume_CV]
)) as P1

	pivot(sum(forecast) for FV_Metric in ([Call_FV], 
[Online_FV], 
[Online_sales_Access Line_FV], 
[Online_sales_DSL_FV], 
[Online_sales_DSL Direct_FV], 
[Online_sales_HSIA_FV], 
[Online_sales_Fiber_FV], 
[Online_sales_IPDSL_FV], 
[Online_sales_DirecTV_FV], 
[Online_sales_UVTV_FV], 
[Online_sales_VoIP_FV], 
[Online_sales_WRLS Data_FV], 
[Online_sales_WRLS Family_FV], 
[Online_sales_WRLS Voice_FV],
[Online_sales_WRLS Home_FV],
[Online_sales_Digital Life_FV], 
[Telesales_Access Line_FV], 
[Telesales_DSL_FV], 
[Telesales_DSL Direct_FV], 
[Telesales_HSIA_FV], 
[Telesales_Fiber_FV],
[Telesales_IPDSL_FV], 
[Telesales_DirecTV_FV], 
[Telesales_UVTV_FV], 
[Telesales_VoIP_FV], 
[Telesales_WRLS Data_FV], 
[Telesales_WRLS Family_FV], 
[Telesales_WRLS Voice_FV], 
[Telesales_WRLS Home_FV],
[Telesales_Digital Life_FV], 
[Volume_FV])) as P2

	pivot(sum(actual) for AV_Metric in ([Call_AV], 
[Online_AV], 
[Online_sales_Access Line_AV], 
[Online_sales_DSL_AV], 
[Online_sales_DSL Direct_AV], 
[Online_sales_HSIA_AV], 
[Online_sales_Fiber_AV], 
[Online_sales_IPDSL_AV], 
[Online_sales_DirecTV_AV], 
[Online_sales_UVTV_AV], 
[Online_sales_VoIP_AV], 
[Online_sales_WRLS Data_AV], 
[Online_sales_WRLS Family_AV], 
[Online_sales_WRLS Voice_AV],
[Online_sales_WRLS Home_AV],
[Online_sales_Digital Life_AV], 
[Online_Sales_DTV Now_AV], 
[Telesales_Access Line_AV], 
[Telesales_DSL_AV], 
[Telesales_DSL Direct_AV], 
[Telesales_HSIA_AV], 
[Telesales_Fiber_AV],
[Telesales_IPDSL_AV], 
[Telesales_DirecTV_AV], 
[Telesales_UVTV_AV], 
[Telesales_VoIP_AV], 
[Telesales_WRLS Data_AV], 
[Telesales_WRLS Family_AV], 
[Telesales_WRLS Voice_AV],
[Telesales_WRLS Home_AV],
[Telesales_Digital Life_AV], 
[Volume_AV])) as P3

	pivot(sum(best_view) for BV_Metric in ([Call_BV], 
[Online_BV], 
[Online_sales_Access Line_BV], 
[Online_sales_DSL_BV], 
[Online_sales_DSL Direct_BV], 
[Online_sales_HSIA_BV],
[Online_sales_Fiber_BV], 
[Online_sales_IPDSL_BV], 
[Online_sales_DirecTV_BV], 
[Online_sales_UVTV_BV], 
[Online_sales_VoIP_BV], 
[Online_sales_WRLS Data_BV], 
[Online_sales_WRLS Family_BV], 
[Online_sales_WRLS Voice_BV],
[Online_sales_WRLS Home_BV],
[Online_sales_Digital Life_BV], 
[Telesales_Access Line_BV], 
[Telesales_DSL_BV], 
[Telesales_DSL Direct_BV], 
[Telesales_HSIA_BV],
[Telesales_Fiber_BV], 
[Telesales_IPDSL_BV], 
[Telesales_DirecTV_BV], 
[Telesales_UVTV_BV], 
[Telesales_VoIP_BV], 
[Telesales_WRLS Data_BV], 
[Telesales_WRLS Family_BV], 
[Telesales_WRLS Voice_BV], 
[Telesales_WRLS Home_BV],
[Telesales_Digital Life_BV], 
[Volume_BV])) as P4

group by [idFlight_Plan_Records_FK], [Campaign_Name], [InHome_Date], [Strategy_Eligibility], [Lead_Offer], [Media_Year], [Media_Week], [Media_Month], [Touch_Name]
, [Program_Name], [Tactic], [Media], [Campaign_Type], [Audience], [Creative_Name], [Goal], [Offer], [Channel], [Scorecard_Group], 
[Scorecard_Program_Channel], CONVERT(VARCHAR(6),InHome_Date,112), M_Schedule, [Calendar_Year], [Calendar_Month]
;
---------------End of Pivot work---------------------------------------------

SET NOCOUNT OFF
END
