create procedure [weekly_ops].[SP_OPS_15_UPRO_ProgramNotes_data]
as 

/* this is not useful right now because UPRO is not at the detailed media level for CV*/
if object_id('tempdb..#WOWnotes') is not null drop table #WOWnotes
SELECT a.[Lookup Name]
      ,a.[Scorecard_Program_Channel]
	  ,(convert(varchar(50), (round(
			(((sum(isnull(a.[unapp_quantity],0)))/(sum(nullif(a.[cv_quantity],0))))
							-((sum(isnull(b.[unapp_quantity],0)))/(sum(nullif(b.[cv_quantity],0))))),2)*100))+'%') as [Quantity % to CV]
	  ,(convert(varchar(50), (round(
			(((sum(isnull(a.[calls],0)))/(sum(nullif(a.[cv_calls],0))))
							-((sum(isnull(b.[calls],0)))/(sum(nullif(b.[cv_calls],0))))),2)*100))+'%') as [Calls % to CV]
	  ,(convert(varchar(50), (round(
			(((sum(isnull(a.[clicks],0)))/(sum(nullif(a.[cv_clicks],0))))
							-((sum(isnull(b.[clicks],0)))/(sum(nullif(b.[cv_clicks],0))))),2)*100))+'%') as [Clicks % to CV]							
	  ,(convert(varchar(50), (round(
			(((sum(isnull(a.[strategic_sales],0)))/(sum(nullif(a.[CV_strat_sales],0))))
							-((sum(isnull(b.[strategic_sales],0)))/(sum(nullif(b.[CV_strat_sales],0))))),2)*100))+'%') as [Strat. Sales % to CV]								
	  ,(convert(varchar(50), (round(
			(((sum(isnull(a.[uvtv_sales],0)))/(sum(nullif(a.[CV_tv_sales],0))))
							-((sum(isnull(b.[uvtv_sales],0)))/(sum(nullif(b.[CV_tv_sales],0))))),2)*100))+'%') as [UVTV Sales % to CV]								
  into #WOWnotes
  FROM [UVAQ].[weekly_ops].[OPS_02_UPRO_currentweek] as a
	join [weekly_ops].[OPS_04_UPRO_previousweek] as b
	on (a.[Lookup Name]=b.[Lookup Name] and a.Scorecard_Program_Channel=b.Scorecard_Program_Channel)
  where a.Scorecard_Program_Channel not like '%D2R%'
	and a.Scorecard_Program_Channel not like '%drag%'
  group by a.[Lookup Name]
      ,a.[Scorecard_Program_Channel]
      
if object_id('tempdb..#WOWnotes2') is not null drop table #WOWnotes2
 select [Lookup Name]
,([Lookup Name]+' ('+[Calls % to CV]+')' )as [Directed Calls]
,([Lookup Name]+' ('+[Clicks % to CV]+')' )as [Directed Online Responses]
,([Lookup Name]+' ('+[Strat. Sales % to CV]+')' )as [Directed Strategic Sales]
,([Lookup Name]+' ('+[UVTV Sales % to CV]+')' )as [Directed UVTV Sales]
into #WOWnotes2
 from #WOWnotes
alter table #WOWnotes2
 add [Program] varchar(max)
update #WOWnotes2
 set [Program]='UPRO'

if object_id('tempdb..#OPS_15_UPRO_Program_Level_Notes') is not null drop table #OPS_15_UPRO_Program_Level_Notes
create table #OPS_15_UPRO_Program_Level_Notes
 ([Program] varchar(max),
 [Directed Calls Notes] varchar(max),
 [Directed Online Responses Notes] varchar(max),
 [Directed Strategic Sales Notes] varchar(max),
 [Directed TV Sales Notes] varchar(max),);
 
 insert into #OPS_15_UPRO_Program_Level_Notes ([Program], [Directed Calls Notes])
  SELECT A.[Program], 
            (SELECT DISTINCT RTRIM(B.[Directed Calls]) + ', ' FROM #WOWnotes2 B WHERE B.[Program] = A.[Program] FOR XML PATH('')) 'Directed Calls Notes'
            FROM #WOWnotes2 A
            WHERE A.[Program] IS NOT NULL
            GROUP BY A.[Program]
  
  insert into #OPS_15_UPRO_Program_Level_Notes ([Program], [Directed Online Responses Notes])
  SELECT A.[Program], 
            (SELECT DISTINCT RTRIM(B.[Directed Online Responses]) + ', ' FROM #WOWnotes2 B WHERE B.[Program] = A.[Program] FOR XML PATH('')) 'Directed Clicks Notes'
            FROM #WOWnotes2 A
            WHERE A.[Program] IS NOT NULL
            GROUP BY A.[Program]   
  
  insert into #OPS_15_UPRO_Program_Level_Notes ([Program], [Directed Strategic Sales Notes])
  SELECT A.[Program], 
            (SELECT DISTINCT RTRIM(B.[Directed Strategic Sales]) + ', ' FROM #WOWnotes2 B WHERE B.[Program] = A.[Program] FOR XML PATH('')) 'Directed Strategic Sales Notes'
            FROM #WOWnotes2 A
            WHERE A.[Program] IS NOT NULL
            GROUP BY A.[Program]                                                                              

  insert into #OPS_15_UPRO_Program_Level_Notes ([Program], [Directed TV Sales Notes])
  SELECT A.[Program], 
            (SELECT DISTINCT RTRIM(B.[Directed UVTV Sales]) + ', ' FROM #WOWnotes2 B WHERE B.[Program] = A.[Program] FOR XML PATH('')) 'Directed TV Sales Notes'
            FROM #WOWnotes2 A
            WHERE A.[Program] IS NOT NULL
            GROUP BY A.[Program]                                                                              
                                 
 if object_id('weekly_ops.OPS_15_UPRO_Program_Level_Notes') is not null drop table weekly_ops.OPS_14_UVLB_Program_Level_Notes                                                                   
 select program
 ,max([Directed Calls Notes]) as [Directed Calls]
 ,max([Directed Online Responses Notes]) as [Directed Online]
 ,max([Directed Strategic Sales Notes]) as [Directed Strategic Sales]
 ,max([Directed TV Sales Notes]) as [Directed UVTV Sales]
 into weekly_ops.OPS_15_UPRO_Program_Level_Notes
  from #OPS_15_UPRO_Program_Level_Notes
  group by program
select * from weekly_ops.OPS_15_UPRO_Program_Level_Notes
