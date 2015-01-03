CREATE TABLE [Forecasting].[Program] (
    [Program_ID]   INT         IDENTITY (1, 1) NOT NULL,
    [Program]      VARCHAR (8) NOT NULL,
    [Program_Desc] TEXT        NULL,
    PRIMARY KEY CLUSTERED ([Program_ID] ASC)
);

