CREATE TABLE [Forecasting].[MLP] (
    [MLP_ID]       INT            IDENTITY (1, 1) NOT NULL,
    [MLP_Version]  DECIMAL (3, 1) NOT NULL,
    [Region]       CHAR (2)       NOT NULL,
    [Sub_Region]   VARCHAR (12)   NOT NULL,
    [DMA]          VARCHAR (3)    NOT NULL,
    [MLP_Year]     INT            NOT NULL,
    [MLP_Month]    INT            NOT NULL,
    [ELU_Forecast] INT            NULL,
    PRIMARY KEY CLUSTERED ([MLP_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_MLP_Version]
    ON [Forecasting].[MLP]([MLP_Version] ASC, [MLP_Month] ASC, [MLP_Year] ASC);

