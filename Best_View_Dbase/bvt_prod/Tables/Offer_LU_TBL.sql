CREATE TABLE [bvt_prod].[Offer_LU_TBL] (
    [idOffer_LU_TBL]    INT          IDENTITY (1, 1) NOT NULL,
    [Offer_Description] TEXT         NULL,
    [Offer]             VARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([idOffer_LU_TBL] ASC)
);

