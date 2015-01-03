CREATE TABLE [bvt_prod].[Target_Rate_Adjustments] (
    [idTarget_Rate_Adjustments]          INT        IDENTITY (1, 1) NOT NULL,
    [idTarget_Rate_Reasons_LU_TBL_FK]    INT        NOT NULL,
    [idProgram_Touch_Definitions_TBL_FK] INT        NOT NULL,
    [Rate_Adjustment_Factor]             FLOAT (53) NULL,
    [Adj_Start_Date]                     DATETIME   NULL,
    [Volume_Adjustment]                  FLOAT (53) NULL,
    PRIMARY KEY CLUSTERED ([idTarget_Rate_Adjustments] ASC),
    FOREIGN KEY ([idProgram_Touch_Definitions_TBL_FK]) REFERENCES [bvt_prod].[Program_Touch_Definitions_TBL] ([idProgram_Touch_Definitions_TBL]),
    FOREIGN KEY ([idTarget_Rate_Reasons_LU_TBL_FK]) REFERENCES [bvt_prod].[Target_Rate_Reasons_LU_TBL] ([idTarget_Rate_Reasons_LU_TBL])
);


GO
CREATE NONCLUSTERED INDEX [Target_Rate_Adjustments_FKIndex2]
    ON [bvt_prod].[Target_Rate_Adjustments]([idProgram_Touch_Definitions_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_90]
    ON [bvt_prod].[Target_Rate_Adjustments]([idProgram_Touch_Definitions_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_91]
    ON [bvt_prod].[Target_Rate_Adjustments]([idTarget_Rate_Reasons_LU_TBL_FK] ASC);

