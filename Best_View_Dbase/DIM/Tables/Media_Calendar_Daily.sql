CREATE TABLE [DIM].[Media_Calendar_Daily] (
    [ID]                   INT          NULL,
    [Date]                 DATETIME     NOT NULL,
    [Date_Year]            INT          NOT NULL,
    [Date_Month]           INT          NOT NULL,
    [CalendarMonth_YYYYMM] INT          NULL,
    [CalendarMonth_ID]     INT          NULL,
    [Date_Day]             INT          NOT NULL,
    [Date_Month_Long]      VARCHAR (50) NULL,
    [Date_Month_Short]     VARCHAR (50) NULL,
    [ISO_Week_Year]        INT          NOT NULL,
    [ISO_Week]             INT          NOT NULL,
    [ISO_Week_YYYYWW]      INT          NULL,
    [Week_ID]              INT          NULL,
    [WeekDay]              INT          NOT NULL,
    [WeekDay_Long]         VARCHAR (50) NULL,
    [WeekDay_Short]        VARCHAR (50) NULL,
    [Quarter]              INT          NOT NULL,
    [Quarter_YYYYQQ]       INT          NULL,
    [Quarter_ID]           INT          NULL,
    [MediaMonth_Year]      INT          NOT NULL,
    [MediaMonth]           INT          NOT NULL,
    [MediaMonth_YYYYMM]    INT          NULL,
    [MediaMonth_ID]        INT          NULL,
    [MediaMonth_Long]      VARCHAR (50) NULL,
    [MediaMonth_Short]     VARCHAR (50) NULL,
    [Trimester]            INT          NOT NULL,
    [Trimester_Year]       INT          NOT NULL,
    [Trimester_YYYYTT]     INT          NULL,
    [Trimester_ID]         INT          NULL,
    [LTV_Eff_Week_YYYYWW]  INT          NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [IDX_Media_Calendar_Daily]
    ON [DIM].[Media_Calendar_Daily]([Date] ASC);

