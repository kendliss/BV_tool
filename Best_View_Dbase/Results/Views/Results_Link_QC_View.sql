
create view Results.Results_Link_QC_View with schemabinding
as select 
A.ParentID,
A.Touch_Type_FK,
B.Campaign_Name,
B.[Start_Date],
Media_Scorecard,
Vendor
FROM Results.ParentID_Touch_Type_Link as A INNER JOIN
Results.UVAQ_LB_2012_Active_Campaigns as B
ON A.ParentID=B.ParentID
where Campaign_Name not like '%T3%' or Campaign_Name not like '%T4%'