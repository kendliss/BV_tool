create procedure [QC_stimreport.SP04_QtyBudget1] as 
--parentid level declines
select [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description] as [Cell Title]
,[ParentID]
,total_quantity
,total_budget
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW]
where total_quantity<0 or total_budget<0
group by [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description]
,[ParentID]
,total_quantity
,total_budget
order by [Scorecard_TypeC] desc
,total_quantity
,total_budget
