create proc bvt_processed.Dropdate_Start_End_PR 
AS
truncate table bvt_processed.Dropdate_Start_End
insert into bvt_processed.Dropdate_Start_End

select * from bvt_prod.Dropdate_Start_End_VW
