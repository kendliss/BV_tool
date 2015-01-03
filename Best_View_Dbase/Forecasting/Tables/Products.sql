CREATE TABLE [Forecasting].[Products] (
    [Product_ID]        INT          IDENTITY (1, 1) NOT NULL,
    [Product]           VARCHAR (20) NOT NULL,
    [Product_Desc]      TEXT         NULL,
    [Strategic_Product] BIT          NOT NULL,
    PRIMARY KEY CLUSTERED ([Product_ID] ASC)
);

