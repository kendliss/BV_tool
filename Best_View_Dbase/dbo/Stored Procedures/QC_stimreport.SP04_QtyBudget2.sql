create procedure [QC_stimreport.SP04_QtyBudget2] as 
--campaign level declines
select [Scorecard_TypeC]
,[Campaign_Name]
,sum(isnull(total_quantity,0)) as total_quantity
,sum(isnull(total_budget,0)) as total_budget
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW]
where total_quantity<0 or total_budget<0
group by [Scorecard_TypeC]
,[Campaign_Name]
order by [Scorecard_TypeC] desc
,sum(isnull(total_quantity,0))
,sum(isnull(total_budget,0))