
create proc bvt_processed.KPI_Rate_Start_End_PR 
AS
truncate table bvt_processed.KPI_Rate_Start_End
insert into bvt_processed.KPI_Rate_Start_End
select * from bvt_prod.KPI_Rate_Start_End_VW
