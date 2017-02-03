
ALTER View bvt_prod.CLM_Revenue_GRE
AS

Select Lookup_Value, 
Project_ID, 
ParentID, 
Tracking_Completed, 
eCrw_Project_Name, 
a.Campaign_Name, 
Media, 
b.Campaign_Name AS BV_Campaign, 
b.Offer, 
Start_Date, 
Start_Month, 
Start_Year, 
Volume, 
Calls, 
Clicks, 
QR_Scans, 
Opens, 
Strat_Call_Sales, 
Strat_Online_Sales,
Total_Call_Sales, 
Total_Online_Sales, 
CASE WHEN Volume <> 0 THEN Opens/Volume ELSE 0 END as Open_Rate, 
CASE WHEN Volume <> 0 THEN Calls/Volume ELSE 0 END as Call_RR, 
CASE WHEN Goal_Calls <> 0 THEN Calls/Goal_Calls ELSE 0 END as 'Call_RR_%_to_Obv', 
CASE WHEN Volume <> 0 THEN Clicks/Volume ELSE 0 END as Click_RR, 
CASE WHEN Goal_Clicks <> 0 THEN Clicks/Goal_Clicks ELSE 0 END as 'Click_RR_%_to_Obv', 
CASE WHEN Volume <> 0 THEN (Calls+Clicks)/Volume ELSE 0 END as DRR,
CASE WHEN (Goal_Calls+Goal_Clicks)<> 0 THEN (Calls+Clicks)/(Goal_Calls+Goal_Clicks) ELSE 0 END as 'DRR_RR_%_to_Obv',
CASE WHEN Calls <> 0 THEN Total_Call_Sales/Calls ELSE 0 END AS Call_CR,
CASE WHEN Clicks <> 0 THEN Total_Online_Sales/Clicks ELSE 0 END as Click_CR,
CASE WHEN Volume <> 0 THEN (Strat_Call_Sales+Strat_Online_Sales)/Volume ELSE 0 END AS Strat_SR,
CASE WHEN Volume <> 0 THEN (Total_Call_Sales+Total_Online_Sales)/Volume ELSE 0 END AS Total_SR,
LTV_ITP_Directed AS Directed_LTV, 
Budget,
CASE WHEN Budget <> 0 THEN LTV_ITP_Directed/Budget ELSE 0 END as 'Directed_LTV/E',
CASE WHEN Volume <> 0 THEN Budget/Volume ELSE 0 END as CPP,
CASE WHEN (Total_Call_Sales+Total_Online_Sales) <> 0 THEN Budget/(Total_Call_Sales+Total_Online_Sales) ELSE 0 END AS CPS,
CASE WHEN Calls <> 0 THEN Budget/Calls ELSE 0 END as CPC,
Goal_Calls,
Goal_Clicks

from bvt_prod.CLM_Revenue_GRE_Raw_Data a
JOIN (Select DISTINCT Source_System_ID, Campaign_Name, Touch_Name, Offer from bvt_prod.External_ID_linkage_TBL a
JOIN bvt_prod.External_ID_linkage_TBL_has_Flight_Plan_Records b
on a.idExternal_ID_linkage_TBL = b.idExternal_ID_linkage_TBL_FK
JOIN bvt_prod.Flight_Plan_Records c
on b.idFlight_Plan_Records_FK = c.idFlight_Plan_Records
JOIN bvt_Prod.Touch_Definition_VW d
on d.idProgram_Touch_Definitions_TBL = c.idProgram_Touch_Definitions_TBL_FK) b
on a.ParentID = b.Source_System_ID
