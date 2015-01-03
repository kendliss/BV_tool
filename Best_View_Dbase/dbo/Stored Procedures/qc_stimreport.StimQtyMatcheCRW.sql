CREATE procedure [dbo].[qc_stimreport.StimQtyMatcheCRW] as 
select a.[campaign id]
,a.[campaign name]
,a.[parentid]
,a.quantity as [Snapshot Quantity]
,b.total_quantity as [Stim Report Quantity]
,(sum(isnull(total_quantity,0)))-(sum(isnull(a.quantity,0))) as Diff
 from eCRW.weekly_report_data as a 
	left join javdb.ireport_2014.dbo.WB_07_Stim_report as b
	on a.parentid=b.parentid
where total_quantity is not null
group by a.[campaign id]
,a.[campaign name]
,a.[parentid]
,a.quantity
,b.total_quantity
having (sum(isnull(total_quantity,0)))-(sum(isnull(a.quantity,0))) >0
order by (sum(isnull(total_quantity,0)))-(sum(isnull(a.quantity,0))) desc

	