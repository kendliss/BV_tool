create proc bvt_processed.CPP_Start_End_PR 
AS
truncate table bvt_processed.CPP_Start_End
insert into bvt_processed.CPP_Start_End
(idProgram_Touch_Definitions_TBL_FK, idCPP_Category_FK, CPP, Minimum_volume, Maximum_Volume, Bill_timing, CPP_Start_Date, END_DATE)
select * from bvt_prod.CPP_Start_End_VW
