
create procedure [weekly_ops].[SP_OPS_17_UPRO_Overall_data]
as 
if object_id('tempdb..#WOWnotes') is not null drop table #WOWnotes
SELECT (convert(varchar(50), (round(
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

alter table #WOWnotes
 add [Program] varchar(max)
update #WOWnotes
 set [Program]='UPRO'
select * from #WOWnotes