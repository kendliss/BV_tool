Drop Proc [bvt_prod].[DeleteTouchType]
GO

CREATE PROC [bvt_prod].[DeleteTouchType]
	@Touch_Type Varchar(10)

AS


/*To Delete Touch Types in new tool 

Will error out if there are flight plan records, budgets, or volumes, or Manual CPP records. Can run supplemental code at bottom is still want deleted.

Will delete all metrics and touch type.

*/

Delete  bvt_prod.KPI_Rates
where idProgram_Touch_Definitions_TBL_FK = @Touch_Type

Delete  bvt_prod.Response_Curve
where idProgram_Touch_Definitions_TBL_FK = @Touch_Type

Delete  bvt_prod.Response_Daily
where idProgram_Touch_Definitions_TBL_FK = @Touch_Type

Delete  bvt_prod.Sales_Rates
where idProgram_Touch_Definitions_TBL_FK = @Touch_Type

Delete  bvt_prod.Sales_Curve
where idProgram_Touch_Definitions_TBL_FK = @Touch_Type

Delete  bvt_prod.CPP
where idProgram_Touch_Definitions_TBL_FK = @Touch_Type

Delete  bvt_prod.Seasonality_Adjustements
where idProgram_Touch_Definitions_TBL_FK = @Touch_Type

Delete  bvt_prod.Target_Rate_Adjustments
where idProgram_Touch_Definitions_TBL_FK = @Touch_Type

Delete  bvt_prod.Drop_Date_Calc_Rules
where idProgram_Touch_Definitions_TBL_FK = @Touch_Type

Delete bvt_scenario.Drop_Date_Calc_Rules
where idProgram_Touch_Definitions_TBL_FK = @Touch_Type

Delete bvt_scenario.KPI_Rates
where idProgram_Touch_Definitions_TBL_FK = @Touch_Type

Delete bvt_scenario.Response_Curve
where idProgram_Touch_Definitions_TBL_FK = @Touch_Type

Delete bvt_scenario.Response_Daily
where idProgram_Touch_Definitions_TBL_FK = @Touch_Type

Delete bvt_scenario.Sales_Rates
where idProgram_Touch_Definitions_TBL_FK = @Touch_Type

Delete bvt_scenario.Sales_Curve
where idProgram_Touch_Definitions_TBL_FK = @Touch_Type

Delete bvt_scenario.CPP
where idProgram_Touch_Definitions_TBL_FK =@Touch_Type

Delete bvt_scenario.Seasonality_Adjustements
where idProgram_Touch_Definitions_TBL_FK = @Touch_Type

Delete bvt_scenario.Target_Rate_Adjustments
where idProgram_Touch_Definitions_TBL_FK = @Touch_Type


Delete  bvt_prod.Program_Touch_Definitions_TBL
where idProgram_Touch_Definitions_TBL = @Touch_Type



GO


