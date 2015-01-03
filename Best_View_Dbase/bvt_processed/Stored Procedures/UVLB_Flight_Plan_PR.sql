

create proc [bvt_processed].[UVLB_Flight_Plan_PR]
AS
drop table bvt_processed.[UVLB_Flight_Plan]

select * into bvt_processed.[UVLB_Flight_Plan] from bvt_prod.[UVLB_Flight_Plan_VW]


