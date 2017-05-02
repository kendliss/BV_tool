CREATE FUNCTION [bvt_prod].[Flightplan_FUN]
(
	@prog int
)
RETURNS TABLE
AS
RETURN (
SELECT 
  * 
from 
  bvt_prod.Flight_Plan_Records
where 
  idProgram_Touch_Definitions_TBL_FK 
    in (select idProgram_Touch_Definitions_TBL 
	from bvt_prod.Program_Touch_Definitions_TBL
	WHERE idProgram_LU_TBL_FK=@PROG)
-------In Home date limitation to prevent excess calculations on old flight plan records
  and inhome_date>='2016-01-01')

