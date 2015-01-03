CREATE TABLE [bvt_prod].[Campaign_Type_LU_TBL] (
    [idCampaign_Type_LU_TBL]    INT           IDENTITY (1, 1) NOT NULL,
    [Campaign_Type]             VARCHAR (255) NULL,
    [Campaign_Type_Description] VARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([idCampaign_Type_LU_TBL] ASC)
);

