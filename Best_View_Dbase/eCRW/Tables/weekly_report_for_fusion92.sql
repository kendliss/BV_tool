CREATE TABLE [eCRW].[weekly_report_for_fusion92] (
    [Channel]                      VARCHAR (50)  NULL,
    [First Drop Date/ Track Start] DATETIME      NULL,
    [In-Home Date]                 DATETIME      NULL,
    [Campaign Name]                VARCHAR (250) NULL,
    [Cell Title]                   VARCHAR (250) NULL,
    [ParentID]                     NUMERIC (12)  NULL,
    [TFN]                          VARCHAR (MAX) NULL,
    [TFN Type]                     VARCHAR (50)  NULL,
    [URL]                          VARCHAR (MAX) NULL,
    [Quantity]                     NUMERIC (20)  NULL,
    [Call RR]                      FLOAT (53)    NULL,
    [Click RR]                     FLOAT (53)    NULL,
    [New Parentid]                 VARCHAR (1)   NOT NULL
);

