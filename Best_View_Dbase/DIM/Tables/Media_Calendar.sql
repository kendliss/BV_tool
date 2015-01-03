CREATE TABLE [DIM].[Media_Calendar] (
    [Week_ID]             INT          NULL,
    [Week_Year]           INT          NOT NULL,
    [ISO_Week]            INT          NOT NULL,
    [ISO_Week_YYYYWW]     INT          NULL,
    [YearWeek]            VARCHAR (50) NULL,
    [Week_Long]           VARCHAR (50) NULL,
    [Month_Year]          INT          NULL,
    [Month]               INT          NULL,
    [MediaMonth_YYYYMM]   INT          NULL,
    [MediaMonth_ID]       INT          NULL,
    [Month_Long]          VARCHAR (50) NULL,
    [Month_Short]         VARCHAR (50) NULL,
    [Trimester_Year]      INT          NULL,
    [Trimester]           INT          NULL,
    [Trimester_YYYYTT]    INT          NULL,
    [Trimester_ID]        INT          NULL,
    [Start_Date]          DATETIME     NULL,
    [End_Date]            DATETIME     NULL,
    [LTV_Eff_Week_YYYYWW] INT          NULL
);

