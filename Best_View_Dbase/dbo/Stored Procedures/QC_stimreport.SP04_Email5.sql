
CREATE procedure [dbo].[QC_stimreport.SP04_Email5] as 
--Check for quantity delivered, opens and opt outs increases
select a.[Scorecard_TypeC]
,d.start_date
,a.[Campaign_Name]
,a.[TFN_Description] as [Cell Title]
,a.[ParentID]
--,b.[Source_Code_Ext]
,a.ytd_clicks
,a.ytd_quantity_delivered
,a.ytd_unique_opens
,a.ytd_opt_outs
,Share#
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] as a 
	left join [javdb].[IREPORT_2014].[dbo].[WB_01_SourceCode_List_WB] as b
	on a.[ParentID]=b.[ParentID]
	left join (select [Source_Code_Ext], count(parentid)as Share# from [javdb].[IREPORT_2014].[dbo].[WB_01_SourceCode_List_WB] where [Source_Code_Ext] is not null group by [Source_Code_Ext]) as c
	on b.[Source_Code_Ext]=c.[Source_Code_Ext]
	left join [javdb].[IREPORT_2014].[dbo].WB_07_Stim_report as d
	on a.[ParentID]=d.[ParentID]
where (a.ytd_quantity_delivered>0 or a.ytd_unique_opens >0 or a.ytd_opt_outs>0)
--and [Scorecard_TypeC] like '%Uverse Base Acq%'
group by a.[Scorecard_TypeC]
,d.start_date
,a.[Campaign_Name]
,a.[TFN_Description]
,a.[ParentID]
--,b.[Source_Code_Ext]
,a.ytd_clicks
,a.ytd_quantity_delivered
,a.ytd_unique_opens
,a.ytd_opt_outs
,Share#
order by a.ytd_clicks desc
,a.ytd_quantity_delivered desc
,a.ytd_unique_opens desc
,a.ytd_opt_outs desc