

CREATE procedure [weekly_ops].[SP_OPS_13_UPRO_Notes_data]
as 
if object_id('tempdb..#notes_data') is not null drop table #notes_data
select case when b.id = 255 then 'U-verse Base Acq - DM - Hisp'
		when (a.vendor like '%dieste%' and a.Campaign_Parent_Name like '%hisp%') then 'U-verse Base Acq - DM - Hisp'
	    when ((b.id = 51 and (a.Campaign_Parent_Name like '%HISP%' or a.Campaign_Parent_Name like '%SPANISH%')) or a.Campaign_Parent_Name like '%Aug Cat Control 5%') then  'U-verse Base Acq - Catalog - Hisp'
	else b.Scorecard_Program_Channel
	end as Scorecard_Program_Channel,b.id as tactic_id
,a.media_code
,case when a.vendor like '%dieste%' then 'Y' --hispanic actuals
	when b.id = 255 then 'Y' --hispanic CV
	else 'N'
	end as hisp_ind
,a.parentid
,case when a.ecrw_project_name is null then a.Campaign_Parent_Name
	else a.ecrw_project_name
	end as ecrw_project_name
,a.Campaign_Parent_Name
,max(In_Home_Date) as In_Home_Date
,case when a.Campaign_Parent_Name like '%over%' then 0
		else sum(isnull(ITP_Quantity_UnApp,0))
		end as unapp_quantity
,sum(isnull(ITP_Dir_Calls,0)) as ITP_Dir_Calls
,sum(isnull(ITP_Dir_Clicks,0)) as ITP_Dir_Clicks
,sum(isnull(CTD_Dir_Calls,0)) as CTD_Dir_Calls
,sum(isnull(CTD_Dir_Clicks,0)) as CTD_Dir_Clicks
,sum(isnull(Goal_ITP_Dir_Calls,0)) as Goal_ITP_Dir_Calls
,sum(isnull(Goal_ITP_Dir_Clicks,0)) as Goal_ITP_Dir_Clicks
,sum(isnull(Goal_CTD_Dir_Calls,0)) as Goal_CTD_Dir_Calls
,sum(isnull(Goal_CTD_Dir_Clicks,0)) as Goal_CTD_Dir_Clicks
into #notes_data
from javdb.ireport_2014.dbo.IR_Workbook_Data as a
	join javdb.ireport_2014.dbo.ir_a_ownertypetactic_matrix as b
      on a.tactic_id=b.id
where b.Scorecard_Top_Tab = 'Direct Marketing'
and b.Scorecard_LOB_Tab = 'U-verse'
and b.Scorecard_tab = 'Prospect'
and b.Scorecard_Program_Channel like '%U-verse%'
and a.parentid not in (181100) --a.Campaign_Parent_Name not like '%JUN13_UPRO_D2D_DetroitDoorHanger%' (parentid = 181100) so we do not pull in Prospect. Not sure why they are showing up LB.
and b.Scorecard_Program_Channel not like '%social%'
and b.Scorecard_Program_Channel not like '%prospect%'
and a.reportweek_yyyyww = (select (ReportCycle_YYYYWW) from javdb.[IREPORT_2014].[dbo].[wb_00_reporting_cycle] group by ReportCycle_YYYYWW)
and excludefromscorecard <> 'Y'
group by b.Scorecard_Program_Channel
,a.media_code
,a.Campaign_Parent_Name
,a.parentid
,a.ecrw_project_name
,a.vendor
,b.id
order by b.Scorecard_Program_Channel
,a.media_code
,a.Campaign_Parent_Name
,a.parentid
,a.ecrw_project_name
,a.vendor
,b.id

/* calls and clicks notes */
if object_id('tempdb..#notes_data2') is not null drop table #notes_data2
select Scorecard_Program_Channel
, ecrw_project_name
, datediff(d, In_Home_Date, 
			(select end_date 
				from javdb.ireport_2014.dbo.WB_00_Media_Calendar_Weekly 
				where ReportWeek_YYYYWW = (select (ReportCycle_YYYYWW) from javdb.[IREPORT_2014].[dbo].[wb_00_reporting_cycle] group by ReportCycle_YYYYWW))) as days_in_home
, round(sum(isnull(ITP_Dir_Calls,0)),0) as ITP_Dir_Calls
, round(sum(isnull(ITP_Dir_Clicks,0)),0) as ITP_Dir_Clicks
, round(sum(isnull(CTD_Dir_Calls,0)),0) as CTD_Dir_Calls
, round(sum(isnull(CTD_Dir_Clicks,0)),0) as CTD_Dir_Clicks
, round(sum(isnull(Goal_ITP_Dir_Calls,0)),0) as Goal_ITP_Dir_Calls
, round(sum(isnull(Goal_ITP_Dir_Clicks,0)),0) as Goal_ITP_Dir_Clicks
, round(sum(isnull(Goal_CTD_Dir_Calls,0)),0) as Goal_CTD_Dir_Calls
, round(sum(isnull(Goal_CTD_Dir_Clicks,0)),0) as Goal_CTD_Dir_Clicks
--formulas
, convert(varchar(50), (round((sum(isnull(CTD_Dir_Calls,0)))/(sum(nullif(Goal_CTD_Dir_Calls,0))),2)*100))+'%'  as [CTD Calls % to Forecast]
, convert(varchar(50), (round((sum(isnull(CTD_Dir_Clicks,0)))/(sum(nullif(Goal_CTD_Dir_Clicks,0))),2)*100))+'%'  as [CTD Clicks % to Forecast]
into #notes_data2
 from #notes_data
 where Scorecard_Program_Channel not like '%D2R%'
 and Scorecard_Program_Channel not like '%drag%'
 and ecrw_project_name not like '%objectives%'
 group by Scorecard_Program_Channel
, ecrw_project_name
, In_Home_Date
order by ITP_Dir_Calls desc
, Scorecard_Program_Channel
, ecrw_project_name
, In_Home_Date 

if object_id('tempdb..#notes_data2b') is not null drop table #notes_data2b
select t1.Scorecard_Program_Channel, t2.ecrw_project_name
, t2.days_in_home
, t2.ITP_Dir_Calls
, t2.ITP_Dir_Clicks
, t2.CTD_Dir_Calls
, t2.CTD_Dir_Clicks
, t2.Goal_CTD_Dir_Calls
, t2.Goal_CTD_Dir_Clicks
, t2.[CTD Calls % to Forecast]
, t2.[CTD Clicks % to Forecast]
into #notes_data2b
from (select distinct Scorecard_Program_Channel from #notes_data) as t1
cross apply (select top 3 
 t2.Scorecard_Program_Channel
, t2.ecrw_project_name
, t2.days_in_home
, t2.ITP_Dir_Calls
, t2.ITP_Dir_Clicks
, t2.CTD_Dir_Calls
, t2.CTD_Dir_Clicks
, t2.Goal_CTD_Dir_Calls
, t2.Goal_CTD_Dir_Clicks
, t2.[CTD Calls % to Forecast]
, t2.[CTD Clicks % to Forecast]
 from #notes_data2
 as t2 where t2.Scorecard_Program_Channel=t1.Scorecard_Program_Channel)as t2
 
 if object_id('tempdb..#notes_data2c') is not null drop table #notes_data2c
 select 
 Scorecard_Program_Channel
 ,(ecrw_project_name+' ('+convert(varchar(12),ITP_Dir_Calls,101)+'; '+convert(varchar(12),[CTD Calls % to Forecast],101)+'; '+convert(varchar(12),days_in_home,101)+')' )as [Calls Notes]
 ,(ecrw_project_name+' ('+convert(varchar(12),ITP_Dir_Clicks,101)+'; '+convert(varchar(12),[CTD Clicks % to Forecast],101)+'; '+convert(varchar(12),days_in_home,101)+')' )as [Clicks Notes]
into #notes_data2c
 from #notes_data2b
 alter table #notes_data2c
 add [Calls_Notes] varchar(max)
 alter table #notes_data2c
 add [Clicks_Notes] varchar(max)
 

;with concatenation(Scorecard_Program_Channel, [Calls Notes]) as
(select a.Scorecard_Program_Channel,
 (select distinct RTRIM(b.[Calls Notes])+'; ' 
	from #notes_data2c B where b.Scorecard_Program_Channel=a.Scorecard_Program_Channel
	 FOR XML PATH('')) 'Calls Notes'
	from #notes_data2c A
	where a.Scorecard_Program_Channel IS NOT NULL
	group by a.Scorecard_Program_Channel)
update #notes_data2c
set [Calls_Notes] = LEFT(t.[Calls Notes],LEN(t.[Calls Notes])-1)
from #notes_data2c c inner join concatenation t on (c.Scorecard_Program_Channel=t.Scorecard_Program_Channel AND t.[Calls Notes] <>'')


;with concatenation(Scorecard_Program_Channel, [clicks Notes]) as
(select a.Scorecard_Program_Channel,
 (select distinct RTRIM(b.[clicks Notes])+'; ' 
	from #notes_data2c B where b.Scorecard_Program_Channel=a.Scorecard_Program_Channel
	 FOR XML PATH('')) 'clicks Notes'
	from #notes_data2c A
	where a.Scorecard_Program_Channel IS NOT NULL
	group by a.Scorecard_Program_Channel)
update #notes_data2c
set [clicks_Notes] = LEFT(t.[clicks Notes],LEN(t.[clicks Notes])-1)
from #notes_data2c c inner join concatenation t on (c.Scorecard_Program_Channel=t.Scorecard_Program_Channel AND t.[clicks Notes] <>'')


/* quantity notes */
if object_id('tempdb..#qty_notes') is not null drop table #qty_notes
select Scorecard_Program_Channel
, ecrw_project_name
, round(sum(isnull(unapp_quantity,0)),0) as unapp_quantity
 into #qty_notes
 from #notes_data
 where Scorecard_Program_Channel not like '%D2R%'
 and Scorecard_Program_Channel not like '%drag%'
 and ecrw_project_name not like '%objectives%'
 and unapp_quantity>0
 group by Scorecard_Program_Channel
 , ecrw_project_name
order by unapp_quantity desc


if object_id('tempdb..#qty_notes2') is not null drop table #qty_notes2
select t1.Scorecard_Program_Channel
, t2.ecrw_project_name
, t2.unapp_quantity
into #qty_notes2
from (select distinct Scorecard_Program_Channel from #notes_data) as t1
cross apply (select top 2 
 t2.Scorecard_Program_Channel
, t2.ecrw_project_name
, t2.unapp_quantity
 from #qty_notes
 as t2 where t2.Scorecard_Program_Channel=t1.Scorecard_Program_Channel)as t2

if object_id('tempdb..#qty_notes3') is not null drop table #qty_notes3
 select 
 Scorecard_Program_Channel
 ,(ecrw_project_name+' ('+replace(convert(varchar(20),cast(unapp_quantity as money),1),'.00','')+')' )as [Quantity Notes]
into #qty_notes3
 from #qty_notes2
alter table #qty_notes3
 add [Quantity_Notes] varchar(max)
 
;with concatenation(Scorecard_Program_Channel, [Quantity Notes]) as
(select a.Scorecard_Program_Channel,
 (select distinct RTRIM(b.[Quantity Notes])+'; ' 
	from #qty_notes3 B where b.Scorecard_Program_Channel=a.Scorecard_Program_Channel
	 FOR XML PATH('')) 'clicks Notes'
	from #qty_notes3 A
	where a.Scorecard_Program_Channel IS NOT NULL
	group by a.Scorecard_Program_Channel)
update #qty_notes3
set [Quantity_Notes] = LEFT(t.[Quantity Notes],LEN(t.[Quantity Notes])-1)
from #qty_notes3 c inner join concatenation t on (c.Scorecard_Program_Channel=t.Scorecard_Program_Channel AND t.[Quantity Notes] <>'')


/* combine calls, clicks, and quantity notes */
if object_id('weekly_ops.OPS_13_UPRO_Notes') is not null drop table weekly_ops.OPS_13_UPRO_Notes
select case 
	when a.Scorecard_Program_Channel = 'U-verse Prospect - Catalog' then 'Catalog'
	when a.Scorecard_Program_Channel = 'U-verse Prospect - DM' then 'Direct Mail'
	when a.Scorecard_Program_Channel = 'U-verse Prospect - Direct Digital' then 'Digital Direct'
	when a.Scorecard_Program_Channel = 'U-verse Prospect - Program Level' then 'Program Level'
	when a.Scorecard_Program_Channel = 'U-verse Prospect - Doorhanger' then 'Door Hanger'	
		else 'NEW!'
	end as [Lookup Name]
	,a.Scorecard_Program_Channel, calls_notes, clicks_notes, [Quantity_Notes]
	into weekly_ops.OPS_13_UPRO_Notes
	from #notes_data2c as a left join #qty_notes3 as b
		on a.Scorecard_Program_Channel=b.Scorecard_Program_Channel
	group by a.Scorecard_Program_Channel, calls_notes, clicks_notes, [Quantity_Notes]
select * from weekly_ops.OPS_13_UPRO_Notes

