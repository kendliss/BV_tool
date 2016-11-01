CREATE TABLE [bvt_prod].[Flight_Plan_Records] (
    [idFlight_Plan_Records]                   INT           IDENTITY (1, 1) NOT NULL,
    [idVolume_Type_LU_TBL_FK]                 INT           NOT NULL,
    [idProgram_Touch_Definitions_TBL_FK]      INT           NOT NULL,
    [Budget_Type_LU_TBL_idBudget_Type_LU_TBL] INT           NOT NULL,
    [Campaign_Name]                           VARCHAR (255) NULL,
    [InHome_Date]                             DATE          NULL,
    [TFN_ind]                                 BIT           NULL,
    [URL_ind]                                 BIT           NULL,
    [idTarget_Rate_Reasons_LU_TBL_FK]         INT           NULL,
	[idTarget_Adj_Manual_FK]                  INT           NULL,
    PRIMARY KEY CLUSTERED ([idFlight_Plan_Records] ASC),
    FOREIGN KEY ([Budget_Type_LU_TBL_idBudget_Type_LU_TBL]) REFERENCES [bvt_prod].[Budget_Type_LU_TBL] ([idBudget_Type_LU_TBL]),
    FOREIGN KEY ([idProgram_Touch_Definitions_TBL_FK]) REFERENCES [bvt_prod].[Program_Touch_Definitions_TBL] ([idProgram_Touch_Definitions_TBL]),
    FOREIGN KEY ([idVolume_Type_LU_TBL_FK]) REFERENCES [bvt_prod].[Volume_Type_LU_TBL] ([idVolume_Type_LU_TBL]),
	FOREIGN KEY ([idTarget_Adj_Manual_FK]) REFERENCES [bvt_prod].[Target_Rate_Adjustment_Manual_TBL] ([idTarget_Adj_Manual]),
    CONSTRAINT [FK_Flight_PL_idTarget_Adj] FOREIGN KEY ([idTarget_Rate_Reasons_LU_TBL_FK]) REFERENCES [bvt_prod].[Target_Rate_Reasons_LU_TBL] ([idTarget_Rate_Reasons_LU_TBL])
);


GO
CREATE NONCLUSTERED INDEX [Flight_Plan_Records_FKIndex5]
    ON [bvt_prod].[Flight_Plan_Records]([Budget_Type_LU_TBL_idBudget_Type_LU_TBL] ASC);


GO
CREATE NONCLUSTERED INDEX [Flight_Plan_Records_FKIndex6]
    ON [bvt_prod].[Flight_Plan_Records]([idProgram_Touch_Definitions_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_71]
    ON [bvt_prod].[Flight_Plan_Records]([Budget_Type_LU_TBL_idBudget_Type_LU_TBL] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_102]
    ON [bvt_prod].[Flight_Plan_Records]([idProgram_Touch_Definitions_TBL_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_107]
    ON [bvt_prod].[Flight_Plan_Records]([idVolume_Type_LU_TBL_FK] ASC);

