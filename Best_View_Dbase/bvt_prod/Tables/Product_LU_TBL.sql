CREATE TABLE [bvt_prod].[Product_LU_TBL] (
    [idProduct_LU_TBL]    INT           IDENTITY (1, 1) NOT NULL,
    [Product_Code]        VARCHAR (255) NULL,
    [Product_Description] TEXT          NULL,
    PRIMARY KEY CLUSTERED ([idProduct_LU_TBL] ASC)
);

