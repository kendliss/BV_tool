CREATE TABLE [bvt_prod].[Sales_Curve] (
    [idSales_Curve]                      INT        IDENTITY (1, 1) NOT NULL,
    [idProgram_Touch_Definitions_TBL_FK] INT        NOT NULL,
    [Week_ID]                            INT        NULL,
    [Curve_Start_Date]                   DATE       DEFAULT (getdate()) NULL,
    [idkpi_type_FK]                      INT        NOT NULL,
    [week_percent]                       FLOAT (53) NOT NULL,
    PRIMARY KEY CLUSTERED ([idSales_Curve] ASC),
    FOREIGN KEY ([idProgram_Touch_Definitions_TBL_FK]) REFERENCES [bvt_prod].[Program_Touch_Definitions_TBL] ([idProgram_Touch_Definitions_TBL]),
    CONSTRAINT [idkpi_type_salesFK] FOREIGN KEY ([idkpi_type_FK]) REFERENCES [bvt_prod].[KPI_Types] ([idKPI_Types])
);


GO
CREATE NONCLUSTERED INDEX [Sales_Curve_FKIndex1]
    ON [bvt_prod].[Sales_Curve]([idProgram_Touch_Definitions_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_101]
    ON [bvt_prod].[Sales_Curve]([idProgram_Touch_Definitions_TBL_FK] ASC);

