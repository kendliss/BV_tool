




CREATE PROCEDURE [eCRW].[weekly_report_campaign_schedule]
as

if object_id('tempdb..#projects') is not null drop table #projects
select 
  C.Touch_Name
, C.Touch_Name_2
, F.Audience_Type_Name
, D.Media_Type
, E.ISO_Week_YYYYWW
, E.date_month_long
, initial_entry_wk = 
	case
		when E.ISO_Week_YYYYWW < '201209' and E.ISO_Week_YYYYWW >'201152' then '201152'-7+E.iso_week
		when E.ISO_Week_YYYYWW ='201152' then '201152'-7
		
		when E.ISO_Week_YYYYWW < '201308' and E.ISO_Week_YYYYWW >'201253' then '201253'-7+E.iso_week
		when E.ISO_Week_YYYYWW ='201253' then '201253'-7
		
		when E.ISO_Week_YYYYWW < '201408' and E.ISO_Week_YYYYWW >'201352' then '201352'-7+E.iso_week --added 11/1/13
		when E.ISO_Week_YYYYWW ='201352' then '201352'-7                                             --added 11/1/13
		
		when E.ISO_Week_YYYYWW < '201508' and E.ISO_Week_YYYYWW >'201452' then '201452'-7+E.iso_week --added 11/11/14
		when E.ISO_Week_YYYYWW ='201452' then '201452'-7                                             --added 11/11/14
		
		
		else E.ISO_Week_YYYYWW-7
		end
, update_qty = 
		case 
		when E.ISO_Week_YYYYWW='201152' then '201201'
		when E.ISO_Week_YYYYWW='201253' then '201301'
		when E.ISO_Week_YYYYWW='201254' then '201302'
		when E.ISO_Week_YYYYWW='201352' then '201401'
		when E.ISO_Week_YYYYWW='201452' then '201501'
		else E.ISO_Week_YYYYWW+1
		end
, A.Inhome_Date
, sum(A.volume_forecast) as volume

into #projects
	  from uvaq.[Forecasting].[Current_UVAQ_Flightplan_Forecast_view] as A
	  inner join uvaq.Forecasting.Flight_Plan_Records as B ON A.Flight_Plan_Record_ID=B.Flight_Plan_Record_ID
      inner join uvaq.Forecasting.Touch_Type as C on B.Touch_Type_FK=C.Touch_Type_ID
      inner join uvaq.Forecasting.Media_Type as D on C.Media_Type_FK=D.Media_Type_ID
      inner join uvaq.DIM.Media_Calendar_Daily as E on A.Inhome_Date=E.[Date]
      inner join uvaq.Forecasting.Audience as F on C.Audience_FK=F.Audience_ID
 where iso_week_YYYYWW > '201345'
 group by E.ISO_Week_YYYYWW
, C.Touch_Name
, C.Touch_Name_2
, F.Audience_Type_Name
, D.Media_Type
, A.Inhome_Date
, E.date_month_long
, E.iso_week

 order by E.ISO_Week_YYYYWW
, C.Touch_Name
, C.Touch_Name_2
, F.Audience_Type_Name
, D.Media_Type
, E.date_month_long
, E.iso_week

if object_id('tempdb..#initial_schedule') is not null drop table #initial_schedule
select 
 a.*
 , b.date as initial_entry 
 into #initial_schedule
 from #projects as a 
	left join uvaq.DIM.Media_Calendar_Daily as b
	on a.initial_entry_wk = b.ISO_Week_YYYYWW
 where weekday_short='mon'

if object_id('eCRW.weekly_report_campaign_entry') is not null drop table eCRW.weekly_report_campaign_entry
select 
 a.*
 , b.date as upd_qty
 into eCRW.weekly_report_campaign_entry
 from #initial_schedule as a 
	left join uvaq.DIM.Media_Calendar_Daily as b
	on a.update_qty = b.ISO_Week_YYYYWW
 where weekday_short='mon'
select * from eCRW.weekly_report_campaign_entry



