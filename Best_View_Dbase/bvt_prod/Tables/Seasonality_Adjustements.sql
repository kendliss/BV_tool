CREATE TABLE [bvt_prod].[Seasonality_Adjustements] (
    [idSeasonality_Adjustements]         INT        IDENTITY (1, 1) NOT NULL,
    [idProgram_Touch_Definitions_TBL_FK] INT        NOT NULL,
    [Media_Year]                         INT        NULL,
    [Media_Month]                        INT        NULL,
    [Media_Week]                         INT        NULL,
    [Seasonality_Adj]                    FLOAT (53) NULL,
    PRIMARY KEY CLUSTERED ([idSeasonality_Adjustements] ASC),
    FOREIGN KEY ([idProgram_Touch_Definitions_TBL_FK]) REFERENCES [bvt_prod].[Program_Touch_Definitions_TBL] ([idProgram_Touch_Definitions_TBL])
);

