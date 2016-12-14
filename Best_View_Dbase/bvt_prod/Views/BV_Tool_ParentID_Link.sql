

CREATE view [bvt_prod].[BV_Tool_ParentID_Link]
as

Select * from bvt_prod.External_ID_linkage_TBL a
JOIN bvt_prod.External_ID_linkage_TBL_has_Flight_Plan_Records b
on a.idExternal_ID_linkage_TBL = b.idExternal_ID_linkage_TBL_FK
JOIN bvt_prod.Flight_Plan_Records c
on b.idFlight_Plan_Records_FK = c.idFlight_Plan_Records
JOIN bvt_Prod.Touch_Definition_VW d
on d.idProgram_Touch_Definitions_TBL = c.idProgram_Touch_Definitions_TBL_FK




GO


