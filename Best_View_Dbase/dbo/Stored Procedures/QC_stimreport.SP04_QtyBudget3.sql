
create procedure [QC_stimreport.SP04_QtyBudget3] as 
--Look at campaigns that have parentid level data with [Scorecard_TypeC] = NA. qty and budget are 0, then the cell title must have changed to cause a new parentid. 
--If increases or decreases here, then check that the data in the stim report matches to the data in eCRW. Watch for dates when campaigns were last updated in eCRW.
--Remember the deadline is Thurs @ 11 am (agency) and Thurs @ 4 pm (reviewer). Anything after is not guarenteed to make the stim report. 
select [Campaign_Name]
,sum(isnull(total_quantity,0)) as total_quantity
,sum(isnull(total_budget,0)) as total_budget
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW]
where [Campaign_Name] in (select [Campaign_Name] from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] where [Scorecard_TypeC] like 'NA' group by [Campaign_Name])
group by [Campaign_Name]