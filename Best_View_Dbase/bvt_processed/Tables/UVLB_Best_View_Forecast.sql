CREATE TABLE [bvt_processed].[UVLB_Best_View_Forecast] (
    [idFlight_Plan_Records] INT           NOT NULL,
    [Campaign_Name]         VARCHAR (255) NULL,
    [InHome_Date]           DATE          NULL,
    [Media_Year]            INT           NULL,
    [Media_Week]            INT           NULL,
    [Media_Month]           INT           NULL,
    [Touch_Name]            VARCHAR (255) NULL,
    [Program_Name]          VARCHAR (255) NULL,
    [Tactic]                VARCHAR (45)  NULL,
    [Media]                 VARCHAR (45)  NULL,
    [Campaign_Type]         VARCHAR (255) NULL,
    [Audience]              VARCHAR (255) NULL,
    [Creative_Name]         VARCHAR (255) NULL,
    [Goal]                  VARCHAR (50)  NULL,
    [Offer]                 VARCHAR (50)  NULL,
    [KPI_Type]              VARCHAR (12)  NULL,
    [Product_Code]          VARCHAR (255) NULL,
    [Forecast_DayDate]      DATE          NULL,
    [Forecast]              FLOAT (53)    NULL,
    [load_dt]               DATETIME      NULL
);

