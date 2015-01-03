CREATE TABLE [bvt_prod].[Budget_Type_LU_TBL] (
    [idBudget_Type_LU_TBL]           INT          IDENTITY (1, 1) NOT NULL,
    [Budget_Calculation_Description] TEXT         NULL,
    [Budget_Calculation]             VARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([idBudget_Type_LU_TBL] ASC)
);

