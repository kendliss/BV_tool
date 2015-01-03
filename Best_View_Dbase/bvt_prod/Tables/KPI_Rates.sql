CREATE TABLE [bvt_prod].[KPI_Rates] (
    [idKPI_Rates]                        INT        IDENTITY (1, 1) NOT NULL,
    [idProgram_Touch_Definitions_TBL_FK] INT        NOT NULL,
    [idKPI_Types_FK]                     INT        NOT NULL,
    [KPI_Rate]                           FLOAT (53) NOT NULL,
    [Rate_Start_Date]                    DATE       NOT NULL,
    PRIMARY KEY CLUSTERED ([idKPI_Rates] ASC),
    FOREIGN KEY ([idKPI_Types_FK]) REFERENCES [bvt_prod].[KPI_Types] ([idKPI_Types]),
    FOREIGN KEY ([idProgram_Touch_Definitions_TBL_FK]) REFERENCES [bvt_prod].[Program_Touch_Definitions_TBL] ([idProgram_Touch_Definitions_TBL])
);

