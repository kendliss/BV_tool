
create proc [bvt_processed].[UCLM_GP_Flight_Plan_PR]
AS
drop table bvt_processed.[UCLM_GP_Flight_Plan]

select * into bvt_processed.[UCLM_GP_Flight_Plan] from bvt_prod.[UCLM_GP_Flight_Plan_VW]

