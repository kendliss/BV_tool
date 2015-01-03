
create view Results.UVAQ_LB_2012_Volume_Budget
as select SUM(CTD_Quantity) as Volume, SUM(CTD_Budget) as Budget, B.ParentID, B.Touch_Type_FK, A.CTD_Start_Date as [Start_Tracking_Date], 
	report_week, mediamonth_year
from JAVDB.IREPORT.dbo.IR_Campaign_Data_Latest_MAIN_2012 as A
INNER JOIN Results.ParentID_Touch_Type_Link as B
ON A.ParentID=B.ParentID
INNER JOIN DIM.Media_Calendar_Daily as C 
ON A.CTD_Start_Date=c.[DATE]
WHERE A.Flag_Latest_Week='Y'
GROUP BY B.ParentID, B.Touch_Type_FK, A.CTD_Start_Date, report_week, mediamonth_year