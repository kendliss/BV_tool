/* 
DMDR TFN list sent each week to Wanda Kosub at AT&T
created by: Brittany
2/13/2014

Updates:

*/

--future month

CREATE PROCEDURE [ecrw].[SP_DMDR_List_future_month] @track_start_date date, @track_end_date date
as

if object_id('[ecrw].[DMDR_List_future_month0]') is not null drop table [ecrw].[DMDR_List_future_month0]
select * into [ecrw].[DMDR_List_future_month0] 
from [ecrw].[DMDR_List_future_month1]

if object_id('[ecrw].[DMDR_List_future_month1]') is not null drop table [ecrw].[DMDR_List_future_month1]
select distinct a.ecrw_campaign_id as [Campaign ID]
,ecrw_campaign_title as [Campaign Name]
,a.parentid as [ParentID]
,ecrw_cell_title as [Cell Name]
,tfn_type_name as tfn_type
,CONVERT(VARCHAR(10),track_start_date, 101) 'track_start_date'
,CONVERT(VARCHAR(10),track_end_date, 101) 'track_end_date'
,cell_tfn as TFN
,case when (a.parentid IN (select parentid
								from [ecrw].[DMDR_List_future_month0] as a 
								group by parentid) 
					and a.cell_tfn not in (select TFN  
								from [ecrw].[DMDR_List_future_month0] as a 
								group by TFN)) 
			OR a.parentid not in (select parentid
								from [ecrw].[DMDR_List_future_month0] as a 
								group by parentid) 
		then 'Yes'						
	else ''
	end as [New TFN]
into [ecrw].[DMDR_List_future_month1]
from javdb.ireport.dbo.eCRW_Final_cells_view a join 
(
	select distinct b.ecrw_campaign_id, track_start_date
	,track_end_date, ecrw_program_title, ecrw_campaign_title
	from javdb.ireport.dbo.eCRW_Final_Program_campaign_view b
	where ecrw_business_unit_name like '%U-verse Live Base%'
) b
on a.ecrw_campaign_id = b.ecrw_campaign_id
where tfn_type_name like '%DMDR%' 
and track_end_date>=@track_end_date
and track_start_date<=@track_start_date
and cell_tfn not like '%9999%'
and cell_tfn is not null
select * from [ecrw].[DMDR_List_future_month1]
order by [New TFN] desc

