CREATE TABLE [bvt_processed].[Target_Adjustment_Start_End] (
    [idProgram_Touch_Definitions_TBL_FK] INT        NOT NULL,
    [idTarget_Rate_Reasons_LU_TBL_FK]    INT        NOT NULL,
    [Rate_Adjustment_Factor]             FLOAT (53) NULL,
    [Volume_Adjustment]                  FLOAT (53) NULL,
    [Adj_Start_Date]                     DATETIME   NULL,
    [END_DATE]                           DATETIME   NULL
);

