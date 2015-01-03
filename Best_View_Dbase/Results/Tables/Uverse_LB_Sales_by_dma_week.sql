CREATE TABLE [Results].[Uverse_LB_Sales_by_dma_week] (
    [parentid]          NUMERIC (12)    NOT NULL,
    [tfn]               VARCHAR (10)    NULL,
    [dma_cd]            VARCHAR (10)    NULL,
    [report_week]       INT             NOT NULL,
    [mediamonth_YYYYMM] INT             NULL,
    [report_year]       INT             NULL,
    [TV_sales]          NUMERIC (38, 2) NULL,
    [HSIA_sales]        NUMERIC (38, 2) NULL,
    [VOIP_sales]        NUMERIC (38, 2) NULL
);

