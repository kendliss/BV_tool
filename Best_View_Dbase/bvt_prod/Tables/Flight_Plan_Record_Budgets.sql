CREATE TABLE [bvt_prod].[Flight_Plan_Record_Budgets] (
    [idFlight_Plan_Record_Budgets] INT        IDENTITY (1, 1) NOT NULL,
    [idBudget_Status_LU_FK]        INT        NOT NULL,
    [Budget]                       FLOAT (53) NULL,
    [Bill_Year]                    INT        NULL,
    [Bill_Month]                   INT        NULL,
    [idFlight_Plan_Records_FK]     INT        NULL,
    PRIMARY KEY CLUSTERED ([idFlight_Plan_Record_Budgets] ASC),
    FOREIGN KEY ([idBudget_Status_LU_FK]) REFERENCES [bvt_prod].[Budget_Status_LU] ([idBudget_Status_LU]),
    CONSTRAINT [FK_Flight_Plan_Record_Budgets_Flight_Plan_Records] FOREIGN KEY ([idFlight_Plan_Records_FK]) REFERENCES [bvt_prod].[Flight_Plan_Records] ([idFlight_Plan_Records])
);


GO
CREATE NONCLUSTERED INDEX [Flight_Plan_Record_Budgets_FKIndex1]
    ON [bvt_prod].[Flight_Plan_Record_Budgets]([idBudget_Status_LU_FK] ASC);


GO
CREATE NONCLUSTERED INDEX [IFK_Rel_111]
    ON [bvt_prod].[Flight_Plan_Record_Budgets]([idBudget_Status_LU_FK] ASC);

