


-------------------------------------------
CREATE view [bvt_prod].[Movers_Flightplan_SalesRate_Daily_VW]
as
----Join Seasonality Adjustments
select idFlight_Plan_Records
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
	, DATEADD(week,c.Week_ID-1,DATEADD(day,Days_Before_Inhome,InHome_Date)) as Forecast_Week_Date
	, DATEADD(day,Day_of_Week-1,DATEADD(week,c.Week_ID-1,DATEADD(day,Days_Before_Inhome,InHome_Date))) as Forecast_DayDate
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
	, idkpi_type_FK
	, idProduct_LU_TBL_FK
	, case when tfn_ind=-1 and idkpi_type_FK=1 then Sales_Rate
		when TFN_ind=0 and idkpi_type_FK=1 then 0
		when URL_ind=-1 and idkpi_type_FK=2 then Sales_Rate
		when URL_ind=0 and idkpi_type_FK=2 then 0
		else Sales_Rate
		end as Sales_Rate
	, InHome_Date
	, idTarget_Rate_Reasons_LU_TBL_FK
from bvt_processed.Movers_Flight_Plan as A
	
	left join bvt_prod.Sales_Rates_Start_End_VW as B on A.idProgram_Touch_Definitions_TBL_FK=B.idProgram_Touch_Definitions_TBL_FK
	and InHome_Date between Sales_Rate_Start_Date and b.END_DATE) as SalesRate_Join
---End Join KPI and Flight Plan	

	left join bvt_prod.Response_Daily_Start_End_VW as B 
		on SalesRate_Join.idProgram_Touch_Definitions_TBL_FK=b.idProgram_Touch_Definitions_TBL_FK 
			and SalesRate_Join.idkpi_type_FK=b.idkpi_type_FK
		and InHome_Date between daily_Start_Date and b.END_DATE) as Daily_Join
	
---End Join Daily Percentages

	left join bvt_prod.Sales_Curve_Start_End_VW as C
		on Daily_Join.idProgram_Touch_Definitions_TBL_FK=c.idProgram_Touch_Definitions_TBL_FK and Daily_Join.idkpi_type_FK=c.idkpi_type_FK
		and inhome_date between Curve_Start_Date and c.END_DATE
	left join bvt_prod.Dropdate_Start_End_VW as D
		on Daily_Join.idProgram_Touch_Definitions_TBL_FK=d.idProgram_Touch_Definitions_TBL_FK
		and inhome_date between drop_start_date and d.end_date
	left join  dim.Media_Calendar_Daily 
		on Daily_Join.InHome_Date=Media_Calendar_Daily.Date) as ResponseByDay
----------End  Weekly Response Curve and Media Calendar		
	left join bvt_prod.Seasonality_Adjustements as E
		on ResponseByDay.idProgram_Touch_Definitions_TBL_FK=E.idProgram_Touch_Definitions_TBL_FK and iso_week_year=Media_Year and mediamonth=Media_Month
	left join bvt_processed.Target_adjustment_start_end
		on ResponseByDay.idTarget_Rate_Reasons_LU_TBL_FK=Target_adjustment_start_end.idTarget_Rate_Reasons_LU_TBL_FK 
		and ResponseByDay.idProgram_Touch_Definitions_TBL_FK=Target_adjustment_start_end.idProgram_Touch_Definitions_TBL_FK
		and responsebyday.inhome_date between Adj_Start_Date and end_date



