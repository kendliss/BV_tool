CREATE TABLE [Results].[UVAQ_Calls_by_DMA_parentid_tfn] (
    [parentID]             NUMERIC (12) NOT NULL,
    [start_date]           DATETIME     NULL,
    [end_date_traditional] DATETIME     NULL,
    [tfn]                  CHAR (10)    NULL,
    [DMA_CD]               CHAR (4)     NULL,
    [media_week]           INT          NOT NULL,
    [mediamonth_YYYYMM]    INT          NULL,
    [mediamonth_year]      INT          NOT NULL,
    [calls]                INT          NULL
);

