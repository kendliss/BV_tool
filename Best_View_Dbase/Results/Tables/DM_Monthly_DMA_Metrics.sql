CREATE TABLE [Results].[DM_Monthly_DMA_Metrics] (
    [MediaMonth_YYYYMM]       INT             NULL,
    [DMA]                     INT             NULL,
    [volume]                  INT             NULL,
    [calls]                   INT             NULL,
    [TV_Sales]                NUMERIC (38, 2) NULL,
    [HSIA_Sales]              NUMERIC (38, 2) NULL,
    [VOIP_Sales]              NUMERIC (38, 2) NULL,
    [Call_Response_Rate]      VARCHAR (12)    NULL,
    [TV_Call_Sales_Rate]      VARCHAR (12)    NULL,
    [HSIA_Call_Sales_Rate]    VARCHAR (12)    NULL,
    [VOIP_Call_Sales_Rate]    VARCHAR (12)    NULL,
    [U-verse_Call_Sales_Rate] VARCHAR (12)    NULL,
    [Average Interval]        FLOAT (53)      NULL
);

