drop function [bvt_prod].[Program_ID_Selector]
GO

create function [bvt_prod].[Program_ID_Selector] (@PROGRAM_ID int)
RETURNS TABLE AS
RETURN (select idProgram_Touch_Definitions_TBL 
	from bvt_prod.Program_Touch_Definitions_TBL as a
		inner join bvt_prod.Program_LU_TBL as b 
			on a.idProgram_LU_TBL_FK=b.idProgram_LU_TBL
	where b.idProgram_LU_TBL = @PROGRAM_ID)


GO


