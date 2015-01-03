/* want most recent data
vanity, dates, destination URL */


create view integration.most_recent_vanity_tracking as 
WITH X AS     
(SELECT c.[Scorecard_Top_Tab]
      ,c.[Scorecard_LOB_Tab]
      ,c.[Scorecard_Tab]
      ,c.[Scorecard_Program_Channel]
	  ,a.[Parentid]
      ,[Track_Start_Date]
      ,[Track_End_Date]
      ,a.[URL]
      ,a.[terminating_url]
      ,a.[Source]
      ,rn=row_number() over (partition by URL order by [Track_Start_Date] DESC)
  FROM javdb.[IREPORT].[dbo].[WB_01_URL_List_WB] as a 
  join javdb.[IREPORT].dbo.ir_Workbook_Data as b
	on a.parentid=b.parentid 
  join javdb.[IREPORT].dbo.ir_a_ownertypetactic_matrix as c
      on b.tactic_id=c.id )
select [Scorecard_Top_Tab]
      ,[Scorecard_LOB_Tab]
      ,[Scorecard_Tab]
      ,[Scorecard_Program_Channel]
      ,[Parentid]
      ,[Track_Start_Date]
      ,[Track_End_Date]
      ,[URL]
      ,[terminating_url] 
      ,[Source]
from X
where rn=1
group by [Scorecard_Top_Tab]
      ,[Scorecard_LOB_Tab]
      ,[Scorecard_Tab]
      ,[Scorecard_Program_Channel]
      ,[Parentid]
      ,[Track_Start_Date]
      ,[Track_End_Date]
      ,[URL]
      ,[terminating_url]
      ,[Source]