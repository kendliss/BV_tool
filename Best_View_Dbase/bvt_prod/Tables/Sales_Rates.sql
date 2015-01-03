CREATE TABLE [bvt_prod].[Sales_Rates] (
    [idSales_Rates]                      INT        IDENTITY (1, 1) NOT NULL,
    [idProduct_LU_TBL_FK]                INT        NOT NULL,
    [idProgram_Touch_Definitions_TBL_FK] INT        NOT NULL,
    [Sales_Rate_Start_Date]              DATE       DEFAULT (getdate()) NULL,
    [Sales_Rate]                         FLOAT (53) NOT NULL,
    [idkpi_type_FK]                      INT        NOT NULL,
    PRIMARY KEY CLUSTERED ([idSales_Rates] ASC),
    FOREIGN KEY ([idProduct_LU_TBL_FK]) REFERENCES [bvt_prod].[Product_LU_TBL] ([idProduct_LU_TBL]),
    FOREIGN KEY ([idProgram_Touch_Definitions_TBL_FK]) REFERENCES [bvt_prod].[Program_Touch_Definitions_TBL] ([idProgram_Touch_Definitions_TBL]),
    CONSTRAINT [idkpi_type_salesrateFK] FOREIGN KEY ([idkpi_type_FK]) REFERENCES [bvt_prod].[KPI_Types] ([idKPI_Types])
);


GO
CREATE NONCLUSTERED INDEX [Sales_Rates_FKIndex2]
    ON [bvt_prod].[Sales_Rates]([idProgram_Touch_Definitions_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_98]
    ON [bvt_prod].[Sales_Rates]([idProgram_Touch_Definitions_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_105]
    ON [bvt_prod].[Sales_Rates]([idProduct_LU_TBL_FK] ASC);

