CREATE TABLE [bvt_prod].[Touch_Managers_TBL]
(
	[idTouch_Managers] INT NOT NULL identity(1,1) PRIMARY KEY, 
    [idProgram_Touch_Definitions_TBL_FK] INT NOT NULL, 

    [idManagers_FK] INT NOT NULL, 
    [Start_Date] DATE NOT NULL, 
    CONSTRAINT [FK_Touch_Managers_TBL_Program_touch_Def_TBL] FOREIGN KEY (idprogram_touch_definitions_TBL_fk) REFERENCES bvt_prod.Program_Touch_Definitions_TBL(idProgram_Touch_Definitions_TBL), 
    CONSTRAINT [FK_Touch_Managers_TBL_Managers] FOREIGN KEY (idManagers_FK) REFERENCES bvt_prod.Managers_LU_TBL(idManagers)
)

GO
