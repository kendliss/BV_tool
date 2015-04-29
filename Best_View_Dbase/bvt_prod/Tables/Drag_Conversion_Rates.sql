CREATE TABLE [bvt_prod].[Drag_Conversion_Rates]
(
	[idDrag_Conversion] INT NOT NULL, 
    [idProduct_LU_TBL_FK] INT NOT NULL, 
    [idProgram_Touch_Definitions_TBL_FK] INT NOT NULL, 
    [Conversion_Rate] FLOAT NOT NULL, 
    [Conv_Rate_Start_Date] DATE NOT NULL DEFAULT (getdate()), 
    [idKPI_Type_FK] INT NOT NULL
	PRIMARY KEY CLUSTERED ([idDrag_Conversion] ASC)
	FOREIGN KEY ([idProduct_LU_TBL_FK]) REFERENCES [bvt_prod].[Product_LU_TBL] ([idProduct_LU_TBL]),
    FOREIGN KEY ([idProgram_Touch_Definitions_TBL_FK]) REFERENCES [bvt_prod].[Program_Touch_Definitions_TBL] ([idProgram_Touch_Definitions_TBL]),
    FOREIGN KEY ([idkpi_type_FK]) REFERENCES [bvt_prod].[KPI_Types] ([idKPI_Types])
);

GO
CREATE NONCLUSTERED INDEX [IFK_Rel_1001]
    ON [bvt_prod].[Drag_Conversion_Rates]([idProgram_Touch_Definitions_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_1005]
    ON [bvt_prod].[Drag_Conversion_Rates]([idProduct_LU_TBL_FK] ASC);
