CREATE TABLE [Forecasting].[2013_Lead_Forecast] (
    [Month_Leads]      BIGINT NULL,
    [Year_leads]       BIGINT NULL,
    [DMDR_leads]       BIGINT NULL,
    [IRU_Leads]        BIGINT NULL,
    [LT_Leads]         BIGINT NULL,
    [Spanish_Leads]    BIGINT NULL,
    [Recur_NG_Leads]   BIGINT NULL,
    [DMDR_NG_leads]    BIGINT NULL,
    [IRU_NG_leads]     BIGINT NULL,
    [LT_NG_leads]      BIGINT NULL,
    [SPANISH_NG_leads] BIGINT NULL,
    [Lead_Forecast_ID] BIGINT IDENTITY (1, 1) NOT NULL,
    [TV_Upsell_Leads]  BIGINT NULL,
    [Spanish_2_3]      BIGINT NULL,
    CONSTRAINT [PK_Lead_Forecast] PRIMARY KEY CLUSTERED ([Lead_Forecast_ID] ASC)
);

