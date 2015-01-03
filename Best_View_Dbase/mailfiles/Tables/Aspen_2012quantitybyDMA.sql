CREATE TABLE [mailfiles].[Aspen_2012quantitybyDMA] (
    [MailfileID]              VARCHAR (4)    NULL,
    [Campaign_Name]           VARCHAR (255)  NULL,
    [TFN]                     VARCHAR (8000) NULL,
    [DMA_CD]                  VARCHAR (3)    NULL,
    [quantity]                INT            NULL,
    [parentid]                NUMERIC (12)   NULL,
    [start_date]              DATETIME       NULL,
    [start_MediaMonth_YYYYMM] INT            NULL,
    [Budget]                  REAL           NULL,
    [CORE]                    VARCHAR (10)   NULL,
    [green_or_red]            VARCHAR (5)    NULL,
    [Tier]                    VARCHAR (10)   NULL,
    [competitor]              VARCHAR (11)   NULL,
    [Comcast]                 VARCHAR (1)    NULL,
    [DMA_Name]                VARCHAR (50)   NULL
);

