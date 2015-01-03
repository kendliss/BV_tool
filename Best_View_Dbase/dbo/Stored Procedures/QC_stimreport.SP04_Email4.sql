
CREATE procedure [dbo].[QC_stimreport.SP04_Email4] as 
--Check for quantity delivered, opens and opt outs declines
select [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description] as [Cell Title]
,a.[ParentID]
,b.[Source_Code_Ext]
,ytd_clicks
,ytd_quantity_delivered
,ytd_unique_opens
,ytd_opt_outs
,Share#
from [javdb].[IREPORT_2014].[dbo].[WB_07_Stim_Report_WOW] as a 
	left join [javdb].[IREPORT_2014].[dbo].[WB_01_SourceCode_List_WB] as b
	on a.[ParentID]=b.[ParentID]
	left join (select [Source_Code_Ext], count(parentid)as Share# from [javdb].[IREPORT_2014].[dbo].[WB_01_SourceCode_List_WB] where [Source_Code_Ext] is not null group by [Source_Code_Ext]) as c
	on b.[Source_Code_Ext]=c.[Source_Code_Ext]
where (ytd_clicks<0 or ytd_quantity_delivered<0 or ytd_unique_opens <0 or ytd_opt_outs<0)  
and [Scorecard_TypeC] like '%Uverse Base Acq%'
and a.placementname like '%att.com/uverse%'
group by [Scorecard_TypeC]
,[Campaign_Name]
,[TFN_Description]
,a.[ParentID]
,b.[Source_Code_Ext]
,ytd_clicks
,ytd_quantity_delivered
,ytd_unique_opens
,ytd_opt_outs
,Share#