CREATE TABLE [Forecasting].[Program_Owners] (
    [Program_Owner_ID] INT          IDENTITY (1, 1) NOT NULL,
    [Program_Owner]    VARCHAR (65) NOT NULL,
    PRIMARY KEY CLUSTERED ([Program_Owner_ID] ASC)
);

