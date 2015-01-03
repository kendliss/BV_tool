CREATE TABLE [bvt_prod].[Drop_Date_Calc_Rules] (
    [idDrop_Date]                        INT  IDENTITY (1, 1) NOT NULL,
    [idProgram_Touch_Definitions_TBL_FK] INT  NOT NULL,
    [Days_Before_Inhome]                 INT  NOT NULL,
    [drop_start_date]                    DATE NOT NULL,
    PRIMARY KEY CLUSTERED ([idDrop_Date] ASC),
    FOREIGN KEY ([idProgram_Touch_Definitions_TBL_FK]) REFERENCES [bvt_prod].[Program_Touch_Definitions_TBL] ([idProgram_Touch_Definitions_TBL])
);

