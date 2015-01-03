CREATE TABLE [bvt_prod].[Program_LU_TBL] (
    [idProgram_LU_TBL]    INT           IDENTITY (1, 1) NOT NULL,
    [Program_Name]        VARCHAR (255) NOT NULL,
    [Program_Description] TEXT          NULL,
    PRIMARY KEY CLUSTERED ([idProgram_LU_TBL] ASC)
);

