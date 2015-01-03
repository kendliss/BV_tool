CREATE TABLE [Forecasting].[Response_Channel] (
    [Response_Channel_ID]   INT         IDENTITY (1, 1) NOT NULL,
    [Response_Channel]      VARCHAR (8) NOT NULL,
    [Response_Channel_Desc] TEXT        NULL,
    PRIMARY KEY CLUSTERED ([Response_Channel_ID] ASC)
);

