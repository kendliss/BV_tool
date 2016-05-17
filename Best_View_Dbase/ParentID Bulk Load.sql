
Begin tran

INSERT INTO  UVAQ.bvt_prod.External_ID_linkage_TBL
(Source_System_ID, idSource_System_LU_FK, idSource_Field_Name_LU_FK)
SELECT NewValueVarchar, 1, 1 
FROM bvt_staging.BulkUpdates


begin tran
INSERT INTO UVAQ.bvt_prod.External_ID_linkage_TBL_has_Flight_Plan_Records
(idExternal_ID_linkage_TBL_FK, idFlight_Plan_Records_FK)
SELECT idExternal_ID_linkage_TBL, UniqueID
	FROM UVAQ.bvt_prod.External_ID_linkage_TBL
	INNER JOIN bvt_staging.BulkUpdates a
	ON source_system_id=a.NewValueVarchar
	WHERE idExternal_ID_linkage_TBL NOT IN (SELECT idExternal_ID_linkage_TBL_FK FROM UVAQ.bvt_prod.External_ID_linkage_TBL_has_Flight_Plan_Records)
	AND (UniqueID>0 OR UniqueID IS NOT NULL)


END





GO


commit tran