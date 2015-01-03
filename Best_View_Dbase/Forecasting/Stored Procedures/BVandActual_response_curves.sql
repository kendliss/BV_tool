CREATE procedure [Forecasting].[BVandActual_response_curves] 
@CampaignStartDate datetime, @weeks_tracking numeric
as
----------------------------------------------------------------------
--Actual Data from Main Table
----------------------------------------------------------------------

/*call response curve data*/
if object_id('tempdb..#daily_calls') is not null drop table #daily_calls
select project = (Touch_Name + ' ' + Touch_Name_2 + ' ' + e.Media_Type)
, Start_Date
, In_Home_Date
, eCRW_Project_Name
, Campaign_Name
, a.Media_code
, d.Touch_Type_FK
, e.Media_Type
, e.Touch_Name
, e.Touch_Name_2
, e.Audience_Type_Name
, e.Program_Owner
, a.parentid
, a.End_Date_Traditional
, datediff(ww,start_date,(select b.End_Date 
	from javdb.ireport_2014.dbo.wb_00_reporting_cycle as a 
	join javdb.ireport_2014.dbo.WB_00_Media_Calendar_Weekly as b 
	on a.ReportCycle_YYYYWW=b.ReportWeek_YYYYWW 
	group by b.End_Date)) as [Weeks Tracking]
, tfn
, date
, calls 
, datediff(d, Start_Date, date) as days
, datediff(week, Start_Date, date) as weeks
, datename(weekday,date) as day
into #daily_calls
from javdb.ireport_2014.dbo.WB_01_Campaign_List as a 
	left join (select * from javdb.[IREPORT].[dbo].[WB_03_Data_Calls_SCAMP_Complete] UNION select * from javdb.ireport_2014.[dbo].[WB_03_Data_Calls_SCAMP_Complete] )as b 
		on a.parentid = b.parentid
	join javdb.ireport_2014.dbo.ir_a_ownertypetactic_matrix as c
      on a.tactic_id=c.id
    join UVAQ.Results.ParentID_Touch_Type_Link as d
	  on a.parentid=d.parentid
	join UVAQ.dbo.[Touch Type Human View] as e
	  on d.Touch_Type_FK=e.Touch_Type_id
where c.Scorecard_Top_Tab = 'Direct Marketing'
and c.Scorecard_LOB_Tab = 'U-verse'
and c.Scorecard_tab = 'Uverse Base Acq'
and c.Scorecard_Program_Channel not like '%social%'
and a.Report_year = 2014
and a.start_date >=@CampaignStartDate
and eCRW_Project_Name not like '%overrun%'
and eCRW_Project_Name not like '%JUN13_UPRO_D2D_DetroitDoorHanger%'
group by Touch_Name
, Touch_Name_2
, e.Media_Type
, Start_Date
, In_Home_Date
, eCRW_Project_Name
, Campaign_Name
, a.Media_code
, d.Touch_Type_FK
, e.Media_Type
, e.Touch_Name
, e.Touch_Name_2
, e.Audience_Type_Name
, e.Program_Owner
, a.parentid
, a.End_Date_Traditional
, eCRW_Project_Name
, Campaign_Name
, a.Media_code
, a.parentid
, tfn
, date
, calls 
having datediff(ww,start_date,(select b.End_Date 
	from javdb.ireport_2014.dbo.wb_00_reporting_cycle as a 
	join javdb.ireport_2014.dbo.WB_00_Media_Calendar_Weekly as b 
	on a.ReportCycle_YYYYWW=b.ReportWeek_YYYYWW 
	group by b.End_Date))>@weeks_tracking
order by date

if object_id('tempdb..#weekly_calls') is not null drop table #weekly_calls
select /*Touch_Type_FK
, Touch_Name
, Touch_Name_2
, Audience_Type_Name
, */Media_Type
, Program_Owner
, project
, weeks
, sum(calls) as weekly_calls
into #weekly_calls
from #daily_calls
where weeks is not null
group by /*Touch_Type_FK
, Touch_Name
, Touch_Name_2
, Audience_Type_Name
, */Media_Type
, Program_Owner
, project
, weeks
order by /*Touch_Type_FK
, Touch_Name
, Touch_Name_2
, Audience_Type_Name
, */Media_Type
, Program_Owner
, project
, weeks

if object_id('tempdb..#total_calls') is not null drop table #total_calls
select /*Touch_Type_FK
, Touch_Name
, Touch_Name_2
, Audience_Type_Name
, */Media_Type
, Program_Owner
, project
, sum(calls) as total_calls
into #total_calls
from #daily_calls
where weeks is not null
group by /*Touch_Type_FK
, Touch_Name
, Touch_Name_2
, Audience_Type_Name
, */Media_Type
, Program_Owner
, project
order by /*Touch_Type_FK
, Touch_Name
, Touch_Name_2
, Audience_Type_Name
, */Media_Type
, Program_Owner
, project

/*actual calls % by week*/
if object_id('tempdb..#actual_calls_curves') is not null drop table #actual_calls_curves
select /*coalesce(a.touch_type_fk,b.touch_type_fk) as touch_type_fk
, coalesce(a.touch_name,b.touch_name) as touch_name
, coalesce(a.touch_name_2,b.touch_name_2) as touch_name_2
, coalesce(a.audience_type_name,b.audience_type_name) as audience_type_name
, */coalesce(a.media_type,b.media_type) as media_type
, coalesce(a.Program_Owner,b.Program_Owner) as Program_Owner
, coalesce(a.project,b.project) as project
, weeks
, isnull(isnull(weekly_calls,0)/nullif(total_calls,0),0) as [Actual Calls Percent]
into #actual_calls_curves
from #weekly_calls as a join #total_calls as b
	on (a.project=b.project)
--select * from #actual_calls_curves

/*click response curve data*/
if object_id('tempdb..#daily_clicks') is not null drop table #daily_clicks
select project = (Touch_Name + ' ' + Touch_Name_2 + ' ' + e.Media_Type)
, Start_Date
, In_Home_Date
, eCRW_Project_Name
, Campaign_Name
, a.Media_code
, d.Touch_Type_FK
, e.Media_Type
, e.Touch_Name
, e.Touch_Name_2
, e.Audience_Type_Name
, e.Program_Owner
, a.parentid
, a.End_Date_Traditional
, datediff(ww,start_date,(select b.End_Date 
	from javdb.ireport_2014.dbo.wb_00_reporting_cycle as a 
	join javdb.ireport_2014.dbo.WB_00_Media_Calendar_Weekly as b 
	on a.ReportCycle_YYYYWW=b.ReportWeek_YYYYWW 
	group by b.End_Date)) as [Weeks Tracking]
, placementname
, date
, sum(clicks) as clicks
, datediff(d, Start_Date, date) as days
, datediff(week, Start_Date, date) as weeks
, datename(weekday,date) as day
into #daily_clicks
from javdb.[IREPORT_2014].dbo.WB_01_Campaign_List as a 
	left join (select * from javdb.[IREPORT].dbo.WB_03_Data_Clicks_WEBTRENDS UNION select * from javdb.[IREPORT_2014].dbo.WB_03_Data_Clicks_WEBTRENDS) as b 
	on a.parentid = b.parentid
	join javdb.[IREPORT_2014].dbo.ir_a_ownertypetactic_matrix as c
      on a.tactic_id=c.id
    join UVAQ.Results.ParentID_Touch_Type_Link as d
	  on a.parentid=d.parentid
	join UVAQ.dbo.[Touch Type Human View] as e
	  on d.Touch_Type_FK=e.Touch_Type_id
where c.Scorecard_Top_Tab = 'Direct Marketing'
and c.Scorecard_LOB_Tab = 'U-verse'
and c.Scorecard_tab = 'Uverse Base Acq'
and c.Scorecard_Program_Channel not like '%social%'
and a.Report_year = 2014
and a.start_date >=@CampaignStartDate
and eCRW_Project_Name not like '%overrun%'
and eCRW_Project_Name not like '%JUN13_UPRO_D2D_DetroitDoorHanger%'
group by Touch_Name
, Touch_Name_2
, e.Media_Type
, Start_Date
, In_Home_Date
, eCRW_Project_Name
, Campaign_Name
, a.Media_code
, d.Touch_Type_FK
, e.Media_Type
, e.Touch_Name
, e.Touch_Name_2
, e.Audience_Type_Name
, e.Program_Owner
, a.parentid
, a.End_Date_Traditional
, eCRW_Project_Name
, Campaign_Name
, a.Media_code
, a.parentid
, placementname
, date
having datediff(ww,start_date,(select b.End_Date 
	from javdb.ireport_2014.dbo.wb_00_reporting_cycle as a 
	join javdb.ireport_2014.dbo.WB_00_Media_Calendar_Weekly as b 
	on a.ReportCycle_YYYYWW=b.ReportWeek_YYYYWW 
	group by b.End_Date))>@weeks_tracking
order by date

if object_id('tempdb..#weekly_clicks') is not null drop table #weekly_clicks
select /*Touch_Type_FK
, Touch_Name
, Touch_Name_2
, Audience_Type_Name
, */Media_Type
, Program_Owner
, project
, weeks
, sum(clicks) as weekly_clicks
into #weekly_clicks
from #daily_clicks
where weeks is not null
group by /*Touch_Type_FK
, Touch_Name
, Touch_Name_2
, Audience_Type_Name
, */Media_Type
, Program_Owner
, project
, weeks
order by /*Touch_Type_FK
, Touch_Name
, Touch_Name_2
, Audience_Type_Name
, */Media_Type
, Program_Owner
, project
, weeks

if object_id('tempdb..#total_clicks') is not null drop table #total_clicks
select /*Touch_Type_FK
, Touch_Name
, Touch_Name_2
, Audience_Type_Name
, */Media_Type
, Program_Owner
, project
, sum(clicks) as total_clicks
into #total_clicks
from #daily_clicks
where weeks is not null
group by /*Touch_Type_FK
, Touch_Name
, Touch_Name_2
, Audience_Type_Name
, */Media_Type
, Program_Owner
, project
order by /*Touch_Type_FK
, Touch_Name
, Touch_Name_2
, Audience_Type_Name
, */Media_Type
, Program_Owner
, project

/*actual clicks % by week*/
if object_id('tempdb..#actual_clicks_curves') is not null drop table #actual_clicks_curves
select /*coalesce(a.touch_type_fk,b.touch_type_fk) as touch_type_fk
, coalesce(a.touch_name,b.touch_name) as touch_name
, coalesce(a.touch_name_2,b.touch_name_2) as touch_name_2
, coalesce(a.audience_type_name,b.audience_type_name) as audience_type_name
, */coalesce(a.media_type,b.media_type) as media_type
, coalesce(a.Program_Owner,b.Program_Owner) as Program_Owner
, coalesce(a.project,b.project) as project
, weeks
, isnull(isnull(weekly_clicks,0)/nullif(total_clicks,0),0) as [Actual Clicks Percent]
into #actual_clicks_curves
from #weekly_clicks as a join #total_clicks as b
	on (a.project=b.project)
--select * from #actual_clicks_curves


/* Most Recent BV curves */
if object_id('tempdb..#bv_curves') is not null drop table #bv_curves
SELECT [Touch_Type_FK]
	  ,case when [Response_Channel_FK]=1 then 'CALL'
	  when [Response_Channel_FK]=2 then 'CLICK'
	  end as [Response_Channel_FK]
      ,project = (Touch_Name + ' ' + Touch_Name_2 + ' ' + Media_Type)
      ,Media_Type
      ,Touch_Name
      ,Audience_Type_Name
      ,Touch_Type_id
      ,Program_Owner
      ,Touch_Name_2
      ,[Curve_Week]
      ,[Week_Percent]
  into #bv_curves
  FROM Forecasting.Most_Recent_Response_Curve_View as a left join dbo.[Touch Type Human View] as b
  on a.[Touch_Type_FK]=b.Touch_Type_id


if object_id('sandbox.response_curves') is not null drop table sandbox.response_curves
DECLARE @cols AS NVARCHAR(MAX),
    @query  AS NVARCHAR(MAX);

select @cols = STUFF((SELECT distinct ',' + QUOTENAME(c.[Response_Channel_FK]) 
            FROM #bv_curves c
            FOR XML PATH('')),1,1,'')

set @query = 'SELECT [Touch_Type_FK],project,Media_Type,Touch_Name,Audience_Type_Name,Touch_Type_id,Program_Owner,Touch_Name_2,[Curve_Week], ' + @cols + ' 
				into sandbox.response_curves from 
            (
                select [Touch_Type_FK],project,[Response_Channel_FK],Media_Type,Touch_Name,Audience_Type_Name,Touch_Type_id,Program_Owner,Touch_Name_2,[Curve_Week],[Week_Percent]
                from #bv_curves
           ) x
            pivot 
            (
                 max([Week_Percent])
                for [Response_Channel_FK] in (' + @cols + ')
            ) p '


execute(@query)

if object_id('tempdb..#BVresponse_curves') is not null drop table #BVresponse_curves
select [Touch_Type_FK],project,Media_Type,Touch_Name,Audience_Type_Name,Touch_Type_id,Program_Owner,Touch_Name_2,[Curve_Week],
[CALL] as [BV CALL CURVE],
[CLICK] as [BV CLICK CURVE]
into #BVresponse_curves
from sandbox.response_curves
drop table sandbox.response_curves

/*selecting most recent touch types*/
if object_id('tempdb..#mostrecent_touch_types') is not null drop table #mostrecent_touch_types
select project, 
COUNT(distinct touch_type_fk) as touch_type_fk_count 
,max(touch_type_fk) as max_touch_type_fk
into #mostrecent_touch_types
from #BVresponse_curves
group by project
order by COUNT(distinct touch_type_fk) desc

if object_id('tempdb..#mostrecent_response_curves') is not null drop table #mostrecent_response_curves
select * 
into #mostrecent_response_curves
from #BVresponse_curves 
where touch_type_fk in (select max_touch_type_fk
		from #mostrecent_touch_types)
		
--select * from #mostrecent_response_curves

----------------------------------------------------------------------
--Join Actual and BV Response Curves
----------------------------------------------------------------------

--SOMETHING IS NOT RIGHT HERE WHEN JOINING either the actuals together or when putting it all together.
if object_id('tempdb..#Actualresponse_curves') is not null drop table #Actualresponse_curves
select /*coalesce(a.touch_type_fk,b.touch_type_fk) as touch_type_fk
, coalesce(a.touch_name,b.touch_name) as touch_name
, coalesce(a.touch_name_2,b.touch_name_2) as touch_name_2
, coalesce(a.audience_type_name,b.audience_type_name) as audience_type_name
, */coalesce(a.Media_Type,b.Media_Type) as Media_Type
, coalesce(a.program_owner,b.program_owner) as program_owner
, coalesce(a.project,b.project) as project
, coalesce(a.weeks,b.weeks) as [Curve_Week]
, isnull([Actual Calls Percent],0) as [Actual Calls Curve]
, isnull([Actual Clicks Percent],0) as [Actual Clicks Curve]
into #Actualresponse_curves
from #actual_calls_curves as a
	full join #actual_clicks_curves as b
	on (a.project=b.project) and (a.weeks=b.weeks)
	and (a.Program_Owner=b.Program_Owner) and (a.media_type=b.media_type)
--select * from #Actualresponse_curves
--select * from #BVresponse_curves


select /*coalesce(a.touch_type_fk,b.touch_type_fk) as touch_type_fk
, coalesce(a.touch_name,b.touch_name) as touch_name
, coalesce(a.touch_name_2,b.touch_name_2) as touch_name_2
, coalesce(a.audience_type_name,b.audience_type_name) as audience_type_name
, */coalesce(a.Media_Type,b.Media_Type) as Media_Type
, coalesce(a.program_owner,b.program_owner) as program_owner
, coalesce(a.[Curve_Week],b.[Curve_Week]) as [Curve_Week]
, coalesce(a.project,b.project) as project
, isnull([Actual Calls Curve],0) as [Actual Calls Curve]
, isnull([BV CALL CURVE],0) as [BV CALL CURVE]
, isnull([Actual Calls Curve]-[BV CALL CURVE],0) as [Diff Call Curve]

, isnull([Actual Clicks Curve],0) as [Actual Clicks Curve]
, isnull([BV CLICK CURVE],0) as [BV CLICK CURVE]
, isnull([Actual Clicks Curve]-[BV CLICK CURVE],0) as [Diff Click Curve]

from #mostrecent_response_curves as a 
	full join #Actualresponse_curves as b
	on (a.project=b.project) and (a.[Curve_Week]=b.[Curve_Week])
	and (a.media_type=b.Media_Type) and a.program_owner=b.program_owner


/* add in part for daily percents. Forecasting.Response_Curves_Daily*/
/* calls and clicks by weekday */
if object_id('tempdb..#Actual_daily_calls') is not null drop table #Actual_daily_calls
select day
--, sum(calls) as calls
, SUM(calls)/(select SUM(calls) from #daily_calls where calls is not null) as Actual_Calls_percent
into #Actual_daily_calls
from #daily_calls
where calls is not null
group by day
order by day
--select * from #Actual_daily_calls

if object_id('tempdb..#BV_daily_calls') is not null drop table #BV_daily_calls
select case when Curve_Day='Sat' then 'Saturday'
	when Curve_Day='Sun' then 'Sunday'
	when Curve_Day='Mon' then 'Monday'
	when Curve_Day='Tue' then 'Tuesday'
	when Curve_Day='Wed' then 'Wednesday'
	when Curve_Day='Thu' then 'Thursday'
	when Curve_Day='Fri' then 'Friday'
	end as Day
,Day_Percent as BV_Calls_percent
into #BV_daily_calls
from Forecasting.Response_Curves_Daily
where Response_Channel_FK=1
and Entry_Metadata_FK = (select MAX(Entry_Metadata_FK) from Forecasting.Response_Curves_Daily)
group by Curve_Day
,Day_Percent
--select * from #BV_daily_calls

if object_id('tempdb..#Actual_daily_clicks') is not null drop table #Actual_daily_clicks
select day
--, sum(clicks) as clicks
, SUM(clicks)/(select SUM(clicks) from #daily_clicks where clicks is not null) as Actual_clicks_percent
into #Actual_daily_clicks
from #daily_clicks
where clicks is not null
group by day
order by day
--select * from #Actual_daily_clicks

if object_id('tempdb..#BV_daily_clicks') is not null drop table #BV_daily_clicks
select case when Curve_Day='Sat' then 'Saturday'
	when Curve_Day='Sun' then 'Sunday'
	when Curve_Day='Mon' then 'Monday'
	when Curve_Day='Tue' then 'Tuesday'
	when Curve_Day='Wed' then 'Wednesday'
	when Curve_Day='Thu' then 'Thursday'
	when Curve_Day='Fri' then 'Friday'
	end as Day
,Day_Percent as BV_clicks_percent
into #BV_daily_clicks
from Forecasting.Response_Curves_Daily
where Response_Channel_FK=2
and Entry_Metadata_FK = (select MAX(Entry_Metadata_FK) from Forecasting.Response_Curves_Daily)
group by Curve_Day
,Day_Percent
--select * from #BV_daily_clicks

select coalesce(a.day, b.day, c.day, d.day) as day
,a.Actual_Calls_percent
,b.BV_Calls_percent
,a.Actual_Calls_percent-b.BV_Calls_percent as [Diff Call %]
,c.Actual_Clicks_percent
,d.BV_clicks_percent
,c.Actual_clicks_percent-d.BV_clicks_percent as [Diff Click %]
from #Actual_daily_calls as a 
join #BV_daily_calls as b
on a.day=b.Day
join #Actual_daily_clicks as c
on a.day=c.Day
join #BV_daily_clicks as d
on a.day=d.Day