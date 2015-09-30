DROP VIEW [bvt_prod].[UCLM_Flightplan_KPIRate_Daily_VW]
GO

CREATE view [bvt_prod].[UCLM_Flightplan_KPIRate_Daily_VW]
as
----Join Seasonality Adjustments
select idFlight_Plan_Records
	, responsebyday.idProgram_Touch_Definitions_TBL_FK
	, idkpi_types_FK
	, Day_of_Week
	, KPI_Daily

/*No seasonality or target rate adjustments currently active for UCLM - alter to include this code if
you wish to incorporate seasonality or target rate adjustments
	, case when ResponseByDay.idTarget_Rate_Reasons_LU_TBL_FK is null then KPI_Daily*Seasonality_Adj
		else KPI_Daily*Seasonality_Adj*Rate_Adjustment_Factor end as KPI_Daily
*/
	, Forecast_DayDate

from
----Join Weekly Response Curve and Media Calendar
(select Daily_Join.idFlight_Plan_Records
	, Daily_Join.idProgram_Touch_Definitions_TBL_FK
	, Daily_Join.idkpi_types_FK
	, Daily_Join.Day_of_Week
	, KPI_Daily*week_percent as KPI_Daily
	, DATEADD(day,c.Week_ID,InHome_Date) as Forecast_DayDate
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
	--Case statement allows a forecast with flat daily rate if day percent is null
	, case when Day_percent is null then KPI_Rate/7
		else KPI_Rate*Day_Percent/7 end as KPI_Daily
	, inhome_date
	, idTarget_Rate_Reasons_LU_TBL_FK

from	
--Join Flight Plan with KPIs
(select 
	a.idFlight_Plan_Records
	, a.idProgram_Touch_Definitions_TBL_FK
	, idkpi_types_FK
	
  --Code to account for having a TFN or URL or not in flightplan entry
	, case when abs(tfn_ind)=1 and idkpi_types_FK=1 then KPI_Rate
		when abs(TFN_ind)=0 and idkpi_types_FK=1 then 0
		when abs(URL_ind)=1 and idkpi_types_FK=2 then KPI_Rate
		when abs(URL_ind)=0 and idkpi_types_FK=2 then 0
		when idkpi_types_FK=3 then KPI_Rate/-1000
		end as KPI_Rate
	, InHome_Date
	, idTarget_Rate_Reasons_LU_TBL_FK
from bvt_prod.UCLM_Flight_Plan_VW as A
	
	left join (SELECT * FROM [bvt_prod].[KPI_Rate_Start_End_FUN]('UVCLM')) as B on A.idProgram_Touch_Definitions_TBL_FK=B.idProgram_Touch_Definitions_TBL_FK
	AND InHome_Date between Rate_Start_Date and b.END_DATE
	) as KPI_Join
---End Join KPI and Flight Plan	

	left join (SELECT * FROM [bvt_prod].[Response_Daily_Start_End_FUN]('UVCLM'))as B 
		on KPI_Join.idProgram_Touch_Definitions_TBL_FK=b.idProgram_Touch_Definitions_TBL_FK and KPI_Join.idkpi_types_FK=b.idkpi_type_FK
		and InHome_Date between daily_Start_Date and b.END_DATE) as Daily_Join
	
---End Join Daily Percentages

	left join  (SELECT * FROM [bvt_prod].[Response_Curve_Start_End_FUN]('UVCLM'))  as C
		on Daily_Join.idProgram_Touch_Definitions_TBL_FK=c.idProgram_Touch_Definitions_TBL_FK and Daily_Join.idkpi_types_FK=c.idkpi_type_FK
		and inhome_date between Curve_Start_Date and c.END_DATE
	left join (SELECT * FROM [bvt_prod].[Dropdate_Start_End_FUN]('UVCLM')) as D
		on Daily_Join.idProgram_Touch_Definitions_TBL_FK=d.idProgram_Touch_Definitions_TBL_FK
		and inhome_date between drop_start_date and d.end_date
	left join  dim.Media_Calendar_Daily 
		on Daily_Join.InHome_Date=Media_Calendar_Daily.Date) as ResponseByDay
----------End  Weekly Response Curve and Media Calendar		
	left join bvt_prod.Seasonality_Adjustements as E
		on ResponseByDay.idProgram_Touch_Definitions_TBL_FK=E.idProgram_Touch_Definitions_TBL_FK and iso_week_year=Media_Year and mediamonth=Media_Month AND ISO_Week=Media_Week
	left join (SELECT * FROM [bvt_prod].[Target_adjustment_start_end_FUN]('UVCLM')) as Target_adjustment_start_end
		on ResponseByDay.idTarget_Rate_Reasons_LU_TBL_FK=Target_adjustment_start_end.idTarget_Rate_Reasons_LU_TBL_FK 
		and ResponseByDay.idProgram_Touch_Definitions_TBL_FK=Target_adjustment_start_end.idProgram_Touch_Definitions_TBL_FK
		and responsebyday.inhome_date between Adj_Start_Date and end_date



