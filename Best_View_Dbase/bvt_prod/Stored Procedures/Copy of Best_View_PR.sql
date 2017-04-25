ALTER PROCEDURE [bvt_prod].[Best_View_ID_Version_PR]
@PROG int	
AS
BEGIN 
SET NOCOUNT ON
/*Temporary Declarations for Testing
DECLARE @PROG INT
set @PROG = 4--*/
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
	Program_Touch_Definitions_TBL.Scorecard_group, Scorecard_program_Channel
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
	left Join bvt_processed.Scorecard_Hierarchy on owner_type_matrix_id_FK =  owner_type_matrix_id
WHERE idProgram_LU_TBL_fk=@PROG;

create clustered index IDX_C_touchdef_id ON #touchdef(idProgram_Touch_Definitions_TBL);
----------End Touch Def-----------------------------


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
	, strat.Strategy_Eligibility
	, lead.Lead_Offer
	
---Media_Calendar_Info
	, Media_Calendar_Daily.ISO_Week_Year as Media_Year
	, Media_Calendar_Daily.ISO_Week as Media_Week
	, Media_Calendar_Daily.MediaMonth as Media_Month
	, Media_Calendar_Daily.ISO_Week_YYYYWW as Media_YYYYWW
	, YEAR(metrics.Forecast_DayDate) as Calendar_Year
	, MONTH(metrics.Forecast_DayDate) as Calendar_Month

---Touch Lookup Tables
	, idProgram_Touch_Definitions_TBL_FK
/*	, Touch_Name
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
*/

----Metrics
	, KPI_TYPE
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
	, idkpi_types_FK as KPI_TYPE
	, null as Product_Code
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
	, idkpi_types_FK
	, Day_of_Week
	, case when ResponseByDay.idTarget_Rate_Reasons_LU_TBL_FK is null then KPI_Daily*Seasonality_Adj
		else KPI_Daily*Seasonality_Adj*Rate_Adjustment_Factor end as KPI_Daily
	, Forecast_DayDate
from
----Join Weekly Response Curve and Media Calendar
(select Daily_Join.idFlight_Plan_Records
	, Daily_Join.idProgram_Touch_Definitions_TBL_FK
	, Daily_Join.idkpi_types_FK
	, Daily_Join.Day_of_Week
	, KPI_Daily*week_percent as KPI_Daily
	, DATEADD(week,c.Week_ID,InHome_Date) as Forecast_Week_Date
	, DATEADD(day,Day_of_Week-1,DATEADD(week,c.Week_ID,InHome_Date)) as Forecast_DayDate
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
	,case when tfn_ind=-1 and b.idkpi_types_FK=1 then KPI_Rate*isnull(adjustment,1)
		when TFN_ind=0 and b.idkpi_types_FK=1 then 0
		when URL_ind=-1 and b.idkpi_types_FK=2 then KPI_Rate*isnull(adjustment,1)
		when URL_ind=0 and b.idkpi_types_FK=2 then 0
		else KPI_Rate*adjustment
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
		on Daily_Join.InHome_Date=Media_Calendar_Daily.Date) as ResponseByDay
----------End  Weekly Response Curve and Media Calendar		
	left join bvt_prod.Seasonality_Adjustements as E
		on ResponseByDay.idProgram_Touch_Definitions_TBL_FK=E.idProgram_Touch_Definitions_TBL_FK and iso_week_year=Media_Year and mediamonth=Media_Month AND ISO_Week=Media_Week
	left join #Trgt_adj as Target_adjustment_start_end
		on ResponseByDay.idTarget_Rate_Reasons_LU_TBL_FK=Target_adjustment_start_end.idTarget_Rate_Reasons_LU_TBL_FK 
		and ResponseByDay.idProgram_Touch_Definitions_TBL_FK=Target_adjustment_start_end.idProgram_Touch_Definitions_TBL_FK
		and responsebyday.inhome_date between Adj_Start_Date and end_date) as kpi
inner join #volumes
		on kpi.idFlight_Plan_Records=#volumes.idFlight_Plan_Records) kpiforecast
)
---------End Section KPI Rates--------------------------------------------------
---------Begin Section Sales Rates
union 

(select idFlight_Plan_Records
	, idKPI_Type_FK as kpi_type
	, idProduct_LU_TBL_FK as product_code
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
	, idkpi_type_FK
	, idProduct_LU_TBL_FK
	, Day_of_Week
	, case when ResponseByDay.idTarget_Rate_Reasons_LU_TBL_FK is null then Sales_rate_Daily*Seasonality_Adj
		else Sales_rate_Daily*Seasonality_Adj*Rate_Adjustment_Factor end as Sales_rate_Daily
	, Forecast_DayDate

from
----Join Weekly Response Curve and Media Calendar
(select Daily_Join.idFlight_Plan_Records
	, Daily_Join.idProgram_Touch_Definitions_TBL_FK
	, Daily_Join.idkpi_type_FK
	, idProduct_LU_TBL_FK
	, Daily_Join.Day_of_Week
	, Salesrate_Daily*week_percent as Sales_Rate_Daily
	, DATEADD(week,c.Week_ID,InHome_Date) as Forecast_Week_Date
	, DATEADD(day,Day_of_Week-1,DATEADD(week,c.Week_ID,InHome_Date)) as Forecast_DayDate
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
	, case when tfn_ind=-1 and b.idkpi_type_FK=1 then Sales_Rate*isnull(adjustment,1)*isnull(Sales_Adjustment,1)
		when TFN_ind=0 and b.idkpi_type_FK=1 then 0
		when URL_ind=-1 and b.idkpi_type_FK=2 then Sales_Rate*isnull(adjustment,1)*isnull(Sales_Adjustment,1)
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
	left join (SELECT * FROM [bvt_prod].[Dropdate_Start_End_FUN](@PROG)) as D
		on Daily_Join.idProgram_Touch_Definitions_TBL_FK=d.idProgram_Touch_Definitions_TBL_FK
		and inhome_date between drop_start_date and d.end_date
	left join  dim.Media_Calendar_Daily 
		on Daily_Join.InHome_Date=Media_Calendar_Daily.Date) as ResponseByDay
----------End  Weekly Response Curve and Media Calendar		
	left join bvt_prod.Seasonality_Adjustements as E
		on ResponseByDay.idProgram_Touch_Definitions_TBL_FK=E.idProgram_Touch_Definitions_TBL_FK and iso_week_year=Media_Year and mediamonth=Media_Month and ISO_Week = Media_Week
	left join #Trgt_adj  as Target_adjustment_start_end
		on ResponseByDay.idTarget_Rate_Reasons_LU_TBL_FK=Target_adjustment_start_end.idTarget_Rate_Reasons_LU_TBL_FK 
		and ResponseByDay.idProgram_Touch_Definitions_TBL_FK=Target_adjustment_start_end.idProgram_Touch_Definitions_TBL_FK
		and responsebyday.inhome_date between Adj_Start_Date and end_date) sales
inner join #volumes
on sales.idFlight_Plan_Records=#volumes.idFlight_Plan_Records) salesforecast
)
UNION
(select idFlight_Plan_Records
	, 4 as kpi_type
	, NULL as product_code
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
left join
bvt_prod.Strategy_Eligibility_LU_TBL strat
	on #flightplan.Strategy_Eligibility_LU_TBL_FK = strat.idStrategy_Eligibility_LU_TBL
left join
bvt_prod.Lead_Offer_LU_TBL lead
	on #flightplan.Lead_Offer_LU_TBL_FK = lead.idLead_Offer_LU_TBL
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
	,[inhome_date]
	,[KPI_TYPE], [Product_Code], Actual
into #volumebudget
from 
	(select [idFlight_Plan_Records_FK], [Start_Date]
	, case when kpiproduct='CTD_Quantity' then 4
		when kpiproduct='CTD_Budget' then 5
		end as KPI_type
	, NULL as Product_Code
	, sum(Actuals.[Actual]) as Actual
	from (select [idFlight_Plan_Records_FK], [Start_Date], [CTD_Quantity], [CTD_Budget]
			from #actuals 
			group by [idFlight_Plan_Records_FK], [Start_Date], [CTD_Quantity], [CTD_Budget]) as actual_query

	UNPIVOT (Actual for kpiproduct in 
			([CTD_Quantity], [CTD_Budget])) as Actuals
	GROUP BY idFlight_Plan_Records_FK, Start_Date
	, case when kpiproduct='CTD_Quantity' then 4
		when kpiproduct='CTD_Budget' then 5
		end) as pivotmetrics
	inner join dim.media_calendar_daily on [Start_Date] = [date]
	inner join #flightplan on [idFlight_Plan_Records_FK] = [idFlight_Plan_Records]
create index IDX_NC_VOLUMEBUDGET
 ON #volumebudget([idFlight_Plan_Records_FK], [Calendar_Year], [Calendar_Month]
  , [media_year] ,[Media_Week] ,[kpi_type] ,[product_code]);
---------End Volume Budget-----------------------------
---------Response and Sales Actuals--------------------
IF OBJECT_ID('tempdb.dbo.#ResponseSales', 'U') IS NOT NULL
  DROP TABLE #ResponseSales; 
--
select [idFlight_Plan_Records_FK], [Media_Year], [Media_Week], [MediaMonth] as Media_Month
	, [inhome_date], [Calendar_Year], [Calendar_Month]
	, [KPI_TYPE], [Product_Code], Actual
into #ResponseSales
from
	(select [idFlight_Plan_Records_FK], [Report_Year] as Media_Year, [Report_Week] as Media_Week,  [Calendar_Year], [Calendar_Month]
	, case 
		when kpiproduct='ITP_Dir_Calls' then 1
		when kpiproduct='ITP_Dir_Clicks' then 2
		when kpiproduct like '%Sales_TS%' then 1
		when kpiproduct like '%Sales_ON%' then 2
		end as KPI_type
	, case
		when kpiproduct='ITP_Dir_Calls' then NULL
		when kpiproduct='ITP_Dir_Clicks' then NULL
		when kpiproduct like '%CING_VOICE%' then 9
		when kpiproduct like '%CING_FAMILY%' then 10
		when kpiproduct like '%CING_DATA%' then 11
		when kpiproduct like '%DISH%' then 8
		when kpiproduct like '%DSL_DRY%' then 3
		when kpiproduct like '%DSL_REG%' then 2
		when kpiproduct like '%HSIAG%' then 17
		when kpiproduct like '%HSIA%' then 5
		when kpiproduct like '%DSL_IP%' then 4
		when kpiproduct like '%UVRS_TV%' then 6
		when kpiproduct like '%VOIP%' then 7 
		when kpiproduct like '%ACCL%' then 1
		when kpiproduct like '%BOLT%' then 15
		when kpiproduct like '%Migrations%' then 16
		when kpiproduct like '%CTECH%' then 13
		when kpiproduct like '%DLIFE%' then 14
		when kpiproduct like '%WHP%' then 12
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
			[ITP_Dir_Sales_ON_UVRS_VOIP_N], [ITP_Dir_Sales_ON_DLIFE_N], [ITP_Dir_Sales_ON_CING_WHP_N], [ITP_Dir_Sales_ON_Migrations])) as Actuals
GROUP BY [idFlight_Plan_Records_FK], [Report_Year], [Report_Week], [Calendar_Year], [Calendar_Month]

, case 
		when kpiproduct='ITP_Dir_Calls' then 1
		when kpiproduct='ITP_Dir_Clicks' then 2
		when kpiproduct like '%Sales_TS%' then 1
		when kpiproduct like '%Sales_ON%' then 2
		end 
	, case
		when kpiproduct='ITP_Dir_Calls' then NULL
		when kpiproduct='ITP_Dir_Clicks' then NULL
		when kpiproduct like '%CING_VOICE%' then 9
		when kpiproduct like '%CING_FAMILY%' then 10
		when kpiproduct like '%CING_DATA%' then 11
		when kpiproduct like '%DISH%' then 8
		when kpiproduct like '%DSL_DRY%' then 3
		when kpiproduct like '%DSL_REG%' then 2
		when kpiproduct like '%HSIAG%' then 17
		when kpiproduct like '%HSIA%' then 5
		when kpiproduct like '%DSL_IP%' then 4
		when kpiproduct like '%UVRS_TV%' then 6
		when kpiproduct like '%VOIP%' then 7 
		when kpiproduct like '%ACCL%' then 1
		when kpiproduct like '%BOLT%' then 15
		when kpiproduct like '%Migrations%' then 16
		when kpiproduct like '%CTECH%' then 13
		when kpiproduct like '%DLIFE%' then 14
		when kpiproduct like '%WHP%' then 12
		end
	) as actuals 
	inner join #flightplan on [idFlight_Plan_Records_FK] = [idFlight_Plan_Records]
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
  , case when [KPI_TYPE]='Response' and CV_Combined.[Product_Code]='Call' then 1
	when [KPI_TYPE]='Response' and CV_Combined.[Product_Code]='Online' then 2
	when [KPI_TYPE]='Telesales' then 1
	when [KPI_TYPE]='Online_Sales' then 2
	when [KPI_TYPE]='Volume' then 4
	else NULL end as KPI_TYPE
  , case when CV_Combined.[Product_Code]='Access Line' then 1
	 when CV_Combined.[Product_Code]='Bolt ons' then 15
	 when CV_Combined.[Product_Code]='ConnecTech' then 13
	 when CV_Combined.[Product_Code]='Digital Life' then 14
	 when CV_Combined.[Product_Code]='DIRECTV' then 8
	 when CV_Combined.[Product_Code]='DSL' then 2
	 when CV_Combined.[Product_Code]='DSL Direct' then 3
	 when CV_Combined.[Product_Code]='Fiber' then 17
	 when CV_Combined.[Product_Code]='HSIA' then 5
	 when CV_Combined.[Product_Code]='IPDSL' then 4
	 when CV_Combined.[Product_Code]='Upgrades' then 16
	 when CV_Combined.[Product_Code]='UVTV' then 6
	 when CV_Combined.[Product_Code]='VoIP' then 7
	 when CV_Combined.[Product_Code]='WRLS Data' then 11
	 when CV_Combined.[Product_Code]='WRLS Family' then 10
	 when CV_Combined.[Product_Code]='WRLS Home' then 12
	 when CV_Combined.[Product_Code]='WRLS Voice' then 9
	else null end as Product_Code
  ,  SUM([forecast]) as Forecast
into #cv
from bvt_cv.CV_Combined
--left join [bvt_prod].[Program_Touch_Definitions_TBL]
--	on CV_Combined.[idProgram_Touch_Definitions_TBL_FK]=[Program_Touch_Definitions_TBL].[idProgram_Touch_Definitions_TBL]
where CV_Combined.[Program_Name]=(select program_name from bvt_prod.program_LU_TBL where idProgram_LU_TBL=@prog)
GROUP BY [idFlight_Plan_Records], [idProgram_Touch_Definitions_TBL_FK], CV_Combined.[Campaign_Name], [InHome_Date], 
	[Media_Year], [Media_Month], [Media_Week], [Media_YYYYWW], [KPI_TYPE], [Product_Code],
 [Calendar_Year], [Calendar_Month];
create index IDX_NC_CV
 ON #cv([idFlight_Plan_Records], [Calendar_Year], [Calendar_Month]
  , [media_year] ,[Media_Week] ,[kpi_type] ,[product_code]);
----------------END CV Section-----------------------------------------
-----------------Blending Section--------------------------------------
/*Combine the Forecast, Actuals, and CV into a single Best View of the
program selected for output*/
-----------------------------------------------------------------------
select
coalesce(forecast_cv.[idFlight_Plan_Records_FK], #volumebudget.[idFlight_Plan_Records_FK], #ResponseSales.[idFlight_Plan_Records_FK]) as idFlight_Plan_Records_FK,
		coalesce(forecast_cv.[Campaign_Name], #volumebudget.[Campaign_Name], #ResponseSales.[Campaign_Name]) as Campaign_Name,
		coalesce(forecast_cv.[InHome_Date], #volumebudget.[InHome_Date], #ResponseSales.[InHome_Date]) as InHome_Date,
		coalesce(forecast_cv.[Media_Year], #volumebudget.[Media_Year], #ResponseSales.[Media_Year]) as Media_Year,
		coalesce(forecast_cv.[Media_Week], #volumebudget.[Media_Week], #ResponseSales.[Media_Week]) as Media_Week,
		coalesce(forecast_cv.[Media_Month], #volumebudget.[Media_Month], #ResponseSales.Media_Month) as Media_Month,
		coalesce(forecast_cv.[Calendar_Year], #volumebudget.[Calendar_Year], #ResponseSales.[Calendar_Year]) as Calendar_Year,
		coalesce(forecast_cv.[Calendar_Month], #volumebudget.[Calendar_Month], #ResponseSales.[Calendar_Month]) as Calendar_Month,
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
		
FROM	

(SELECT 
	   Coalesce(forecast.[idFlight_Plan_Records], cv.[idFlight_Plan_Records]) as idFlight_Plan_Records_FK
      ,Coalesce(forecast.[Campaign_Name], cv.[Campaign_Name]) as Campaign_Name
      ,coalesce(forecast.[InHome_Date], cv.[InHome_Date]) as InHome_Date
      ,coalesce(forecast.[KPI_Type], cv.[KPI_Type]) as KPI_Type
      ,coalesce(forecast.[Product_Code], cv.[Product_Code]) as Product_Code
	  ,coalesce(forecast.[media_year], cv.[media_year]) as media_year
	  ,coalesce(forecast.[media_month], cv.[media_month]) as media_month
	  ,coalesce(forecast.[media_week], cv.[media_week]) as media_week
	  ,coalesce(forecast.[Media_YYYYWW], cv.[Media_YYYYWW]) as Media_YYYYWW
	  ,coalesce(forecast.[Calendar_Year], cv.[Calendar_Year]) as Calendar_Year
	  ,coalesce(forecast.[Calendar_Month], cv.[Calendar_Month]) as Calendar_Month
	  ,forecast.Strategy_Eligibility
      ,forecast.Lead_Offer
      ,sum(forecast.[Forecast]) as Forecast
	  ,sum(CV.forecast) as Commitment 
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

group by Coalesce(forecast.[idFlight_Plan_Records], cv.[idFlight_Plan_Records]) 
      ,Coalesce(forecast.[Campaign_Name], cv.[Campaign_Name]) 
      ,coalesce(forecast.[InHome_Date], cv.[InHome_Date]) 
	  ,coalesce(forecast.[KPI_Type], cv.[KPI_Type])
      ,coalesce(forecast.[Product_Code], cv.[Product_Code])
	  ,forecast.Strategy_Eligibility
      ,forecast.Lead_Offer
	  ,coalesce(forecast.[media_year], cv.[media_year])
	  ,coalesce(forecast.[media_month], cv.[media_month])
	  ,coalesce(forecast.[media_week], cv.[media_week])
	  ,coalesce(forecast.[Media_YYYYWW], cv.[Media_YYYYWW])
	  ,coalesce(forecast.[Calendar_Year], cv.[Calendar_Year])
	  ,coalesce(forecast.[Calendar_Month], cv.[Calendar_Month])
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


SET NOCOUNT OFF
END
