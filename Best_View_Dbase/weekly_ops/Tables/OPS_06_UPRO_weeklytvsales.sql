CREATE TABLE [weekly_ops].[OPS_06_UPRO_weeklytvsales] (
    [Report_Week]       INT          NOT NULL,
    [End_Date]          DATETIME     NULL,
    [reportweek_yyyyww] NUMERIC (11) NOT NULL,
    [CV_responses]      FLOAT (53)   NULL,
    [CV_tv_sales]       FLOAT (53)   NULL,
    [actual_responses]  FLOAT (53)   NULL,
    [uvrs_tv]           FLOAT (53)   NULL
);

