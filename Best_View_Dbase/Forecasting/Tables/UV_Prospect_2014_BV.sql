CREATE TABLE [Forecasting].[UV_Prospect_2014_BV] (
    [Program]      NVARCHAR (255) NULL,
    [METRIC GROUP] NVARCHAR (255) NULL,
    [METRIC]       NVARCHAR (255) NULL,
    [weekid]       NVARCHAR (128) NULL,
    [VALUE]        FLOAT (53)     NULL,
    [loaddate]     DATETIME       NOT NULL,
    [BV_column]    VARCHAR (MAX)  NULL
);

