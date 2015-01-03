CREATE TABLE [eCRW].[weekly_report_campaign_entry] (
    [Touch_Name]         VARCHAR (10) NOT NULL,
    [Touch_Name_2]       VARCHAR (65) NULL,
    [Audience_Type_Name] VARCHAR (8)  NOT NULL,
    [Media_Type]         VARCHAR (8)  NOT NULL,
    [ISO_Week_YYYYWW]    INT          NULL,
    [date_month_long]    VARCHAR (50) NULL,
    [initial_entry_wk]   INT          NULL,
    [update_qty]         INT          NULL,
    [Inhome_Date]        DATETIME     NOT NULL,
    [volume]             FLOAT (53)   NULL,
    [initial_entry]      DATETIME     NULL,
    [upd_qty]            DATETIME     NULL
);

