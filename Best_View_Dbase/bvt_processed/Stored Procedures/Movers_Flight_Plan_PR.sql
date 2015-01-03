
create proc [bvt_processed].[Movers_Flight_Plan_PR]
AS
drop table bvt_processed.[Movers_Flight_Plan]

select * into bvt_processed.[Movers_Flight_Plan] from bvt_prod.[Movers_Flight_Plan_VW]

