CREATE TABLE [bvt_prod].[Volume_Type_LU_TBL] (
    [idVolume_Type_LU_TBL] INT           IDENTITY (1, 1) NOT NULL,
    [Volume_Type]          VARCHAR (45)  NULL,
    [Volume_Description]   VARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([idVolume_Type_LU_TBL] ASC)
);

